{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'promos') }}

),

renamed as (

    select
        distinct md5(promo_id) as promo_id,
        promo_id as promo_name,
        discount as discount_euros,
        IFF(status = 'active', '1', '0') as promo_status,
        _fivetran_deleted as _fivetran_deleted_utc,
        _fivetran_synced as _fivetran_synced_utc

    from source
    union all
    select
        md5('sin_promo')
        ,'sin_promo'
        ,0
        ,0
        ,null
        ,null
)

select * from renamed
