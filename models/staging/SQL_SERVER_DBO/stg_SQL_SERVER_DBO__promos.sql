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
        promo_id,
        discount,
        status,
        _fivetran_deleted AS deleted_at,
        _fivetran_synced AS created_at

    from source

)

select * from renamed
