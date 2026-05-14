SELECT 
    COUNT(job_work_from_home) AS remote_job, 
    skills.skills
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id
WHERE job_work_from_home = true
GROUP BY  skills.skills



SELECT 
    job_title_short,
    salary_year_avg
FROM(
    SELECT
        *
    FROM january   
    UNION
    SELECT
        *
    FROM february    
    UNION
    SELECT
        *
    FROM march )
WHERE salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY salary_year_avg; 