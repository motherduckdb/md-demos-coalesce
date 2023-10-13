SELECT 
    TIMESTAMP_TRUNC(timestamp, DAY) as date,
    COUNT(*) as download_count,
    file.project 
FROM 
    `bigquery-public-data.pypi.file_downloads`
WHERE 
    file.project = 'duckdb' AND
    TIMESTAMP_TRUNC(timestamp, DAY) BETWEEN TIMESTAMP('2021-10-12') AND TIMESTAMP('2023-10-12')
GROUP BY 
    date, file.project
ORDER BY 
    date ASC;
