WITH source AS (

SELECT *
FROM {{ source('raw','suppliers') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY supplier_id
ORDER BY contract_start_date DESC
) AS rn

FROM source

)

SELECT

supplier_id,
supplier_name,
supplier_city,
contact_email,
CAST(contract_start_date AS DATE) AS contract_start_date

FROM deduplicated
WHERE rn = 1