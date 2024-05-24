WITH src_budget_products AS (
    SELECT * 
    FROM {{ ref('stg_SQL_SERVER_DBO__users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        updated_at,
        address_id,
        last_name,
        created_at AS user_created_at,
        phone_number,
        total_orders,
        first_name,
        email AS correo,
        deleted_at,
        created_at
    FROM src_budget_products
    )

SELECT * FROM renamed_casted