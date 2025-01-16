 ---before loading the data first i have to create a file format which states that which file format is coming in so that i can be easy to read.

---create file format 
CREATE OR REPLACE FILE FORMAT csv_file_format
   TYPE = CSV
   FIELD_DELIMITER = ','
   SKIP_HEADER = 1 
   NULL_IF = ('NULL','null','')
   EMPTY_FIELD_AS_NULL = TRUE
   COMPRESSION = AUTO;

 ---Before loading the customer data / i have to create a table named as customer table

   ---creating a table for customers data / Customers table
   CREATE TABLE IF NOT EXISTS raw_customer(
       customer_id INT,
       name STRING,
       email STRING,
       country STRING,
       customer_type STRING,
       registration_date DATE,
       AGE INT,
       grender STRING,
       total_purchase INT,
       source_file_name STRING, ---so that we can get file from which data get ingested.
       source_file_row_number INT, --- we get row number from the source file.
       ingestion_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP() --- whenever the data get ingested it inserted with current timestamp.
   );

   --- so as of now the table is empty,now we have to load, what im gonna do is ill make automate using task so that data will automatically inserted at given time 

---task creation 
CREATE OR REPLACE TASK load_customer_data_task --- name of the task 
    WAREHOUSE = compute_wh
    SCHEDULE = 'USING CRON 0 2 * * * America/New_York' ---task to get executed every 2:00am in new york time.
AS
    COPY INTO raw_customer(  ---to copy the data into table i used COPY INTO command.
       customer_id,
       name,
       email,
       country,
       customer_type,
       registration_date,
       AGE,
       grender,
       total_purchase,
       source_file_name,
       source_file_row_number 
    )
    FROM(
        SELECT
            $1, ---every column numbers 
            $2,
            $3,
            $4,
            $5,
            $6::DATE,
            $7,
            $8,
            $9,
            metadata$filename, ---which gives me file name which im loading.
            metadata$file_row_number ---which gives me row number.
        FROM @stage_customers_csv ---my data is coming from s3 stage - customer folder.     
    )
    FILE_FORMAT = (FORMAT_NAME = 'csv_file_format')
    ON_ERROR = 'CONTINUE' ---even if any error shows continue the task.
    PATTERN = '.*[.]csv'


--- ok created the task, but to run it automatically in the given time we need to start 

alter task load_customer_data_task resume



