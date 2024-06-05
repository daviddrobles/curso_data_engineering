{% set event_types = ["checkout", "package_shipped", "add_to_cart","page_view"] %}

with 

fact_events as (

    select * from {{ ref('fact_events') }}

),

dim_users as (

    select * from {{ ref('dim_users') }}

),

dim_addresses as (

    select * from {{ ref('dim_addresses') }}

),

dim_events_types as (

    select * from {{ ref('dim_events_types') }}

),

datamart_producto1 as (

    SELECT 
        session_id,
        e.user_id,
        min(e.created_at_utc) as inicio_sesion,
        max(e.created_at_utc) as fin_sesion,
        DATEDIFF(minute, min(e.created_at_utc), max(e.created_at_utc)) as minutos_sesion,
        U.first_name,
        U.LAST_NAME,
        U.PHONE_NUMBER,
        U.EMAIL,
        count(e.page_url) as numero_paginas_vistas,
        {%- for event_type_name in event_types   %}
        sum(case when event_type_name = '{{event_type_name}}' then 1 end) as {{event_type_name}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}

    FROM fact_events E
    JOIN dim_users U
    ON E.user_id = U.user_id
    JOIN dim_addresses A
    ON U.address_id = A.address_id
    JOIN dim_events_types ET
    ON e.event_type_id = ET.event_type_id
    GROUP BY session_id, e.user_id, u.first_name, u.last_name, u.phone_number, u.email

)

select * from datamart_producto1