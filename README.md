# 🏥 Hospital Readmission Analysis (SQL Project)

## 📋 Project Overview
This project analyzes **hospital readmission data** to uncover patterns and insights related to **patient demographics, medical specialties, procedures, and chronic conditions**. The analysis focuses on **identifying high-risk patients, understanding readmission trends, and providing actionable recommendations for improving healthcare outcomes.**

## 📊 Data Source
- Dataset: `hospital_readmissions.csv`
- Total Rows: 25,000 records
- Fields: Patient age, specialty, diagnosis, lab procedures, medications, and readmission status

## 🎯 Key Objectives
✅ Analyze **readmission rates** by department, diagnosis, and age group  
✅ Identify **high-risk patients** (multiple readmissions)  
✅ Assess **impact of diabetes management** on readmissions  
✅ Explore **average length of stay** by specialty  
✅ Automate data refresh using a **Stored Procedure**

## 🛠️ Tools Used
| Tool | Purpose |
|---|---|
| PostgreSQL | Database Management & SQL Queries |
| pgAdmin | Query Execution & Data Import |
| Python (for initial analysis) | Exploratory Analysis |
| GitHub | Version Control & Portfolio Showcase |

## 📂 Folder Structure
```
/hospital_readmission_analysis/
│-- README.md                    # Project Overview
│-- data/
│   └── hospital_readmissions.csv # Raw Data
│-- sql/
│   ├── schema.sql                 # Table Creation Script
│   ├── data_cleaning.sql          # Data Cleaning Queries
│   ├── analysis_queries.sql       # Analytical Queries
│   ├── views_and_ctes.sql         # CTEs & Views
│   ├── stored_procedures.sql      # Stored Procedure for Refresh
│-- insights_report.md            # Key Findings Summary
```

## 📑 Database Schema
| Column Name | Data Type | Description |
|---|---|---|
| age | VARCHAR(20) | Age group |
| time_in_hospital | INTEGER | Duration of stay |
| n_lab_procedures | INTEGER | Number of lab tests |
| n_procedures | INTEGER | Number of non-lab procedures |
| n_medications | INTEGER | Total medications prescribed |
| n_outpatient | INTEGER | Outpatient visits in history |
| n_inpatient | INTEGER | Inpatient visits in history |
| n_emergency | INTEGER | Emergency visits in history |
| medical_specialty | VARCHAR(50) | Treating department |
| diag_1, diag_2, diag_3 | VARCHAR(50) | Primary, secondary, tertiary diagnosis |
| glucose_test | VARCHAR(10) | Glucose test done (yes/no) |
| A1Ctest | VARCHAR(10) | A1C test done (yes/no) |
| change | VARCHAR(10) | Medication change (yes/no) |
| diabetes_med | VARCHAR(10) | On diabetes meds (yes/no) |
| readmitted | VARCHAR(10) | Readmitted within 30 days (yes/no) |

## 🔎 Analytical Questions Addressed
- Readmission Rates by Specialty, Diagnosis, and Age
- High-Risk Patients Analysis
- Length of Stay Analysis
- Diabetes Medication Impact

## 💡 Key Findings
- Older patients (70-90 years) have the highest readmission rates.
- Specialties like Family/General Practice and Emergency have the highest readmissions.
- Patients on diabetes medications are readmitted more often.
- Internal Medicine and Surgery patients have the longest stays.

## ⚙️ Stored Procedure Automation
```sql
SELECT refresh_high_risk_patients();
```
