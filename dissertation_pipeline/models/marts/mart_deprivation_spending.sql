-- ============================================================
-- MODEL: mart_deprivation_spending
-- Purpose: Join IMD deprivation, revenue spending, and population
--          data to produce the core analytical table
-- Sources: stg_imd_2025, stg_revenue_outturn, stg_population
-- Key decisions documented:
--   D3: IMD average score as primary deprivation measure
--   D4/D11: Revenue Outturn filtered to submitted rows only
--   D6: COVID years (2020-21, 2021-22) included with indicator flag
--   D7: Council mergers - authorities must appear in all three tables
--   D9: RS_netcurrtot_net_exp as primary spending variable
--       RS_totsx_net_exp, RS_asc_net_exp, RS_csc_net_exp as sensitivity
--   D12: Year-matched ONS population denominators
-- ============================================================

with imd as (
    select * from {{ ref('stg_imd_2025') }}
),

revenue as (
    select * from {{ ref('stg_revenue_outturn') }}
),

population as (
    select * from {{ ref('stg_population') }}
),

-- Join revenue to population on authority code and year
revenue_with_pop as (
    select
        r.year_ending,
        r.financial_year_start,
        r.lad_code,
        r.la_name,
        r.la_class,
        r.la_subclass,

        -- Primary spending variable (Decision D9)
        -- RS line 749: net current expenditure total
        -- Standard measure used in academic literature
        r.rs_netcurrtot_net_exp as net_current_expenditure,

        -- Sensitivity spending variables (Decision D9)
        r.rs_totsx_net_exp as total_service_expenditure,
        r.rs_asc_net_exp as adult_social_care_expenditure,
        r.rs_csc_net_exp as childrens_social_care_expenditure,

        -- Population denominator (Decision D12)
        p.population,

        -- Per capita calculations
        -- Dividing by 1000 converts from thousands of pounds to pounds
        round(r.rs_netcurrtot_net_exp * 1000.0 / p.population, 2)
            as net_current_expenditure_per_capita,
        round(r.rs_totsx_net_exp * 1000.0 / p.population, 2)
            as total_service_expenditure_per_capita,
        round(r.rs_asc_net_exp * 1000.0 / p.population, 2)
            as adult_social_care_per_capita,
        round(r.rs_csc_net_exp * 1000.0 / p.population, 2)
            as childrens_social_care_per_capita,

        -- COVID year indicator (Decision D6)
        -- 2020-21 and 2021-22 involved exceptional COVID spending
        case
            when r.financial_year_start in (2020, 2021) then true
            else false
        end as is_covid_year

    from revenue r
    left join population p
        on r.lad_code = p.lad_code
        and r.financial_year_start = p.financial_year_start
),

-- Join with IMD deprivation scores
final as (
    select
        rp.year_ending,
        rp.financial_year_start,
        rp.lad_code,
        rp.la_name,
        rp.la_class,
        rp.la_subclass,

        -- Deprivation measures (Decision D3)
        i.imd_score,
        i.imd_rank,
        i.imd_proportion_deprived_10pct,

        -- Spending variables
        rp.net_current_expenditure,
        rp.total_service_expenditure,
        rp.adult_social_care_expenditure,
        rp.childrens_social_care_expenditure,

        -- Population
        rp.population,

        -- Per capita spending
        rp.net_current_expenditure_per_capita,
        rp.total_service_expenditure_per_capita,
        rp.adult_social_care_per_capita,
        rp.childrens_social_care_per_capita,

        -- COVID indicator
        rp.is_covid_year

    from revenue_with_pop rp
    -- Inner join with IMD ensures only authorities
    -- present in both datasets are included (Decision D7)
    inner join imd i
        on rp.lad_code = i.lad_code
)

select * from final