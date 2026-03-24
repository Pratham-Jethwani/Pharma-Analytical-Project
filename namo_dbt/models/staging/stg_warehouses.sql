WITH source AS (

SELECT *
FROM {{ source('raw','warehouses') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY warehouse_id
ORDER BY capacity DESC
) AS rn

FROM source

)

SELECT

warehouse_id,
warehouse_city,
CAST(capacity AS INTEGER) AS capacity,
manager_name

FROM deduplicated
WHERE rn = 1