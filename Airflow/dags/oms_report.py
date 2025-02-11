import os
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_conn",
        profile_args={"database": "dbt_db", "schema": "dbt_schema"},
    )
)

EMAIL_RECIPIENTS = ["naveenkumar19082004@gmail.com"]
SENDER_EMAIL = "naveenkumar19082004@gmail.com"
SENDER_PASSWORD = os.environ.get("SENDER_PASSWORD")
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587

def send_email_via_smtp(subject, body, recipients, sender_email, sender_password, smtp_server, smtp_port):
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = ", ".join(recipients)
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, recipients, msg.as_string())
            print("Email sent successfully!")
    except Exception as e:
        print(f"Failed to send email: {e}")

def send_failure_email(context):
    subject = f"DBT DAG Failure Alert: {context['task_instance'].dag_id}"
    body = f"""
    <h3>DBT DAG Failure Notification</h3>
    <ul>
        <li><b>DAG:</b> {context['task_instance'].dag_id}</li>
        <li><b>Task:</b> {context['task_instance'].task_id}</li>
        <li><b>Execution Date:</b> {context['execution_date']}</li>
        <li><b>Log URL:</b> <a href="{context['task_instance'].log_url}">{context['task_instance'].log_url}</a></li>
    </ul>
    """
    send_email_via_smtp(subject, body, EMAIL_RECIPIENTS, SENDER_EMAIL, SENDER_PASSWORD, SMTP_SERVER, SMTP_PORT)

dbt_snowflake_dag = DbtDag(
    project_config=ProjectConfig(
        "/usr/local/airflow/dags/dbt/dbt_project",
    ),
    operator_args={"install_deps": True},
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",
    ),
    schedule_interval="@daily",
    start_date=datetime(2024, 12, 15),
    catchup=False,
    dag_id="dbt_dag",
)

dbt_snowflake_dag.dag.default_args = {
    "email": EMAIL_RECIPIENTS,
    "email_on_failure": True,
    "email_on_retry": False,
    "on_failure_callback": send_failure_email,
}