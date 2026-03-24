SELECT

oi.order_item_id,
oi.order_id,
oi.product_id,

DATE(o.order_ts) AS date_key,

oi.quantity,
oi.item_price,

(oi.quantity * oi.item_price) AS revenue

FROM {{ ref('stg_order_items') }} oi

JOIN {{ ref('stg_orders') }} o
ON oi.order_id = o.order_id