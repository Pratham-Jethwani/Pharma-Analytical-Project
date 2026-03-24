{{ config(materialized='table') }}

SELECT

ROW_NUMBER() OVER (ORDER BY category) AS category_id,
category

FROM (

SELECT DISTINCT category
FROM {{ ref('stg_products') }}

)