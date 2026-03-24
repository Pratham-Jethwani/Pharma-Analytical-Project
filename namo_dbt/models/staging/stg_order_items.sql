WITH source AS (

SELECT *
FROM {{ source('raw','order_items') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY order_item_id
ORDER BY order_item_id DESC
) AS rn

FROM source

)

SELECT

order_item_id,
order_id,
product_id,
CAST(quantity AS INTEGER) AS quantity,
CAST(item_price AS FLOAT) AS item_price

FROM deduplicated
WHERE rn = 1