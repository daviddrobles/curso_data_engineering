{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'users') }}

),

renamed as (

    select
        user_id,
        address_id,
        first_name,
        last_name,
        phone_number,
        email,
        coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address,
        updated_at as updated_at_utc,
        created_at as created_at_utc,
        total_orders,
        _fivetran_deleted as _fivetran_deleted_utc,
        _fivetran_synced as _fivetran_synced_utc

    from source

)

select * from renamed
