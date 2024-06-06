{{
  config(
    materialized='table'
  )
}}

with 

source_order_items as (

    select * from {{ ref('stg_SQL_SERVER_DBO__order_items') }}

),

source_orders as (

    select * from {{ ref('stg_SQL_SERVER_DBO__orders') }}

),

source_products as (

    select * from {{ ref('stg_SQL_SERVER_DBO__products') }}

),

source_promos as (

    select * from {{ ref('stg_SQL_SERVER_DBO__promos') }}

),

precio_producto as (

    SELECT
        row_number() over(PARTITION BY i.order_id ORDER BY i.order_id) as ROW_,
        i.order_id, 
        o.order_status_id, 
        o.user_id, 
        o.shipping_service_id, 
        o.address_id,  
        o.tracking_id,
        o.promo_id,
        PR.discount_dollar,
        i.product_id,
        P.price_dollar,
        i.quantity_of_products,
        o.shipping_cost_dollar,
        (i.quantity_of_products*p.price_dollar) as cost_per_product,
        o.created_at_utc,
        o.created_at_month,
        o.estimated_delivery_at_utc,
        o.delivered_at_utc
    FROM source_orders O
    JOIN source_order_items I
    ON O.order_id = I.order_id
    JOIN source_products P
    ON I.product_id = P.product_id
    JOIN source_promos PR
    ON O.promo_id = PR.promo_id

),

precio_acumulado AS (

    SELECT
        ROW_,
        order_id, 
        order_status_id, 
        user_id, 
        shipping_service_id, 
        address_id,  
        tracking_id,
        promo_id,
        discount_dollar,
        product_id,
        price_dollar,
        quantity_of_products,
        shipping_cost_dollar,
        cost_per_product,
        sum(cost_per_product) OVER (PARTITION BY order_id ORDER BY row_ ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as precio_acumulado,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    
    FROM precio_producto

),

precio_final_calculado AS (

    SELECT 
        ROW_,
        order_id, 
        order_status_id, 
        user_id, 
        shipping_service_id, 
        address_id,  
        tracking_id,
        promo_id,
        discount_dollar,
        product_id,
        price_dollar,
        quantity_of_products,
        shipping_cost_dollar,
        cost_per_product,
        precio_acumulado, 
        (precio_acumulado + IFF(ROW_ = '1', shipping_cost_dollar, 0)) - IFF(ROW_ = '1', discount_dollar, 0) as precio_final,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    FROM precio_acumulado
),

precio_final AS (

    SELECT
        ROW_,
        order_id, 
        order_status_id, 
        user_id, 
        shipping_service_id, 
        address_id,  
        tracking_id,
        promo_id,
        discount_dollar,
        product_id,
        price_dollar,
        quantity_of_products,
        shipping_cost_dollar,
        cost_per_product,
        precio_acumulado, 
        sum(precio_final) OVER (PARTITION BY order_id ORDER BY row_ ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as precio_final,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    FROM precio_final_calculado
)

select * from precio_final