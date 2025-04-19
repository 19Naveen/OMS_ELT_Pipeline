import os
from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.email import EmailOperator
from datetime import timedelta, datetime
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': True,
    'email_on_retry': False,
    'email_on_success': True,
    'email': ['you@example.com'],
}

with DAG(
    dag_id="dbt_dag",
    default_args=default_args,
    description="A dbt pipeline running on Snowflake with Cosmos",
    schedule_interval="@daily",
    start_date=datetime(2023, 9, 10),
    catchup=False,
    tags=["dbt", "snowflake", "cosmos"],
) as dag:

    start = DummyOperator(task_id="start")
    end = DummyOperator(task_id="end")
    success_notification = EmailOperator(
        task_id='success_notification',
        to='you@example.com',
        subject='DBT DAG Succeeded',
        html_content='The DBT DAG has succeeded.',
        trigger_rule='all_success',
    )

    failure_notification = EmailOperator(
        task_id='failure_notification',
        to='you@example.com',
        subject='DBT DAG Failed',
        html_content='The DBT DAG has failed.',
        trigger_rule='one_failed',
    )

    profile_config = ProfileConfig(
        profile_name="default",
        target_name="dev",
        profile_mapping=SnowflakeUserPasswordProfileMapping(
            conn_id="snowflake_conn",
            profile_args={"database": "dbt_db", "schema": "dbt_schema"},
        ),
    )

    dbt_dag = DbtDag(
        project_config=ProjectConfig("/usr/local/airflow/dags/dbt/data_pipeline"),
        operator_args={"install_deps": True},
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"
        ),
        dag=dag,  
    )

    start >> dbt_dag >> [success_notification, failure_notification] >> end
