/*
Question: What are the top skills for Data Analysts over time with demand trends?
- This query tracks the most in-demand skills for data analysts by year and ranks them by demand.

Features of this Query:
- **Uses CTE (`SkillDemand`)** to separate skill aggregation and demand tracking.
- **Counts skill occurrences (`COUNT(sjd.job_id) AS demand_count`)** to determine demand for each skill per year.
- **Extracts the year (`EXTRACT(YEAR FROM jp.job_posted_date)`)** to analyze trends over time.
- **Filters for Data Analyst roles (`job_title_short = 'Data Analyst'`)** to ensure results are industry-relevant.
- **Ranks skills by demand percentile (`CUME_DIST() OVER (ORDER BY demand_count DESC)`)** to highlight the most sought-after skills.
- **Orders results first by year (`ORDER BY post_year DESC`)**, then by demand count, to show trends clearly.
- **Limits output to top 10 skills (`LIMIT 10`)** to provide a concise snapshot of the most in-demand skills.
*/

WITH SkillDemand AS (
    SELECT 
        s.skills, 
        COUNT(sjd.job_id) AS demand_count,
        EXTRACT(YEAR FROM jp.job_posted_date) AS post_year
    FROM job_postings_fact jp
    JOIN skills_job_dim sjd ON jp.job_id = sjd.job_id
    JOIN skills_dim s ON sjd.skill_id = s.skill_id
    WHERE jp.job_title_short = 'Data Analyst'
    GROUP BY s.skills, post_year
)
SELECT 
    skills, 
    demand_count, 
    post_year,
    CUME_DIST() OVER (ORDER BY demand_count DESC) * 100 AS demand_percentile
FROM SkillDemand
ORDER BY post_year DESC, demand_count DESC
LIMIT 10;
