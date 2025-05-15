# Data Analyst Job Market Dashboard

## Introduction
This project demonstrates the cumulative skills learned in my Computer Science program by building an interactive dashboard that analyzes the data analyst job market. The dashboard highlights:

- **Top-Paying Jobs**: Identify the highest-paying data analyst roles.
- **In-Demand Skills**: Show which skills are most frequently requested.
- **Optimal Skills to Learn**: Combine demand and salary to recommend skills.

*Dataset explored interactively with [[SQLiteViz Workspace](https://sqliteviz.com/app/#/workspace?hide_schema=1)*](https://sqliteviz.com/app/#/workspace?hide_schema=1)

## Repository Structure
```
your-repo/
├─ .gitignore
├─ README.md
├─ requirements.txt
├─ slides/
│   └─ presentation.pptx
├─ docs/
│   ├─ ER_diagram.png
│   ├─ data_flow.png
│   └─ effort_log.md
├─ csv_files/
│   ├─ company_dim.csv
│   ├─ company_dim_utf8.csv
│   ├─ job_postings_fact.csv
│   ├─ job_postings_fact_utf8.csv
│   ├─ skills_dim.csv
│   ├─ skills_job_dim.csv
│   └─ convert_to_utf8.py
├─ sql_load/
│   ├─ 1_create_dimensional_model.sql
│   ├─ 2_import_dimensional_model.sql
│   ├─ 3_import_dashboard_data.sql
│   └─ 4_create_dashboard_tables.sql
├─ project_sql/
│   ├─ top_paying_jobs.sql
│   ├─ top_paying_skills.sql
│   ├─ top_paying_job_skills.sql
│   └─ optimal_skills.sql
├─ dashboard.py
└─ .pre-commit-config.yaml
```

## Installation & Setup
1. **Clone the repo** and navigate into it:
   ```bash
   git clone <repo_url>
   cd your-repo
   ```
2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
3. **Load the database** using PostgreSQL and the scripts in `sql_load/`.
4. **Run the dashboard**:
   ```bash
   streamlit run dashboard.py
   ```

## Standards & Practices
All SQL and Python code adhere to the following:

- **Python**: PEP8 styling, `black` formatting, `flake8` linting.
- **SQL**: Lowercase keywords, 4-space indentation, semicolons at end of statements, checked with `sqlfluff`.
- **Version Control**: Commits are atomic and descriptive.

## Documentation of Effort
See `docs/effort_log.md` for a timeline of key milestones, commit summaries, and challenges encountered (encoding issues, ETL refinements).

## How to Contribute
1. Fork the repo
2. Create a feature branch
3. Make changes and commit
4. Open a pull request

---
_Last updated: May 2025_
