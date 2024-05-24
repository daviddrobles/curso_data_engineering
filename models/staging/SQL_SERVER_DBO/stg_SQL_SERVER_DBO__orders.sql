{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'orders') }}

),

renamed as (

    select
        order_id,
        shipping_service,
        shipping_cost,
        address_id,
        created_at AS order_created_at,
        promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted AS deleted_at,
        _fivetran_synced AS created_at

    from source

)

select * from renamed
