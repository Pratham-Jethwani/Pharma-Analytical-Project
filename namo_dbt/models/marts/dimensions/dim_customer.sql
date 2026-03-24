SELECT

c.customer_id,
c.customer_name,
c.email,
c.phone,

city.city_id,

c.state,
c.signup_date

FROM {{ ref('stg_customers') }} c

LEFT JOIN {{ ref('dim_city') }} city
ON c.city = city.city