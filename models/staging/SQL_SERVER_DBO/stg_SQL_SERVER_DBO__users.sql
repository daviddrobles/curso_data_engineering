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
        updated_at,
        address_id,
        last_name,
        created_at,
        phone_number,
        total_orders,
        first_name,
        email,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
