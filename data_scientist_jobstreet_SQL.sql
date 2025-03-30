-- View all raw data (initial check)
SELECT * 
FROM [dbo].[data_scientist_jobstreet_scrape$];

--------------------------------------------------
-- Add min_salary and max_salary columns if needed
--------------------------------------------------
IF COL_LENGTH('[dbo].[data_scientist_jobstreet_scrape$]', 'min_salary') IS NULL
BEGIN
    ALTER TABLE [dbo].[data_scientist_jobstreet_scrape$]
    ADD min_salary INT;
END;

IF COL_LENGTH('[dbo].[data_scientist_jobstreet_scrape$]', 'max_salary') IS NULL
BEGIN
    ALTER TABLE [dbo].[data_scientist_jobstreet_scrape$]
    ADD max_salary INT;
END;

--------------------------------------------------
-- Replace NULLs in descriptions
--------------------------------------------------
UPDATE [dbo].[data_scientist_jobstreet_scrape$]
SET descriptions = 'null'
WHERE descriptions IS NULL;

--------------------------------------------------
-- Extract min_salary and max_salary from text
--------------------------------------------------
UPDATE [dbo].[data_scientist_jobstreet_scrape$]
SET 
    min_salary = TRY_CAST(REPLACE(
                    SUBSTRING(salary, 
                        CHARINDEX('RM', salary) + 3,
                        CHARINDEX('–', salary) - CHARINDEX('RM', salary) - 3),
                    ',', '') AS INT),
                    
    max_salary = TRY_CAST(REPLACE(
                    SUBSTRING(salary, 
                        CHARINDEX('– RM', salary) + 4,
                        CHARINDEX('per month', salary) - CHARINDEX('– RM', salary) - 4),
                    ',', '') AS INT)
WHERE salary LIKE 'RM%– RM%per month'
  AND CHARINDEX('–', salary) > 0
  AND CHARINDEX('– RM', salary) > 0
  AND CHARINDEX('per month', salary) > CHARINDEX('– RM', salary);

--------------------------------------------------
-- Count number of jobs in Kuala Lumpur
--------------------------------------------------
SELECT COUNT(*) AS number_of_jobs_kl
FROM [dbo].[data_scientist_jobstreet_scrape$]
WHERE location = 'Kuala Lumpur';

--------------------------------------------------
-- Count of job titles (grouped)
--------------------------------------------------
SELECT job_title, COUNT(*) AS number
FROM [dbo].[data_scientist_jobstreet_scrape$]
GROUP BY job_title
ORDER BY number DESC;

--------------------------------------------------
-- Count of distinct job titles
--------------------------------------------------
SELECT COUNT(DISTINCT job_title) AS distinct_jobs
FROM [dbo].[data_scientist_jobstreet_scrape$];

--------------------------------------------------
-- Average min_salary for Data Analyst
--------------------------------------------------
SELECT job_title,
       AVG(min_salary) AS avg_min_salary
FROM [dbo].[data_scientist_jobstreet_scrape$]
WHERE job_title = 'Data Analyst'
  AND min_salary IS NOT NULL
GROUP BY job_title;

--------------------------------------------------
-- Average min_salary for each job + description
--------------------------------------------------
SELECT job_title,
       descriptions,
       AVG(min_salary) AS avg_min_salary
FROM [dbo].[data_scientist_jobstreet_scrape$]
WHERE min_salary IS NOT NULL
GROUP BY job_title, descriptions
ORDER BY avg_min_salary DESC;

--------------------------------------------------
-- Salary categorization per job title
--------------------------------------------------
WITH avg_salary AS (
    SELECT job_title,
           AVG(min_salary) AS avg_min_salary
    FROM [dbo].[data_scientist_jobstreet_scrape$]
    WHERE min_salary IS NOT NULL
    GROUP BY job_title
)
SELECT job_title,
       avg_min_salary,
       CASE 
           WHEN avg_min_salary < 4000 THEN 'low salary'
           WHEN avg_min_salary >= 4000 AND avg_min_salary < 8000 THEN 'median salary'
           WHEN avg_min_salary >= 8000 THEN 'high salary'
       END AS salary_category
FROM avg_salary
ORDER BY avg_min_salary DESC;

--------------------------------------------------
-- Highest minimum salary for Data Analyst
--------------------------------------------------
SELECT TOP 1
       job_title,
       company,
       descriptions,
       category,
       subcategory,
       min_salary
FROM [dbo].[data_scientist_jobstreet_scrape$]
WHERE job_title = 'Data Analyst'
ORDER BY min_salary DESC;

--------------------------------------------------
-- Top 3 highest minimum salaries per job title
--------------------------------------------------
WITH ranked_jobs AS (
    SELECT job_title,
           company,
           min_salary,
           DENSE_RANK() OVER (PARTITION BY job_title ORDER BY min_salary DESC) AS rank
    FROM [dbo].[data_scientist_jobstreet_scrape$]
    WHERE min_salary IS NOT NULL
)
SELECT *
FROM ranked_jobs
WHERE rank <= 3;
