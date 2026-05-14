SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type, 
    job_posted_date,
    salary_year_avg,
    companies.name AS Company_name

FROM job_postings_fact 
LEFT JOIN company_dim AS companies ON job_postings_fact.company_id = companies.company_id 
WHERE job_location = 'Anywhere' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;