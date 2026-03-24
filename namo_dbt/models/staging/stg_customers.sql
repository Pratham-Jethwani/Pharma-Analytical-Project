WITH source AS (

SELECT *
FROM {{ source('raw','customers') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY customer_id
ORDER BY signup_date DESC
) AS rn

FROM source

)

SELECT

customer_id,
customer_name,
email,
phone,
city,
state,
CAST(signup_date AS DATE) AS signup_date

FROM deduplicated
WHERE rn = 1