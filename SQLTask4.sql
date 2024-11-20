--1.Database Creation
--a) creating a database to store the sales data.

-- Database: sales_db

-- DROP DATABASE sales_db;

CREATE DATABASE sales_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Portuguese_Brazil.1252'
       LC_CTYPE = 'Portuguese_Brazil.1252'
       CONNECTION LIMIT = -1;

--b) creating a table named "sales_sample" with the specified columns:

-- Product_Id (Integer)

-- Region (varchar(50)) - like East, West etc

-- Date (Date)

-- Sales_Amount (int)

CREATE TABLE sales_sample (
    Product_Id INT,
    Region VARCHAR(50),
    Date DATE,
    Sales_Amount INT
);

--2.Data Creation
--a) iserting 10 sample records into the "sales_sample" table, representing sales data.
INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount)
VALUES 
	(1, 'Region 1', '2024-01-01', 2500),
	(2, 'Region 1', '2024-01-02', 900),
	(2, 'Region 2', '2024-01-02', 1000),
	(3, 'Region 2', '2024-01-03', 1050),
	(3, 'Region 2', '2024-01-02', 850),
	(3, 'Region 3', '2024-01-03', 1750),
	(4, 'Region 4', '2024-01-04', 2000),
	(2, 'Region 4', '2024-01-05', 550),
	(3, 'Region 5', '2024-01-05', 1500),
	(4, 'Region 5', '2024-01-05', 1750)	
;

--3.Perform OLAP operations
--a) writing a query to perform drill down from region to product level to understand sales performance.
SELECT
	Region,
	Product_Id,
	SUM(Sales_Amount)
FROM
	sales_sample
GROUP BY
	Region,
	Product_Id
ORDER BY
	Region
;

--b) writing a query to perform roll up from product to region level to view total sales by region.
SELECT 
	Region,
	Product_Id,
	SUM(Sales_Amount)
FROM 
	sales_sample
GROUP BY 
	Region, 
	Product_Id

UNION ALL

SELECT 
	Region || ' - Total',
	NULL AS Product_Id,
	SUM(Sales_Amount)
FROM 
	sales_sample
GROUP BY 
	Region

UNION ALL

SELECT 
	NULL AS Region,
	NULL AS Product_Id,
	SUM(Sales_Amount)
FROM 
	sales_sample
ORDER BY
	Region,
	Product_Id
;

-- c) writing a query to explore sales data from different perspectives, such as product, region and date.
SELECT 
	Region,
	Product_Id,
	Date,
	SUM(Sales_Amount)
FROM 
	sales_sample
GROUP BY 
	Region, 
	Product_Id, 
	Date

UNION ALL

SELECT 
	Region,
	Product_Id,
	NULL AS Date,
	SUM(Sales_Amount)
FROM 
	sales_sample
GROUP BY 
	Region, 
	Product_Id

UNION ALL

SELECT 
	Region || ' - Total',
	NULL AS Product_Id,
	NULL AS Date,
	SUM(Sales_Amount)
FROM 
	sales_sample
GROUP BY 
	Region

UNION ALL

SELECT 
	NULL AS Region,
	NULL AS Product_Id,
	NULL AS Date,
	SUM(Sales_Amount)
FROM 
	sales_sample
ORDER BY
	Region,
	Product_Id,
	Date
;

--d) writing a query to slice the data to view sales for a particular region or date range.
SELECT * FROM sales_sample WHERE Region = 'Region 2';

--e) writing a query to view sales for specific combinations of product, region, and date.
SELECT 
	* 
FROM 
	sales_sample 
WHERE 
	Region = 'Region 2' AND
	Product_id = 3 AND
	Date = '2024-01-02'
;