Select * from hospital_readmissions;

--Data Cleaning
--Standardize Age Groups 
UPDATE hospital_readmissions
SET age = REPLACE(age, '[', '');
UPDATE hospital_readmissions
SET age = REPLACE(age, ')', '');
UPDATE hospital_readmissions
SET age = REGEXP_REPLACE(age, '(.*)-(.*)', '\1-\2');

SELECT COUNT(*) FROM hospital_readmissions;

--Check Missing Specialties
SELECT medical_specialty, COUNT(*) 
FROM hospital_readmissions 
GROUP BY medical_specialty 
ORDER BY COUNT(*) DESC;

--Analysis
--Readmission Rate
SELECT 
    readmitted,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM hospital_readmissions), 2) AS percentage
FROM hospital_readmissions
GROUP BY readmitted;

--Readmission Rate by Specialty
SELECT 
    medical_specialty,
    COUNT(*) AS total_admissions,
    SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(100.0 * SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate
FROM hospital_readmissions
GROUP BY medical_specialty
ORDER BY readmission_rate DESC;

--Most Common Diagnoses (Primary Diagnosis)
SELECT 
    diag_1,
    COUNT(*) AS diagnosis_count
FROM hospital_readmissions
GROUP BY diag_1
ORDER BY diagnosis_count DESC
LIMIT 10;

--Average Stay by Specialty
SELECT 
    medical_specialty,
    ROUND(AVG(time_in_hospital), 2) AS avg_stay
FROM hospital_readmissions
GROUP BY medical_specialty
ORDER BY avg_stay DESC;

--Age Group Analysis
SELECT 
    age,
    COUNT(*) AS total_admissions,
    SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(100.0 * SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate
FROM hospital_readmissions
GROUP BY age
ORDER BY age;

--Diabetes Medication Impact
SELECT 
    diabetes_med,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(100.0 * SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmission_rate
FROM hospital_readmissions
GROUP BY diabetes_med;

--Compute readmission rate by department using a CTE
WITH department_readmissions AS (
    SELECT 
        medical_specialty,
        COUNT(*) AS total_admissions,
        SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions
    FROM hospital_readmissions
    GROUP BY medical_specialty
)

SELECT 
    medical_specialty,
    total_admissions,
    readmissions,
    ROUND(100.0 * readmissions / total_admissions, 2) AS readmission_rate
FROM department_readmissions
ORDER BY readmission_rate DESC;

--Patient Age Group Analysis (CTE to Compute Age Group Metrics)
WITH age_group_stats AS (
    SELECT 
        age,
        COUNT(*) AS total_patients,
        SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmitted_patients
    FROM hospital_readmissions
    GROUP BY age
)

SELECT 
    age,
    total_patients,
    readmitted_patients,
    ROUND(100.0 * readmitted_patients / total_patients, 2) AS readmission_rate
FROM age_group_stats
ORDER BY age;

--Create a view that you can easily query for reporting.
CREATE OR REPLACE VIEW readmission_by_specialty AS
WITH department_readmissions AS (
    SELECT 
        medical_specialty,
        COUNT(*) AS total_admissions,
        SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions
    FROM hospital_readmissions
    GROUP BY medical_specialty
)
SELECT 
    medical_specialty,
    total_admissions,
    readmissions,
    ROUND(100.0 * readmissions / total_admissions, 2) AS readmission_rate
FROM department_readmissions;

SELECT * FROM readmission_by_specialty ORDER BY readmission_rate DESC;

--View for Patients with Multiple Readmissions
CREATE OR REPLACE VIEW high_risk_patients AS
WITH readmission_count AS (
    SELECT 
        age,
        medical_specialty,
        COUNT(*) AS total_visits,
        SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions
    FROM hospital_readmissions
    GROUP BY age, medical_specialty
)
SELECT 
    age,
    medical_specialty,
    total_visits,
    readmissions,
    ROUND(100.0 * readmissions / total_visits, 2) AS readmission_rate
FROM readmission_count
WHERE readmissions > 1;

SELECT * FROM high_risk_patients ORDER BY readmission_rate DESC;



CREATE OR REPLACE FUNCTION refresh_high_risk_patients()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    DROP VIEW IF EXISTS high_risk_patients;

    CREATE VIEW high_risk_patients AS
    WITH readmission_count AS (
        SELECT 
            age,
            medical_specialty,
            COUNT(*) AS total_visits,
            SUM(CASE WHEN readmitted = 'yes' THEN 1 ELSE 0 END) AS readmissions
        FROM hospital_readmissions
        GROUP BY age, medical_specialty
    )
    SELECT 
        age,
        medical_specialty,
        total_visits,
        readmissions,
        ROUND(100.0 * readmissions / total_visits, 2) AS readmission_rate
    FROM readmission_count
    WHERE readmissions > 1;
    
    RAISE NOTICE 'High-risk patient view refreshed successfully';
END;
$$;



SELECT refresh_high_risk_patients();
SELECT * FROM high_risk_patients;





