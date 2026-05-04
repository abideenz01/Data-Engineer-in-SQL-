USE MyDatabase
--INTERMEDIATE DIFFICULTY
-- WHERE OPERATORS 
-- Retrieve customers from USA 
SELECT *
FROM customers 
WHERE country= 'USA'
--Retrieve all customers who are not from Germany 
SELECT *
FROM customers 
WHERE country<> 'Germany'
-- Retrieve all customers with score greater than 500
SELECT *
FROM customers 
WHERE score> 500
--Retrieve all customers with score equal to greater than 500
SELECT *
FROM customers 
WHERE score>= 500
-- AND OPERATOR 
-- Retrieve all customers from USA and score having greater thab 500
SELECT *
FROM customers 
WHERE country= 'USA' AND score>500
--Retrieve all customers from USA OR score having greater thab 500
SELECT *
FROM customers 
WHERE country= 'USA' OR score>500
--Retrieve all customers with a score NOT less than 500
SELECT *
FROM customers 
WHERE NOT score <500
--Retrieve customers with score fall between 100 and 500
SELECT *
FROM customers 
WHERE score>=100 AND score<=500
--Retrieve all customers either from Germany or USA 
SELECT * 
FROM customers 
WHERE country IN ('Germany','USA')
--Find all customers whose first name starts with M
SELECT *
FROM customers 
WHERE first_name LIKE 'M%'
--Find all customers whose first name ends with n
SELECT *
FROM customers 
WHERE first_name LIKE '%n'
--Find all customers whose first name contains an r 
SELECT *
FROM customers 
WHERE first_name LIKE '%r%'
--Find all customers whose first name has r in the third posiion
SELECT *
FROM customers 
WHERE first_name LIKE '__r%'
--JOINING DATA
--JOINS IN SQL 
--NO JOIN
--Retrieve all data from customers and orders in two seperate results 
SELECT * 
FROM customers;
SELECT *
FROM orders;
--INNER JOIN-- Return only matching DATA from both tables
SELECT 
c.id,-- it is recommended to mention table name when two columns have same name
c.first_name,
o.order_id,
o.sales
FROM customers AS c --using alias for convenience of naming
INNER JOIN orders AS o
ON c.id=o.customer_id
--****LEFT JOIN****(THE MOST IMP JOIN)
--Return all rows from the Left and only matching from Right
--Retrieve all customers(Main tabel) with the orders including those without orders
SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id=o.customer_id
-- Righ Join
-- Return all rows from the right and only matching from left 
SELECT
id,
first_name,
order_id,
sales
FROM  customers AS c
RIGHT JOIN orders AS o
ON c.id=o.customer_id
--FULL JOIN
SELECT
id,
first_name,
order_id,
sales
FROM  customers AS c
FULL JOIN orders AS o
ON c.id=o.customer_id --order does not matter 
-- Return all rows from both table 

--Executing same task using LEFT JOIN 
--Returns all rows from right and only matching ones from left 

SELECT
id,
first_name,
order_id,
sales
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id=c.id
--Advanced JOINS 
--LEFT ANTI JOIN
-- Get all customers who have not placed any order
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id= o.customer_id
WHERE customer_id IS NULL 
--RIGHT ANTI JOIN
-- Get all orders wihout matching orders
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id= o.customer_id
WHERE c.id IS NULL 
--Same task using left join
-- Get all orders wihout matching customers
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON c.id= o.customer_id
WHERE c.id IS NULL
--FULL ANTI JOIN
--Return rows that don't match either tables 
SELECT *
FROM orders AS o
FULL JOIN customers AS c
ON c.id= o.customer_id
WHERE c.id IS NULL OR o.customer_id  IS NULL
--Get all customers with their orders but only for customers who have placed an order
--WITHOUT INNER JOIN
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id= o.customer_id 
WHERE o.customer_id IS NOT  NULL 
--CROSS JOIN
--Generate all combinations of customers and orders
SELECT * 
FROM customers
CROSS JOIN orders

/*USING salesDB, Retrieve a list of all orders,
along with the related customer,
product, and employee details
For each order display:
order ID
customer's name 
product name 
sales 
price 
salesperson's name*/
USE SalesDB
SELECT 
o.OrderID,
c.FirstName AS CustomerFirstName,
c.LastName AS CustomerSecondName,
p.Product AS ProductName,
o.Sales,
p.Price,
e.FirstName AS SalesPersonFirstName,
e.LastName  AS SalesPersonSecondName

FROM sales.orders AS o --it has schema of sales 
LEFT JOIN sales.customers AS c
ON o.CustomerID=  c.CustomerID 
LEFT JOIN sales.products AS p
ON o.ProductID=  p.ProductID 
LEFT JOIN sales.Employees AS e
ON o.SalesPersonID= e.EmployeeID

--SET OPERATORS
--UNION-- returns distinct rows from both queries and remove duplicate ones 
--Combine the data from employees and customers into one table 
SELECT
FirstName,
LastName

FROM Sales.Customers

UNION

SELECT 

FirstName,
LastName
FROM Sales.Employees 
--UNION ALL-- Returns all rows from both queries with duplicates 
--Combine all data in customers and employees including duplicates
SELECT
FirstName,
LastName
FROM Sales.Customers

UNION ALL

SELECT 
FirstName,
LastName
FROM Sales.Employees 
--EXCEPT-- 
--Returns all distinct rows from the first query that are not found in the secong query
--Find employees who are not customers at the same time 
SELECT
FirstName,
LastName
FROM Sales.Employees

EXCEPT

SELECT 
FirstName,
LastName
FROM Sales.Customers 
--INTERSECT--
-- Returns rows that are common in both queries 
SELECT
FirstName,
LastName
FROM Sales.Employees

INTERSECT

SELECT 
FirstName,
LastName
FROM Sales.Customers 
--Combine all orders data into one report without duplicates 
SELECT 
       'Orders' AS SourceTable,-- Industry Practice 
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
       'OrdersArchive' AS SourceTable, --Industry Practice
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER By OrderID -- Sorting by OrderID
--SQL FUNCTIONS--
--STRING FUNCTIONS--
/*Show a list of customers first
names together with their 
country in one column*/

SELECT 
FirstName,
Country,
CONCAT(FirstName, ' ' ,Country) AS name_country
FROM Sales.Customers
--LOWER()--
--Convert customer first name to lower case 
--Convert customer first name to upper case 

SELECT 
FirstName,
UPPER(FirstName) AS upper_case
FROM Sales.Customers
--LENGTH-
USE MyDatabase
SELECT 
first_name,
LEN(first_name) AS len
FROM customers
--TRIM--
SELECT 
first_name,
LEN(first_name) AS len,
LEN(TRIM(first_name)) AS len_trim_name,
LEN(first_name) - LEN(TRIM(first_name)) Flag 
FROM customers
WHERE first_name!= TRIM(first_name) 
--REPLACE--
--Remove dashes from a phone number--
SELECT 
'123-456-789' AS old_phone,
REPLACE('123-456-789', '-','') AS clean_phone
--Replace file extension name--
SELECT
'file.txt' AS old_file_name,
REPLACE('file.txt','.txt','.csv') AS new_file_name
--LEFT AND RIGHT--
--Retrieve first two characters of each first name--
SELECT 
first_name,
LEFT(first_name,2) AS first_two_characters
FROM customers 
--LEFT AND RIGHT--
--Retrieve last two characters of each first name--
SELECT 
first_name,
RIGHT(first_name,2) AS last_two_characters
FROM customers 
--SUBSTRING--
--Extracts a part of string at a specified position--
--SUBSTRING(value,start,length)
SELECT 
first_name,
SUBSTRING(first_name,3,2) AS third_character
FROM customers 
--Retrieve customer first name after removing first character
SELECT 
first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS third_character
FROM customers 
--NUMBER FUNCTIONS-
--***DATE AND TIME FUNCTIONS***--
USE SalesDB
SELECT
OrderID,
CreationTime,
YEAR(CreationTime) AS YEAR,
MONTH(CreationTime) AS MONTH,
DAY(CreationTime) AS DAY
FROM Sales.Orders
--DATE PART-
--SYNTAX: DATEPART(part,date)
SELECT
OrderID,
CreationTime,
DATEPART(YEAR,CreationTime) AS YEAR_dp,
DATEPART(QUARTER,CreationTime) AS Quater_dp,
DATEPART(MONTH,CreationTime) AS MONTH_dp,
DATEPART(WEEK,CreationTime) AS WEEk_dp,
DATEPART(DAY,CreationTime) AS DAY_dp,
DATEPART(HOUR,CreationTime) AS HOUR_dp,
DATEPART(MINUTE,CreationTime) AS MINT_dp,
DATEPART(SECOND,CreationTime) AS SECOND_dp,
YEAR(CreationTime) AS YEAR,
MONTH(CreationTime) AS MONTH,
DAY(CreationTime) AS DAY
FROM Sales.Orders
--DATE NAME--
--SYNTAX: DATENAME(part,name)--
SELECT 
OrderID,
CreationTime,
DATENAME(MONTH,CreationTime) AS MONTH,
DATENAME(WEEKDAY,CreationTime) AS DAY
FROM Sales.Orders
--DATETRUNC--
SELECT 
OrderID,
CreationTime,
DATETRUNC(YEAR,CreationTime) AS trunc_year,
DATETRUNC(MONTH,CreationTime) AS trunc_month,
DATETRUNC(DAY,CreationTime) AS trunc_day
FROM Sales.Orders
--USE CASE OF DATETRUNC IN REPORTING--
SELECT 
DATETRUNC(YEAR,CreationTime) AS create_time,
COUNT(*)
FROM Sales.Orders
Group BY DATETRUNC(YEAR,creationTime) 
--END OF MONTH--
SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) AS end_of_month,
CAST(DATETRUNC(MONTH,CreationTime)AS DATE) AS start_of_month
FROM Sales.Orders
--How many orders were placed each year?--
SELECT
DATENAME(MONTH,OrderDate) AS order_month,
COUNT(*) no_of_orders
FROM Sales.Orders
Group By DATENAME(MONTH,OrderDate)
/*Show all orders that were placed during the
month of february*/
SELECT
DATENAME(MONTH,OrderDate) AS order_month,
COUNT(*) no_of_orders
FROM Sales.Orders
WHERE DATENAME(MONTH,OrderDate)= 'February'
Group By DATENAME(MONTH,OrderDate)
--OR--BEST PRACTICE--
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate)= 02
--FORMAT-- 
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime,'dd/MM/yyyy') as Standard_time
FROM Sales.Orders
--Specific Format-- Recreate Day Wed Jan Q1 2025 12:34:56 pm
SELECT
OrderID,
CreationTime,
'day' + FORMAT(CreationTime, ' ddd MMM')
+ ' Q' + DATENAME(QUARTER, CreationTime) + FORMAT(CreationTime,' yyyy hh MM ss tt') AS custom_format
FROM Sales.Orders
--CAST--
USE SalesDB
SELECT
CreationTime,
CAST(CreationTime AS DATE ) AS  date_time
FROM Sales.Orders
--DATEADD--
--SYNTAX: DATEADD(part,interval,date)
SELECT
OrderID,
OrderDate,
DATEADD(MONTH,2,OrderDate) AS later_date
FROM Sales.Orders
--------
SELECT
OrderID,
OrderDate,
DATEADD(DAY,-4,OrderDate) AS previous_date
FROM Sales.Orders
--***DATEDIFF***--
--SYNTAX: DATEDIFF(part,start_date,end_date) 
SELECT
OrderID,
OrderDate,
ShipDate,
(DATEDIFF(DAY,OrderDate,ShipDate)) AS day_difference,
DATEDIFF(MONTH,OrderDate,ShipDate) AS month_difference,
DATEDIFF(YEAR,OrderDate,ShipDate) AS year_difference
FROM Sales.Orders

--Find the average shipping duration in days for each month--
SELECT 
MONTH(OrderDate) AS order_date,
AVG(DATEDIFF(day, OrderDate, ShipDate))  avg_Ship_duration_in_days
FROM Sales.Orders
Group By MONTH(OrderDate)
--Find number of days b/w each order and previous order--
--****TIME GAP ANALYSIS****--
USE SalesDB
SELECT 
OrderID,
OrderDate,
LAG(OrderDate) OVER (Order By OrderDate) AS previousdate,
DATEDIFF(day,LAG(OrderDate) OVER (Order By OrderDate),OrderDate) AS noofdays
FROM Sales.Orders
--DATE VALIDATION--
--ISDATE--CHECK IF A VALUE IS A DATE--
--SYNTAX-- ISDATE(VALUE)
--NULL FUNCTIONS--
--ISNULL()--
--ISNULL() replaces NULL with a specific value--
--SYNTAX: ISNULL(value, replacement_value)
--COALESCE-- Returns the first non null value from the list--
--SYNTAX:COALESCE(value1,value2, value3)
--Find the average scores of the customers--
SELECT
CustomerID,
Score,
AVG(COALESCE(Score,0)) OVER() As avg_score
FROM Sales.Customers
--Display full names of customers in a single
--field by merging their first and last names 
--and add 10 bonus points to each customers score.
USE SalesDB
SELECT 
CustomerID,
FirstName,
LastName,
Score,
COALESCE(Score,0)+10 AS updated_score,
FirstName + ' ' + COALESCE(LastName, '') As full_name
FROM Sales.Customers
--IMPORTANT QUERY--
--ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END--
--NULLIF()--
--It compares two expression returns:
--1.NULL, if they are equal
--2.First value if they are not equal.
--NULLIF() SYNTAX: NULLIF(value_1,value2)
USE SalesDB
--Find price for each order.
SELECT
OrderID,
Quantity,
Sales,
Sales/NULLIF(Quantity,0) AS price
FROM Sales.Orders
--IS NULL-- Returns TRUE IF value is NULL otherwise
--False--
--IS NOT NULL--Returns TRUE if value is not NULL otherwise false--
--SYNTAX: value ISNULL
--SYNTAX: value ISNOT NULL--
--Identify the customers who have no score--
SELECT *
FROM Sales.Customers
WHERE Score IS NULL
--Identify the customers who have scores--
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL
--LEFT ANTI JOIN (LEFT JOIN + ISNULL):
-- All rows from left without matching rows--
--RIGHT ANTI JOIN (RIGHT JOIN + ISNULL):
--All rows from right without matching rows--
--List all details from customers who have not
--placed any order--
SELECT 
c.*,
o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID= o.CustomerID
WHERE o.OrderID IS NULL
--CASE STATEMENT--
--SYNTAX: CASE WHEN Condition1 THEN result1 ELSE END--
--IN CASE: SQL execution stops once first condition is met--
--***RULE: data type of results must be matching***--
--MAIN PURPOSE OF CASE STATEMENT IS TO PERFORM DATA
--TRANSFORMATION--
--USE CASE:01--
--Categorizing Data--
--Generate a report showing the total sales for each
--category--
--1.High: if the sales are higher than 50--
--2.Medium: if the sales are b/w 20 and 50--
--3.Low: if the sales equal or lower than 20
--Sort the categories from sales highest to lowest--
SELECT 
Category,
SUM(Sales) AS totalSales
FROM(
    SELECT
    OrderID,
    Sales,
    CASE 
        WHEN Sales > 50 THEN 'HIGH'
        WHEN Sales > 20 THEN 'MEDIUM'
        WHEN Sales <= 20 THEN 'LOW'

    END Category 

    FROM Sales.Orders
)t
GROUP BY Category 
ORDER BY SUM(Sales) DESC
--USE CASE: 02--
--Transform the values from one form to another--
--Retrieve Employee details with gender displayed as full text--
SELECT 
GenderFullText

FROM (SELECT 
    EmployeeID,
    Gender,
    CASE 
        WHEN Gender='M' THEN 'MALE'
        WHEN Gender='F' THEN 'FEMALE'
    END GenderFullText

FROM Sales.Employees)t
GROUP BY GenderFullText
ORDER BY GenderFullText DESC
--V.IMP CASE NO:03--Handling NULLS--
/*CASE NO:04--Conditional Aggregation--Apply aggregate functions only
on subsets of data that fulfills certain condition*/
/*Count how many times each customer has made an order with sales
greater than 30*/
--******V.IMP******--
SELECT 
    CustomerID,
        SUM(CASE
             WHEN Sales> 30 THEN 1
             ELSE 0
             END) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID
--Aggregate Functions--Accept multiple in return of one value--
SELECT
COUNT(Sales) totalrows,
MAX(Sales) maxsale,
AVG(Sales) avgsale,
MIN(Sales) minsale,
SUM(Sales) sumsale
FROM Sales.Orders


--WINDOW FUNCTIONS--Aggregation + having more details--
--1. OVER()--
SELECT
OrderID,
ProductID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER() totalsales,
SUM(Sales) OVER(PARTITION BY ProductID) AS total_sales_by_product,
SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) AS sales_by_product_and_order
FROM Sales.Orders
--2. ORDER BY()-- SORT THE DATA WITHIN WINDOW IN ASC OR DESC--
--Rank each order based on their sales from highest to lowest--
SELECT 
Orderdate,
ProductID,
Sales,
RANK() OVER(ORDER BY Sales DESC ) sales_by_order
FROM Sales.Orders
--Window Frame--
--***SYNTAX: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING***--
/*Defines Subset of rows within each window that is relevant
for the calculation*/
--***RULES FOR: WINDOW FUNCTION + GROUP BY***--
--Column use in window function must be part of GROUP BY--
--Rank Customers based on their total sales--
--IN following example same column i.e SUM(Sales) is used in both rank() and Group by--
--STEPS: 1. GROUP BY 2. WINDOW FUNCTIONS--
SELECT
CustomerID,
SUM(Sales) total_sales,
RANK() OVER(ORDER BY SUM(Sales) DESC ) customer_rank
FROM Sales.Orders
GROUP BY CustomerID
--TYPES OF WINDOW FUNCTIONS--
--1.WINDOW AGGREGATE FUNCTIONS--
--2.WINDOW RANKING FUNCTIONS--
--3.WINDOW VALUE FUNCTIONS--

--1. WINDOW AGGREGATE FUNCTION--
     --COUNT--
--Returns number of rows within a window--
--Find the number of orders--
SELECT 
ProductID,
OrderID,
Quantity, 
Count(Sales) OVER() total_sales
FROM Sales.Orders
--Find total number of orders for each customer--
SELECT 
OrderID,
CustomerID,
OrderDate,
COUNT(Sales) OVER(PARTITION BY CustomerID) total_sales
FROM Sales.Orders
--Find the total number of customers and provide all customer details--
--Find total number of scores for customers--
SELECT 
*,
count(*) OVER() total_customers, 
COUNT(Score) OVER () total_score,
COUNT(Country) OVER () total_countries
FROM sales.Customers
--Data quality issues-
--Having duplicates in data--
--COUNT() can be use to identify duplicates and NULLS--
--Check whether table orders contain any duplcate rows--

SELECT 
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) check_primary_key
FROM Sales.Orders
---------------------------
SELECT 
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) check_primary_key
FROM Sales.OrdersArchive
--SubQuery to check duplicates--
SELECT
*
FROM 
    (SELECT
        OrderID,
        COUNT(*) OVER(PARTITION BY OrderID) check_primary_key
    FROM Sales.OrdersArchive)t
    WHERE check_primary_key >1
            --SUM()--
/*Find the total sales across all orders--
And the total sales fr each product
Additionally provide such orderid, order date*/
SELECT 
OrderID,
ProductID,
OrderDate,
Sales,
SUM(Sales)  OVER() total_sales,
SUM(Sales) OVER(PARTITION BY ProductID) total_sales_by_product
FROM Sales.Orders
--Comparison Analysis--Part to whole Analysis--
/* Find the percentage contribution of each product
sales to the total sales*/
SELECT 
ProductID,
OrderID,
Sales,
SUM(Sales) OVER() total_sales,
ROUND(CAST(Sales AS Float)/SUM(Sales) OVER() * 100,2) percentage_contribution
FROM Sales.Orders
-------------------------------------
SELECT
ProductID,
Orderdate,
MIN(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) min_sales_by_product,
MAX(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) max_sales_by_product,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) avg_sales_by_product,
SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) total_sales_by_product
FROM Sales.Orders
     --USE CASE--
--Tracking current sales with target sales--
--Running and Rolling total--
/*1. Running total aggregates all values from the beginning up 
 to the current point without dropping a
 older details*/
 /*2. Rolling total aggregates values within a fixed time period e.g
 30 days. As new data arrives, old data is dropped off*/
 /*Calculate the moving average of sales for each product
 over time*/
 USE SalesDB
 SELECT 
 OrderID,
 ProductID,
 OrderDate,
 Sales,
 AVG(Sales) OVER(PARTITION BY ProductID) avg_by_product,
 AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) moving_avg
 FROM Sales.Orders
 /*Calculate the moving average of sales for each product
 over time, including only the next order*/
 SELECT 
 OrderID,
 ProductID,
 OrderDate,
 Sales,
 AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) moving_avg,
 AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) rolling_avg
 FROM Sales.Orders
 --2. Window Ranking Functions--
   /*1. MOST IMP--ROW_NUMBER()*** Assign a unique number to each row
      doesn't handles ties, leaves no gaps*/
 --Rank orders based on sales from highest to lowest--
 SELECT 
     OrderID,
     ProductID,
     Sales,
 ROW_NUMBER() OVER(ORDER BY Sales DESC) sales_rank_row 
 FROM Sales.Orders
 --2. RANK() Assigns a rank to each row, handle ties, leaves gaps
 --Rank orders based on sales from highest to lowest--
 SELECT 
     OrderID,
     ProductID,
     Sales,
 RANK() OVER(ORDER BY Sales DESC) sales_rank_rank
 FROM Sales.Orders
 /*--3. DENSE_RANK Assign rank to each row, handle ties, 
 doesn't leaves gaps in ranking*/
 --Rank orders based on sales from highest to lowest--
 SELECT 
     OrderID,
     ProductID,
     Sales,
 DENSE_RANK() OVER(ORDER BY Sales DESC) sales_rank_dense 
 FROM Sales.Orders
 --USE CASES OF ROW_NUMBER() 1.TOP N ANALYSIS
 --Find the top highest sales for each product--
 SELECT
 *
 FROM 
 (SELECT 
     OrderID,
     ProductID,
     Sales,
 ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) top_sales
 FROM Sales.Orders)t
 WHERE top_sales=1
 --Find the lowest two customers based on their total sales
 --2.BOTTOM N ANALYSIS
 SELECT *
 FROM
 (SELECT
     CustomerID,
     SUM(Sales) total_sales, 
     ROW_NUMBER() OVER(ORDER BY SUM(Sales)) customers_rank
 FROM Sales.Orders
 GROUP BY CustomerID)t
 WHERE customers_rank<=2
 --ROW_NUMBER() USE CASE 3.Generate Unique IDs
 --Assign Unique IDs to the rows of the table OrdersArchive
 
 SELECT
 ROW_NUMBER() OVER(ORDER BY OrderID) unique_IDs,
 OrderID,
 ProductID,
 Sales
 FROM Sales.OrdersArchive
 --***V.IMP ROW_NUMBER() USE CASE 4.Removing duplocates/ Data Cleansing
 /*Identify duplicate rows in the table 'Orders Archive' and 
 return clean results without duplicates*/
 SELECT 
 *
 FROM
 (SELECT 
 ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) row_number,
 *
 FROM Sales.OrdersArchive)t
 --V.IMP If unique row number exceeds 1 it means primary key is not unique
 --CLEAN DATA
 WHERE row_number=1
 --OR BAD DATA
 --WHERE row_number>1

 /*---NTILE(n)----: divide the rows into a specific number of approx
 equal buckets*/
 --SYNTAX: NTILE(no of buckets) OVER(ORDER BY Sales)
 --Bucket Size= Number of rows/Number of Buckets
 --SQL RULE: Larger group comes first
 
 --USE CASE:Segment all orders into 3 categories: high,medium,low
 SELECT
 *,
 CASE WHEN buckets=1 THEN 'High'
      WHEN buckets=2 THEN 'Medium'
      ELSE 'LOW'
 END Sales
 FROM
 (SELECT 
 OrderID,
 Sales,
 NTILE(3) OVER(ORDER BY Sales DESC) buckets
 FROM Sales.Orders)t
 --USE CASE: Load balancing in ETL
 --In order to export the data divide data in 2 groups
 SELECT
 *,
 NTILE(2) OVER(ORDER BY OrderID) Grouping
 FROM Sales.Orders
 /*    --CUME_DIST()-- stands for cumulative distribution. It calculates the 
 distribution of data points within a window*/
 --FORMULA: CUME_DIST()= position number of value/Number of rows meaning % of each row
 /* ***MOST CONFUSING:***Tie Rule: in case of tie: The position of value of the last occurance
 of same value*/
 /*    --PERCENT_RANK()-- Calculates the relative position of each row
  FORMULA: PERCENT_RANK()= position number of value-1/Number of rows-1
  /* ***MOST CONFUSING/Difference:***Tie Rule: in case of tie: The position of value of the first occurance
 of same value*/
 Find the products that fall within the highest 40% of prices*/
 SELECT
 *,
 CONCAT(price_distribution * 100, '%' ) percenatge
 FROM
 (SELECT *,
 CUME_DIST() OVER(ORDER BY Price DESC) price_distribution
 FROM Sales.Products)t
 WHERE price_distribution<=0.4
 -------------------------------
 SELECT
 *,
 CONCAT(rank * 100, '%' ) percenatge_rank
 FROM
 (SELECT *,
 PERCENT_RANK() OVER(ORDER BY Price DESC) rank
 FROM Sales.Products)t
 WHERE rank <=0.4
 --3. WINDOW VALUE FUNCTIONS--
 --LEAD() AND LAG()
 --LAG(): it allows to access value from previous row within the window
 --LEAD():it allows to access value from next row within the window
 /*SYNTAX OF LEAD() AND LAG(): 
 LEAD/LAG(expression of any data type i.e Sales,2(rows forward/backward,10(defaultin case value is not available put 10))) OVER(ORDER BY Sales)

 ***1.USE CASE****: Time Analyse:year over year(YOY) and month over month(MOM) by finding the percentage
 change in sales between current and previous month*/

 SELECT
 *,
 current_month_sales - previous_month_sales MOM,
 ROUND(CAST((current_month_sales - previous_month_sales) AS FLOAT)/previous_month_sales * 100,1) MOM_percentage
 FROM
 (SELECT 
 MONTH(OrderDate) order_month,
 SUM(Sales)  current_month_sales,
 LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) previous_month_sales
 FROM Sales.Orders
 GROUP BY MONTH(OrderDate))t

 /* 
 ***2.USE CASE: Customer Retention Analysis:
 Measure customer's behaviour and loyalty.
 Analyse customer loyalty by ranking customers based on the average
 number of days between orders */
 SELECT 
 CustomerID,
 AVG(no_of_days) avg_days,
 RANK() OVER(ORDER BY COALESCE(AVG(no_of_days), 1000)) rank_of_customers
 FROM
 
 (SELECT 
 CustomerID,
 OrderDate Current_order_date,
 LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) Next_order_date,
 DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) no_of_days
 FROM Sales.Orders
)t
GROUP BY CustomerID
-- FIRST_VALUE()/LAST_VALUE()
-- FIRST_VALUE(): Access a value from the first row of a window
-- LAST_VALUE(): Access a value from the last row of **a window**
/*LAST_VALUE(): It is mandatory to define Frame window as **ROWS 
BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING*/
--Find highest and lowest sales for each product--
--Find the difference in sales between current and lowest sales
SELECT
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowest_sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) highest_sales,
Sales-FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) difference_in_sales
FROM Sales.Orders 



 
 



 
 
 
















 

 
 
 







   


 













 
 
 

 
 




















































 









 






















































































	

















