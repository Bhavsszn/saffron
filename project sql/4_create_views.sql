\c sql_course;

-- 1) Top-paying jobs by avg salary (take top 50)
DROP VIEW IF EXISTS top_paying_jobs;
CREATE VIEW top_paying_jobs AS
SELECT
  job_title,
  (salary_min + salary_max) / 2.0 AS average_salary
FROM job_postings_fact
GROUP BY job_title, salary_min, salary_max
ORDER BY average_salary DESC
LIMIT 50;

-- 2) Top-paying skills by avg salary
DROP VIEW IF EXISTS top_paying_skills;
CREATE VIEW top_paying_skills AS
SELECT
  sd.skill_name AS skill,
  AVG((j.salary_min + j.salary_max) / 2.0) AS average_salary
FROM skills_job_dim sj
JOIN job_postings_fact j    ON sj.posting_id = j.posting_id
JOIN skills_dim sd         ON sj.skill_id   = sd.skill_id
GROUP BY sd.skill_name
ORDER BY average_salary DESC
LIMIT 50;

-- 3) Skills required by those top jobs
DROP VIEW IF EXISTS top_paying_job_skills;
CREATE VIEW top_paying_job_skills AS
SELECT DISTINCT
  tp.job_title,
  sd.skill_name AS skill
FROM top_paying_jobs tp
JOIN job_postings_fact j     ON j.job_title      = tp.job_title
JOIN skills_job_dim sj       ON sj.posting_id    = j.posting_id
JOIN skills_dim sd           ON sd.skill_id      = sj.skill_id
ORDER BY tp.job_title, sd.skill_name;

-- 4) Optimal skills (demand × pay score)
DROP VIEW IF EXISTS optimal_skills;
CREATE VIEW optimal_skills AS
SELECT
  sd.skill_name AS skill,
  COUNT(*) * AVG((j.salary_min + j.salary_max) / 2.0) AS optimal_score
FROM skills_job_dim sj
JOIN job_postings_fact j    ON sj.posting_id = j.posting_id
JOIN skills_dim sd         ON sj.skill_id    = sd.skill_id
GROUP BY sd.skill_name
ORDER BY optimal_score DESC
LIMIT 50;
