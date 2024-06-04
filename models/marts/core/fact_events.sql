{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__events') }}

),

renamed as (

    select
        event_id,
        page_url,
        event_type_id,
        user_id,
        product_id,
        session_id,
        created_at_utc,
        order_id,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source

)

select * from renamed