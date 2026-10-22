# medicare-claims-utilization-dashboard
# Medicare Claims Cost & Utilization Analysis

End-to-end analysis of Medicare claims data using PostgreSQL, Python, Excel, and Power BI to uncover cost drivers and utilization trends.

> **Dashboard walkthrough:** [Loom video link, add later]
> **Live dashboard:** [Power BI link, add later]

## Business Question

A health plan wants to understand where its money is going. Which member groups, conditions, and services drive the most cost and utilization, and where can care management or cost-containment efforts have the biggest impact?

## Data

- **Source:** [CMS 2008-2010 Data Entrepreneurs' Synthetic Public Use File (DE-SynPUF), Sample 1](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/DE_Syn_PUF)
- **Tables used:** Beneficiary Summary (2008-2010), Inpatient Claims, Outpatient Claims, Carrier Claims
- **Period:** 2008-2010
- **Note:** The data is synthetic, so findings demonstrate analytical method and are not conclusions about real Medicare beneficiaries. Raw data files are not included in this repo because of their size.

## Approach

1. **Data loading:** Loaded CSV files into PostgreSQL using a Python (pandas + SQLAlchemy) script.
2. **Cleaning and validation:** Checked for duplicates, missing IDs, invalid dates, and negative payments.
3. **Metric building in SQL:** Calculated total paid per member, PMPM (per member per month) cost, admissions per 1,000 members, and average length of stay.
4. **Segmentation:** Broke results down by age band, sex, state, and chronic condition.
5. **Dashboard:** Built a 3-page Power BI report (executive overview, utilization drilldown, high-cost members).
6. **Stakeholder summary:** Produced an Excel pivot summary with recommendations.

## Key Findings

*(Fill this in after your analysis, using real numbers.)*

- [Example: The top 5% of members account for X% of total spend.]
- [Example: Inpatient admissions per 1,000 were highest among members aged 75+.]
- [Example: Members with X chronic conditions cost Y times more than those with none.]

## Recommendations

- [Example: Prioritize care management outreach for the highest-cost 5% of members.]
- [Example: Target discharge follow-up for conditions with the highest admission rates.]

## Dashboard Preview

![Overview page](images/dashboard_overview.png)

## Repository Structure

```
sql/        SQL scripts (table creation, cleaning, metrics)
python/     Data loading and validation scripts
excel/      Pivot summaries and stakeholder reports
powerbi/    Power BI report file
images/     Dashboard screenshots
docs/       Methodology and data dictionary notes
```

## Tools

PostgreSQL, SQL, Python (pandas, SQLAlchemy), Excel, Power BI

## How to Reproduce

1. Download DE-SynPUF Sample 1 from the CMS link above.
2. Create a PostgreSQL database named `medicare_claims`.
3. Run `python/load_data.py` to load the CSV files.
4. Run the SQL scripts in `sql/` in numbered order.
5. Open the Power BI file and refresh the data source.
