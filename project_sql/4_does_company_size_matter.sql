/*
Question: Do larger companies that have more job postings offer higher average salaries than smaller or medium companies?
- Case company small if less than 20 job postings, medium if between 20-50 job postings and over 50 means large
- Exclude companies that only have 5 or less job postings to make the averages more reliable
- Why? To check whether jobseekers should apply to larger/medium/smaller companies for a bigger salary
*/
SELECT 
    company_summary.company_id,
    company_size,
    average_salary
FROM (
    SELECT 
        job_postings_fact.company_id,
        ROUND(AVG(salary_year_avg),0) AS average_salary,
        COUNT(job_id) AS count_job_postings,
        CASE
            WHEN COUNT(job_id) < 20 THEN 'Small Company'
            WHEN COUNT(job_id) BETWEEN 20 AND 50 THEN 'Medium Company'
            WHEN COUNT(job_id) > 50 THEN 'Large Company'
        END AS company_size
    FROM job_postings_fact
    INNER JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id 
    WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
    GROUP BY job_postings_fact.company_id
    HAVING COUNT(job_id) > 5
) AS company_summary
ORDER BY average_salary DESC;

