{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted AS deleted_at,
        _fivetran_synced AS created_at

    from source

)

select * from renamed