{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'addresses') }}

),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        {{ to_utc('_fivetran_synced') }} as _fivetran_synced_utc

    from source
    union all
    select
        md5('sin_address'),
        0,
        'country',
        'address',
        'state',
        null,
        null
    
)

select * from renamed
