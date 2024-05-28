{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select status from {{ source('SQL_SERVER_DBO', 'orders') }}

),

renamed as (

    select
        distinct md5(status) as status_id,
        IFF(status = '', 'sin_status', status) as status

    from source

)

select * from renamed