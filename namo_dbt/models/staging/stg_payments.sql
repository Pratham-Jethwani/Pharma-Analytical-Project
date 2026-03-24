WITH source AS (

SELECT *
FROM {{ source('raw','payments') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY payment_id
ORDER BY payment_timestamp DESC
) AS rn

FROM source

)

SELECT

payment_id,
order_id,
payment_method,
LOWER(payment_status) AS payment_status,
CAST(payment_amount AS FLOAT) AS payment_amount,
CAST(payment_timestamp AS TIMESTAMP) AS payment_ts

FROM deduplicated
WHERE rn = 1