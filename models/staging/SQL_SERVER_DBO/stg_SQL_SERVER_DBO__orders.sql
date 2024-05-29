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
        shipping_cost as shipping_cost_dollar,
        address_id,
        created_at as created_at_utc,
        IFF(promo_id = '', md5('sin_promo'), md5(promo_id) ) as promo_id,
        estimated_delivery_at as estimated_delivery_at_utc,
        order_cost as order_cost_dollar,
        user_id,
        order_total as order_total_dollar,
        delivered_at as delivered_at_utc,
        IFF(tracking_id = '', null, tracking_id) as tracking_id,
        IFF(status = '', md5('sin_status'), md5(status) ) as order_status_id,
        _fivetran_deleted as _fivetran_deleted_utc,
        _fivetran_synced as _fivetran_synced_utc

    from source
    union all
    select
        md5('order_vacio'),
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
)

select * from renamed
