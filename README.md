\# Deprivation and Local Authority Spending in England



A cloud-based analytics engineering platform analysing whether English local authority revenue expenditure reflects deprivation need, using IMD 2025 and MHCLG Revenue Outturn data for 2019-20 to 2024-25.



\## Dissertation



Title: A Cloud-Based Analytics Engineering Platform for Transparent Public-Sector Policy Analysis: Deprivation and Local Authority Spending in England



Author: Klea Zici, 19376977



Programme: MSc Data Science and Artificial Intelligence



Institution: Oxford Brookes University



Year: 2026



\## Data Sources



\- IMD 2025 File 10 (MHCLG): English Indices of Deprivation 2025

\- MHCLG Revenue Outturn multi-year dataset

\- ONS Mid-Year Population Estimates 2024



All data published under Open Government Licence v3.0.



\## Technical Stack



\- Google BigQuery (cloud data warehouse)

\- dbt Core 1.11.11 (transformation, documentation, lineage graph)

\- Python 3.13.13 / Google Colab (ingestion and analysis)

\- Google Looker Studio (dashboard)



\## Reproduction Instructions



1\. Clone this repository

2\. Set up Google Cloud project and BigQuery dataset

3\. Run 01\_ingestion.ipynb in Google Colab to load raw data

4\. Configure dbt profile with BigQuery credentials

5\. Run dbt run to build all models

6\. Run dbt test to validate data quality

7\. Run dbt docs generate and dbt docs serve to view lineage graph



\## Discretionary Decisions



All consequential decisions made during pipeline construction are documented in the Discretionary Decisions Catalogue, available in the project documentation.



\## Licence



Code: MIT Licence



Data: Open Government Licence v3.0

