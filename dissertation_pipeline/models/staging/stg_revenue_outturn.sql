-- ============================================================
-- MODEL: stg_revenue_outturn
-- Purpose: Clean and filter raw Revenue Outturn data
-- Source: raw_data.raw_revenue_outturn
-- Key decisions documented:
--   D4: Filter to status = 'submitted' only
--   D11: 'not submitted' rows excluded (23 rows, 2023-24 and 2024-25)
--        Birmingham (E08000025) absent from final two years
--   D9: RS_netcurrtot_net_exp as primary spending variable
--       RS_totsx_net_exp, RS_asc_net_exp, RS_csc_net_exp as sensitivity
--   Study period: 202003 to 202503 (2019-20 to 2024-25)
-- ============================================================

with source as (
    select * from {{ source('raw_data', 'raw_revenue_outturn') }}
),

filtered as (
    select *
    from source
    where
        -- Decision D4 and D11: keep only individually submitted rows
        status = 'submitted'

        -- Restrict to study period 2019-20 to 2024-25
        and year_ending between 202003 and 202503
),

cleaned as (
    select
        -- Year and authority identifiers
        year_ending,

        -- Convert year_ending to financial year start
        cast(left(cast(year_ending as string), 4) as int64) - 1
            as financial_year_start,

        ons_code as lad_code,
        la_name,
        la_class,
        la_subclass,
        status,

        -- Primary spending variable (Decision D9)
        -- RS line 749: net current expenditure total
        rs_netcurrtot_net_exp,

        -- Sensitivity spending variables (Decision D9)
        rs_totsx_net_exp,
        rs_asc_net_exp,
        rs_csc_net_exp

    from filtered
)

select * from cleaned