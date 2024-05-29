{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'products') }}

),

renamed as (

    select
        product_id,
        price as price_dollar,
        name,
        inventory,
        _fivetran_deleted as _fivetran_deleted_utc,
        _fivetran_synced as _fivetran_synced_utc

    from source
    union all
    select
        md5('producto_vacio'),
        0,
        'producto_vacio',
        0,
        null,
        null
)

select * from renamed
