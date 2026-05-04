-- Retrieve selected columns 
USE MyDatabase
SELECT 
	first_name,
	country,
	score
FROM customers 
-- Retrieve all columns 
SELECT * 
FROM customers 
WHERE score>500
-- Retrieve customers where score not equal to zero
SELECT *
FROM customers 
WHERE score<> 0 
-- Retrieve customers from Germany
SELECT 
	first_name,
	country
FROM customers 
WHERE country= 'Germany' 

-- SORT THE DATA USING OrderBy in ascending or descending order
-- Retrieve all the customers and sort the results by the highest score first 
SELECT * 
FROM customers 
Order By score DESC
--Retrieve all the customers and sort the results by the lowest score first 
SELECT * 
FROM customers 
Order By score ASC
--Retrieve all the customers and sort the results by the country and highest score 
-- in Order By columns sequence is crucial since sql executes queries in sequence 
SELECT * 
FROM customers 
--Order By country ASC, score DESC
Order By score DESC, country ASC
--FIND THE TOTAL SCORE FOR EACH COUNTRY
SELECT 
	country,
	first_name,
	SUM(score) AS Total_Score
FROM customers 
Group By country,first_name
-- FIND the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) AS Total_Score,
	COUNT(id) AS Total_Customers
FROM customers 
Group BY country
/*FIND the average score for each cuntry 
considering only customers with a score 
not equal to 0 and return only those 
countries with an average score greater than 430*/
 SELECT 
 country,
 AVG(score) AS Average_score 
 FROM customers 
 WHERE score<> 0
 Group By country
 HAVING AVG(score)>430 
 --RETURN UNIQUE LIST OF ALL COUNTRIES 
 SELECT DISTINCT
 country 
 FROM customers 
 -- Retrieve only 3 customers using TOP 
 SELECT TOP 3 *
 FROM customers 
 -- Retrieve top 3 customers with the highest score 
 SELECT TOP 3 *
 FROM customers 
 Order By score DESC
 -- Retrieved 2 lowest customers based on the score 
 SELECT TOP 2 *
 FROM customers 
 Order By score ASC
 -- Get the two most recent orders 
 SELECT TOP 2 *
 FROM orders 
 Order By order_date DESC
 -- Extracting data from multiple tables 
 SELECT * 
 FROM customers 
 /*SELECT *
 FROM orders*/
 -- STATIC VALUES 
 SELECT 
 first_name,
 country,
 'last_name' AS last_name
 FROM customers 
 -- Create new table called persons with columns: id, person_name,birth_date and phone 
USE MyDatabase
-- DDL COMAMNDS (DATA DEFINITION LANGUAGE)

 CREATE TABLE person
 ( id INT NOT NULL,
   person_name VARCHAR(50) NOT NULL,
   birth_date VARCHAR(15),
   phone_number VARCHAR(15),
   CONSTRAINT pk_persons PRIMARY KEY (id)
 )
 -- ALTER the existing tabel
 ALTER TABLE person
 ADD email VARCHAR (50) NOT NULL
 SELECT * FROM person 
 -- REMOVE the column phone from existing table 
 ALTER TABLE person
 DROP COLUMN phone_number 
 -- DROPPING THE TABLE 
 DROP TABLE person
 -- DML COMMANDS (DATA MANIPULATION LANGUAGE)
SELECT * FROM customers 
INSERT INTO customers (id,first_name,country,score)
VALUES (6, 'Mona', 'NZ', 50),
(7, 'Suzane', 'AUS', 60)
-- Adding only 2 columns
INSERT INTO customers (id,first_name)
VALUES (8, 'John')
-- COPY DATA FROM CUSTOMER TABLE(SOURCE TABLE) INTO PERSON TABLE (TARGET TABLE)

INSERT INTO person (id, person_name, birth_date, phone_number)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers 
SELECT * FROM person
--UPDATE DATA
-- Change the score of customer 6 to 0
SELECT * FROM customers
UPDATE customers 
SET score = 0
WHERE id=6
SELECT * FROM customers 
--Change the score of customer 8 to 0 and and update the country to UK
UPDATE customers 
SET score= 90,
country= 'UK'
WHERE id =8
--Update all customers with a NULL score to 0
UPDATE customers
SET score= 0
WHERE score IS NULL

SELECT * 
FROM customers
WHERE score IS NULL
-- Delete all customers with id greater than 5
DELETE customers 
WHERE id>5


SELECT * 
FROM customers 
WHERE id>5
--USE TRUNCATE TO DELETE ALL THE DATA FROM A TABLE BECAUSE IT IS FAST QUERY
TRUNCATE TABLE person 


SELECT * 
FROM person



  
  













 






