
-- 20 M rows ~ 1GB of dataset from october 2021 to october 2022 on duckDB pypi stats
DESCRIBE FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet';
SELECT COUNT(*) FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet';
FROM 's3://us-prd-motherduck-open-datasets/duckdb_stats/pypi/duckdb_pypi.parquet' limit 5;

