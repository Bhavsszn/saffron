\c sql_course;

-- 1) Top-paying jobs by average yearly salary (top 50)
DROP TABLE IF EXISTS top_paying_jobs;
CREATE TABLE top_paying_jobs AS
SELECT
  job_title,
  salary_year_avg AS average_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY average_salary DESC
LIMIT 50;

-- 2) Top-paying skills by average yearly salary
DROP TABLE IF EXISTS top_paying_skills;
CREATE TABLE top_paying_skills AS
SELECT
  sd.skills            AS skill,
  AVG(j.salary_year_avg) AS average_salary
FROM skills_job_dim sj
JOIN job_postings_fact j ON sj.job_id    = j.job_id
JOIN skills_dim sd       ON sj.skill_id  = sd.skill_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY average_salary DESC
LIMIT 50;

-- 3) Skills required by those top-paying jobs
DROP TABLE IF EXISTS top_paying_job_skills;
CREATE TABLE top_paying_job_skills AS
SELECT DISTINCT
  tp.job_title,
  sd.skills AS skill
FROM top_paying_jobs tp
JOIN job_postings_fact j ON j.job_title = tp.job_title
JOIN skills_job_dim sj   ON sj.job_id   = j.job_id
JOIN skills_dim sd       ON sd.skill_id = sj.skill_id
ORDER BY tp.job_title, sd.skills;

-- 4) Optimal skills (demand × pay score)
DROP TABLE IF EXISTS optimal_skills;
CREATE TABLE optimal_skills AS
SELECT
  sd.skills AS skill,
  COUNT(*) * AVG(j.salary_year_avg) AS optimal_score
FROM skills_job_dim sj
JOIN job_postings_fact j ON sj.job_id    = j.job_id
JOIN skills_dim sd       ON sj.skill_id  = sd.skill_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY optimal_score DESC
LIMIT 50;
