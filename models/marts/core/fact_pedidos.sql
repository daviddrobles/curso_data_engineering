with int_pedidos AS (
    SELECT * FROM {{ref('int_pedidos')}}
),

fact_pedidos AS (

    SELECT 
        order_id,
        order_status_id,
        user_id,
        shipping_service_id,
        shipping_cost_dollar,
        address_id,
        tracking_id,
        promo_id,
        product_id,
        quantity_of_products,
        coste_por_producto,
        max(precio_final) OVER (PARTITION BY order_id ORDER BY order_id) as precio_final,
        created_at_utc,
        created_at_month,
        estimated_delivery_at_utc,
        delivered_at_utc
    FROM int_pedidos
)

SELECT * FROM fact_pedidos