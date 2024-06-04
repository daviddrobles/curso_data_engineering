{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__promos_status') }}

),

renamed as (

    select
        promo_status_id,
        promo_status

    from source
    
)

select * from renamed