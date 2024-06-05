with 

fact_pedidos as (

    select * from {{ ref('fact_pedidos') }}

),

dim_users as (

    select * from {{ ref('dim_users') }}

),

dim_promos as (

    select * from {{ ref('dim_promos') }}

),

dim_addresses as (

    select * from {{ ref('dim_addresses') }}

),

datamart_marketing1 as (

    SELECT
        P.user_id,
        U.first_name,
        U.last_name,
        U.email,
        U.phone_number,
        U.created_at_utc,
        U.updated_at_utc,
        A.address,
        A.zipcode,
        A.state,
        A.country,
        count(distinct order_id) as numero_pedidos,
        sum(order_total_dollar) as total_orders_cost,
        sum(shipping_cost_dollar) as total_shipping_cost,
        sum(discount_dollar) as total_discount,
        sum(quantity_of_products) as total_productos,
        count(distinct(product_id)) as total_productos_diferentes
    FROM fact_pedidos P
    JOIN dim_users U
    ON P.user_id = U.user_id
    JOIN dim_addresses A
    ON U.address_id = A.address_id
    JOIN dim_promos PR
    ON P.promo_id = PR.promo_id
    GROUP BY ALL

)

select * from datamart_marketing1