{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select shipping_service from {{ source('SQL_SERVER_DBO', 'orders') }}

),

renamed as (

    select
        distinct md5(shipping_service) as shipping_service_id,
        IFF(shipping_service = '', 'Sin_shipping_service', shipping_service) as shipping_service_name

    from source

)

select * from renamed