
-- create stored PROCEDURE
CREATE OR REPLACE PROCEDURE  merge_product_to_silver()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  rows_inserted INT;
  rows_updated INT;
BEGIN
  MERGE INTO silver.product AS target
  USING (
    SELECT
      product_id,
      name AS name,
       category,
      -- Price validation and normalization
      CASE
        WHEN price < 0 THEN 0
        ELSE price
      END AS price,
      brand,
      -- Stock quantity validation
      CASE
        WHEN stock_quantity >= 0 THEN stock_quantity
        ELSE 0
      END AS stock_quantity,
      -- Rating validation
      CASE
        WHEN rating BETWEEN 0 AND 5 THEN rating
        ELSE 0
      END AS rating,
      is_active,
      
      CURRENT_TIMESTAMP() AS last_updated_timestamp
    FROM bronze.product_changes_stream
 
  ) AS source
  ON target.product_id = source.product_id
  WHEN MATCHED THEN
    UPDATE SET
      name = source.name,
      category = source.category,
      price = source.price,
      brand = source.brand,
      stock_quantity = source.stock_quantity,
      rating = source.rating,
      is_active = source.is_active,
     
      last_updated_timestamp = source.last_updated_timestamp
  WHEN NOT MATCHED THEN
    INSERT (product_id, name, category, price, brand, stock_quantity, rating, is_active, last_updated_timestamp)
    VALUES (source.product_id, source.name, source.category, source.price, source.brand, source.stock_quantity, source.rating, source.is_active, source.last_updated_timestamp);



  -- Return summary of operations
  RETURN 'Products processed: ';
END;
$$;

-- create task
CREATE OR REPLACE TASK product_silver_merge_task
  WAREHOUSE = compute_wh
  SCHEDULE = 'USING CRON 15 */4 * * * America/New_York'
AS
  CALL merge_product_to_silver();

--start task  
ALTER TASK product_silver_merge_task RESUME;
