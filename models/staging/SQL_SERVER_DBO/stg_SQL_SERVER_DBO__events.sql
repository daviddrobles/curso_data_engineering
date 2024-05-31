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
        IFF(event_type = '', md5('sin_event_type'), md5(event_type)) as event_type_id,
        IFF(user_id = '', md5('sin_user'), user_id) as user_id,
        IFF(product_id = '', md5('sin_producto'), product_id) as product_id,
        IFF(session_id = '', md5('sin_sesion'), session_id) as session_id,
        {{ to_utc('created_at') }} as created_at_utc,
        IFF(order_id = '', md5('sin_order'), order_id) as order_id,
        _fivetran_deleted,
        {{ to_utc('_fivetran_synced') }} as _fivetran_synced_utc

    from source
    union all
    select
        md5('sin_evento'),
        'No existe',
        md5('sin_event_type'),
        md5('sin_user'),
        md5('sin_producto'),
        md5('sin_sesion'),
        '2024-05-31',
        md5('sin_order'),
        null,
        null
)

select * from renamed
