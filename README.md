# Data Analyst Job Market Dashboard

## Introduction
This project demonstrates the cumulative skills learned in my Computer Science program by building an interactive dashboard that analyzes the data analyst job market. The dashboard highlights:

- **Top-Paying Jobs**: Identify the highest-paying data analyst roles.
- **In-Demand Skills**: Show which skills are most frequently requested.
- **Optimal Skills to Learn**: Combine demand and salary to recommend skills.

*Dataset explored interactively with (https://drive.google.com/drive/folders/12f6YdpTguBmocpmCqBaB8zDrT4rovCxx?usp=sharing)

## Repository Structure
```
Job_Analysis/
│
├── .vscode/                      # VSCode settings (optional)
│   └── settings.json
│
├── csv_files/                    # Raw and converted CSV data
│   ├── company_dim.csv
│   ├── company_dim_utf8.csv
│   ├── job_postings_fact.csv
│   ├── job_postings_fact_utf8.csv
│   ├── skills_dim.csv
│   └── skills_job_dim.csv
│
├── project_sql/                  # SQL files for interactive filters in the dashboard
│   ├── 4_create_views.sql
│   ├── 4_subqueries.sql
│   ├── Sql tutorial.sql
│   └── (any other custom .sql filters)
│
├── sql_load/                     # ETL pipeline scripts, run in numeric order
│   ├── 1_create_database.sql
│   ├── 2_create_tables.sql
│   ├── 3_import_project_sql.sql
│   ├── 3_modify_tables.sql
│   ├── 4_create_dashboard_tables.sql
|   ├── 5_rebuild_optimal_skills.sql
│
├── docs/                         # Supporting documentation
│   ├── README.md                 # Executive summary, setup, dataset link, S&P, index
│   ├── effort_log.md             # Timeline of milestones, challenges, fixes
│   ├── ER_diagram.png            # Entity-Relationship Diagram
│   └── data_flow.png             # Data Flow Diagram
│
├── slides/                       # (Your final presentation deck)
│   └── Data_Analyst_Dashboard.pptx
│
├── dashboard.py                  # Main Streamlit application
└── requirements.txt              # Python package requirements
```

##Folders:

.vscode/ — VSCode settings (optional)

csv_files/ — Raw and converted CSV data

project_sql/ — SQL files for interactive filters in the dashboard

sql_load/ — ETL pipeline scripts, run in numeric order

docs/ — Supporting documentation

slides/ — Final presentation deck

dashboard.py — Main Streamlit application

requirements.txt — Python package requirements



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
- **SQL**: Use UPPERCASE for SQL keywords, 4-space indentation, semicolons at end of statements, checked with `sqlfluff`.
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
