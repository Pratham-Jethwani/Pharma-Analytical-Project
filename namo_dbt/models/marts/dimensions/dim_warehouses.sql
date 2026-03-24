SELECT

w.warehouse_id,
city.city_id,
w.capacity,
w.manager_name

FROM {{ ref('stg_warehouses') }} w

LEFT JOIN {{ ref('dim_city') }} city
ON w.warehouse_city = city.city