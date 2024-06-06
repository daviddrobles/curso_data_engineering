{{
  config(
    materialized='table'
  )
}}

with 

budget as (

    select 
        product_id,
        MONTH(month) as month,
        sum(quantity_sold_expected) as cantidad_vendida_esperada
    
    from {{ ref('stg_google_sheets__budget') }}
    group by product_id, month

),

orders as (

    select 
        product_id,
        MONTH(created_at_month) as month,
        sum(quantity_of_products) as cantidad_vendida
    from {{ ref('stg_SQL_SERVER_DBO__orders')}} o
    JOIN {{ ref('stg_SQL_SERVER_DBO__order_items')}} oi
    ON o.order_id = oi.order_id
    GROUP BY product_id, month
),

calculado as (

    select
        B.product_id,
        B.cantidad_vendida_esperada,
        B.month,
        IFF(B.month = O.month, O.cantidad_vendida, null) as cantidad_vendida

    from orders O
    JOIN budget B
    ON O.product_id = B.product_id
    ORDER BY MONTH

),

fct_prevision as (

    select
        *,
        (cantidad_vendida - cantidad_vendida_esperada) as diferencia_ventas
    from calculado

)

select * from fct_prevision