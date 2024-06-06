WITH int_pedidos as (

    select * from {{ ref('int_pedidos') }}

),

fact_pedidos_nueva as (

    SELECT 
        order_id, 
        order_status_id,
        user_id,
        shipping_service_id,
        address_id,
        tracking_id,
        promo_id,
        product_id,
        quantity_of_products,
        shipping_cost_dollar,
        cost_per_product as coste_por_producto,
        precio_acumulado as total_fijo,
        precio_final,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc

    FROM int_pedidos

)

SELECT * FROM fact_pedidos_nueva