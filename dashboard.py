import os  # Provides functions for interacting with the operating system (reading file paths, listing directories)
import streamlit as st  # Imports Streamlit, a library for building interactive web apps in Python
import pandas as pd  # Imports pandas, a library for data manipulation and analysis
import sqlparse  # Imports sqlparse, a library for formatting SQL queries
from sqlalchemy import create_engine, text  # Imports SQLAlchemy tools to connect to a database and run SQL statements
import matplotlib.pyplot as plt  # Imports Matplotlib’s plotting interface for creating charts
import seaborn as sns  # Imports Seaborn, a library built on Matplotlib for statistical data visualization

# Configure the Streamlit page’s title and layout
st.set_page_config(
    page_title="Data Analyst Job Market Dashboard",  # The text shown in the browser tab
    layout="wide"  # Use the full browser width for content
)

class DatabaseClient:  # Defines a class to manage database connections and queries
    def __init__(self, user, password, host, port, dbname):  # Constructor runs when we create a DatabaseClient
        # Build the connection URL using the provided credentials
        url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}"
        # Create a SQLAlchemy engine object to talk to the database
        self.engine = create_engine(url, echo=False)

    def load_table(self, table_name):  # Method to load an entire database table into a pandas DataFrame
        stmt = text(f"SELECT * FROM {table_name}")  # Wrap the SQL query in a SQLAlchemy text object
        return pd.read_sql(stmt, self.engine)  # Execute the query and return the results as a DataFrame

    def execute_sql(self, raw_sql):  # Method to run an arbitrary SQL query and get results
        return pd.read_sql(text(raw_sql), self.engine)  # Format text and return results as DataFrame

    def parse_sql(self, raw_sql):  # Method to format (pretty-print) an SQL string
        return sqlparse.format(raw_sql, reindent=True, keyword_case='upper')  # Reindent and uppercase keywords

class JobDashboard:  # Defines a class to build and display the dashboard
    def __init__(self, db_client):  # Constructor takes a DatabaseClient instance
        self.db = db_client  # Store the database client for use later

    def show_filters(self):  # Method to display sidebar controls for filtering
        st.sidebar.title("Filters")  # Title in the sidebar
        # Slider to pick minimum average salary
        self.min_salary = st.sidebar.slider("Min average salary", 0, 300000, 0, step=5000)
        # Text input to filter skills by name
        self.skill_filter = st.sidebar.text_input("Skill contains")

    def load_data(self):  # Method to load and prepare all required data tables
        # Load the precomputed dashboard tables from the database
        self.jobs_df    = self.db.load_table("top_paying_jobs")       # Data about top-paying jobs
        self.skills_df  = self.db.load_table("top_paying_skills")     # Data about top-paying skills
        self.job_skills = self.db.load_table("top_paying_job_skills") # Mapping of jobs to skills
        self.optimal_df = self.db.load_table("optimal_skills")        # Data about optimal skills to learn
        # Load raw postings and company tables for counting
        self.full_jobs  = self.db.load_table("job_postings_fact")     # All job postings
        self.companies  = self.db.load_table("company_dim")           # Company metadata

        # Apply the salary filter to both the dashboard table and the raw postings
        self.jobs_df   = self.jobs_df[self.jobs_df["average_salary"] >= self.min_salary]
        self.full_jobs = self.full_jobs[self.full_jobs["salary_year_avg"] >= self.min_salary]

    def render(self):  # Method to draw the dashboard sections
        st.title("Data Analyst Job Market Dashboard")  # Main title at top

        # Section: Salary Distribution histogram
        st.header("Salary Distribution")
        fig1, ax1 = plt.subplots()  # Create a Matplotlib figure and axes
        # Plot a histogram of average salaries using Seaborn
        sns.histplot(self.jobs_df["average_salary"], bins=20, ax=ax1)
        ax1.set(xlabel="Average Salary", ylabel="Job Count")  # Label axes
        st.pyplot(fig1)  # Render the plot in Streamlit

        # Section: Top Companies by job count
        st.header("Top Companies by Job Count")
        # Count the number of postings per company and take the top 10
        comp_counts = (
            self.full_jobs["company_id"]
            .value_counts()
            .head(10)
            .rename_axis("company_id")
            .reset_index(name="count")
            .merge(self.companies[["company_id", "name"]], on="company_id")
        )
        fig2, ax2 = plt.subplots()  # New figure for bar chart
        # Bar plot of posting counts vs. company name
        sns.barplot(data=comp_counts, x="count", y="name", ax=ax2)
        ax2.set(xlabel="Postings", ylabel="Company")  # Label axes
        st.pyplot(fig2)  # Show the bar chart

        # Section: Skills Demand vs. Salary scatterplot
        st.header("Skills: Demand vs. Salary")
        # Merge job-skill links with skill details
        merged = self.job_skills.merge(self.skills_df, on="skill")
        # Aggregate: count how often each skill appears and its average salary
        agg = (
            merged.groupby("skill")
                  .agg(demand_count=("skill", "count"),
                       avg_salary=("average_salary", "mean"))
                  .reset_index()
                  .sort_values("demand_count", ascending=False)
                  .head(15)
        )
        fig3, ax3 = plt.subplots()  # New figure for scatterplot
        sns.scatterplot(data=agg, x="demand_count", y="avg_salary", ax=ax3)
        ax3.set(xlabel="Demand Count", ylabel="Avg Salary")  # Label axes
        st.pyplot(fig3)  # Show the scatterplot

        # Section: Optimal Skills to Learn table
        st.header("Optimal Skills to Learn")
        df = self.optimal_df.copy()  # Work with a copy of the data
        # Apply skill-name filter if provided
        if self.skill_filter:
            df = df[df["skill"].str.contains(self.skill_filter, case=False)]
        # Normalize the optimal_score into a 1–10 usefulness scale
        min_s, max_s = df["optimal_score"].min(), df["optimal_score"].max()
        if min_s == max_s:
            df["usefulness"] = 10.0  # If all scores identical, set usefulness to 10
        else:
            df["usefulness"] = 1 + 9 * (df["optimal_score"] - min_s) / (max_s - min_s)
            df["usefulness"] = df["usefulness"].round(2)  # Round to two decimals
        df = df[df["average_salary"] < 200000]  # Remove outliers above $200k
        # Display the resulting table sorted by usefulness
        st.dataframe(
            df[["skill", "demand_count", "average_salary", "usefulness"]]
              .sort_values("usefulness", ascending=False)
              .reset_index(drop=True)
        )

        # Section: SQL Parser & Filter Demo
        st.header("SQL Parser & Filter Demo")
        sql_dir = os.path.join(os.getcwd(), "project_sql")  # Directory of SQL files
        sql_files = [f for f in sorted(os.listdir(sql_dir)) if f.lower().endswith(".sql")]
        selected = st.selectbox("Choose SQL file:", sql_files)  # Dropdown menu
        if selected:
            # Read and format the chosen SQL file
            raw_sql = open(os.path.join(sql_dir, selected)).read()
            st.subheader("Formatted SQL")
            st.code(self.db.parse_sql(raw_sql), language="sql")
            # Execute and show first 50 rows of the result
            try:
                result = self.db.execute_sql(raw_sql)
                st.subheader("Results (first 50 rows)")
                st.dataframe(result.head(50))
            except Exception as e:
                st.error(f"Execution error: {e}")  # Show error message

def main():
    # Instantiate the database client with credentials
    db_client = DatabaseClient(
        user="postgres",
        password="D%40gger4500",
        host="localhost",
        port="5432",
        dbname="sql_course"
    )
    # Create and display the dashboard
    dashboard = JobDashboard(db_client)
    dashboard.show_filters()  # Show filtering controls
    dashboard.load_data()     # Load and prepare data
    dashboard.render()        # Render all dashboard components

if __name__ == "__main__":
    main()  # Entry point: run the main function when the script is executed
