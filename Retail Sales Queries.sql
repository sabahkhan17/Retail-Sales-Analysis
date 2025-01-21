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

--DATA CLEANING

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

-- DELETING NULL ROWS
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

--DATA EXPLORATION

---how many sales we have?
SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

---how many unique customers we have?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALES FROM RETAIL_SALES

---how many categories we have?
SELECT COUNT(DISTINCT CATEGORY) AS TOTAL_SALES FROM RETAIL_SALES
--OR
SELECT DISTINCT CATEGORY FROM RETAIL_SALES


--DATA ANALYSIS


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

SELECT CATEGORY, COUNT(*) AS TOTAL_ORDERS, SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY 1

---Q4. Write a SQL query to find the average age Of Customers who purchased items from the 'Beauty' category .
SELECT ROUND(AVG(AGE)) as average_age
FROM RETAIL_SALES
WHERE category = 'Beauty'

---Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM RETAIL_SALES
WHERE TOTAL_SALE > '1000'

---Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT CATEGORY, GENDER, COUNT(TRANSACTIONS_ID) AS TOTAL_ORDERS
FROM RETAIL_SALES
GROUP BY 1, 2
ORDER BY 1

---Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

---Q8. Write a SQL query to fInd the top 5 Customers based on the highest total sales.
SELECT CUSTOMER_ID, SUM(TOTAL_SALE)
FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

---Q9. write a SQL query to find the number of unique customers who purchased items each category .
SELECT CATEGORY, COUNT(DISTINCT CUSTOMER_ID) AS NO_OF_CUSTOMERS
FROM RETAIL_SALES
GROUP BY 1

---Q10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

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


---END OF PROJECT



