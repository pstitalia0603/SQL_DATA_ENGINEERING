-- Length and Count

SELECT LENGTH('SQL');

SELECT CHAR_LENGTH('SQL');

-- Case Conversion

SELECT LOWER('SQL');

SELECT UPPER('Sql');

-- Substring/Extraction

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL', 2, 2);


-- Concatenation

SELECT CONCAT('SQL', '-', 'Functions');


SELECT 'SQL' || '-' || 'Functions';


-- Trimming

SELECT TRIM(' SQL');

SELECT LTRIM (' SQL');

SElECT RTRIM ('SQL ');


-- Replacement

SELECT REPLACE('SQL', 'Q', '-');

SELECT REGEXP_REPLACE('SQL', '[A-Z]+', 'sql');

SELECT REGEXP_REPLACE('datanerd@gmail.com', '^.*(@)', '\1');

WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE 
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;


--NULLIF (Returns NULL if values are equal; if not equal, displays expression 1)

SELECT NULLIF(10,10);

SELECT NULLIF('apple','orange');


SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg,0))
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


--COALESCE (Returns first non-NULL value in a list of expressions)

SELECT COALESCE(0,1,2);

SELECT COALESCE(NULL, 1,2);


SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


-- FINAL EXAMPLE 

WITH salaries AS (
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
        END AS standardized_salary
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
)
SELECT *,
    CASE
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary <75_000 THEN 'Low'
        WHEN standardized_salary <150_000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY RANDOM()
LIMIT 20;

--UPDATE

SELECT 
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg,salary_hour_avg *2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg,salary_hour_avg *2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg,salary_hour_avg *2080)  <75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg,salary_hour_avg *2080)  <150_000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;


