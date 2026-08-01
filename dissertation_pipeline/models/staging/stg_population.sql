-- ============================================================
-- MODEL: stg_population
-- Purpose: Clean and prepare ONS mid-year population estimates
-- Source: raw_data.raw_population
-- Key decisions documented:
--   D12: Year-matched ONS mid-year estimates used as denominator
--        Mid-2019 = financial_year_start 2019 = covers 2019-20
--        Mid-2024 = financial_year_start 2024 = covers 2024-25
--   Only English local authority districts included (296 authorities)
-- ============================================================

with source as (
    select * from {{ source('raw_data', 'raw_population') }}
),

cleaned as (
    select
        lad_code,
        lad_name,
        financial_year_start,
        population
    from source
    where population is not null
    and population > 0
)

select * from cleaned