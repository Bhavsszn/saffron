import pandas as pd

files = [
    "D:/Job_Analysis/csv_files/company_dim.csv",
    "D:/Job_Analysis/csv_files/job_postings_fact.csv"
]

for src in files:
    # Read with latin-1 so no byte ever fails
    df = pd.read_csv(src, encoding='latin-1', dtype=str, low_memory=False)
    dest = src.replace(".csv", "_utf8.csv")
    # Write clean UTF-8
    df.to_csv(dest, index=False, encoding='utf-8')
    print(f"Converted {src} → {dest}")
