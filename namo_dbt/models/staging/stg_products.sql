WITH source AS (

SELECT *
FROM {{ source('raw','products') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY product_id
ORDER BY manufacture_date DESC
) AS rn

FROM source

)

SELECT

product_id,
product_name,
brand,
LOWER(category) AS category,
CAST(mrp AS FLOAT) AS mrp,
CAST(manufacture_date AS DATE) AS manufacture_date,
CAST(expiry_date AS DATE) AS expiry_date,
LOWER(requires_prescription) AS requires_prescription

FROM deduplicated
WHERE rn = 1