/*
Question: What are the most optimal skills to learn (aka in high demand and high-paying)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis

Features of this Query:
- Uses **Common Table Expressions (CTEs)** to separate demand calculation and salary computation for clarity.
- Filters only **remote jobs** (`job_work_from_home = TRUE`) to provide insights relevant to flexible work opportunities.
- Filters for **Data Analyst roles** (`job_title_short = 'Data Analyst'`) to ensure industry-specific insights.
- Ensures **salary data is available** (`salary_year_avg IS NOT NULL`) for meaningful salary insights.
- **Aggregates demand** by counting occurrences of each skill (`COUNT(sjd.job_id) AS demand_count`).
- **Calculates the average salary** for each skill (`ROUND(AVG(jp.salary_year_avg)::numeric, 0) AS avg_salary`).
- Implements a **weighted scoring system** (`0.6 * demand_count + 0.4 * avg_salary`) to balance demand and salary.
- **Excludes low-demand skills** (`WHERE sd.demand_count > 10`) to focus on widely sought-after skills.
- **Orders results** by `weighted_score` to highlight the most strategically valuable skills.
- **Limits output to 25 skills** (`LIMIT 25`) to provide a concise, actionable list.
*/

WITH skills_demand AS (
    SELECT
        s.skill_id,
        s.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact jp
    INNER JOIN skills_job_dim sjd ON jp.job_id = sjd.job_id
    INNER JOIN skills_dim s ON sjd.skill_id = s.skill_id
    WHERE
        jp.job_title_short = 'Data Analyst' 
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE 
    GROUP BY s.skill_id, s.skills
),
average_salary AS (
    SELECT 
        s.skill_id,
        ROUND(AVG(jp.salary_year_avg)::numeric, 0) AS avg_salary
    FROM job_postings_fact jp
    INNER JOIN skills_job_dim sjd ON jp.job_id = sjd.job_id
    INNER JOIN skills_dim s ON sjd.skill_id = s.skill_id
    WHERE
        jp.job_title_short = 'Data Analyst'
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_work_from_home = TRUE 
    GROUP BY s.skill_id
)
SELECT 
    sd.skill_id,
    sd.skills,
    sd.demand_count,
    asal.avg_salary,
    (sd.demand_count * 0.6 + asal.avg_salary * 0.4) AS weighted_score
FROM skills_demand sd
INNER JOIN average_salary asal ON sd.skill_id = asal.skill_id
WHERE sd.demand_count > 10
ORDER BY weighted_score DESC
LIMIT 25;
