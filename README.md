# OMS Pipeline Project [ELT]

## Overview
This project implements a cost-effective ELT pipeline designed for medium businesses, focusing on daily data processing with minimal impact on production systems. The pipeline extracts raw data, processes it incrementally, and stores it in a hybrid S3-Snowflake architecture for analytics and visualization.

## Key Features
* **Daily Incremental Processing**: Only processes new data each day, reducing compute costs and ensuring efficient resource utilization.

* **Cost-Optimized Storage**: Implements a hybrid approach using S3 for raw data storage and Snowflake for processed data, optimizing costs while maintaining performance.

* **Data Orchestration**: Leverages Apache Airflow for robust pipeline automation with scheduled workflows and dependency management.

* **Data Transformation**: Utilizes DBT for SQL transformations with incremental models, ensuring efficient and maintainable data processing.

* **Data Storage**: Implements a dual-storage strategy with AWS S3 for raw data and Snowflake for processed data, optimizing for both cost and performance.

* **Data Visualization**: Integrates Metabase for creating interactive dashboards connected directly to Snowflake.

* **Notifications**: Features comprehensive email alert system for pipeline status and failure monitoring.

* **Scalability**: Built with Docker containerization for seamless deployment and scaling.

## Architecture

```mermaid
graph TD
    A[Daily Raw Data] -->|S3 Partitioned Storage| B{S3 Raw Zone}
    B -->|External Tables| C[Snowflake Staging]
    C -->|dbt Incremental| D[Snowflake Facts/Marts]
    D -->|Materialized Views| E[Metabase Dashboards]
    B -->|Lifecycle Rules| F[S3 Glacier for Backup]
    C -.->|Transient Tables| G[Daily Staging Cleanup]
```

## Tech Stack

### Core Components
* **Orchestration**: Apache Airflow
* **Data Transformation**: DBT (with incremental models)
* **Data Storage**:
  * Raw Data: AWS S3 (partitioned by date)
  * Processed Data: Snowflake (transient tables for staging)
* **Visualization**: Metabase
* **Programming**: Python (for Airflow tasks)
* **Containerization**: Docker
* **Infrastructure**: AWS EC2 (for Airflow and Metabase hosting)

## Installation

### Prerequisites
* Docker and Docker Compose installed
* AWS account with S3 and EC2 access
* Snowflake account with a configured warehouse
* Metabase instance (hosted or self-hosted)

### Setup Steps
1. Clone the repository:
```bash
git clone <repository_url>
cd <repository_name>
```

2. Build and run the Docker container:
```bash
docker-compose up --build
```

3. Configure Airflow connections:
   * AWS S3
   * Snowflake
   * Metabase

4. Deploy DBT models:
```bash
dbt run
```

5. Access the pipeline:
   * Airflow: http://localhost:8080
   * Metabase: http://localhost:3000

## Workflow

### Daily Pipeline Execution

#### 1. Data Extraction
* Extract raw data from the source system
* Store in S3 with date-based partitioning:
```bash
s3://your-bucket/raw/year=YYYY/month=MM/day=DD/
```

#### 2. Data Loading
* Utilize Snowflake external tables to query raw data directly from S3
* Load only the previous day's data into a transient staging table

#### 3. Data Transformation
* Implement DBT incremental models to process and update facts/marts

Example incremental model:
```sql
{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
  )
}}
SELECT *
FROM {{ source('s3', 'raw_orders') }}
WHERE order_date = CURRENT_DATE - 1
```

#### 4. Staging Cleanup
* Drop transient staging tables after successful processing:
```sql
DROP TABLE IF EXISTS staging.orders;
```

#### 5. Visualization
* Create dashboards in Metabase using Snowflake marts

## Cost Optimization

### S3 Storage Strategy
* Raw Data Lifecycle:
  * Move to Glacier after 7 days
  * Delete after 90 days

Example Lifecycle Policy:
```json
{
  "Rules": [
    {
      "Filter": {"Prefix": "raw/"},
      "Transitions": [
        {"Days": 7, "StorageClass": "GLACIER"}
      ],
      "Expiration": {"Days": 90}
    }
  ]
}
```

### Snowflake Optimization
* Implement transient tables for staging to reduce storage costs
* Enable auto-suspend for warehouses to minimize compute costs

### Notifications
Email alerts for stakeholder notification:

```python
from airflow.operators.email_operator import EmailOperator

notify = EmailOperator(
    task_id='notify',
    to='team@example.com',
    subject='Pipeline Status',
    html_content='The daily pipeline has completed successfully.'
)
```

## Deployment
* **Docker**: Containerized pipeline for consistent deployment
* **AWS EC2**: Dedicated hosting for Airflow and Metabase
* **Docker Hub**: Centralized image repository for team access

## Future Improvements
* **Enhanced Notifications**: Integration with Slack for real-time alerts
* **Data Quality**: Implementation of Great Expectations for validation
* **Multi-Source Support**: Extension for additional data sources
* **Cost Monitoring**: Integration with AWS Cost Explorer and Snowflake usage dashboards
* **Automated Testing**: Comprehensive test suite for pipeline components
* **Disaster Recovery**: Backup and recovery procedures
* **Performance Monitoring**: Advanced metrics and logging

## License
This project is licensed under the MIT License. See the LICENSE file for details.
