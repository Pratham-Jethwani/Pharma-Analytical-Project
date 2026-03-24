WITH source AS (

SELECT *
FROM {{ source('raw','prescriptions') }}

),

deduplicated AS (

SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY prescription_id
ORDER BY upload_date DESC
) AS rn

FROM source

)

SELECT

prescription_id,
customer_id,
doctor_name,
hospital_name,
CAST(upload_date AS DATE) AS upload_date,
LOWER(verification_status) AS verification_status

FROM deduplicated
WHERE rn = 1