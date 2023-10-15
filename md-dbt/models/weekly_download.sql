{% if target.name == 'dev' %}
    {{ config(materialized='external', location='output/weekly_download.csv', format='csv') }}
{% elif target.name == 'prod' %}
    {{ config(materialized='table') }}
{% endif %}
SELECT 
    EXTRACT(year FROM timestamp) AS year, 
    EXTRACT(week FROM timestamp) AS week, 
    COUNT(*) AS download_count 
FROM 
    {{ source('external_source', 'duckdb_pypi') }}

GROUP BY 
    year, week
ORDER BY 
    year DESC, week DESC
