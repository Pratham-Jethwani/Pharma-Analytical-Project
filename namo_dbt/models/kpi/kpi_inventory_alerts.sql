SELECT

p.product_name,
w.warehouse_id,

i.stock_quantity,
i.reorder_level,

CASE
WHEN i.stock_quantity < i.reorder_level
THEN 'LOW STOCK'
ELSE 'OK'
END AS inventory_status

FROM {{ ref('fact_inventory') }} i

JOIN {{ ref('dim_products') }} p
ON i.product_id = p.product_id

JOIN {{ ref('dim_warehouses') }} w
ON i.warehouse_id = w.warehouse_id