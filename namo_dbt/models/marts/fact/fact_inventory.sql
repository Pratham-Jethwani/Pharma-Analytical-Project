SELECT

inventory_id,
product_id,
warehouse_id,
stock_quantity,
reorder_level,
last_updated

FROM {{ ref('stg_inventory') }}