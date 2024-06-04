{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ ref('stg_SQL_SERVER_DBO__orders_status') }}

),

renamed as (

    select
        order_status_id,
        status

    from source

)

select * from renamed