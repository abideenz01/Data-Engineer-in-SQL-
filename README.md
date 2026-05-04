# Data-Engineer-in-SQL-
Condense and Top-Tier knowledge of SQL from Basics to Advance

<div align="center">

# A complete SQL reference from fundamentals to advanced analytics — covering DDL, DML, Joins, Window Functions, CTEs, Subqueries and more. Written in T-SQL (Microsoft SQL Server).
# 📑 Table of Contents

📌 Overview
🗂️ File Structure
🟢 Basic SQL
🟡 Intermediate SQL
🔴 Advanced SQL


# 📌 Overview
This repository documents a structured learning journey through SQL from absolute basics to advanced analytical queries. All queries are written in T-SQL and tested on Microsoft SQL Server using two databases: MyDatabase and SalesDB.
<img width="332" height="339" alt="details" src="https://github.com/user-attachments/assets/640cbb55-42e7-4e18-b660-18bdba606dc8" />

# 🗂️ File Structure
<img width="294" height="148" alt="struc 1" src="https://github.com/user-attachments/assets/5aad0a13-9c15-41b0-a83a-5a62e22d1db2" />

# 🟢 Basic SQL
Retrieve selected columns
sqlSELECT first_name, country, score
FROM customers
Retrieve all columns
sqlSELECT *
FROM customers
WHERE score > 500
Filter with not equal
sql-- Retrieve customers where score not equal to zero
SELECT *
FROM customers
WHERE score <> 0
Filter by country
sqlSELECT first_name, country
FROM customers
WHERE country = 'Germany'

sql-- Highest score first
SELECT * FROM customers
ORDER BY score DESC

-- Lowest score first
SELECT * FROM customers
ORDER BY score ASC

-- Sort by country then highest score
SELECT * FROM customers
ORDER BY score DESC, country ASC

-- Total score for each country
SELECT country, SUM(score) AS Total_Score, COUNT(id) AS Total_Customers
FROM customers
GROUP BY country

-- Average score per country (excluding 0 scores, avg > 430)
SELECT country, AVG(score) AS Average_score
FROM customers
WHERE score <> 0
GROUP BY country
HAVING AVG(score) > 430
<img width="267" height="194" alt="image" src="https://github.com/user-attachments/assets/78db7b1e-7605-4b7e-af9f-d8d1dd6d626e" />
-- Unique list of countries
SELECT DISTINCT country FROM customers

-- Top 3 customers with highest score
SELECT TOP 3 * FROM customers
ORDER BY score DESC

-- 2 most recent orders
SELECT TOP 2 * FROM orders
ORDER BY order_date DESC

-- Create a new table
CREATE TABLE person (
    id           INT          NOT NULL,
    person_name  VARCHAR(50)  NOT NULL,
    birth_date   VARCHAR(15),
    phone_number VARCHAR(15),
    CONSTRAINT pk_persons PRIMARY KEY (id)
)

-- Add a column
ALTER TABLE person
ADD email VARCHAR(50) NOT NULL

-- Remove a column
ALTER TABLE person
DROP COLUMN phone_number

-- Delete the table
DROP TABLE person

-- Insert multiple rows
INSERT INTO customers (id, first_name, country, score)
VALUES (6, 'Mona', 'NZ', 50),
       (7, 'Suzane', 'AUS', 60)

-- Copy data between tables
INSERT INTO person (id, person_name, birth_date, phone_number)
SELECT id, first_name, NULL, 'Unknown'
FROM customers

-- Update a single record
UPDATE customers
SET score = 0
WHERE id = 6

-- Update multiple columns
UPDATE customers
SET score = 90, country = 'UK'
WHERE id = 8

-- Replace NULL scores with 0
UPDATE customers
SET score = 0
WHERE score IS NULL

-- Delete records
DELETE customers WHERE id > 5

-- Fast delete all data
TRUNCATE TABLE person

# 🟡 Intermediate SQL
-- AND Operator
SELECT * FROM customers
WHERE country = 'USA' AND score > 500

-- OR Operator
SELECT * FROM customers
WHERE country = 'USA' OR score > 500

-- NOT Operator
SELECT * FROM customers
WHERE NOT score < 500

-- BETWEEN
SELECT * FROM customers
WHERE score >= 100 AND score <= 500

-- IN Operator
SELECT * FROM customers
WHERE country IN ('Germany', 'USA')

-- LIKE — Pattern Matching
SELECT * FROM customers WHERE first_name LIKE 'M%'    -- Starts with M
SELECT * FROM customers WHERE first_name LIKE '%n'    -- Ends with n
SELECT * FROM customers WHERE first_name LIKE '%r%'   -- Contains r
SELECT * FROM customers WHERE first_name LIKE '__r%'  -- r in 3rd position

Join Types Visual
INNER JOIN          LEFT JOIN           RIGHT JOIN          FULL JOIN
┌──┬──┐            ┌──┬──┐             ┌──┬──┐             ┌──┬──┐
│  │██│            │██│██│             │  │██│             │██│██│
│  │██│            │██│██│             │  │██│             │██│██│
└──┴──┘            └──┴──┘             └──┴──┘             └──┴──┘
matching only      all left+match      all right+match     all rows

-- INNER JOIN — Only matching rows
SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers AS c
INNER JOIN orders AS o ON c.id = o.customer_id

-- LEFT JOIN — All customers including those without orders
SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id

-- RIGHT JOIN
SELECT id, first_name, order_id, sales
FROM customers AS c
RIGHT JOIN orders AS o ON c.id = o.customer_id

-- FULL JOIN — All rows from both tables
SELECT id, first_name, order_id, sales
FROM customers AS c
FULL JOIN orders AS o ON c.id = o.customer_id

-- LEFT ANTI JOIN — Customers with NO orders
SELECT * FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id
WHERE customer_id IS NULL

-- CROSS JOIN — All combinations
SELECT * FROM customers
CROSS JOIN orders
# Multi-Table Join (Real World Example)
SELECT
    o.OrderID,
    c.FirstName  AS CustomerFirstName,
    c.LastName   AS CustomerLastName,
    p.Product    AS ProductName,
    o.Sales,
    p.Price,
    e.FirstName  AS SalesPersonFirstName
FROM sales.orders AS o
LEFT JOIN sales.customers AS c  ON o.CustomerID    = c.CustomerID
LEFT JOIN sales.products  AS p  ON o.ProductID     = p.ProductID
LEFT JOIN sales.Employees AS e  ON o.SalesPersonID = e.EmployeeID

-- UNION — distinct rows from both queries
SELECT FirstName, LastName FROM Sales.Customers
UNION
SELECT FirstName, LastName FROM Sales.Employees

-- UNION ALL — all rows including duplicates
SELECT FirstName, LastName FROM Sales.Customers
UNION ALL
SELECT FirstName, LastName FROM Sales.Employees

-- EXCEPT — rows in first not in second
SELECT FirstName, LastName FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName FROM Sales.Customers

-- INTERSECT — rows common to both
SELECT FirstName, LastName FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName FROM Sales.Customers

-- Industry Pattern: Combine tables with source tracking
SELECT 'Orders' AS SourceTable, OrderID, Sales FROM Sales.Orders
UNION
SELECT 'OrdersArchive' AS SourceTable, OrderID, Sales FROM Sales.OrdersArchive
ORDER BY OrderID

-- CONCAT
SELECT FirstName, Country,
       CONCAT(FirstName, ' ', Country) AS name_country
FROM Sales.Customers

-- UPPER / LOWER
SELECT FirstName, UPPER(FirstName) AS upper_case FROM Sales.Customers

-- LEN
SELECT first_name, LEN(first_name) AS len FROM customers

-- TRIM — Detect whitespace issues
SELECT first_name,
       LEN(first_name) - LEN(TRIM(first_name)) AS extra_spaces
FROM customers
WHERE first_name != TRIM(first_name)

-- REPLACE
SELECT REPLACE('123-456-789', '-', '')     AS clean_phone
SELECT REPLACE('file.txt', '.txt', '.csv') AS new_file_name

-- LEFT / RIGHT
SELECT first_name, LEFT(first_name, 2)  AS first_two FROM customers
SELECT first_name, RIGHT(first_name, 2) AS last_two  FROM customers

-- SUBSTRING(value, start, length)
SELECT first_name, SUBSTRING(first_name, 3, 2) AS chars_3_4 FROM customers

-- Basic Date Parts
SELECT OrderID, CreationTime,
       YEAR(CreationTime)  AS YEAR,
       MONTH(CreationTime) AS MONTH,
       DAY(CreationTime)   AS DAY
FROM Sales.Orders

-- DATEPART — Granular extraction
SELECT OrderID,
       DATEPART(QUARTER, CreationTime) AS Quarter,
       DATEPART(WEEK,    CreationTime) AS Week,
       DATEPART(HOUR,    CreationTime) AS Hour
FROM Sales.Orders

-- DATENAME — Named values
SELECT OrderID,
       DATENAME(MONTH,   CreationTime) AS MonthName,
       DATENAME(WEEKDAY, CreationTime) AS DayName
FROM Sales.Orders

-- DATETRUNC — Truncate to period
SELECT DATETRUNC(YEAR, CreationTime)  AS trunc_year,
       DATETRUNC(MONTH, CreationTime) AS trunc_month
FROM Sales.Orders

-- EOMONTH — End of month
SELECT OrderID,
       EOMONTH(CreationTime)                          AS end_of_month,
       CAST(DATETRUNC(MONTH, CreationTime) AS DATE)   AS start_of_month
FROM Sales.Orders

-- Orders per year using DATETRUNC
SELECT DATETRUNC(YEAR, CreationTime) AS create_time, COUNT(*) AS orders
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR, CreationTime)

# Ranking Functions
-- ROW_NUMBER() — Unique sequential number
SELECT OrderID, ProductID, Sales,
       ROW_NUMBER() OVER(ORDER BY Sales DESC) AS row_num
FROM Sales.Orders

-- RANK() — Handles ties with gaps
SELECT OrderID, Sales,
       RANK() OVER(ORDER BY Sales DESC) AS sales_rank
FROM Sales.Orders

-- DENSE_RANK() — Handles ties without gaps
SELECT OrderID, Sales,
       DENSE_RANK() OVER(ORDER BY Sales DESC) AS sales_dense_rank
FROM Sales.Orders
# Use Cases
-- TOP N per group — Top sale per product
SELECT * FROM (
    SELECT OrderID, ProductID, Sales,
           ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS top_sales
    FROM Sales.Orders
) t WHERE top_sales = 1

-- Remove duplicates — Data cleansing
SELECT * FROM (
    SELECT ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS row_num, *
    FROM Sales.OrdersArchive
) t WHERE row_num = 1

-- NTILE — Segment into buckets (High/Medium/Low)
SELECT *,
       CASE WHEN buckets = 1 THEN 'High'
            WHEN buckets = 2 THEN 'Medium'
            ELSE 'Low' END AS segment
FROM (
    SELECT OrderID, Sales,
           NTILE(3) OVER(ORDER BY Sales DESC) AS buckets
    FROM Sales.Orders
) t

# LAG & LEAD — Time Analysis
-- Month-over-Month (MOM) Sales Change
SELECT *,
       current_month_sales - previous_month_sales AS MOM,
       ROUND(CAST((current_month_sales - previous_month_sales) AS FLOAT)
             / previous_month_sales * 100, 1)     AS MOM_percentage
FROM (
    SELECT MONTH(OrderDate) AS order_month,
           SUM(Sales)       AS current_month_sales,
           LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS previous_month_sales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
) t

-- Customer Retention — Average days between orders
SELECT CustomerID,
       AVG(no_of_days) AS avg_days,
       RANK() OVER(ORDER BY COALESCE(AVG(no_of_days), 1000)) AS loyalty_rank
FROM (
    SELECT CustomerID,
           DATEDIFF(day, OrderDate,
               LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS no_of_days
    FROM Sales.Orders
) t
GROUP BY CustomerID

# CUME_DIST & PERCENT_RANK

-- Top 40% of products by price
SELECT *, CONCAT(price_distribution * 100, '%') AS percentage
FROM (
    SELECT *, CUME_DIST() OVER(ORDER BY Price DESC) AS price_distribution
    FROM Sales.Products
) t
WHERE price_distribution <= 0.4

# 🔴 Advanced SQL
<img width="313" height="261" alt="image" src="https://github.com/user-attachments/assets/e0c8c22f-d448-49e6-80a7-cb078d4e2c33" />
-- FROM Subquery — Products above average price
SELECT * FROM (
    SELECT ProductID, Price,
           AVG(Price) OVER() AS avg_price
    FROM Sales.Products
) t WHERE Price > avg_price

-- WHERE Subquery — Comparison operator
SELECT ProductID, Price FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

-- WHERE Subquery — IN operator
SELECT * FROM Sales.Orders
WHERE CustomerID IN (
    SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany'
)

-- JOIN Subquery
SELECT c.*, o.total_orders
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT CustomerID, COUNT(*) AS total_orders
    FROM Sales.Orders
    GROUP BY CustomerID
) AS o ON c.CustomerID = o.CustomerID

-- Correlated Subquery — References outer query
SELECT *,
    (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS total_orders
FROM Sales.Customers c

-- EXISTS — Check if rows exist
SELECT * FROM Sales.Orders o
WHERE EXISTS (
    SELECT 1 FROM Sales.Customers c
    WHERE c.Country = 'Germany' AND c.CustomerID = o.CustomerID
)

-- ANY / ALL Operators
-- Female employees earning more than ANY male
SELECT * FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (
    SELECT Salary FROM Sales.Employees WHERE Gender = 'M'
)

-- Female employees earning more than ALL males
SELECT * FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ALL (
    SELECT Salary FROM Sales.Employees WHERE Gender = 'M'
)

-- Basic CTE
WITH SalesSummary AS (
    SELECT CustomerID, SUM(Sales) AS total_sales
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT c.FirstName, s.total_sales
FROM Sales.Customers c
LEFT JOIN SalesSummary s ON c.CustomerID = s.CustomerID

-- Multiple CTEs
WITH
MonthlySales AS (
    SELECT MONTH(OrderDate) AS month, SUM(Sales) AS sales
    FROM Sales.Orders GROUP BY MONTH(OrderDate)
),
RankedMonths AS (
    SELECT *, RANK() OVER(ORDER BY sales DESC) AS rank
    FROM MonthlySales
)
SELECT * FROM RankedMonths WHERE rank <= 3

-- Create a View
CREATE VIEW vw_CustomerOrders AS
SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) AS total_orders
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName

-- Query a View
SELECT * FROM vw_CustomerOrders

-- Drop a View
DROP VIEW vw_CustomerOrders

-- Create Stored Procedure
CREATE PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT o.OrderID, o.Sales, o.OrderDate
    FROM Sales.Orders o
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC
END

-- Execute Stored Procedure
EXEC sp_GetCustomerOrders @CustomerID = 1

-- Drop Stored Procedure
DROP PROCEDURE sp_GetCustomerOrders

-- View all column metadata
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- View all tables in database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- View columns of a specific table
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders'




🌟 About Me: 👋 Hi, I'm Zain UL Abideen | Data Engineer

I am passionate about Building scalable data pipelines that turn raw data into actionable insights

🎓 Computer Engineering Graduate | 💡 Data Engineering Enthusiast | ☁️ Cloud-Native Advocate

About Me: I'm a data engineer who loves transforming messy data into clean, reliable pipelines. My passion lies in architecting robust data solutions that scale—whether it's processing terabytes in Spark or optimizing complex SQL queries that make databases sing.

🔧 Tech Stack:

• Python • SQL • Big Data: Apache Spark • Databricks • Cloud: Microsoft Azure

Specialties: • ETL/ELT Pipelines • Data Warehousing • Data Design Architecture • System Design • Performance Optimization

🚀 What I'm About:

📊 Building end-to-end data solutions from ingestion to visualization ⚡ Optimizing Spark jobs to squeeze out every bit of performance 🏗️ Designing cloud-native architectures on Azure 🧩 Turning complex data problems into elegant engineering solutions

📫 Let's Connect! I'm always excited to collaborate on data engineering projects or discuss the latest in distributed computing.

Email: abideenz095@gmail.com




