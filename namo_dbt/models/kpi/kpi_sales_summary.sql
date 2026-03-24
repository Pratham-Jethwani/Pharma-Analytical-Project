SELECT

d.year,
d.month,
d.month_name,

COUNT(DISTINCT f.order_id) AS total_orders,
SUM(f.payment_amount) AS total_revenue,
SUM(f.payment_amount)/NULLIF(COUNT(DISTINCT f.order_id),0) AS avg_order_value

FROM {{ ref('fact_orders') }} f

JOIN {{ ref('dim_date') }} d
ON f.date_key = d.date_key

GROUP BY
d.year,
d.month,
d.month_name