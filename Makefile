
.PHONY: dataset, duckdb-install, duckdb-uninstall, dbt-local, dbt-md, evidence-install, evidence-run

## Init targets

dataset:
	mkdir -p dataset
	[ -f dataset/duckdb_pypi.parquet ] || curl -o dataset/duckdb_pypi.parquet https://us-prd-motherduck-open-datasets.s3.amazonaws.com/duckdb_stats/pypi/duckdb_pypi.parquet

duckdb-install:
	.devcontainer/scripts/setup_duckdb.sh install

duckdb-uninstall:
	.devcontainer/scripts/setup_duckdb.sh uninstall

## dbt

dbt-local:
	cd md-dbt && dbt run

dbt-md:
	cd md-dbt && dbt run --target prod 

## evidence

evidence-install:
	cd md-evidence && npm install

evidence-run:
	cd md-evidence && npm run dev
