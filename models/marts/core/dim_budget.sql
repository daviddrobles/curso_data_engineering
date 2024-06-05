{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_google_sheets__budget') }}

),

renamed as (

    select
        budget_id,
        quantity_sold_expected,
        month,
        product_id,
        _fivetran_synced_utc

    from source

)

select * from renamed