<div align="center">

# Medicare Claims Cost & Utilization Dashboard

**SQL (PostgreSQL) · Python (pandas, SQLAlchemy) · Power BI (DAX)**

<img src="https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL">
<img src="https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white" alt="Python">
<img src="https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=black" alt="Power BI">
<img src="https://img.shields.io/badge/Data-Synthetic%20(CMS%20DE--SynPUF)-orange" alt="Synthetic data">

</div>

<br>

**Business question:** Where is the money going, and which populations or services drive utilization?

An end-to-end analytics project that takes raw Medicare claims files, loads them into PostgreSQL, cleans them with SQL views, builds a member-year fact table, and presents cost and utilization in a two-page Power BI dashboard.

> [!WARNING]
> **Synthetic data notice.** This project uses the CMS 2008–2010 Data Entrepreneurs' Synthetic Public Use File (DE-SynPUF), Sample 1. The data is synthetic and was built to protect beneficiary privacy. CMS notes that the synthetic process limits its value for drawing reliable conclusions about real Medicare beneficiaries. The findings below demonstrate the method; they are not real-world facts about Medicare.

---

## Table of Contents

- [Dashboard](#dashboard)
- [Key Findings](#key-findings-synthetic-data)
- [Data](#data)
- [Pipeline](#pipeline)
- [Data Model](#data-model)
- [DAX Measures](#dax-measures)
- [Metric Definitions](#metric-definitions)
- [Limitations](#limitations)
- [Roadmap](#roadmap)
- [Repository Structure](#repository-structure)
- [How to Run](#how-to-run)
- [Skills Demonstrated](#skills-demonstrated)

---

## Dashboard

<table>
  <thead>
    <tr>
      <th align="left">Page</th>
      <th align="left">What it answers</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>1. Executive Overview</b></td>
      <td>How much was spent, on what type of care, and how did PMPM change by year?</td>
    </tr>
    <tr>
      <td><b>2. Utilization Drilldown</b></td>
      <td>Which age bands, sexes, races, states and chronic-disease burdens drive cost, admissions and length of stay?</td>
    </tr>
  </tbody>
</table>

<!-- Add screenshots to docs/screenshots/ and keep these links -->

<table>
  <tr>
    <td align="center" width="50%">
      <img src="docs/screenshots/executive_overview.png" alt="Executive Overview" width="100%"><br>
      <sub><b>Executive Overview</b></sub>
    </td>
    <td align="center" width="50%">
      <img src="docs/screenshots/utilization_drilldown.png" alt="Utilization Drilldown" width="100%"><br>
      <sub><b>Utilization Drilldown</b></sub>
    </td>
  </tr>
</table>

### Page 1: Executive Overview

- **KPI cards:** distinct members, inpatient PMPM and outpatient + carrier PMPM, admissions per 1,000, average length of stay (ALOS), total Medicare paid
- **Combo chart:** total Medicare cost (columns) with PMPM (line) by year, 2008–2010
- **Stacked columns:** cost by type of care (inpatient vs outpatient + carrier) by year
- **Year slicer**

### Page 2: Utilization Drilldown

- **Slicers:** year, sex, race, age band, state
- Cost PMPM by age band, by race and by sex
- Average length of stay by age band
- Claims per member-year by claim type (inpatient, outpatient, carrier)
- Average cost per member-year by number of chronic conditions
- Cost PMPM by state

---

## Key Findings (synthetic data)

| # | Finding | Evidence |
|:-:|---------|----------|
| 1 | **Inpatient care is the largest cost driver.** | 52% of the $1.24B paid over 2008–2010 was inpatient; carrier 31%; outpatient 17%. |
| 2 | **Inpatient share is shrinking.** | 55% of spend in 2008 → 49% in 2010. |
| 3 | **Chronic disease burden is the strongest cost signal.** | Member-years with 4+ chronic conditions are 28% of the population but 71% of spend. Member-years with none are 37% of the population but 3% of spend. |
| 4 | **Cost rises steeply with each added condition.** | Average cost per member-year grows from about $270 (0 conditions) to about $36,800 (11 conditions). PMPM grows from $29 to $3,108. |
| 5 | **Cost and admissions rise with age.** | PMPM: $289 (65–74), $353 (75–84), $397 (85+). Admissions per 1,000: 156 → 212 → 254. Under-65 beneficiaries sit at $346 PMPM. |
| 6 | **Length of stay tracks illness, not age.** | ALOS is flat across age bands (5.5–5.7 days) but rises from 4.7 days (0 conditions) to 7.0 days (11 conditions). |
| 7 | **Sex shows almost no cost difference.** | PMPM $336 (female) vs $330 (male). |

### Yearly summary

| Year | Total paid | PMPM | Admissions / 1,000 | ALOS (days) |
|:----:|-----------:|-----:|-------------------:|------------:|
| 2008 | $465.2M | $381 | 236 | 5.60 |
| 2009 | $492.2M | $387 | 221 | 5.60 |
| 2010 | $284.3M | $231 | 123 | 5.50 |

> [!NOTE]
> **Interpreting 2010:** total cost, PMPM and admissions all drop sharply in 2010, but membership barely changes (116,352 → 114,538 → 112,754 member-years) and ALOS stays at about 5.5 days. That pattern points to lower claim volume in the synthetic file rather than a genuine change in care, so the 2010 decline should not be read as a real cost-containment result.

---

## Data

| Item | Detail |
|------|--------|
| **Source** | CMS DE-SynPUF, Sample 1 only |
| **Files used** | Beneficiary summary (2008, 2009, 2010), inpatient claims, outpatient claims, carrier claims (both CSV files) |
| **Not used** | Prescription drug events |
| **Join key** | `DESYNPUF_ID` |
| **Size in the final model** | 116,352 distinct beneficiaries, 343,644 member-year rows |
| **Dictionary** | SynPUF Data User Document |

---

## Pipeline

```text
CMS CSV files ─► Python (pandas + SQLAlchemy) ─► PostgreSQL: raw tables
                                                      │
                          SQL cleaning views: beneficiary_cl, *_count views, ref_states
                                                      │
                     SQL outputs: dashboard_member_year (table), pmpm (view)
                                                      │
                                       Power BI (DAX measures, 2 pages)
```

1. **Load (Python).** A pandas + SQLAlchemy script loads the beneficiary (one table per year), inpatient, outpatient and carrier files into PostgreSQL.
2. **Clean (SQL).** Each source gets a cleaning script that trims text fields, casts types and decodes values:
   - **Beneficiary:** unions the 2008, 2009 and 2010 tables with a `bene_year` column; decodes sex, race, ESRD and the 11 chronic-condition flags into readable labels; joins a `ref_states` lookup (state codes 01–54 → state names); and adds `total_medicare_paid`, `total_patient_paid` and `total_other_insurer_paid`.
   - **Inpatient, outpatient, carrier:** trims and casts claim fields, then builds per-beneficiary-per-year count views (`ip_count`, `op_count`, `carrier_count`). `ip_count` also sums inpatient utilization days.
3. **Model (SQL).** `dashboard_member_year` is the clean fact table at beneficiary × year grain: age and age band, state name, total Medicare cost, chronic-condition count, claim counts for all three claim types, and inpatient days. `pmpm` is a year-level view of inpatient and outpatient + carrier cost with Part A and Part B member-months and precomputed PMPM.
4. **Validate (SQL).** Standalone queries calculate claims per beneficiary-year and admissions by year, to cross-check the DAX results.
5. **Visualize (Power BI).** Power BI connects to the `medicare_claims` PostgreSQL database on localhost, imports `dashboard_member_year` and `pmpm`, relates them on `bene_year`, and defines the DAX measures below. Breakdowns by age band, sex, race, state and chronic-condition count are computed in DAX over the fact table.

---

## Data Model

| Object | Type | Grain | Key columns |
|--------|------|-------|-------------|
| `dashboard_member_year` | table | beneficiary × year | `desynpuf_id_cl`, `bene_year`, `age`, `age_band`, `state_name`, `sex`, `race`, 11 chronic-condition flags, `chronic_count`, `total_medicare_cost`, `medreimb_ip/op/car_cl`, `ip_cnt_clms`, `ip_days`, `op_cnt_clms`, `crrr_cnt_clms`, Part A months (`bene_hi_cvrage_tot_mons_cl`), Part B months (`bene_smi_cvrage_tot_mons_cl`) |
| `pmpm` | view | year | `sum_ip_cost`, `sum_op_car_cost`, `part_a_member_months`, `part_b_member_months`, `medicare_ip_cost_pmpm`, `medicare_op_cost_pmpm` |

**Relationship:** `dashboard_member_year[bene_year]` → `pmpm[bene_year]` (many-to-one, single direction).

<details>
<summary><b>The 11 chronic-condition flags</b></summary>

<br>

Alzheimer's/dementia, heart failure, chronic kidney disease, cancer, COPD, depression, diabetes, ischemic heart disease, osteoporosis, RA/OA, and stroke/TIA. `chronic_count` is the number of flags set (0–11).

</details>

---

## DAX Measures

| Measure | Definition |
|---------|------------|
| `cost_pmpm` | `DIVIDE(SUM(total_medicare_cost), SUM(bene_smi_cvrage_tot_mons_cl))` |
| `ip_pmpm` | `DIVIDE(SUM(medreimb_ip_cl), SUM(bene_hi_cvrage_tot_mons_cl))` |
| `opcar_pmpm` | `DIVIDE([sum_opcar_cost], SUM(bene_smi_cvrage_tot_mons_cl))` |
| `sum_ip_cost` | `SUM(medreimb_ip_cl)` |
| `sum_opcar_cost` | `SUM(medreimb_op_cl) + SUM(medreimb_car_cl)` |
| `adm_per_1000` | `DIVIDE(SUM(ip_cnt_clms), COUNTA(desynpuf_id_cl)) * 1000` |
| `ALOS` | `DIVIDE(SUM(ip_days), SUM(ip_cnt_clms))` |
| IP / OP / Carrier Claims Per Member-Year | `DIVIDE(SUM(<claim count>), COUNTA(desynpuf_id_cl))` |
| Average Cost Per Member-Year | `DIVIDE(SUM(total_medicare_cost), COUNTROWS(dashboard_member_year))` |

---

## Metric Definitions

- **Cost source:** cost comes from the annual reimbursement fields in the beneficiary summary file (`medreimb_ip`, `medreimb_op`, `medreimb_car`). Total Medicare cost is their sum. The claims files supply claim counts and inpatient days, not dollars.
- **PMPM (per member per month):** cost divided by covered member-months. Inpatient PMPM uses Part A months; total cost and outpatient + carrier PMPM use Part B months. Using Part A months for total cost would give slightly lower values (for example $359 instead of $381 in 2008).
- **Admissions per 1,000:** inpatient claims divided by member-year records, times 1,000. It counts inpatient claims as a proxy for admissions, and the denominator is member-year records, not full-year equivalents.
- **ALOS:** total inpatient utilization days divided by inpatient claims.
- **Claim year:** a claim is assigned to the calendar year of its claim-through date.
- **Age:** age on July 1 of each beneficiary year. Age bands are Under 65, 65–74, 75–84 and 85+.
- **Cost per member-year:** total Medicare paid divided by member-year rows.

---

## Limitations

- **Synthetic data:** use it to evaluate the method, not to draw real-world conclusions.
- **Three years only,** and 2010 looks structurally different from 2008–2009 (see above).
- **State-level estimates** rest on small samples in some states (for example about 1,500 member-year rows in Wyoming), and a catch-all "Others" state group is included.
- **Cost is Medicare-paid only** and excludes patient and other-insurer payments.

---


---

## Repository Structure

```text
├── python/                                   # data loading script (pandas + SQLAlchemy)
├── sql/
│   ├── cleaning_medicare_beneficiary_2008.sql    # beneficiary_cl view + ref_states
│   ├── cleaning_medicare_inpatient_claims.sql    # inpatient views, ip_count
│   ├── cleaning_medicare_outpatient_claims.sql   # outpatient views, op_count
│   ├── cleaning_medicare_carrier_claims.sql      # carrier views, carrier_count
│   ├── claims_count.sql                          # claim counts per beneficiary-year
│   ├── admissions_per_1000_members.sql           # admissions by year (validation)
│   ├── Cost_PMPM.sql                             # pmpm view
│   └── dashboard_member_year.sql                 # fact table for Power BI
├── powerbi/
│   └── dashboard_analysis_for_medicare.pbix
├── docs/
│   └── screenshots/
└── README.md
```

---

## How to Run

1. Download Sample 1 (including both carrier CSVs) from the CMS page.
2. Create a PostgreSQL database named `medicare_claims`.
3. Run the Python loading script to create the raw tables (`beneficiary_2008`, `beneficiary_2009`, `beneficiary_2010`, `inpatient_claims`, `outpatient_claims`, `carrier_claims`).
4. Run the SQL scripts in this order:
   1. `cleaning_medicare_beneficiary_2008.sql`
   2. `cleaning_medicare_inpatient_claims.sql`
   3. `cleaning_medicare_outpatient_claims.sql`
   4. `cleaning_medicare_carrier_claims.sql`
   5. `Cost_PMPM.sql`
   6. `dashboard_member_year.sql`
   7. `claims_count.sql` and `admissions_per_1000_members.sql` (optional validation queries)
5. Open `dashboard_analysis_for_medicare.pbix` in Power BI Desktop and point the data source at your PostgreSQL server.

---

## Skills Demonstrated

Healthcare claims analytics · PMPM and utilization metrics · ETL with Python · SQL data cleaning and modeling (views, CTEs, joins) · DAX · dashboard design · communicating data limitations

---

<div align="center">


</div>
