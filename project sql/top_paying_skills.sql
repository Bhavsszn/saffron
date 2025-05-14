/*
Question: What are the most common skills for top-paying Data Analyst jobs with salary insights?
- Identifies the most frequently occurring skills in the highest-paying jobs.
- Provides salary statistics such as average salary and demand level for jobs requiring each skill.

Features of this Query:
- **Uses a CTE (`TopPaying`)** to extract the highest-paying Data Analyst jobs dynamically.
- **Joins job postings with skill data** to determine the skills required for these high-paying jobs.
- **Counts occurrences of each skill (`COUNT(sjd.job_id) AS skill_count`)** to highlight the most common skills.
- **Calculates salary insights**:
  - `AVG(tp.salary_year_avg)`: Average salary for jobs requiring each skill.
  - `COUNT(tp.job_id)`: Number of top-paying jobs requiring each skill.
- **Ranks skills based on a weighted formula (`skill_count * avg_salary / total_jobs`)** to determine skill impact.
- **Ensures only jobs with salary data (`salary_year_avg IS NOT NULL`)** are considered.
- **Orders by salary impact and skill frequency** to prioritize the highest-paying and most-required skills.
*/

WITH TopPaying AS (
    SELECT job_id, salary_year_avg FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
),
SkillCounts AS (
    SELECT 
        sjd.skill_id,
        COUNT(sjd.job_id) AS skill_count
    FROM TopPaying tp
    JOIN skills_job_dim sjd ON tp.job_id = sjd.job_id
    GROUP BY sjd.skill_id
),
TotalJobs AS (
    SELECT COUNT(job_id) AS total_jobs FROM TopPaying
)
SELECT 
    s.skills, 
    sc.skill_count,
    ROUND(AVG(tp.salary_year_avg)::numeric, 0) AS avg_salary,
    COUNT(tp.job_id) AS job_count,
    ROUND((sc.skill_count * AVG(tp.salary_year_avg)::numeric) / MAX(tj.total_jobs), 2) AS skill_impact_score
FROM TopPaying tp
JOIN skills_job_dim sjd ON tp.job_id = sjd.job_id
JOIN skills_dim s ON sjd.skill_id = s.skill_id
JOIN SkillCounts sc ON s.skill_id = sc.skill_id
JOIN TotalJobs tj ON 1=1
GROUP BY s.skills, sc.skill_count, tj.total_jobs
ORDER BY skill_impact_score DESC, avg_salary DESC, sc.skill_count DESC;
