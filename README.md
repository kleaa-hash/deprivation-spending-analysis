Deprivation and Local Authority Spending in England

This repository contains the code, data and documentation for my MSc dissertation. The project uses a cloud-based analytics platform to examine whether revenue spending by English local authorities reflected deprivation between 2019-20 and 2024-25, and whether a documented, publicly available platform of this kind can support accountability.

Dissertation: A Cloud-Based Analytics Engineering Platform for Public-Sector Accountability: Deprivation and Local Authority Spending in England Klea Zici, MSc Data Science and Artificial Intelligence, Oxford Brookes University, 2026

Dashboard: Looker Studio report
Decisions catalogue: docs/decisions_catalogue.pdf
Main findings
Each additional point of IMD score is associated with £35.92 more net current expenditure per resident (Model 2, p < 0.001, n = 1,727).
Controlling for authority type reduces this to £13.98 per point, about 61% lower, and deprivation remains significant within each type (Model 1).
There is no statistically significant change in the relationship between 2019-20 and 2024-25 once regional trends are allowed for.
Against Busuioc's (2021) framework, the platform largely meets the Information and Explanation stages. The Consequences stage is not met, as no forum exists that can require an answer or act on one.

Full results, sensitivity checks and limitations are reported in the dissertation and the decisions catalogue.

Repository contents
Location	Stage	Contents
imd2025_file10_lad.xlsx, mhclg_revenue_outturn_multiyear.csv.csv, mye24tablesuk.xlsx, Local_Authority_District_to_Region_(December_2024)…, Local_Authority_Districts_December_2024_Boundaries…	Raw data	The source files as downloaded
01_ingestion.ipynb	Ingestion	Loads the raw files into BigQuery (raw_data dataset). Column names are cleaned, the population table is limited to local authority districts for mid-2019 to mid-2024, and the region lookup is reduced to code and region name
dissertation_pipeline/	Transformation	dbt project with four staging models, the mart_deprivation_spending table, model documentation and 12 data quality tests
02_analysis.ipynb	Analysis	Descriptive statistics, Models 1 and 2, sensitivity checks, the Random Forest with Group K-Fold validation, SHAP values and the maps
docs/	Documentation	Discretionary decisions catalogue
Looker Studio (link above)	Reporting	Public dashboard reading from BigQuery
dbt lineage
raw_data.raw_imd_2025          -> stg_imd_2025         \
raw_data.raw_revenue_outturn   -> stg_revenue_outturn   \
                                                          -> mart_deprivation_spending
raw_data.raw_population        -> stg_population        /
raw_data.raw_region_lookup     -> stg_region_lookup    /

Revenue Outturn and IMD are combined with an inner join, so only authorities present in both are included (D7). Population and region are added to each row. The boundary file is used only in Python, for the maps.

Data sources
Source	Publisher	Used for
English Indices of Deprivation 2025, File 10 (local authority district summaries)	MHCLG	IMD average score for each authority
Revenue Outturn multi-year data set	MHCLG	Net current expenditure and service spending
Mid-year population estimates, mid-2024 edition (table MYE4; mid-2019 to mid-2024 used)	ONS	Population for per-resident figures, matched by year
Local Authority Districts (December 2024) boundariesONS Open Geography Portal	Maps
Local Authority District to Region (December 2024) lookup	ONS Open Geography Portal	Region control

All data are published under the Open Government Licence v3.0.

Reproduction

Requirements: a Google Cloud project with BigQuery enabled, Python 3, and dbt Core 1.11 with the BigQuery adapter.

The project ID deprivation-spending-analysis is set in the following places and should be replaced with your own:

01_ingestion.ipynb and 02_analysis.ipynb (Edit → Find and replace in Colab)
dissertation_pipeline/models/staging/sources.yml (the project: line)
Clone the repository and install the packages:
bash
   git clone https://github.com/kleaa-hash/deprivation-spending-analysis.git
   cd deprivation-spending-analysis
   pip install -r requirements.txt
Create a BigQuery dataset named raw_data in the EU multi-region. dbt creates spending_analysis_staging and spending_analysis_marts when it runs.
Open 01_ingestion.ipynb in Google Colab, authenticate when prompted and run all cells. The source files are read directly from this repository. Four tables are created in raw_data: IMD, Revenue Outturn, population and region lookup.
Copy profiles_example.yml to ~/.dbt/profiles.yml, replace YOUR_GCP_PROJECT_ID with your project ID and run gcloud auth application-default login. The dataset name spending_analysis should be kept, as the notebooks read from spending_analysis_staging and spending_analysis_marts. Authentication uses OAuth, so no credentials are stored in the repository (D1).
Build and test the models:
bash
   cd dissertation_pipeline
   dbt run
   dbt test         
   dbt docs generate
   dbt docs serve    
Open 02_analysis.ipynb in Colab and upload Local_Authority_Districts_December_2024_Boundaries_UK_BGC_7423724764112241180.geojson from this repository to /content/ using the Files panel. Run all cells to reproduce the results in Section 9 of the dissertation and the tables used by the dashboard.

The Looker Studio dashboard is built in a hosted tool and cannot be version-controlled. The tables it reads are produced by the steps above.

Discretionary decisions

Choices made during the project, including the deprivation measure, council mergers, the treatment of COVID years, the exclusion of City of London and the validation of the Random Forest, are recorded in the decisions catalogue with date, alternatives, rationale and effect. Decision numbers (D1 to D31) match the dissertation. Authorities missing because of boundary changes or unsubmitted returns are listed under D7 and D11.

Licence

Data: Open Government Licence v3.0. Code: available for academic review and reuse with attribution.
