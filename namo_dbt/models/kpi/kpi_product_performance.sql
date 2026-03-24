SELECT

p.product_name,
c.category,

SUM(f.quantity) AS total_units_sold,
SUM(f.revenue) AS total_revenue

FROM {{ ref('fact_order_items') }} f

JOIN {{ ref('dim_products') }} p
ON f.product_id = p.product_id

JOIN {{ ref('dim_category') }} c
ON p.category_id = c.category_id

GROUP BY
p.product_name,
c.category