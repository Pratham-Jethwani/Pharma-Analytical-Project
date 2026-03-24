WITH customer_orders AS (

SELECT
customer_id,
COUNT(order_id) AS order_count

FROM {{ ref('fact_orders') }}

GROUP BY customer_id

)

SELECT

COUNT(DISTINCT customer_id) AS total_customers,

COUNT(DISTINCT CASE
WHEN order_count > 1
THEN customer_id
END) AS repeat_customers

FROM customer_orders