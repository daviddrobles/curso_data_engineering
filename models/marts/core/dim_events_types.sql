{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__events_types') }}

),

renamed as (

    select
        event_type_id,
        event_type_name

    from source

)

select * from renamed