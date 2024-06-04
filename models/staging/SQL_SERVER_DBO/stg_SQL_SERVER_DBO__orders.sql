{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ ref('base_SQL_SERVER_DBO__orders') }}

),

renamed as (

    select
        order_id,
        IFF(shipping_service = '', md5('sin_shipping_service'), md5(shipping_service) ) as shipping_service_id,
        shipping_cost_dollar,
        IFF(address_id = '', md5('sin_address'), address_id) as address_id,
        created_at_utc,
        IFF(promo_id = '', md5('sin_promo'), md5(promo_id) ) as promo_id,
        estimated_delivery_at_utc,
        order_cost_dollar,
        user_id,
        order_total_dollar,
        delivered_at_utc,
        tracking_id,
        IFF(status = '', md5('sin_status'), md5(status) ) as order_status_id,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source
    union all
    select
        md5('sin_order'),
        md5('sin_shipping_service'),
        0,
        md5('sin_address'),
        '2024-05-31',
        md5('sin_promo'),
        null,
        0,
        md5('sin_user'),
        0,
        null,
        md5('sin_track'),
        md5('sin_status'),
        null,
        null
)

select * from renamed
