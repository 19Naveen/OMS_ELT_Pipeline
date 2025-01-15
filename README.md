# OMS Pipeline Project[ELT]

## Overview
This project involves the design and implementation of an ELT (Extract, Load, Transform) pipeline to handle data orchestration, transformation, storage, and visualization. The solution leverages modern data engineering tools to ensure scalability, reliability, and efficiency.

## Features
- **Data Orchestration**: Apache Airflow is used to automate and schedule pipeline workflows.
- **Data Transformation**: DBT (Data Build Tool) handles modular, maintainable SQL transformations.
- **Data Storage**: AWS S3 serves as the data storage layer, with Snowflake as the data warehouse.
- **Data Visualization**: Insights are visualized using Metabase.
- **Notifications**: Automated email alerts provide real-time updates on pipeline status.
- **Scalability**: The pipeline is containerized using Docker and published on Docker Hub for easy deployment.

## Architecture
1. **Orchestration**: Airflow DAGs manage the workflow, including data extraction, loading, and transformation steps.
2. **Transformation**: DBT models transform raw data into analytics-ready datasets in Snowflake.
3. **Storage**: Data is stored on AWS S3 before being ingested into Snowflake.
4. **Visualization**: Metabase connects to Snowflake for interactive dashboards and insights.
5. **Notifications**: Email notifications inform stakeholders of pipeline status and any issues.

## Tech Stack
- **Orchestration**: Apache Airflow
- **Data Transformation**: DBT
- **Data Storage**: AWS S3, Snowflake
- **Visualization**: Metabase
- **Programming**: Python
- **Containerization**: Docker
- **Infrastructure**: AWS EC2

## Installation
### Prerequisites
- Docker and Docker Compose installed.
- AWS account with S3 and EC2 setup.
- Snowflake account and warehouse configured.
- Metabase instance (hosted or self-hosted).

### Steps
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```
2. Build and run the Docker container:
   ```bash
   docker-compose up --build
   ```
3. Configure Airflow connections for AWS, Snowflake, and Metabase.
4. Deploy DBT models:
   ```bash
   dbt run
   ```
5. Access the pipeline:
   - Airflow: `http://localhost:8080`
   - Metabase: `http://localhost:3000`

## Usage
1. Define the data sources and transformations in Airflow and DBT.
2. Trigger the Airflow DAG to execute the pipeline.
3. Monitor the status through Airflow and receive email notifications.
4. View visualized insights in Metabase.

## Deployment
- The Docker image is published on Docker Hub for scalability.
- AWS EC2 is used for hosting the Airflow and Metabase services.

## Future Improvements
- Add support for multiple data sources.
- Implement Slack notifications for better team collaboration.
- Optimize DBT models for improved performance.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
