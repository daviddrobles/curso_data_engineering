{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ ref('base_SQL_SERVER_DBO__promos') }}

),

renamed as (

    select
        promo_id,
        promo_name,
        discount_dollar,
        IFF(promo_status = 'active', '1', '0')::number(2,0) as promo_status_id,
        _fivetran_deleted,
        _fivetran_synced_utc

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
