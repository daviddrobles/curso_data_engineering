{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'events') }}

),

renamed as (

    select
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        {{ to_utc('created_at') }} as created_at_utc,
        order_id,
        _fivetran_deleted,
        {{ to_utc('_fivetran_synced') }} as _fivetran_synced_utc

    from source
)

select * from renamed
