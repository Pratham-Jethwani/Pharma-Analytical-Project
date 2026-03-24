SELECT

p.product_id,
p.product_name,
p.brand,

c.category_id,

p.mrp,
p.manufacture_date,
p.expiry_date,
p.requires_prescription

FROM {{ ref('stg_products') }} p

LEFT JOIN {{ ref('dim_category') }} c
ON p.category = c.category