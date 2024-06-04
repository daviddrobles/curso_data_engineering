{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__shipping_service') }}

),

renamed as (
    SELECT
        shipping_service_id,
        shipping_service_name

    from source
    )



select * from renamed