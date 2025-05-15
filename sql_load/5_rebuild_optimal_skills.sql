\c sql_course;

-- Drop the old optimal_skills
DROP TABLE IF EXISTS optimal_skills;

-- Recreate it using the original weighted score formula
CREATE TABLE optimal_skills AS
SELECT
  sd.skills          AS skill,
  COUNT(*)           AS demand_count,
  AVG(j.salary_year_avg) AS average_salary,
  (0.6 * COUNT(*) + 0.4 * AVG(j.salary_year_avg)) AS optimal_score
FROM skills_job_dim sj
JOIN job_postings_fact j ON sj.job_id   = j.job_id
JOIN skills_dim sd       ON sj.skill_id = sd.skill_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY optimal_score DESC
LIMIT 50;
