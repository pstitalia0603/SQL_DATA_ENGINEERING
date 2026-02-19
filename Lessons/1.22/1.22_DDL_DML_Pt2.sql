--CTAS

--DESCRIBE

CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name,
FROM data_jobs.job_postings_fact as jpf
LEFT JOIN data_jobs.company_dim as cd
    ON jpf.company_id = cd.company_id;

SELECT COUNT(*)
FROM staging.job_postings_flat;


-- VIEW

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
SELECT jpfl.*
FROM staging.job_postings_flat AS jpfl
JOIN staging.priority_roles AS pr
    ON jpfl.job_title_short = pr.role_name
WHERE pr.priority_lvl=1;


SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;


-- TEMP TABLE

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging. priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';

SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp
GROUP BY job_title_short
ORDER BY job_count DESC;


--DELETE

 SELECT COUNT(*) FROM staging.job_postings_flat;
 SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
 SELECT COUNT(*) FROM senior_jobs_flat_temp;

 DELETE FROM  staging.job_postings_flat
 WHERE job_posted_date < '2024-01-01';


--TRUNCATE

TRUNCATE TABLE staging.job_postings_flat;

SELECT * from staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
    SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name,
FROM data_jobs.job_postings_fact as jpf
LEFT JOIN data_jobs.company_dim as cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date >= '2024-01-01';
