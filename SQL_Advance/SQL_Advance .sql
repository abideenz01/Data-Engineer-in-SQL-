--MetaData: Data about Data 
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
--SubQuery: A query within query.It is use to breakdown complex tasks.
--Types of SubQuery:
--1. Scalar SubQuery
SELECT 
AVG(Sales) 
FROM Sales.Orders
--2.Row SubQuery: Returns multiple rows and single column
SELECT 
CustomerID
FROM Sales.Orders
--3.Table SubQuery: Returns multiple rows and multiple columns
SELECT 
CustomerID,
Sales
FROM Sales.Orders
--4. FROM SubQuery: Used as temporary table for the main Query
/* Find the products that have a price higher than the average price 
of all products*/
--Main Query
SELECT *
FROM 
---Sub Query
(SELECT
ProductID,
Price,
AVG(Price) OVER() avg_price
FROM Sales.Products)t
WHERE Price>avg_price /*WHERE is applicable in main query
                   WHERE cannot be used with windows functions because
                   WHERE EXECUTES FIRST*/
--Rank Customers based on their total amount of sales
SELECT 
*,
RANK() OVER(ORDER BY sum_sales DESC) customer_rank
FROM
    (SELECT 
    CustomerID,
    SUM(Sales) sum_sales
    FROM Sales.Orders
    GROUP BY CustomerID)t
    /* Show the product IDs, product names,prices and 
    and total number of orders*/
    --SELECT SubQuery
    SELECT 
    ProductID,
    Product,
    Price,
    
   
     (SELECT 
      COUNT(*) 
      FROM Sales.Orders) AS total_orders
      FROM Sales.Products
   --JOIN SubQuery
   /* Show all customer details and find the total orders for each 
   customer*/
   
   SELECT 
   c.*,
   o.total_orders
  
   FROM Sales.Customers AS c
   LEFT JOIN 

      (SELECT 
       CustomerID,
       COUNT(*) total_orders
       FROM Sales.Orders
       GROUP BY CustomerID) AS o
       ON c.CustomerID=o.CustomerID
--WHERE SubQuery using comparisom operator
--Only scalar values are allowed in subquery
/*Find the products that have a price higher than 
the average price of all products*/

SELECT 
ProductID,
Price

FROM Sales.Products

WHERE Price>(
           SELECT 
               AVG(Price) avg_price
           FROM Sales.Products)
--SubQuery IN Operator
/* Check if a value matches list of values*/
-- WHERE Subquery using IN operator
--Subquery is allowed to have multiple rows
--Show the details of orders made by customers in Germany

SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID --dynamic list
FROM Sales.Customers WHERE Country = 'Germany')
--Show the details of orders made by customers not from Germany
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID --dynamic list
FROM Sales.Customers WHERE Country != 'Germany')
--WHERE subquery using ANY/ALL
--Check if value matches any value
/* Find female employees whose salaries are greater than the salaries
of any male employees*/
SELECT 
*
FROM Sales.Employees
WHERE Gender='F' AND Salary  > ANY (SELECT Salary
FROM Sales.Employees
WHERE Gender= 'M')
--ALL Operator
--Check if a value matches all values within a list
/* Find female employees whose salaries are greater than the
salaries of all male emplyees*/
SELECT 
*
FROM Sales.Employees
WHERE Gender='F' AND Salary  > ALL (SELECT Salary
FROM Sales.Employees
WHERE Gender= 'M')
--Non-Correlated and Correlated SubQueries 

/*Non-Correlated SubQueries: A Subquery that can run independently 
from main query

Correlated SubQuerie: A Subquery that relies on values from main query*/

/* Show all customer details and find the total orders for each 
customer*/

--**IMP** 1.Correlated Subquerie
--Main Query
SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID=c.CustomerID ) total_orders

FROM Sales.Customers c
--Correlated SubQuery in WHERE Clause Exists operator 
--EXISTS: check if a subquery returns any rows 
--Show the details of orders made by customers in Germany

SELECT *                 
FROM Sales.Orders o
WHERE EXISTS (SELECT 1           --Since we are using subquery in
                                   --order to check existence of customer   
            FROM Sales.Customers c  --so value in subquery i.e 1 does not
            WHERE Country='Germany' --matter*/
            AND o.CustomerID= c.CustomerID)--here it means cutsomer with
--Now using WHERE clause IN operater          ID no 1
SELECT *                 
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID

         FROM Sales.Customers   
         WHERE Country='Germany');

/*COMMOM TABLE EXPRESSION(CTEs): Virtual table that can be used multiple
times within the query to simplify and organize complex queries*/

--Types of CTE:

--1. Non Recursive CTE
--it is executed once without repeatition 
--SubTypes of None Recursive CTE: 
--1. StandAlone CTE
--2. Nested CTE

--2. Recursive CTE

/*StandAlone CTE: It runs independently without relying on other CTEs
or subqueries*/


--CTE Query
--***IMP***:ORDER BY CANNOT BE USED IN CTE BUT CAN BE USED IN MAIN QUERY

--MINI PROJECT:

--STEP 01: Find the total sales per customers

WITH CTE_Sales_Per_Customer AS (
SELECT 
    CustomerID,
    SUM(Sales) total_sales
FROM Sales.Orders
GROUP BY CustomerID

),

--STEP 02: Find the last order date per customer

CTE_last_order_customer AS
(
SELECT 
     CustomerID,
     MAX(OrderDate) last_order_date
     FROM Sales.Orders
     GROUP BY CustomerID
    
 ),

 --Nested CTEs: CTE inside another CTE. It can't run independently

 --Step 03: Rank customers based on total sales per customer

 CTE_rank_customer AS
 ( SELECT
     CustomerID,
     total_sales,
     RANK() OVER(ORDER BY total_sales DESC) customer_rank
 FROM CTE_Sales_Per_Customer
 ),
 --Step 04: Segment customers based on their total sales
 CTE_customers_segmentation AS
 ( SELECT 
     CustomerID,
     CASE WHEN total_sales>= 100 THEN 'HIGH'
          WHEN total_sales>= 75 THEN 'MEDIUM'
          WHEN total_sales<= 60 THEN 'LOW'
          ELSE 'N/A'
     END customers_segmentation

     FROM CTE_Sales_Per_Customer
 
 
 )



--Main Query
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cts.total_sales,
    cts_1.last_order_date,
    cts_2.customer_rank,
    cts_3.customers_segmentation

FROM Sales.Customers AS c
LEFT JOIN CTE_Sales_Per_Customer AS cts
ON c.CustomerID=cts.CustomerID
LEFT JOIN CTE_last_order_customer AS cts_1
ON c.customerID=cts_1.customerID
LEFT JOIN CTE_rank_customer AS cts_2
ON c.CustomerID=cts_2.CustomerID
LEFT JOIN CTE_customers_segmentation AS cts_3
ON c.CustomerID=cts_3.CustomerID
ORDER BY total_sales DESC

--2. Recursive CTE
--Repeatedly processes data until a specific condition is met
--Used in hierarical structure
--Generate a sequence of numbers from 1 to 20.
WITH CTE_series AS(
    --Anchor Query
    SELECT
    1 AS n

    --Recursive Query (Loop)
    UNION ALL
    SELECT
    n+1 
    FROM CTE_series
    WHERE  n<20
)
--Main Query
SELECT
*
FROM CTE_series 
OPTION(MAXRECURSION 20);

--Show the employee hierarchy by displaying 
--each emplyee's level within the organization
WITH CTE_employee_hierarchy AS 
(
-- Anchor Query
SELECT
EmployeeID,
FirstName,
ManagerID,
1 AS emp_level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
--Recursive Query
SELECT
e.EmployeeID,
e.FirstName,
e.ManagerID,
emp_level+1
FROM Sales.Employees AS e
INNER JOIN CTE_employee_hierarchy as hie
ON hie.EmployeeID=e.ManagerID
)

--Main Query 
SELECT 
EmployeeID,
FirstName,
ManagerID,
emp_level
FROM CTE_employee_hierarchy;

--------------VIEWS---------------------------
-- view is a virtual table that shows data without storing it
--physically
--SYNTAX OF VIEW:
/*CREATE VIEW VIEW-NAME AS (
SELECT 
FROM 
WHERE
)*/
--Find the running total of sales for each month

WITH CTE_Running_Total AS(

SELECT 

MONTH(OrderDate) Order_Month,
SUM(Sales)  Total_Sales,
COUNT(*) Total_Orders,
SUM(Quantity) Total_Quantity
FROM Sales.Orders
GROUP BY MONTH(OrderDate))

SELECT 
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER(ORDER BY Order_Month) Running_Total

FROM CTE_Running_Total;
-----VIEW-----

CREATE VIEW Sales.V_Monthly_Summary AS (
SELECT 

MONTH(OrderDate) Order_Month,
SUM(Sales)  Total_Sales,
COUNT(*) Total_Orders,
SUM(Quantity) Total_Quantity
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

)
SELECT 
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER(ORDER BY Order_Month) Running_Total

SELECT * FROM Sales.V_Monthly_Summary

--DROP A VIEW IN SQL--
DROP VIEW Sales.V_Monthly_Summary
---DROP AND CREATE VIEW--

IF OBJECT_ID ('Sales.V_Monthly_Summary','V') IS NOT NULL
DROP VIEW Sales.V_Monthly_Summary
GO
CREATE VIEW Sales.V_Monthly_Summary AS (
SELECT 

MONTH(OrderDate) Order_Month,
SUM(Sales)  Total_Sales,
COUNT(*) Total_Orders
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)

SELECT 
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER(ORDER BY Order_Month) Running_Sales
FROM Sales.V_Monthly_Summary

--Provide view that combines details from orders,products,customers
--and employees.

-----VIEW USE CASE:02-----

CREATE VIEW Sales.V_Order_Details AS (

SELECT 
o.OrderID,
p.Product,
p.Category,
c.FirstName,
c.Country,
e.Department,
o.Sales,
o.Quantity


FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON o.ProductID=p.ProductID
LEFT JOIN Sales.Customers AS c
ON o.CustomerID= c.CustomerID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID=e.EmployeeID
)
SELECT *
FROM Sales.V_Order_Details

--VIEW USE CASE:03---
-- DATA SECURITY--
--Provide a view for the EU sales team that combines details 
--from all tables and excludes data from USA.

IF OBJECT_ID('EU_Sales_Team','V') IS NOT NULL 
DROP VIEW EU_Sales_Team 
GO
CREATE VIEW EU_Sales_Team AS (
SELECT 
o.OrderID,
p.Product,
p.Category,
c.FirstName + ' ' + c.LastName Full_Name,
c.Country,
e.Department,
o.Sales,
o.Quantity

FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON o.ProductID=p.ProductID
LEFT JOIN Sales.Customers AS c
ON o.CustomerID= c.CustomerID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID=e.EmployeeID
WHERE Country !='USA'
)

SELECT * 
FROM EU_Sales_Team

----VIEW USE CASE:04----
--Custom Changes for users--

--VIEW USE CASE:05--
--Changing Column Headings to another Lanaguage--

--****IMP USE CASE OF VIEWS****--
--Views can be used as virtual DATA MARTS in Data Warehouse Systems 
--because they provide flexible and efficient way to present data

--***CTAS and TEMP***--
--SYNTAX: CREATE TABLE Table-Name (
          --ID INT,
          --Name VARCHAR(50)

--)
--INSERT INTO Table_Name(
            --VALUES(1,'Frank')
--)

--***CTAS/CREATE TABLE AS SELECT SYNTAX***--
     --SELECT
     --INTO New-Table
     --FROM
     --WHERE
     
     --)
      ---CTAS--- 
   --How to update conetent of the CTAS Table--
IF OBJECT_ID('Sales.Monthly_Orders','U') IS NOT NULL 
DROP TABLE Sales.Monthly_Orders;
GO 
SELECT
DATENAME(MONTH,OrderDate) Order_Month,
COUNT(OrderID)  Total_Orders
INTO Sales.Monthly_Orders --DDL command for creating table
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate)
SELECT * FROM Sales.Monthly_Orders
 ---CTAS USE CASE:01 Creating SnapShot--
 --Since data is changing regularly we take snapshot of data to analyse

 ---CTAS USE CASE:02 Physical Data Marts IN DWH--
 --CTAS creates physical Data Marts with persistent data that 
 --improves the speed of data retrieval in comparison to 
 --virtual data marts in Views

 ---TEMP TABLES--
 /* Stores intermediate results in temporary storage within the 
 database during the session. The database will drop all temporary
 tables once session ends*/

 --TEMP TABLE SYNTAX AND EXAMPLE
 --SELECT 
 --Column1,Column 2
 --INTO # Table_Name
 --FROM 
 --WHERE 
 
 --Copying data from permanent table to temp table
 SELECT *
 INTO #Orders
 FROM Sales.Orders

 --Deleting Orders
 DELETE FROM #Orders
 WHERE OrderStatus='Delivered'

 --Load data from temp table to permanent table
 SELECT 
 * 
 INTO Sales.OrdersTest
 FROM #Orders
 
 SELECT * FROM Sales.OrdersTest;

 ---STORED PROCEDURES--
--SYNTAX: CREATE PROCEDURE ProcedureName AS
--BEGIN 



--END 

--Executionn of Stored Procedure--
--EXEC ProcedureName

--For US customers find the total number of customers and the average 
--score

SELECT 
    COUNT(*) USA_Customers,
    AVG(Score) Customer_Avg
FROM Sales.Customers
WHERE Country='USA'

--Turning the query into stored procedure
CREATE PROCEDURE MonthlyReport AS 
BEGIN 
     SELECT 
    COUNT(*) USA_Customers,
    AVG(Score) Customer_Avg
FROM Sales.Customers
WHERE Country='USA'
END

 EXEC MonthlyReport

--Parameter in stored procedure
ALTER PROCEDURE MonthlyReport @Country NVARCHAR(50) ='USA'--USA default
AS 
BEGIN 
SELECT 
    COUNT(*) USA_Customers,
    AVG(Score) Customer_Avg
FROM Sales.Customers
WHERE Country= @Country;

--Find total number of orders and total sales
SELECT
COUNT(OrderID) Total_Orders,
SUM(Sales) Total_Sales
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID=c.CustomerID
WHERE c.Country=@Country
END

EXEC MonthlyReport 


--TRIGGERS
--SYNTAX:
--CREATE TRIGGER TriggerName ON TableName

     ---INDEXES---
--TYPES OF INDEXES:
--1.Structured Index: Clustered and NonClustered
--2.Storage Index: RowStoreIndex and ColumnStoreIndex
--3.Functions Index: Unique Index and Filtered Index

--Data structure provide quick access to data, optimizing speed of 
--queries

--1.HEAP: TABLE WITHOUT INDEX 
--ADVANTAGE: QUICK WRITE
--DISADVANTAGE: SLOW READ 
--Clustered Index Structure: Fast and Effective Read 
--Non Clustered Index: USES B-TREE 

--Syntax of Index: 
--CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name (column1,column2)
--Default is Non Clustered
--CREATE CLUSTERED INDEX IX_Customers_ID ON Customers (ID)
--CREATE NONCLUSTERED INDEX IX_Customers_ID ON Customers (City)
--CREATE INDEX IX_Customers_ID ON Customers ( LastName ASC, FirstName DESC)

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers (CustomerID)
--DROPPING CLUSTER
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers
--ONLY ONE CLUSTERED INDEX PER TABLE
--MULTIPLE NON CLUSTERED INDEX PER TABLE
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers (LastName)
CREATE INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)
CREATE INDEX idx_DBCustomers_Country_Score ON Sales.DBCustomers (Country,Score)--MUST MATCH QUERY ORDER 
SELECT * 
FROM Sales.DBCustomers
WHERE Country='USA' AND Score>50 --index follows leftmost column rule

--2.Stoarge Index: RowStoreIndex and ColumnStoreIndex
--RowStoreIndex: store data row by row
--ColumnStoreIndex: stores data column by column 

--***IMP***
--ColumnStoreIndex is way faster than rowstoreindex

--ColumnStoreIndex SYNTAX: CREATE CLUSTERED | NONCLUSTERED COLUMNSTOREINDEX INDEX Index_Name ON Table_Name(Column1,Column2)
--Default is ROWSTORE

--NOT ALLOWED TO SPECIFY COLUMNS IN CLUSTERED COLUMNSTORE
--SYNTAX: CREATE CLUSTERED COLUMNSTORE INDEX idx_DB_Customers_CustomerID ON Sales.DBCustomers
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers
--ONLY ONE CLUSTERED OR NONCLUSTERED INDEX IS ALLOWED WITH 
--COLUMNSTORE 

USE AdventureWorksDW2022

--HEAP 
SELECT *
INTO FactInternetSales_HP 
FROM FactInternetSales

--Row_Store Index 
SELECT *
INTO FactInternetSales_RS 
FROM FactInternetSales
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK 
ON FactInternetSales (SalesOrderNumber, SalesOrderLineNumber)

--ColumnStore Index** THE MOST STORAGE EFFICIENT***
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK 
ON FactInternetSales_CS

--STORAGE EFFICIENCY RANKING
--1. Columnstore index
--2. Heapstore index 
--3. Rowstore Index 

--3. Unique Index 
--Ensures no duplicates data exists in specific column
--Benefits: 1. Ensures uniqueness 2. increase query performance
--SYNTAX: CREATE UNIQUE | CLUSTERED | NONCLUSTERED COLUMNSTORE INDEX index_name ON table_name(Column1,column2)

SELECT *
FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product ON Sales.Products(Product)

INSERT INTO Sales.Products(ProductID, Product) 
VALUES (106,'Bottle')

--Filtered Index
--An index that includes only rows that meet specific conditions
--Benefits: Targeted Optimization 
--Reduce storage less data in index 
--SYNTAX: CREATE UNIQUE INDEX index_name ON table_name(column)
--WHERE Condition 
--RULES: 1.You cannot create filtered index on clustered index
--2.You cannot create filtered index on columnstore index

SELECT *
FROM Sales.Customers 
--Creating filtered nonclusterd index on csutomers form USA
CREATE NONCLUSTERED INDEX idx_Customers_Country ON Sales.Customers(Country)
WHERE Country= 'USA'
--Index Management 
--1. Monitor index Usage
--List all indexes on specific table 
--USING STORED PROCEDURES 

sp_helpindex 'Sales.DBCustomers'
--Monitor index useage
SELECT
tbl.name AS tablename,
idx.name AS IndexName,
idx.type_desc AS IndexType,
sts.index_id IndexID,
sts.user_seeks UserSeeks,
sts.user_updates UserUpdate,
COALESCE(sts.last_user_seek,sts.user_scans) LastUpadate,
sts.last_user_lookup UserLookup,
sts.system_updates UserUpdate,
idx.is_unique AS IsUnique,
idx.is_primary_key As IsPrimary,
idx.is_disabled AS IsDisabled
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id=tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats sts
ON sts.object_id= idx.object_id
AND sts.index_id= idx.index_id
ORDER BY tbl.name,idx.name

SELECT * FROM sys.dm_db_index_usage_stats

--DROPPING UNUSED INDEXES BENEFITS:
--1.SAVES STORAGE
--2.Improves write performance

--Execution Plan 
--Roadmap that how database executes queries step by step
--Useage: To identify performance issue 

--Partitions 
--Divides big table into smaller partitions 
--while still bein treated as a single logical table 

--Partition Function: define the logic on how to divide data
--into partitions

--Create a partition function 
--SYNTAX:
CREATE PARTITION FUNCTION PartitionByYear (DATE) AS RANGE LEFT FOR 
VALUES ('2023-12-31', '2024-12-31', '2025-12-31')

--Query lists all existing partitions functions
SELECT
name,
function_id,
type_desc,
boundary_value_on_right
FROM sys.partition_functions

--Create Filegroups
--FILEGROUPS
--It is a large group of one or more data files to help organize
--partitions
--SYNTAX:

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

--Removing Filegroup 
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2024;

--Query lists all existing functions 
SELECT *
FROM sys.filegroups
WHERE type='FG'

INSERT INTO Sales.DBCustomers (CustomerID,FirstName,LastName,Country,Score) VALUES (6,'John','keef','UK',1000)

SELECT * 
FROM Sales.DBCustomers 

--Add .ndf files to each filegroup 
ALTER DATABASE SalesDB 
ADD FILE (
  NAME = P_2023,
  FILENAME = 'E:\ZAIN\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
  
)
TO FILEGROUP FG_2023;

--Adding file to FG_2024
ALTER DATABASE SalesDB 
ADD FILE (
  NAME = P_2024,
  FILENAME = 'E:\ZAIN\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
  
)
TO FILEGROUP FG_2024;


--Adding File to FG_2025
ALTER DATABASE SalesDB 
ADD FILE (
  NAME = P_2025,
  FILENAME = 'E:\ZAIN\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
  
)
TO FILEGROUP FG_2025;

--Adding File to FG_2026
ALTER DATABASE SalesDB 
ADD FILE (
  NAME = P_2026,
  FILENAME = 'E:\ZAIN\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
  
)
TO FILEGROUP FG_2026;

------------------------------------------------------------------
--30x Performance Tips
-----------------------------------------------------------------
--1.Select Only what you need 

---BAD PRACTICE--
SELECT * FROM Sales.Customers

---GOOD PRACTICE---
SELECT 
CustomerID,
FirstName,
Country
FROM Sales.Customers

--2.Avoid unnecessary DISTINCT and ORDER BY--

--BAD PRACTICE--
SELECT DISTINCT
FirstName,
LastName,
Country
FROM Sales.Customers
ORDER BY FirstName

--GOOD PRACTICE--
SELECT 
FirstName
FROM Sales.Customers

--3. For Exploration Purpose Limit Rows in case of 100 million rows

--BAD PRACTICE--
SELECT 
OrderID,
Sales
FROM Sales.Orders

--GOOD PRACTICE
SELECT TOP 10 --limiting to top 10 only
OrderID,
Sales
FROM Sales.Orders

--4. ---------------------
--Create nonclustered index on frequently used columns in WHERE CLAUSE
---------------------------
--BAD PRACTICE
SELECT * FROM 
Sales.Orders 
WHERE OrderStatus= 'Delivered'

--GOOD PRACTICE
CREATE NONCLUSTERED INDEX idx_Orders_OrderStatus ON Sales.Orders(OrderStatus)

--6. Avoid applying functions to columns in WHERE clause 
--BAD PRACTICE--
SELECT *      --using functions on columns blocks index usage
FROM Sales.Orders
WHERE LOWER(OrderStatus)= 'Delivered'

--GOOD PRACTICE--
SELECT *      
FROM Sales.Orders
WHERE (OrderStatus)= 'Delivered'

--Find Customers where fistname starts with A
--BAD PRACTICE
SELECT *
FROM Sales.Customers 
WHERE SubString(FirstName,1,1)= 'A'

--GOOD PRACTICE--
SELECT *
FROM Sales.Customers
WHERE FirstName LIKE 'A%'

--BAD PRACTICE--
SELECT *
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

--GOOD PRACTICE--
SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2023-12-31' AND '2024-12-31'

--7.Avoid leading wildcards as they prevent index usage
--BAD PRACTICE--
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%Gold%'

--GOOD PRACTICE--
SELECT *
FROM Sales.Customers
WHERE LastName LIKE 'Gold%'

--8.USE IN instead of multiple OR

--BAD PRACTICE--
SELECT 
* FROM Sales.Orders
WHERE CustomerID=1 OR CustomerID=2 OR CustomerID = 3

--GOOD PRACTICE--
SELECT 
* FROM Sales.Orders
WHERE CustomerID IN (1,2,3)
---------------------------------------------------------------------
--9. JOINS: Understand speed of JOINS and USE INNER JOIN when possible
---------------------------------------------------------------------
--Best Performance: INNER JOIN--beacuse it only fetches matching rows
--Slightly Better: LEFT AND RIGHT JOIN
--WORST: OUTER JOIN

--10. USE Explicit join(ANSI) instead of non explicit joins (non ANSI)
--BAD PRACTICE
SELECT 
o.OrderID,
c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID=o.CustomerID

--GOOD PRACTICE
SELECT 
o.OrderID,
c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID=o.CustomerID

--11.Make sure to index the columns used in ON Clause
SELECT 
o.OrderID,
c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID=o.CustomerID

CREATE NONCLUSTERED INDEX idx_Orders_CustomerID ON Sales.Customers(CustomerID);

--12. Filter before joining big tables
--using CTEs

WITH CTE_OrderStatus AS(
SELECT
CustomerID,
OrderID
FROM Sales.Orders
WHERE OrderStatus='Delivered'
),

CTE_Customers AS (
SELECT 
FirstName,
CustomerID
FROM Sales.Customers 
)

--Main Query
SELECT 
cts1.CustomerID,
cts1.FirstName
FROM CTE_Customers cts1
INNER JOIN CTE_OrderStatus cts2
ON cts1.CustomerID= cts2.CustomerID

--13. For BIG TABLES: Isolate the preparation steps in CTE or SubQuery for
--optimal performance 
SELECT
c.CustomerID,
o.OrderID,
c.FirstName
FROM Sales.Customers c
INNER JOIN (SELECT CustomerID, OrderID FROM Sales.Orders WHERE OrderStatus='Delivered') o
ON c.CustomerID=o.CustomerID

--14. Aggregate Data Before joining big Tables
--Pre Aggregated SubQuery
SELECT 
c.CustomerID,
c.FirstName,
o.OrderCount
FROM Sales.Customers c
INNER JOIN (SELECT CustomerID, COUNT(OrderID) As OrderCount FROM Sales.Orders GROUP BY CustomerID)  o
ON c.CustomerID=o.CustomerID

--15. Use UNION Instead of OR in JOINS
--BEST PRACTICE

SELECT 
c.CustomerID,
c.FirstName,
o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID= o.CustomerID
UNION 
SELECT 
c.CustomerID,
c.FirstName,
o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID= o.SalesPersonID

--15. Good Practice for joining big and small tables 
SELECT 
c.CustomerID,
c.FirstName,
o.OrderID
FROM Sales.Customers c --small table
INNER JOIN Sales.Orders o --big table
ON c.CustomerID= o.CustomerID
OPTION (HASH JOIN)

--16. Use Columnstore index for aggregating data 
SELECT 
CustomerID,
COUNT(OrderID)
FROM Sales.Orders
GROUP BY CustomerID

CREATE CLUSTERED COLUMNSTORE INDEX idx_Orders_Columstore ON Sales.Orders

--17. Pre-Aggregate data and store it in new table 

SELECT 
DATENAME(MONTH,OrderDate) Order_Month,
SUM(Sales) AS total_sales
INTO Sales.Monthly
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate)

SELECT *
FROM Sales.Monthly

--18. EXISTS BETTER THAN JOIN BECAUSE IT STOPS AT FIRST MATCHING DATA
SELECT
o.OrderID,
o.Sales
FROM Sales.Orders o
WHERE EXISTS( 
                 SELECT 1 FROM Sales.Customers c
                 WHERE c.CustomerID=o.CustomerID
                  AND c.Country='USA')


--AI & SQL---

























































           
   
          








  










