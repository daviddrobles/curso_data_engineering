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

    select * from {{ ref('dim_products') }}

),

source_promos as (

    select * from {{ ref('dim_promos') }}

),

source_promos_status as (

    select * from {{ ref('dim_promos_status') }}

),

fact_pedidos as (

    SELECT
        row_number() over(PARTITION BY i.order_id ORDER BY i.order_id) as ROW_,
        i.order_id, 
        o.order_status_id, 
        o.user_id, 
        o.shipping_service_id, 
        o.address_id,  
        o.tracking_id,
        o.promo_id,
        i.product_id,
        i.quantity_of_products,
        o.shipping_cost_dollar,
        o.created_at_utc,
        o.created_at_month,
        o.order_cost_dollar,
        o.order_total_dollar,
        o.estimated_delivery_at_utc,
        o.delivered_at_utc
    FROM source_order_items I
    JOIN stg_SQL_SERVER_DBO__orders O
    ON I.order_id = O.order_id
    JOIN source_products P
    ON I.product_id = P.product_id
    JOIN source_promos PR
    ON O.promo_id = PR.promo_id

)

select * from fact_pedidos