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
        IFF(page_url = '', null, page_url) as page_url,
        IFF(event_type = '', null, md5(event_type)) as event_type_id,
        user_id,
        IFF(product_id = '', md5('producto_vacio'), product_id) as product_id,
        session_id,
        created_at as created_at_utc,
        IFF(order_id = '', md5('order_vacio'), order_id) as order_id,
        _fivetran_deleted as _fivetran_deleted_utc,
        _fivetran_synced as _fivetran_synced_utc

    from source

)

select * from renamed
