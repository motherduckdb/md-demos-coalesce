{% if target.name == 'dev' %}
    {{ config(materialized='external', location='output/country_download.csv', format='csv') }}
{% elif target.name == 'prod' %}
    {{ config(materialized='table') }}
{% endif %}
SELECT 
    country_code, 
    COUNT(*) as download_count 
FROM 
    {{ source('external_source', 'duckdb_pypi') }}
GROUP BY 
    country_code 
ORDER BY 
    download_count DESC 
