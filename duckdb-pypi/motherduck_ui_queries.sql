
-- Raw sql queries to play around the DuckDB CLI w/ or without MotherDuck

-- 20 M rows ~ 1GB of dataset from october 2021 to october 2022 on duckDB pypi stats
DESCRIBE FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet';

SELECT COUNT(*) FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet';

FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet' limit 5;

-- This is the MotherDuck shared DB where the source dataset is, you can also use the s3 file
-- 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet';
ATTACH 'md:_share/duckdb_stats/d87758b0-7806-4803-8c5d-17144f56bd12';

-- clean up database
DROP DATABASE IF EXISTS my_demo_share;
CREATE DATABASE my_demo_share;

-- create 4 datasets for the dashboards
-- weekly download
CREATE TABLE my_demo_share.weekly_download AS
SELECT 
    EXTRACT(year FROM timestamp) AS year, 
    EXTRACT(month FROM timestamp) AS month, 
    COUNT(*) AS download_count 
FROM 
    duckdb_stats.pypi 
GROUP BY 
    year, month
order by 
    year DESC, month DESC;

-- country download
CREATE TABLE my_demo_share.country_download AS
SELECT 
    country_code, 
    COUNT(*) as download_count 
FROM 
    duckdb_stats.pypi
GROUP BY 
    country_code 
ORDER BY 
    download_count DESC 
LIMIT 1000;

-- weekly duckdb version
CREATE TABLE my_demo_share.weekly_duckdb_version AS
SELECT 
    EXTRACT(year FROM timestamp) AS year,
    EXTRACT(week FROM timestamp) AS week,
    file->>'version' AS duckdb_version,
    COUNT(*) AS download_count
FROM 
    duckdb_stats.pypi
WHERE 
    project = 'duckdb'
GROUP BY 
    year, week, duckdb_version
ORDER BY 
    year DESC, week DESC, download_count DESC;

-- weekly python version
CREATE table my_demo_share.weekly_python_version AS
SELECT 
    EXTRACT(year FROM timestamp) AS year, 
    EXTRACT(week FROM timestamp) AS week, 
    CONCAT(SPLIT_PART(python_version, '.', 1), '.', SPLIT_PART(python_version, '.', 2)) AS python_major_minor_version,
    COUNT(*) AS download_count
FROM (
    SELECT timestamp, 
           details->>'python' as python_version 
    FROM duckdb_stats.pypi
    WHERE (details->>'python' IS NOT NULL) AND (details->>'python' <> '')
) as filtered_data
GROUP BY 
    year, week, python_major_minor_version
ORDER BY 
    year DESC, week DESC, download_count DESC;



