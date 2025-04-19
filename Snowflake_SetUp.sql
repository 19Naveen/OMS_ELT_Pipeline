-- Create External Stage
CREATE OR REPLACE STAGE oms_datalake_ext_stg
  URL='s3://<bucketName>/'
  CREDENTIALS=(AWS_KEY_ID='AKIA5SDAFSDAFKIXSQ' AWS_SECRET_KEY='ab68uuTVzL0oc4pNAgMA0eZdz');

ls @oms_datalake_ext_stg;

CREATE OR REPLACE STAGE my_s3_stage
  URL = 's3://data_uploads_19/'
  STORAGE_INTEGRATION = my_aws_integration
  FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1 NULL_IF = ('NULL','null'));

CREATE OR REPLACE EXTERNAL TABLE l1_landing.orders (
    OrderID STRING,
    OrderDate DATE,
    CustomerID STRING,
    EmployeeID STRING,
    StoreID STRING,
    Status STRING,
    Updated_at TIMESTAMP,
    Created_at TIMESTAMP,        
    LastModified_at TIMESTAMP,    
    file_date STRING AS (METADATA$DIRECTORY)  
)
PARTITION BY (file_date)
LOCATION = @my_s3_stage
PATTERN = '.*\/(\\d{4}-\\d{2}-\\d{2})\/orders\.csv$'
AUTO_REFRESH = TRUE;

CREATE OR REPLACE EXTERNAL TABLE l1_landing.orderitems (
    OrderItemID STRING,
    OrderID STRING,
    ProductID STRING,
    Quantity NUMBER,
    UnitPrice NUMBER,
    TotalPrice NUMBER,           
    Updated_at TIMESTAMP,
    Created_at TIMESTAMP,         
    LastModified_at TIMESTAMP,    
    file_date STRING AS (METADATA$DIRECTORY)
)
PARTITION BY (file_date)
LOCATION = @my_s3_stage
PATTERN = '.*\/(\\d{4}-\\d{2}-\\d{2})\/orderitems\.csv$'
AUTO_REFRESH = TRUE;

CREATE OR REPLACE EXTERNAL TABLE l1_landing.customers (
    CustomerID STRING,
    FirstName STRING,
    LastName STRING,
    Email STRING,
    Phone STRING,
    Address STRING,
    City STRING,
    State STRING,
    ZipCode STRING,
    Updated_at TIMESTAMP,
    Created_at TIMESTAMP,          
    LastModified_at TIMESTAMP,    
    file_date STRING AS (METADATA$DIRECTORY)
)
PARTITION BY (file_date)
LOCATION = @my_s3_stage
PATTERN = '.*\/(\\d{4}-\\d{2}-\\d{2})\/customers\.csv$'
AUTO_REFRESH = TRUE;