--- let me create a shema of for silver layer 

create schema silver 
use AWS_DB.SILVER;

---in the silver layer i wanna do transformations and cleaning then push data into silver layer tables...

----now let me create 3 tables for customers/products/orders.

---customer table 
 CREATE TABLE IF NOT EXISTS SILVER.CUSTOMER (
       customer_id INT,
       name STRING,
       email STRING,
       country STRING,
       customer_type STRING,
       registration_date DATE,
       AGE INT,
       grender STRING,
       total_purchase INT,
       last_updated_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP() --- whenever the data get ingested it inserted with current timestamp.
   );

---lets create the products table 

CREATE TABLE IF NOT EXISTS SILVER.PRODUCT (
    product_id INT,
    name STRING,
    category STRING,
    brand STRING,
    price FLOAT,
    stock_quantity INT,
    rating FLOAT,
    is_active BOOLEAN,
    last_updated_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP() --- whenever the data get ingested it inserted with current timestamp.  
);


---lets create transaction table. 

CREATE OR REPLACE TABLE SILVER.TRANSACTION (
  customer_id INT,
  pyament_method STRING,
  product_id INT,
  quantity INT,
  store_type STRING,
  total_amount DOUBLE,
  transaction_date DATE,
  transaction_id STRING,
  last_updated_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
