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
        created_at AS event_created_at,
        order_id,
        _fivetran_deleted AS deleted_at,
        _fivetran_synced AS created_at

    from source

)

select * from renamed