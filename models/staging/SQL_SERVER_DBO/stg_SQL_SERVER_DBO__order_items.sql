{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity as quantity_of_products,
        _fivetran_deleted,
        {{ to_utc('_fivetran_synced') }} as _fivetran_synced_utc

    from source

)

select * from renamed
