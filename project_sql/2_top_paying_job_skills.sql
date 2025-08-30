/*
Question: What skills are required for the top-paying Data Analyst jobs in New Zealand?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these jobs
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helps jobseekers identify which skills they should be prioritising to align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg,
        job_location
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE 
        salary_year_avg IS NOT NULL AND 
        job_title_short = 'Data Analyst' AND 
        (job_location LIKE '%NZ%' OR job_location LIKE '%New Zealand%')
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills,
    job_location
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC 