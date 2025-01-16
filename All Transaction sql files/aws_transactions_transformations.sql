-- create stored procedure
CREATE OR REPLACE PROCEDURE  merge_order_to_silver()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  rows_inserted INT;
  rows_updated INT;
BEGIN
  MERGE INTO silver.orders AS target
  USING (
    SELECT
      transaction_id,
      customer_id,
      product_id,
      quantity,
      store_type,
      total_amount,
      transaction_date,
      payment_method,
     
    
      CURRENT_TIMESTAMP() AS last_updated_timestamp
    FROM bronze.order_changes_stream where transaction_id is not null
    and total_amount> 0) AS source
  ON target.transaction_id = source.transaction_id
  WHEN MATCHED THEN
    UPDATE SET
      customer_id = source.customer_id,
      product_id = source.product_id,
      quantity = source.quantity,
      store_type = source.store_type,
      total_amount = source.total_amount,
      transaction_date = source.transaction_date,
      payment_method = source.payment_method,
      
      
      last_updated_timestamp = source.last_updated_timestamp
  WHEN NOT MATCHED THEN
    INSERT (transaction_id, customer_id, product_id, quantity, store_type, total_amount, transaction_date, payment_method, last_updated_timestamp)
    VALUES (source.transaction_id, source.customer_id, source.product_id, source.quantity, source.store_type, source.total_amount, source.transaction_date, source.payment_method, source.last_updated_timestamp);



  -- Return summary of operations
  RETURN 'Orders processed: ' ;
END;
$$;


-- create task 
 CREATE OR REPLACE TASK order_silver_merge_task
  WAREHOUSE = compute_wh
  SCHEDULE = 'USING CRON 30 */2 * * * America/New_York'
AS
  CALL merge_order_to_silver();
  

-- start task
  ALTER TASK order_silver_merge_task RESUME;