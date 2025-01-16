--- if i want to analyze the daily sales data 
----i'm creating one view for sales so that i can use it for reporting.

---creating view 1 
--- here i combinied these three tabls orders/products/customers by grouping few columns like 
---transaction_date/product_id/name/category/customer_id/cusotomer_type.
SELECT CURRENT_SCHEMA();


CREATE OR REPLACE VIEW VW_DAILY_SALES_ANALYSIS AS
SELECT 
    o.transaction_date,
    p.product_id,
    p.name AS product_name,
    p.category AS product_category,
    c.customer_id,
    c.customer_type,
    SUM(o.quantity) AS total_quantity,
    SUM(o.total_amount) AS total_sales,
    COUNT(DISTINCT o.transaction_id) AS num_transactions,
    SUM(o.total_amount) / NULLIF(SUM(o.quantity), 0) AS avg_price_per_unit,
    SUM(o.total_amount) / NULLIF(COUNT(DISTINCT o.transaction_id), 0) AS avg_transaction_value
FROM PUBLIC.RAW_TRANSACTION o
JOIN PUBLIC.RAW_PRODUCT p ON o.product_id = p.product_id
JOIN PUBLIC.RAW_CUSTOMER c ON o.customer_id = c.customer_id
GROUP BY 
    o.transaction_date,
    p.product_id,
    p.name,
    p.category,
    c.customer_id,
    c.customer_type;

---lets check the output how it looks like 
select * from VW_DAILY_SALES_ANALYSIS