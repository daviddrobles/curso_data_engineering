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
        IFF(event_type = '', 'sin_event_type', event_type) as event_type_name

    from source

)

select * from renamed