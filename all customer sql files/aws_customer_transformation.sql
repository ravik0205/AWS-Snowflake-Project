use AWS_DB.SILVER;

-- create stored procedure
CREATE OR REPLACE PROCEDURE process_customer_changes()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  rows_inserted INT DEFAULT 0;
  rows_updated INT DEFAULT 0;
BEGIN
  -- Merge changes into silver layer
  MERGE INTO silver.customer AS target
  USING (
    SELECT
      customer_id,
      name,
      email,
      country,
      -- Customer type standardization
      CASE
        WHEN TRIM(UPPER(customer_type)) IN ('REGULAR', 'REG', 'R') THEN 'Regular'
        WHEN TRIM(UPPER(customer_type)) IN ('PREMIUM', 'PREM', 'P') THEN 'Premium'
        ELSE 'Unknown'
      END AS customer_type,
      registration_date,
      -- Age validation
      CASE
        WHEN age BETWEEN 18 AND 120 THEN age
        ELSE NULL
      END AS age,
      -- Gender standardization
      CASE
        WHEN TRIM(UPPER(gender)) IN ('M', 'MALE') THEN 'Male'
        WHEN TRIM(UPPER(gender)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'Other'
      END AS gender,
      -- Total purchases validation
      CASE
        WHEN total_purchases >= 0 THEN total_purchases
        ELSE 0
      END AS total_purchases,
      current_timestamp() AS last_updated_timestamp
    FROM bronze.customer_changes_stream
    WHERE customer_id IS NOT NULL AND email IS NOT NULL -- Basic data quality rule
  ) AS source
  ON target.customer_id = source.customer_id
  WHEN MATCHED THEN
    UPDATE SET
      name = source.name,
      email = source.email,
      country = source.country,
      customer_type = source.customer_type,
      registration_date = source.registration_date,
      age = source.age,
      gender = source.gender,
      total_purchases = source.total_purchases,
      last_updated_timestamp = source.last_updated_timestamp
  WHEN NOT MATCHED THEN
    INSERT (customer_id, name, email, country, customer_type, registration_date, age, gender, total_purchases, last_updated_timestamp)
    VALUES (source.customer_id, source.name, source.email, source.country, source.customer_type, source.registration_date, source.age, source.gender, source.total_purchases, source.last_updated_timestamp);

  -- Return summary of operations
  RETURN 'Rows updated: ' || rows_updated || ', Rows inserted: ' || rows_inserted;
END;
$$;

  -- Return summary of operations
  RETURN 'Customers processed';
END;



-- Create task
CREATE OR REPLACE TASK silver_customer_merge_task
  WAREHOUSE = compute_wh
  SCHEDULE = 'USING CRON 0 */4 * * * America/New_York'
AS
  CALL process_customer_changes();

-- start task    
ALTER TASK silver_customer_merge_task RESUME;
  