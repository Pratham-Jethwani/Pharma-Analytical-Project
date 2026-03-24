SELECT

payment_id,
order_id,
payment_method,
payment_status,
payment_amount,
payment_ts

FROM {{ ref('stg_payments') }}