# 📊 JobStreet Salary Analysis (SQL Project)

This project uses **T-SQL (Microsoft SQL Server)** to clean and analyze job listings scraped from **JobStreet Malaysia**, focusing on data-related careers such as **Data Analyst**, **Data Scientist**, and **Data Engineer**.

---

## 📁 Dataset

**Table:** `[dbo].[data_scientist_jobstreet_scrape$]`  
The dataset includes the following columns:

- `job_title`
- `company`
- `salary` (unstructured text)
- `location`
- `descriptions`
- `category`, `subcategory`
- Other job metadata

---

## 🛠️ SQL Tasks & Workflow

### 1. Initial Setup & Data Cleaning

- Displays all raw records for inspection
- Adds `min_salary` and `max_salary` columns
- Replaces `NULL` values in `descriptions` with `'null'`
- Parses `salary` text like `"RM 4,000 – RM 6,000 per month"` to extract:
  - `min_salary` as integer
  - `max_salary` as integer

### 2. Location-Based Insight

- Counts number of jobs located in **Kuala Lumpur**

### 3. Job Market Overview

- Shows total number of job postings per job title
- Calculates the number of **distinct job titles**

### 4. Salary Statistics

- Computes the average `min_salary` for **Data Analyst** jobs
- Calculates average `min_salary` for each job title with description
- Categorizes each job title’s average salary as:
  - `'low salary'` (< RM4000)
  - `'median salary'` (RM4000–7999)
  - `'high salary'` (≥ RM8000)

### 5. Company-Level Analysis

- Finds the company offering the **highest minimum salary** for Data Analysts
- Identifies the **Top 3 companies** (by `min_salary`) for each job title using `DENSE_RANK()`

---

## 🧪 Sample SQL Features Used

- `ALTER TABLE`, `UPDATE`, `TRY_CAST`, `CHARINDEX`, `SUBSTRING`, `REPLACE`
- `AVG()`, `COUNT()`, `GROUP BY`, `ORDER BY`
- `CASE WHEN` for categorization
- `DENSE_RANK()` and Common Table Expressions (CTEs)

---

## 💡 Use Cases

- **Job market insights** for business intelligence
- **SQL practice** with real-world data parsing and transformation
- **Portfolio project** for data analysts and data engineers

---

## 📌 Requirements

- Microsoft SQL Server (or Azure Data Studio / SSMS)
- A table named `[data_scientist_jobstreet_scrape$]` with job listings data

---

## 📷 Screenshots (Optional)

> Add screenshots of your SQL results or visualizations here if you'd like

---

## 📜 License

This project is for educational and analytical purposes.
