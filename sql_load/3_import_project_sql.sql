TRUNCATE top_paying_jobs, top_paying_skills, top_paying_job_skills, optimal_skills RESTART IDENTITY;

\copy top_paying_jobs       FROM 'D:/Job_Analysis/csv_files/top_paying_jobs.csv'       WITH (FORMAT csv, HEADER);
\copy top_paying_skills     FROM 'D:/Job_Analysis/csv_files/top_paying_skills.csv'     WITH (FORMAT csv, HEADER);
\copy top_paying_job_skills FROM 'D:/Job_Analysis/csv_files/top_paying_job_skills.csv' WITH (FORMAT csv, HEADER);
\copy optimal_skills        FROM 'D:/Job_Analysis/csv_files/optimal_skills.csv'        WITH (FORMAT csv, HEADER);
