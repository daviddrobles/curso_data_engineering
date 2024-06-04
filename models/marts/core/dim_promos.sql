{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__promos') }}

),

renamed as (

    select
        promo_id,
        promo_name,
        discount_dollar,
        promo_status_id,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source

)

select * from renamed