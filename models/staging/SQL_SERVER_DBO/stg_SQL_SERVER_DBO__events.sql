{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ ref('base_SQL_SERVER_DBO__events') }}

),

renamed as (

    select
        event_id,
        IFF(page_url = '', null, page_url) as page_url,
        md5(event_type) as event_type_id,
        user_id,
        IFF(product_id = '', md5('sin_producto'), product_id) as product_id,
        session_id,
        created_at_utc,
        IFF(order_id = '', md5('sin_order'), order_id) as order_id,
        _fivetran_deleted,
        _fivetran_synced_utc

    from source

)

select * from renamed