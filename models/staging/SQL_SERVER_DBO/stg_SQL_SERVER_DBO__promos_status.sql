{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select status from {{ source('SQL_SERVER_DBO', 'promos') }}

),

renamed as (

    select
        IFF(status = 'active', 1, 0)::number(2,0) as promo_status_id,
        status as promo_status

    from source
    group by promo_status
    
)

select * from renamed