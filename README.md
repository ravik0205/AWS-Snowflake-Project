# AWS-Snowflake-Project 🚀

## Overview 🌟

This project focuses on designing and implementing an end-to-end data engineering solution for an e-commerce company with 5 million customers. The company faced various data challenges, including data silos, processing delays, scalability issues, data quality problems, and limited analytics capability. The solution utilized **Snowflake** and **AWS services** (S3, IAM roles) to centralize, scale, and enhance data processing and analytics.

## Challenges 🚧

- **Data Silos**: Product, customer, and transactional data scattered across separate systems.
- **Processing Delays**: Batch processing caused 24-hour delays in reporting.
- **Scalability Issues**: On-prem data warehouses struggled during peak sales.
- **Data Quality Problems**: Lack of standardization affected reporting accuracy.
- **Limited Analytics Capability**: Insufficient support for advanced analytics and ML.

- ### **Architecture Overview**  
![Architecture Diagram](https://github.com/ravik0205/Azure---Databricks-Project/blob/main/Documentation/azure%20databricks%20workflow.png) 


## Solution 💡

The solution involved designing a modern data engineering architecture that centralized and streamlined data processing, enabling real-time analytics and scalable reporting.

### Key Components 🛠️

1. **Multi-Layer Architecture**:
   - **Bronze Layer**: Raw data ingestion.
   - **Silver Layer**: Data cleaning & transformations (e.g., email validation, age range checks, customer type standardization).
   - **Gold Layer**: Business-specific aggregates & reporting-ready data models.

2. **Data Flow** 🔄:
   - **Sources**: CRM (CSV), Inventory (JSON), E-commerce logs (Parquet).
   - **Pipeline**: Data → S3 (staging area) → Snowflake → BI tools for reporting.
   - **Automations**: Real-time incremental processing using **Streams**, **Tasks**, and **COPY Command**.

3. **Security & Permissions 🔐**:
   - Leveraged **IAM roles** for secure access and policy management between Snowflake and AWS services.

## Outcomes 🎯

- **Reduced Data Processing Delays**: From 24 hours to 1 hour.
- **Centralized Data**: Improved scalability and performance during peak sales.
- **Enhanced Reporting**: Improved reporting accuracy and the ability to perform advanced analytics.

## Technologies Used 🖥️

- **Snowflake**: For data warehousing and multi-layer architecture implementation.
- **AWS S3**: For data storage and staging area.
- **IAM Roles**: For secure access and permission management.
- **SQL & Snowflake Streams/Tasks**: For automation and real-time data processing.
- **BI Tools**: For data visualization and reporting.

## Getting Started 🚀

### Prerequisites ⚙️

- AWS account with access to S3, IAM roles, and Snowflake.
- Snowflake account with the necessary permissions.

### Setup Instructions 📝

1. **Snowflake Setup**:
   - Create a Snowflake account and set up a data warehouse.
   - Define your Bronze, Silver, and Gold layers in Snowflake.
   - Use the COPY command for loading data from S3.

2. **AWS Setup**:
   - Create IAM roles and policies for secure access.
   - Set up S3 buckets for staging data.

3. **Data Ingestion**:
   - Define data sources (CRM, Inventory, E-commerce logs) in S3.
   - Use Snowflake Streams and Tasks to automate data processing.

4. **Analytics & Reporting**:
   - Connect Snowflake to BI tools like Tableau, Power BI, or Looker for advanced analytics.

### Example Data Flow 🔄

```bash
Data Sources → S3 (staging) → Snowflake (Bronze, Silver, Gold layers) → BI Tools
