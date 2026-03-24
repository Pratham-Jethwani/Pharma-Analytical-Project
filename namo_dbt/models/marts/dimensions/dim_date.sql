{{ config(materialized='table') }}

WITH date_spine AS (

    SELECT
        DATEADD(day, seq4(), '2022-01-01') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 3650))  -- ~10 years of dates

)

SELECT

    date_day                    AS date_key,
    YEAR(date_day)              AS year,
    QUARTER(date_day)           AS quarter,
    MONTH(date_day)             AS month,
    DAY(date_day)               AS day,

    TO_CHAR(date_day, 'MMMM')   AS month_name,
    TO_CHAR(date_day, 'DY')     AS day_name,

    DAYOFWEEK(date_day)         AS day_of_week,
    WEEK(date_day)              AS week_of_year,

    CASE
        WHEN DAYOFWEEK(date_day) IN (1,7)
        THEN TRUE
        ELSE FALSE
    END                         AS is_weekend

FROM date_spine