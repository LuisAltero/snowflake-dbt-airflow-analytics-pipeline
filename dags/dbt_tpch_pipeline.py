from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator


DBT_PROJECT_DIR = "/usr/local/airflow/dbt_project"
DBT_PROFILES_DIR = "/usr/local/airflow/dbt_project"


default_args = {
    "owner": "data-engineering",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


with DAG(
    dag_id="dbt_snowflake_tpch_pipeline",
    description="Orchestrates dbt models for Snowflake TPCH analytics project",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["dbt", "snowflake", "portfolio", "analytics-engineering"],
) as dag:

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt deps --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_debug = BashOperator(
        task_id="dbt_debug",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt debug --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_run_staging = BashOperator(
        task_id="dbt_run_staging",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt run --select staging --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_test_staging = BashOperator(
        task_id="dbt_test_staging",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt test --select staging --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_run_intermediate = BashOperator(
        task_id="dbt_run_intermediate",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt run --select intermediate --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_run_marts = BashOperator(
        task_id="dbt_run_marts",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt run --select marts --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_test_marts = BashOperator(
        task_id="dbt_test_marts",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt test --select marts --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    dbt_docs_generate = BashOperator(
        task_id="dbt_docs_generate",
        bash_command=f"""
        cd {DBT_PROJECT_DIR} &&
        dbt docs generate --profiles-dir {DBT_PROFILES_DIR}
        """,
    )

    (
        dbt_deps
        >> dbt_debug
        >> dbt_run_staging
        >> dbt_test_staging
        >> dbt_run_intermediate
        >> dbt_run_marts
        >> dbt_test_marts
        >> dbt_docs_generate
    )