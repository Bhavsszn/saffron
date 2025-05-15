/*

SELECT *
FROM job_postings_fact
LIMIT 100;

SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14':: Real;

*/

/*
SELECT
    Job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS Date_month,
    EXTRACT(YEAR FROM job_posted_date) AS Date_year
FROM
    job_postings_fact
LIMIT 5;
*/

/*
SELECT
    COUNT(job_id)  AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS MONTH
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    MONTH
ORDER BY
    job_posted_count DESC
*/

/* 
Q1) Write a query to find the average salary
both yearly(salary_year_avg) and hourly(salary_hourly_avg)
for job postings that were posted after June 1, 2023. Group the
results by job schedule type.
*/

/* 
ANS:

SELECT
    job_schedule_type AS schedule_type,
    AVG(salary_year_avg) AS salary_year_avg,
    AVG(salary_hour_avg) AS salary_hour_avg,
    MIN(job_posted_date) AS earliest_posted_date
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;

*/

/* 
Q2) Write a query to count the number of job postings
for each month in 2023, adjusting the job posted date
to be in 'America/New_York' time zone before extracting
'hint', the month. Assume the job_posted_date is stored
in UTC. Group by and order by the month
*/

/* 
ANS)

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_title_short) AS job_posting_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY
    month
ORDER BY
    month;
*/

/*
Q3) Write a query to find comapnies(Include company name) that
have posted jobs offering health insurance, where these postings
were made in the second quarter of 2023. Use data extraction to filter
by quarter.
*/

/*
SELECT
    job_title,
    COUNT(*) AS job_posting_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
    AND EXTRACT(QUARTER FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2
    AND job_health_insurance = true
GROUP BY
    job_title
ORDER BY
    job_posting_count DESC;

*/

/*
Practice problem 6:

Create 3 tables:
    -Jan 2023 jobs
    -Feb 2023 jobs
    -Mar 2023 jobs

Hints:
    -Use CREATE TABLE table_name AS syntax to create your table
    -Look at a way to filter out specific months(Extract)

*/

/*
CREATE TABLE January_jobs AS
    SELECT *
    FROM
    job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE Febuary_jobs AS
    SELECT *
    FROM
    job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE March_jobs AS
    SELECT *
    FROM
    job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;
*/

SELECT
    job_title_short,
    job_location
FROM job_postings_fact;

/*

Label new column as follows:
- Anywhere jobs as 'Remote'
- New York, NY jobs As 'Local'
-otherwise 'onsite'

*/

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'onsite'
    END AS location_category
FROM job_postings_fact;


SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;



/*
Categorize  the salaries from each job posting, To see if it fits
in the desired salary range.

-Put the salary into different buckets
-Define a high,standard, and low salary with your own conditions
-only look at data analyst roles
-order from highest to lowest
*/

SELECT
    job_title_short AS Job,
    salary_year_avg AS Salary,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High'
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard'
        ELSE 'Low'
    END AS salary_category,
    COUNT(job_id) AS number_of_jobs
FROM
    job_postings_fact
WHERE
    job_title LIKE '%Data Analyst%'
    AND salary_year_avg IS NOT NULL
GROUP BY
    job_title_short, salary_year_avg
ORDER BY
    Salary DESC;

--Min Salary: 30,000.0
--Max Salary: 650,000.0


SELECT *
FROM (--subquery starts here
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH from job_posted_date)=1
        ) AS January_jobs;
 --subquery ends here





WITH january_jobs AS (--cte definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1
    )--cte definition ends here

SELECT *
FROM january_jobs







