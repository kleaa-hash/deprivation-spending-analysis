-- ============================================================
-- MODEL: stg_region_lookup
-- Purpose: Clean ONS region lookup for joining to mart model
-- Source: raw_data.raw_region_lookup
-- Decision D18: regional control variable added to regression
-- 296 English local authority districts, 9 regions
-- ============================================================

with source as (
    select * from {{ source('raw_data', 'raw_region_lookup') }}
),

cleaned as (
    select
        lad_code,
        region_name
    from source
    where lad_code is not null
)

select * from cleaned