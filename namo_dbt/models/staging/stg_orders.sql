WITH source AS (

SELECT *
FROM {{ source('raw','orders') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY order_id
ORDER BY order_timestamp DESC
) AS rn

FROM source

)

SELECT

order_id,
customer_id,
CAST(order_timestamp AS TIMESTAMP) AS order_ts,
DATE(order_timestamp) AS order_date,
EXTRACT(YEAR FROM order_timestamp) AS order_year,
EXTRACT(MONTH FROM order_timestamp) AS order_month,
LOWER(order_status) AS order_status,
payment_method,
delivery_city

FROM deduplicated
WHERE rn = 1