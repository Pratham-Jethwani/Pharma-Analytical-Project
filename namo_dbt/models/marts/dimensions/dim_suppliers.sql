SELECT

supplier_id,
supplier_name,
supplier_city,
contact_email,
contract_start_date

FROM {{ ref('stg_suppliers') }}