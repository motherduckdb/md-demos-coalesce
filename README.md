# MotherDuck Demo Coalesce 2023

This demo contains 3 folders : 
- duckdb-pypi : notebooks and sql to gives intro to DuckDB and play around the pypi dataset on MotherDuck
- md-dbt : same queries used from the above, to give an highlight on how duckdb/md and dbt works together
- md-evidence : for local snappy dashboard

You can find the videos of the demo [here](https://drive.google.com/drive/folders/1iIXrcwBg6Iw30U_K9IpFFN0vpOw6W7GI)

See demo script on [Notion](https://www.notion.so/motherduck/Demo-scripts-Coalesce-October-2023-db4753efa7c94fd38c866be7b58b2992?pvs=4)

Requirements : 
* VSCode & [devcontainer extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
* Docker desktop
* A MotherDuck account & service token
* Copy queries that are in ./duckdb-pypi/motherduck_ui_queries.sql in the MotherDuck UI

# Setup
Use the devcontainer feature from VSCode to load the container that will have all requirements :
* Python 3.11
* dbt/duckdb packages
* NodeJS (for Evidence dashboard)
* DuckDB CLI
* A parquet dataset downloaded from AWS S3 (in the `dataset` folder) of ~900MB

# Run the demos

## Intro to DuckDB & MotherDuck
Open `duckdb_intro.ipynb` in VSCode and go through the cells (intro duckdb, query Pypi data and connect to MotherDuck Cloud).

## dbt
You can use the two `make` commands
* `make dbt-local` : will run dbt/duckdb locally based on the parquet dataset present in `./dataset` and output CSVs in `md-dbt/output`
* `make dbt-md` : will run dbt/duckdb locally and push the data to MotherDuck under the database `my_db`. You need to export first your `MOTHERDUCK_TOKEN` before running this!

## Evidence (dashboard)
You can use the make commands : 
* `make evidence-install`: will install node packages
* `make evidence-run`: will run a local server, dashboard will be accessible typically on port 3001.

