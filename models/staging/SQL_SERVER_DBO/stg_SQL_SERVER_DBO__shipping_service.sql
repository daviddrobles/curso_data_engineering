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
    SELECT md5(x) AS shipping_service_id, 
    x as shipping_service_name 
    FROM (
        select
            DISTINCT CASE WHEN shipping_service = '' THEN 'sin_shipping_service' ELSE shipping_service END as x
            from source)

)

select * from renamed