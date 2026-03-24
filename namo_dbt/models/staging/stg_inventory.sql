WITH source AS (

SELECT *
FROM {{ source('raw','inventory') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY inventory_id
ORDER BY last_updated DESC
) AS rn

FROM source

)

SELECT

inventory_id,
product_id,
warehouse_id,
CAST(stock_quantity AS INTEGER) AS stock_quantity,
CAST(reorder_level AS INTEGER) AS reorder_level,
CAST(last_updated AS DATE) AS last_updated

FROM deduplicated
WHERE rn = 1