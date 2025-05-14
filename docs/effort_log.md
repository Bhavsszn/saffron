Documentation of Effort
=======================

This document captures the journey and key milestones from April through mid-May
2025, described in a conversational style.

Timeline
--------

-   **April 1, 2025**  
    Kicked things off: set up the GitHub repo with the basic folder structure
    and initial README. Created placeholder CSVs and stubbed out `dashboard.py`.

-   **April 5, 2025**  
    Imported raw CSV files into Postgres and defined dimension tables. Ran into
    character encoding issues (Windows-1252 vs. UTF-8) and wrote a small Python
    helper to convert files cleanly.

-   **April 10, 2025**  
    Built and tested the dimensional model scripts (`sql_load/1-2_*.sql`).
    Handled foreign key quirks by staging and filtering out invalid IDs.

-   **April 15, 2025**  
    Launched the first Streamlit prototype: data loads, salary slider, and basic
    tables. Added `requirements.txt` and committed the MVP.

-   **April 20, 2025**  
    Refactored to OOP: introduced `DatabaseClient` and `JobDashboard` classes.
    Implemented the min–max normalization algorithm for our skill “usefulness”
    score.

-   **April 25, 2025**  
    Added the SQL parsing feature using `sqlparse`. Let users select and run
    original SQL files from `project_sql/` and see both formatted queries and
    live results.

-   **May 1, 2025**  
    Created the presentation deck covering project goals, ETL pipeline,
    dashboard demo, and rubric compliance. Pushed slides to `slides/`.

-   **May 10, 2025**  
    Final polish of documentation: added ER diagram and data flow visuals,
    defined coding standards in the README, and set up pre-commit hooks for
    linting.

-   **May 14, 2025**  
    Wrapping up: refined the README, ensured all CSVs load correctly, and
    verified the Streamlit app displays everything smoothly. Ready to present!

Challenges & Learnings
----------------------

-   **Encoding headaches**: Tackled CSV encoding mismatches by converting to
    UTF-8 with a fallback strategy.

-   **Data cleanliness**: Managed orphaned foreign keys by staging and filtering
    during imports.

-   **Environment quirks**: Navigated Windows `psql` PATH issues and absolute
    path requirements.

-   **Iterative improvement**: Moved from procedural scripts to OOP, improving
    code clarity and reuse.

*Last updated: May 14, 2025*
