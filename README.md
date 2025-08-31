# Introduction
This data project dives into the data job market, by focusing on data analyst roles using a dataset from 2023 to explore top-paying jobs, skills that are in-demand for the role, and where a high demand in skills correlate with a higher salary job in data analytics.

Check out the SQL queries here: [project_sql folder](/project_sql/).
# Background
The project focuses on analysing the data analyst job market by seeking the most in-demand and top paid skills for the role. The project analysed job descriptions, salaries, skill requirements and availability in remote positions.  
### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for the top-paying Data Analyst jobs in New Zealand?
3. What are the most in-demand skills for Data Analysts in New Zealand?
4. Do larger companies that have more job postings offer higher average salaries than smaller or medium companies?
5. Is there a difference in salary between people with a degree and people without a degree in New Zealand?
6. What are the most optimal skills to learn such as in-demand and high-paying skills?

# Tools I used
For this project, the skills I used were:
- **SQL**: It allowed me to query the database and explore insights in the data world, from data analyst to data engineer. I applied SQL concepts such as joins, aggregate functions, subqueries, CTEs and Case logic to explore the dataset and answer my questions.
- **Postgres**: Postgres was used in this project as it's considered one of the most popular database management system recognised by all.
- **Visual Studio Code**: My primary coding IDE for writing and testing SQL queries.
- **Git/Github**: Essential for version control and project sharing. I used Git for tracking any changes to my SQL scripts and used Github for presenting my portfolio.

# The Analysis
### 1. What are the top-paying data analyst jobs?

To identify highest paying roles, I filtered data analyst roles by average yearly salary, location and focusing on remote jobs. This query highlights the high paying positions in the data analyst field.

```sql
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
```

The breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range**: The top 10 paying data analyst roles span from $184000 to $650000, showing high salary potential in the data analyst field.
- **Diverse Employers**: Mix of tech giants, mid-sized firms and niche recruiters are among those offering high salaries, showing data analyst is needed for different industries.
- **Senior Roles**: From the several job postings, the roles are targetted towards positions with 'Director' or 'Principal' level, indicating that these salaries are not targetted for entry-level but towards senior positions.

| job_title                                      | company_name                           | job_location | salary_year_avg |
| ----------------------------------------------- | --------------------------------------- | ------------- | ----------------- |
| Data Analyst                                    | Mantys                                  | Anywhere      | 650000.0          |
| Director of Analytics                           | Meta                                    | Anywhere      | 336500.0          |
| Associate Director- Data Insights               | AT\&T                                   | Anywhere      | 255829.5          |
| Data Analyst, Marketing                         | Pinterest Job Advertisements            | Anywhere      | 232423.0          |
| Data Analyst (Hybrid/Remote)                    | Uclahealthcareers                       | Anywhere      | 217000.0          |
| Principal Data Analyst (Remote)                 | SmartAsset                              | Anywhere      | 205000.0          |
| Director, Data Analyst - HYBRID                 | Inclusively                             | Anywhere      | 189309.0          |
| Principal Data Analyst, AV Performance Analysis | Motional                                | Anywhere      | 189000.0          |
| Principal Data Analyst                          | SmartAsset                              | Anywhere      | 186000.0          |
| ERM Data Analyst                                | Get It Recruit - Information Technology | Anywhere      | 184000.0          |

### 2. What skills are required for the top-paying Data Analyst jobs in New Zealand?

To identify skills that result in top paying jobs I filtered for data analyst positions and filtered for job postings that are located in New Zealand. This query highlights the top paying skills in the data analyst field in New Zealand.

```sql
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
```
The breakdown for the most demanded skills for top paying data analyst jobs in New Zealand in 2023:

- **SQL** is leading with a count of 6.
- **Python** follows closely with a count of 5.
- Then we have **data tools** such as Power BI and Spark.
- And **cloud/big** data such as AWS and Azure.
- Then **general office tools** like Excel.

```
SQL        ████████████████████  (6 postings)
Python     ████████████████      (5 postings)
R          ███████████           (4 postings)
Power BI   █████████             (3 postings)
Spark      ███████               (2 postings)
AWS        ██████                (2 postings)
Azure      █████                 (1 posting)
Excel      █████                 (1 posting)
```

### 3. What are the most in-demand skills for Data Analysts in New Zealand?

To identify the 5 most in-demand skills for a data analyst position I filtered the location to be in New Zealand, while limiting it to only 5 rows. This query highlights the most in-demand skills in the data analyst field in New Zealand.

```sql
SELECT 
    skills, 
    COUNT(skills_dim.skill_id) AS skill_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND (job_location LIKE '%NZ%' OR job_location LIKE '%New Zealand%')
GROUP BY skills
ORDER BY skill_count DESC
LIMIT 5;
```

The breakdown for the most in-demand skills for a data analyst job in New Zealand are;
- **SQL** is the clear leader when it comes to data analyst jobs, ~2x more than Python.
- **Excel** is highly relevant and useful in 136 postings.
- **Power BI** is almost tied with Excel shows the importance of data visualisation tools.
- **Python/R** are strong but secondary compared to SQL and BI tools.

```
| Skill    | Skill Count |
| -------- | ----------- |
| SQL      | 203         |
| Excel    | 136         |
| Power BI | 130         |
| R        | 106         |
| Python   | 100         |
```

### 4. Do larger companies that have more job postings offer higher average salaries than smaller or medium companies?

To identify whether larger companies that post more job offerings offer higher average salaries than smaller or medium companies. I did a CASE expression where small companies had less than 20 postings, medium between 20 and 50 and large had more than 50 postings. I also filtered where the number of postings had to be more than 5 to make the averages more reliable. This query highlights whether larger companies offer a higher salary in the data analyst field.

```sql
SELECT 
    COUNT(company_summary.company_id) as num_companies,
    ROUND(AVG(company_summary.average_salary),0) AS average_salary,
    company_size
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
GROUP BY company_size
ORDER BY average_salary DESC;
```

The breakdown for whether larger companies offer higher salaries for a data analyst job in 2023 are:
- **Medium Companies** offer the highest average salaries, even higher than large companies.
- **Large Companies** averages at $93,624, which is lower than expected, this could be because larger comapnies hire more junior analysts.
- **Small Companies** dominate in count of 100 companies, with their average salary higher than larger companies but less than medium companies.
```
| Company Size   | Number of Companies | Average Salary |
| -------------- | ------------------- | -------------- |
| Medium Company | 8                   | 105,286        |
| Small Company  | 100                 | 96,829         |
| Large Company  | 7                   | 93,624         |
```
### 5. Is there a difference in salary between people with a degree and people without a degree in New Zealand?

To identify whether there was a difference in salary between someone with or without a degree. I filtered to search for job postings in New Zealand and used CASE expression for whether the job posting mentioned for a degree or not. This query highlights whether a degree earns more in New Zealand.

```sql
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
```

The breakdown for whether a degree would earn more than someone without a degree in data analyst in New Zealand in 2023 are:
- Out of the 513 job postings in New Zealand, 390 (76%) were open to jobseekers without a degree.
- No degree jobs paid slightly more than than those with a degree jobs.
- Companies might value practical technical skills such as SQL, Python and BI tools over a formal education.
```
| Degree Requirement | Avg. Salary | Job Postings |
| ------------------ | ----------- | ------------ |
| Degree             | 69,771      | 123          |
| No Degree          | 75,450      | 390          |
```

### 6. What are the most optimal skills to learn such as in-demand and high-paying skills?

To identify the most optimal skills to learn in terms of in-demand and high-paying. I joined 3 tables in total to get information I needed, while allowed to work remotely. This query highlights the most in-demand skills followed by their salary.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
ORDER BY demand_count DESC, avg_salary DESC
LIMIT 20;
```

Break down
- **SQL** at a count of 398 shows it's the most in-demand skill across nearly every data role.
- **Go** has the highest average salary although its demand is low at 27 job postings, suggest it's a niche skill but also highly valued.
-- **Cloud & Data Engineering tools** such as Snowflake, AWS and Azure tend to pay the most however, it's demand is not that highly sought after in the data analyst field.

```
| Skill      | Demand Count | Avg. Salary |
| ---------- | ------------ | ----------- |
| SQL        | 398          | 97,237      |
| Excel      | 256          | 87,288      |
| Python     | 236          | 101,397     |
| Tableau    | 230          | 99,288      |
| R          | 148          | 100,499     |
| Power BI   | 110          | 97,431      |
| SAS        | 63           | 98,902      |
| PowerPoint | 58           | 88,701      |
| Looker     | 49           | 103,795     |
| Word       | 48           | 82,576      |
| Snowflake  | 37           | 112,948     |
| Oracle     | 37           | 104,534     |
| SQL Server | 35           | 97,786      |
| Azure      | 34           | 111,225     |
| AWS        | 32           | 108,317     |
| Sheets     | 32           | 86,088      |
| Flow       | 28           | 97,200      |
| Go         | 27           | 115,320     |
| SPSS       | 24           | 92,170      |
```
# What I learned

**Data Aggregation**: Got confident with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarising buddies.

**Complex Query Crafting**: Got confident in using advanced SQL such as merging tables, subqueries, CTEs, however, still have a lot of practice to go before mastering the skills.

**Analytical Skills**: Improved my real-world problem solving skills, such as turning questions into actionable, insightful SQL queries.

# Conclusions
From the analysis, some general insights:
1. **Top Paying Data Analyst Jobs**: The top paying data analyst jobs range from $184k to $650k, showing high earning potential in the data analyst field that allow remote work.
2. **Top Paying Data Analyst Skills**: SQL appears to be in almost all top paying jobs, followed by Python and R. Data tools such as Power BI and cloud/big data skills such as AWS, Azure and Snowflake also contribute to high salaries.
3. **Most In-Demand Skills**: In New Zealand, the most in-demand skills for a data analyst job are SQL, Excel, Power BI, R and Python. SQL is the most dominant skill to learn, but Excel and Power BI are also heavily sought after.
4. **Does Company Size Matter**: Medium sized companies offered the highest average salaries at $105,286, while larger companies offered the lowest average salaries at $93,624. There are much more smaller companies posting data analyst jobs, however, their salaries at inbetween medium and large companies.
5. **Do Degrees Matter for Salary**: Majority of the job postings (76%) accept candidates without a degree in New Zealand. Also, job postings that do not require a degree has a slightly higher salary than those with a degree. Suggesting, technical skills is more valued than a formal education in data analyst.
6. **Optimal Skills in the Job Market**: SQL is the most in-demand skill, offering a high average salary, followed by Python, Tableau, R and Excel. There are also niche skills that are high paying such as Go, Snowflake, AWS, Azure and Oracle, suggesting learning a mix of in-demand and niche skills can lead to career flexibility and earning potential.

### Closing Thoughts
This project enhanced my SQL skills and provided me with valuable insights into the data analyst job market in New Zealand and the rest of the world. As an aspiring data analyst, I can position myself better in the competitive job market by focusing on in-demand skills in the data analyst field not just in New Zealand but globally. This project highlighted that in the field of data analytics, there is continuous learning and adaption to emerging skills and trends.