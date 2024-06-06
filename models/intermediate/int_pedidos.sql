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

informacion as (

    SELECT
        i.order_id, 
        o.order_status_id, 
        o.user_id, 
        o.shipping_service_id,
        shipping_cost_dollar, 
        o.address_id,  
        o.tracking_id,
        o.promo_id,
        PR.discount_dollar,
        i.product_id,
        P.price_dollar,
        i.quantity_of_products,
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
    ORDER BY i.order_id

),

primeros_calculos AS (

    SELECT 
        order_id,
        order_status_id,
        user_id,
        shipping_service_id,
        shipping_cost_dollar,
        address_id,
        tracking_id,
        promo_id,
        discount_dollar,
        product_id,
        price_dollar,
        quantity_of_products,
        (price_dollar*quantity_of_products) as coste_por_producto,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    FROM informacion

),

segundos_calculos AS (

    SELECT
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) as ROW_,
        order_id,
        order_status_id,
        user_id,
        shipping_service_id,
        shipping_cost_dollar,
        address_id,
        tracking_id,
        promo_id,
        discount_dollar,
        product_id,
        price_dollar,
        quantity_of_products,
        coste_por_producto,
        sum(coste_por_producto) OVER (PARTITION BY order_id ORDER BY order_id) as precio_total,
        (precio_total - IFF(ROW_ = '1', discount_dollar, 0) + IFF(ROW_ = '1', shipping_cost_dollar, 0)) AS precio_final,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    FROM primeros_calculos
)

select * from segundos_calculos