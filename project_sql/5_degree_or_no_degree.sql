/*
Question: Is there a difference in salary between people with a degree and people without a degree in New Zealand?
- Check that the job postings are in New Zealand and the role is for data analyst
- Why? To see if in New Zealand a degree helps jobseekers earn more than without a degree
*/

SELECT 
    ROUND(avg_salary,0) AS avg_salary,
    degree,
    job_postings
FROM 
(
    SELECT
        COUNT(job_id) AS job_postings,
        AVG(salary_year_avg) AS avg_salary,
        CASE 
            WHEN job_no_degree_mention = TRUE THEN 'No Degree'
            ELSE 'Degree'
        END AS degree
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst' AND 
    (job_location LIKE '%NZ%' OR job_location LIKE '%New Zealand%')
    GROUP BY degree
)
