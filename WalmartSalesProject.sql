-- Direct Import Method
CREATE DATABASE IM_WALMART
USE IM_WALMART

-- Query Import Method
CREATE DATABASE WALMART
USE WALMART
-- Create Table and Drop tables if they exist
IF OBJECT_ID('WalmartSales', 'U') IS NOT NULL
    DROP TABLE WalmartSales

CREATE TABLE WalmartSales(
InvoiceID VARCHAR(20),
Branch CHAR(1),
City VARCHAR(50),
CustomerType VARCHAR(20),
Gender VARCHAR(10),
ProductLine VARCHAR(100),
UnitPrice FLOAT,
Quantity INT,
Tax FLOAT,
Total FLOAT,
Date DATE,
Time TIME,
Payment VARCHAR(20),
COGS FLOAT,
GrossMarginPercentage FLOAT,
GrossIncome FLOAT,
Rating FLOAT
)

BULK INSERT WalmartSales
FROM 'C:\Users\arjun\OneDrive\Desktop\SQL\Projects\P2\WalmartSalesData.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)

SELECT * FROM WalmartSales

-- Add new column timeofday (Morning, Afternoon, Evening)
ALTER TABLE WalmartSales ADD TimeOfDay VARCHAR(20)

-- Add new column dayname (Mon, Tue, etc.)
ALTER TABLE WalmartSales ADD DayName VARCHAR(10)

-- Add new column monthname (Jan, Feb, etc.)
ALTER TABLE WalmartSales ADD MonthName VARCHAR(10)

-- Update timeofday column based on time
UPDATE WalmartSales
SET TimeOfDay = 
CASE 
WHEN CAST(Time AS TIME) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
WHEN CAST(Time AS TIME) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
ELSE 'Evening'
END

-- Update dayname column based on date
UPDATE WalmartSales
SET DayName = DATENAME(WEEKDAY, Date)

-- Update monthname column based on date
UPDATE WalmartSales
SET MonthName = FORMAT(Date, 'MMM')

SELECT * FROM WalmartSales

-- QUERIES

-- 1. How many unique cities does the data have?
SELECT DISTINCT city FROM WalmartSales

-- 2. In which city is each branch located?
SELECT DISTINCT branch, city FROM WalmartSales

-- 3. How many unique product lines does the data have?
SELECT COUNT(DISTINCT ProductLine) AS unique_product_lines FROM WalmartSales

-- 4. What is the most common payment method?
SELECT TOP 1 Payment, COUNT(*) AS Frequency
FROM WalmartSales
GROUP BY Payment
ORDER BY Frequency DESC

-- 5. What is the most selling product line?
SELECT TOP 1 ProductLine, SUM(quantity) AS Total_Quantity
FROM WalmartSales
GROUP BY ProductLine
ORDER BY total_quantity DESC

-- 6. What is the total revenue by month?
SELECT MonthName, SUM(total) AS total_revenue
FROM WalmartSales
GROUP BY MonthName
ORDER BY total_revenue DESC

-- 7. Which month had the largest COGS?
SELECT TOP 1 monthname, SUM(cogs) AS total_cogs
FROM WalmartSales
GROUP BY monthname
ORDER BY total_cogs DESC

-- 8. What product line had the largest revenue?
SELECT TOP 1 productline, SUM(total) AS total_revenue
FROM WalmartSales
GROUP BY productline
ORDER BY total_revenue DESC

-- 9. Which city had the largest revenue?
SELECT TOP 1 city, SUM(total) AS total_revenue
FROM WalmartSales
GROUP BY city
ORDER BY total_revenue DESC

-- 10. What product line had the largest VAT (tax)?
SELECT TOP 1 productline, AVG(tax) AS avg_tax
FROM WalmartSales
GROUP BY productline
ORDER BY avg_tax DESC

-- 11. Classify each product line as "Good" or "Bad" based on average quantity
SELECT productline, avg(quantity),
CASE
WHEN AVG(quantity) > (SELECT AVG(quantity) FROM WalmartSales) THEN 'Good'
ELSE 'Bad'
END AS performance
FROM WalmartSales
GROUP BY productline

-- 12. Which branch sold more products than average?
SELECT branch, SUM(quantity) AS total_quantity
FROM WalmartSales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM WalmartSales)

-- 13. What is the most common product line by gender?
SELECT gender, productline, COUNT(*) AS count
FROM WalmartSales
GROUP BY gender, productline
ORDER BY count DESC

-- 14. What is the average rating of each product line?
SELECT productline, ROUND(AVG(rating), 2) AS avg_rating
FROM WalmartSales
GROUP BY productline
ORDER BY avg_rating DESC

-- 15. Number of sales made in each time of the day per weekday (example: Sunday)
SELECT timeofday, COUNT(*) AS total_sales
FROM WalmartSales
WHERE dayname = 'Sunday'
GROUP BY timeofday

-- 16. Which customer type brings the most revenue?
SELECT customertype, SUM(total) AS total_revenue
FROM WalmartSales
GROUP BY customertype
ORDER BY total_revenue DESC

-- 17. Which city has the largest average tax/VAT percentage?
SELECT city, ROUND(AVG(tax), 2) AS avg_tax
FROM WalmartSales
GROUP BY city
ORDER BY avg_tax DESC

-- 18. Which customer type pays the most in VAT?
SELECT customertype, AVG(tax) AS avg_vat
FROM WalmartSales
GROUP BY customertype
ORDER BY avg_vat DESC

-- 19. How many unique customer types are there?
SELECT DISTINCT customertype FROM WalmartSales

-- 20. How many unique payment methods are there?
SELECT DISTINCT payment FROM WalmartSales

-- 21. What is the most common customer type?
SELECT TOP 1 customertype, COUNT(*) AS frequency
FROM WalmartSales
GROUP BY customertype
ORDER BY frequency DESC

-- 22. Which customer type buys the most?
SELECT customertype, COUNT(*) AS total_purchases
FROM WalmartSales
GROUP BY customertype
ORDER BY total_purchases DESC

-- 23. What is the gender of most customers?
SELECT TOP 1 gender, COUNT(*) AS total_customers
FROM WalmartSales
GROUP BY gender
ORDER BY total_customers DESC

-- 24. What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS total_customers
FROM WalmartSales
GROUP BY branch, gender
ORDER BY branch

-- 25. Which time of the day do customers give most ratings?
SELECT timeofday, AVG(rating) AS avg_rating
FROM WalmartSales
GROUP BY timeofday
ORDER BY avg_rating DESC

-- 26. Which time of the day do customers give most ratings per branch (example: A)?
SELECT timeofday, AVG(rating) AS avg_rating
FROM WalmartSales
WHERE branch = 'A'
GROUP BY timeofday
ORDER BY avg_rating DESC

-- 27. Which day of the week has the best average rating?
SELECT dayname, AVG(rating) AS avg_rating
FROM WalmartSales
GROUP BY dayname
ORDER BY avg_rating DESC

-- 28. Which day of the week has the best average rating per branch (example: C)?
SELECT dayname, AVG(rating) AS avg_rating
FROM WalmartSales
WHERE branch = 'C'
GROUP BY dayname
ORDER BY avg_rating DESC
