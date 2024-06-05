{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__users') }}

),

renamed as (

    select
        user_id,
        address_id,
        first_name,
        last_name,
        phone_number,
        email,
        is_valid_email_address,
        updated_at_utc,
        created_at_utc,
        --total_orders,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source
)

select * from renamed