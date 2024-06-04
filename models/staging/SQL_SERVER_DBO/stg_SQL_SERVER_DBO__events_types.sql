{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select event_type from {{ ref('base_SQL_SERVER_DBO__events') }}

),

renamed as (

    select
        distinct md5(event_type) as event_type_id,
        event_type as event_type_name

    from source

)

select * from renamed