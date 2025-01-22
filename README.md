# Retail-Sales-Analysis

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_database`

This project showcases SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. It includes setting up a sales database, conducting exploratory data analysis (EDA), and answering key business questions using SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_database`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction_ID, sale_date, sale_time, customer_ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_database;
CREATE TABLE retail_sales
(
    transactions_id INT8 PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT8,	
    gender VARCHAR(10),
    age INT8,
    category VARCHAR(35),
    quantity INT8,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05'
```


2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM RETAIL_SALES
WHERE CATEGORY = 'Clothing' AND QUANTIY >=4 AND
TO_CHAR (SALE_DATE, 'YYYY-MM') = '2022-11'
```


3. **Write a SQL query to calculate the total sales and total orders for each category.**:
```sql
SELECT CATEGORY, 
       COUNT(*) AS TOTAL_ORDERS, 
	   SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY 1
```


4. **Write a query to calculate the total revenue from the dataset.**:
```sql
SELECT SUM(TOTAL_SALE) AS TOTAL_REVENUE 
FROM RETAIL_SALES;
```


5. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(AGE)) as AVERAGE_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
```


6. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM RETAIL_SALES
WHERE TOTAL_SALE > '1000'
```


7. **Write a SQL query to find the total number of transactions made by each gender in each category.**:
```sql
SELECT CATEGORY, GENDER, COUNT(TRANSACTIONS_ID) AS TOTAL_ORDERS
FROM RETAIL_SALES
GROUP BY 1, 2
ORDER BY 1
```

8. **Write a query to calculate the total revenue and the number of transactions for each month.**:
```sql
SELECT 
    EXTRACT(YEAR FROM SALE_DATE) AS YEAR, 
    EXTRACT(MONTH FROM SALE_DATE) AS MONTH, 
    SUM(TOTAL_SALE) AS TOTAL_REVENUE, 
    COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS
FROM RETAIL_SALES
GROUP BY 1, 2
ORDER BY 1, 2;
```

9. **Write a query to calculate the average total sales for customers grouped by their age group (e.g., under 25, 25–35, above 35).**:
```sql
SELECT 
    CASE 
        WHEN AGE < 25 THEN 'UNDER 25'
        WHEN AGE BETWEEN 25 AND 35 THEN '25-35'
        ELSE 'ABOVE 35'
    END AS AGE_GROUP, 
    AVG(TOTAL_SALE) AS AVG_TOTAL_SALES
FROM RETAIL_SALES
GROUP BY AGE_GROUP;
```


10. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH TOTAL_SALES_PER_MONTH AS (
    SELECT EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
	EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
	AVG(TOTAL_SALE) AS AVG_SALES,
	ROW_NUMBER () OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC)
	FROM RETAIL_SALES
	GROUP BY 1, 2
	)
	SELECT YEAR, MONTH, AVG_SALES
	FROM TOTAL_SALES_PER_MONTH AS TM
	WHERE ROW_NUMBER <= 1
```


11. **Write a SQL query to find the top 5 customers based on highest total sales**:
```sql
SELECT CUSTOMER_ID, SUM(TOTAL_SALE)
FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```


12. **Write a SQL query to find the number of unique customers who purchased items from each category**:
```sql
SELECT CATEGORY,
       COUNT(DISTINCT CUSTOMER_ID) AS NO_OF_CUSTOMERS
FROM RETAIL_SALES
GROUP BY 1
```


13. **Write a query to calculate the total profit and profit margin for each product category.**:
```sql
SELECT 
    CATEGORY, 
    SUM(TOTAL_SALE - COGS) AS TOTAL_PROFIT, 
    ROUND(CAST(SUM(TOTAL_SALE - COGS) * 100.0 / SUM(TOTAL_SALE) AS NUMERIC), 2) AS PROFIT_MARGIN_PERCENTAGE
FROM RETAIL_SALES
GROUP BY CATEGORY
ORDER BY TOTAL_PROFIT DESC;
```


14. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH SHIFT_TABLE AS(
                     SELECT *,
					 CASE
					 WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
					 WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
					 ELSE 'EVENING'
					 END AS SHIFT
					 FROM RETAIL_SALES
)
SELECT SHIFT, COUNT(SHIFT_TABLE.TRANSACTIONS_ID) AS TOTAL_ORDERS, SUM(SHIFT_TABLE.TOTAL_SALE) AS TOTAL_SALES
FROM SHIFT_TABLE
GROUP BY 1
```


15. **Write a query to determine the top selling product category during each shift (Morning, Afternoon, Evening).**:
```sql
WITH shift_data AS (
    SELECT category, 
    SUM(quantity) AS total_quantity,
      CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
      END AS shift
    FROM retail_sales
    GROUP BY 
        category, 
        shift
),
ranked_data AS (
    SELECT shift, category, total_quantity,
    ROW_NUMBER() OVER(PARTITION BY shift ORDER BY total_quantity DESC) AS row_num
    FROM shift_data
)
SELECT shift, category, total_quantity
FROM ranked_data
WHERE row_num <= 1;
```

## Findings

- **Customer Demographics**: The data captures customers spanning various age ranges, highlighting diverse purchasing behaviors across categories like Clothing and Beauty.
- **Premium Purchases**: A notable number of transactions exceed 1000 in value, reflecting high-end purchases.
- **Seasonal Trends**: Monthly sales analysis reveals fluctuations, pinpointing peak sales periods.
- **Customer Insights**:  Key findings include identifying top spenders and the most favored product categories.

## Reports

- **Sales Overview**: Comprehensive summary of total sales, customer profiles, and category-wise performance.
- **Trend Insights**: Analysis of sales patterns across months and time shifts.
- **Customer Analysis**: Highlights of top-spending customers and unique customer counts by category.

## Conclusion

This project provides a thorough introduction to SQL for data analysts, focusing on database creation, data cleaning, exploratory analysis, and business-oriented SQL queries. The insights gained offer valuable guidance for understanding sales trends, customer behavior, and product performance to inform business decisions.
