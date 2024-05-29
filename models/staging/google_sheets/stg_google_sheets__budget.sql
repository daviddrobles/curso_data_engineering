{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        _row as budget_id,
        quantity as quantity_sold_expected,
        month,
        product_id,
        _fivetran_synced AS _fivetran_synced_utc

    from source

)

select * from renamed
