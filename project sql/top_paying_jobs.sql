/*
Question: What skills are required for the top-paying data analyst jobs?
- Uses the top 10 highest-paying Data Analyst jobs from the first query.
- Adds the specific skills required for these roles.
- Includes the number of times each skill appears across high-paying roles.
- Why? Provides a detailed look at which high-paying jobs demand certain skills, 
  helping job seekers understand which skills to develop to align with top salaries.

Features of this Query:
- **Uses a CTE (`top_paying_jobs`)** to extract the top 10 highest-paying Data Analyst jobs.
- **Joins job postings with skill data** to identify the required skills for high-paying roles.
- **Counts skill occurrences (`COUNT(sjd.job_id) AS skill_count`)** to highlight the most common skills.
- **Ensures only jobs with salary data (`salary_year_avg IS NOT NULL`)** are considered.
- **Orders by salary and skill count** to prioritize the highest-paying and most-required skills.
- **Provides employer details (`company_name`)** to add context on which companies require these skills.
*/

WITH top_paying_jobs AS (
    SELECT 
        jp.job_id,
        jp.job_title,
        jp.salary_year_avg,
        c.name AS company_name
    FROM job_postings_fact jp
    LEFT JOIN company_dim c ON jp.company_id = c.company_id
    WHERE 
        jp.job_title_short = 'Data Analyst' 
        AND jp.job_location = 'Anywhere' 
        AND jp.salary_year_avg IS NOT NULL
    ORDER BY jp.salary_year_avg DESC
    LIMIT 10
),
SkillCounts AS (
    SELECT 
        sjd.skill_id,
        COUNT(sjd.job_id) AS skill_count
    FROM top_paying_jobs tp
    JOIN skills_job_dim sjd ON tp.job_id = sjd.job_id
    GROUP BY sjd.skill_id
)
SELECT 
    tp.job_id,
    tp.job_title,
    tp.salary_year_avg,
    tp.company_name,
    s.skills,
    sc.skill_count
FROM top_paying_jobs tp
JOIN skills_job_dim sjd ON tp.job_id = sjd.job_id
JOIN skills_dim s ON sjd.skill_id = s.skill_id
JOIN SkillCounts sc ON s.skill_id = sc.skill_id
ORDER BY tp.salary_year_avg DESC, sc.skill_count DESC;
