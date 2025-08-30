/* 
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely
- Focuses on job postings with specifed salaries (no nulls)
- Why? Highlight the top-paying opportunities for Data Analysts
*/

SELECT 
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE 
    salary_year_avg IS NOT NULL AND 
    job_title_short = 'Data Analyst' AND 
    job_work_from_home = TRUE AND 
    job_location = 'Anywhere'
ORDER BY 
    salary_year_avg DESC
LIMIT 10;

