-- ============================================================
-- MODEL: stg_imd_2025
-- Purpose: Clean and standardise the raw IMD 2025 data
-- Source: raw_data.raw_imd_2025 (loaded via 01_ingestion.ipynb)
-- Key decisions documented:
--   D3: IMD average score selected as primary deprivation measure
--   D8: 296 authorities confirmed (not 317 as in proposal)
--   D10: Column names already cleaned to snake_case during ingestion
-- ============================================================

with source as (
    select * from {{ source('raw_data', 'raw_imd_2025') }}
),

cleaned as (
    select
        -- Authority identifiers
        local_authority_district_code_2024 as lad_code,
        local_authority_district_name_2024 as lad_name,

        -- Primary deprivation measure (Decision D3)
        -- Using average score not rank: score is continuous,
        -- more appropriate for linear regression than ordinal rank
        imd_average_score as imd_score,
        imd_rank_of_average_score as imd_rank,

        -- Secondary measures retained for sensitivity analysis
        imd_average_rank,
        imd_proportion_of_lsoas_in_most_deprived_10_nationally
            as imd_proportion_deprived_10pct,

        -- Extent and concentration measures
        imd25_extent as imd_extent,
        imd25_local_concentration as imd_local_concentration

    from source
)

select * from cleaned