SELECT

o.order_id,
o.customer_id,

DATE(o.order_ts) AS date_key,

city.city_id,

o.order_status,
o.payment_method,

p.payment_amount

FROM {{ ref('stg_orders') }} o

LEFT JOIN {{ ref('stg_payments') }} p
ON o.order_id = p.order_id

LEFT JOIN {{ ref('dim_city') }} city
ON o.delivery_city = city.city