{{ config(materialized='table') }}

WITH customer_cities AS (

SELECT DISTINCT city
FROM {{ ref('stg_customers') }}

),

warehouse_cities AS (

SELECT DISTINCT warehouse_city AS city
FROM {{ ref('stg_warehouses') }}

),

order_cities AS (

SELECT DISTINCT delivery_city AS city
FROM {{ ref('stg_orders') }}

),

all_cities AS (

SELECT city FROM customer_cities
UNION
SELECT city FROM warehouse_cities
UNION
SELECT city FROM order_cities

)

SELECT
ROW_NUMBER() OVER (ORDER BY city) AS city_id,
city

FROM all_cities