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
        discount as discount_dollar,
        IFF(status = 'active', '1', '0')::number(2,0) as promo_status_id,
        _fivetran_deleted,
        {{ to_utc('_fivetran_synced') }} as _fivetran_synced_utc

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
