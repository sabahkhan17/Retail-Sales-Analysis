CREATE TABLE RETAIL_SALES
          (transactions_id INT8 PRIMARY KEY,
		  sale_date DATE,
		  sale_time TIME,
		  customer_id INT8,
		  gender VARCHAR(15),
		  age INT8,
		  category VARCHAR(15),
		  quantiy INT8,
		  price_per_unit FLOAT,
		  cogs FLOAT,
		  total_sale FLOAT
);

SELECT * FROM RETAIL_SALES
limit 10


SELECT COUNT(*) FROM RETAIL_SALES

SELECT * FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL

SELECT * FROM RETAIL_SALES
WHERE SALE_DATE IS NULL

--data cleaning

SELECT * FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL
OR SALE_DATE IS NULL
OR SALE_TIME IS NULL
OR CUSTOMER_ID IS NULL
OR GENDER IS NULL
OR CATEGORY IS NULL
OR QUANTIY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL

--deleting null rows

DELETE FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL
OR SALE_DATE IS NULL
OR SALE_TIME IS NULL
OR CUSTOMER_ID IS NULL
OR GENDER IS NULL
OR CATEGORY IS NULL
OR QUANTIY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL

--data exploration

---how many sales we have?
SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

---how many unique customers we have?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALES FROM RETAIL_SALES

---how many categories we have?
SELECT COUNT(DISTINCT CATEGORY) AS TOTAL_SALES FROM RETAIL_SALES
--OR
SELECT DISTINCT CATEGORY FROM RETAIL_SALES


--data analysis


---Q1. Write a SQL query to retrieve aLL columns for saLes made on '2022-11-05

SELECT *
FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05'

---Q2. Write a SQL query to retrieve aLL transactions where the category is 'Clothing'
---and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM RETAIL_SALES
WHERE CATEGORY = 'Clothing' AND QUANTIY >=4 AND
TO_CHAR (SALE_DATE, 'YYYY-MM') = '2022-11'

---Q3. Write a SQL query to calculate the total sales and total orders for each category.

SELECT CATEGORY, 
       COUNT(*) AS TOTAL_ORDERS, 
	   SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY 1

---Q4. Write a query to calculate the total revenue from the dataset.

SELECT SUM(TOTAL_SALE) AS TOTAL_REVENUE 
FROM RETAIL_SALES;

---Q5. Write a SQL query to find the average age Of Customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(AGE)) as AVERAGE_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'

---Q6. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM RETAIL_SALES
WHERE TOTAL_SALE > '1000'

---Q7. Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT CATEGORY, GENDER, COUNT(TRANSACTIONS_ID) AS TOTAL_ORDERS
FROM RETAIL_SALES
GROUP BY 1, 2
ORDER BY 1

---Q8. Write a query to calculate the total revenue and the number of transactions for each month.
SELECT 
    EXTRACT(YEAR FROM SALE_DATE) AS YEAR, 
    EXTRACT(MONTH FROM SALE_DATE) AS MONTH, 
    SUM(TOTAL_SALE) AS TOTAL_REVENUE, 
    COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS
FROM RETAIL_SALES
GROUP BY 1, 2
ORDER BY 1, 2;

---Q9. Write a query to calculate the average total sales for customers grouped by their age group (e.g., under 25, 25–35, above 35).
SELECT 
    CASE 
        WHEN AGE < 25 THEN 'UNDER 25'
        WHEN AGE BETWEEN 25 AND 35 THEN '25-35'
        ELSE 'ABOVE 35'
    END AS AGE_GROUP, 
    AVG(TOTAL_SALE) AS AVG_TOTAL_SALES
FROM RETAIL_SALES
GROUP BY AGE_GROUP;

---Q10. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

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

---Q11. Write a SQL query to find the top 5 Customers based on the highest total sales.

SELECT CUSTOMER_ID, SUM(TOTAL_SALE)
FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

---Q12. write a SQL query to find the number of unique customers who purchased items each category.

SELECT CATEGORY, COUNT(DISTINCT CUSTOMER_ID) AS NO_OF_CUSTOMERS
FROM RETAIL_SALES
GROUP BY 1

---Q13. Write a query to calculate the total profit and profit margin for each product category.
SELECT 
    CATEGORY, 
    SUM(TOTAL_SALE - COGS) AS TOTAL_PROFIT, 
    ROUND(CAST(SUM(TOTAL_SALE - COGS) * 100.0 / SUM(TOTAL_SALE) AS NUMERIC), 2) AS PROFIT_MARGIN_PERCENTAGE
FROM RETAIL_SALES
GROUP BY CATEGORY
ORDER BY TOTAL_PROFIT DESC;

---Q14. Write a SQL query to create each shift and number of orders
---(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

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

---Q15.Write a query to determine the top selling product category during each shift (Morning, Afternoon, Evening).
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

---END OF PROJECT
