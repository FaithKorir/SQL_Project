-- Create company_dim table with primary key
CREATE TABLE public.company_dim (
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);
-- Create skills_dim table with primary key
CREATE TABLE public.skills_dim (
    skill_id INT PRIMARY KEY,
    skills TEXT,
    type TEXT
);
-- Create job_postings_fact table with primary key
CREATE TABLE public.job_postings_fact (
    job_id INT PRIMARY KEY,
    company_id INT,
    job_title_short VARCHAR(255),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN,
    search_location TEXT,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg NUMERIC,
    salary_hour_avg NUMERIC,
    FOREIGN KEY (company_id) REFERENCES public.company_dim (company_id)
);
-- Create skills_job_dim table with a composite primary key and foreign keys
CREATE TABLE public.skills_job_dim (
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES public.job_postings_fact (job_id),
    FOREIGN KEY (skill_id) REFERENCES public.skills_dim (skill_id)
);
-- Set ownership of the tables to the postgres user
ALTER TABLE public.company_dim OWNER to postgres;
ALTER TABLE public.skills_dim OWNER to postgres;
ALTER TABLE public.job_postings_fact OWNER to postgres;
ALTER TABLE public.skills_job_dim OWNER to postgres;
-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_company_id ON public.job_postings_fact (company_id);
CREATE INDEX idx_skill_id ON public.skills_job_dim (skill_id);
CREATE INDEX idx_job_id ON public.skills_job_dim (job_id);
SELECT *
FROM (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(
                MONTH
                FROM job_posted_date
            ) = 1
    ) AS january_jobs;
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(
            MONTH
            FROM job_posted_date
        ) = 1
)
SELECT *
FROM january_jobs;
SELECT name AS company_name
FROM company_dim
WHERE company_id IN (
        SELECT company_id
        FROM job_postings_fact
        WHERE job_no_degree_mention = true
    ) WITH company_job_count AS (
        SELECT company_id,
            COUNT(*) AS total_jobs
        FROM job_postings_fact
        GROUP BY company_id
    )
SELECT company_dim.name AS name,
    company_job_count.total_jobs
FROM company_dim
    LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC

WITH remote_job_skills AS (
    SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact ON skills_to_job.job_id = job_postings_fact.job_id
    
WHERE job_postings_fact.job_work_from_home = true
GROUP BY skill_id

)
SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
    INNER JOIN job_postings_fact ON skills_to_job.job_id = job_postings_fact.job_id
    

