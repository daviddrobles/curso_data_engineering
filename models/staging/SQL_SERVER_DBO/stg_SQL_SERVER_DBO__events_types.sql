{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select event_type from {{ source('SQL_SERVER_DBO', 'events') }}

),

renamed as (

    select
        distinct md5(event_type) as event_type_id,
        event_type as event_type_name

    from source
    union all
    select
        md5('sin_event_type'),
        'Sin evento'
)

select * from renamed