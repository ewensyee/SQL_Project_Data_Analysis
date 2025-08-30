/*
Question: What are the most in-demand skills for Data Analysts in New Zealand?
- Identify the top 5 in-demand skills for Data Analysts
- Focus on all job postings
- Why? By retrieving the top 5 skills with the highest demand in the job market,
    provides insights into the most valuable skills for jobseekers going into data analysts
*/

SELECT skills, COUNT(skills_dim.skill_id) AS skill_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND (job_location LIKE '%NZ%' OR job_location LIKE '%New Zealand%')
GROUP BY skills
ORDER BY skill_count DESC
LIMIT 5;
