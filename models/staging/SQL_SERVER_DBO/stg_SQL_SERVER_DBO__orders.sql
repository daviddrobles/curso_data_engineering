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
        IFF(shipping_service = '', md5('Sin_shipping_service'), md5(shipping_service) ) as shipping_service_id,
        shipping_cost as shipping_cost_eur,
        address_id,
        created_at as created_at_utc,
        IFF(promo_id = '', md5('sin_promo'), md5(promo_id) ) as promo_id,
        estimated_delivery_at as estimated_delivery_at_utc,
        order_cost as order_cost_eur,
        user_id,
        order_total as order_total_eur,
        delivered_at as delivered_at_utc,
        IFF(tracking_id = '', null, tracking_id) as tracking_id,
        IFF(status = '', md5('sin_status'), md5(status) ) as status_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
