{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__products') }}

),

renamed as (

    select
        product_id,
        price_dollar,
        name,
        inventory,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source

)

select * from renamed