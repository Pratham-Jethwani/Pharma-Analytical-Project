WITH source AS (

SELECT *
FROM {{ source('raw','product_suppliers') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY product_supplier_id
ORDER BY contract_date DESC
) AS rn

FROM source

)

SELECT

product_supplier_id,
product_id,
supplier_id,
CAST(supply_price AS FLOAT) AS supply_price,
CAST(contract_date AS DATE) AS contract_date

FROM deduplicated
WHERE rn = 1