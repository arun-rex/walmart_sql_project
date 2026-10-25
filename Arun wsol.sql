--This is the databASe i made for this project
USE walmart
-- ADDing some new column TimeOfDay, Month, WeekNumber, Day
ALTER TABLE WSD
ADD mounth_number int, 
	week_number int, 
	day varchar(50), 
	time_of_day varchar(50) 

--Updating the value in new column
UPDATE WSD 
	set mounth_number = MONTH(date)

UPDATE WSD 
	set week_number=datepart(weekday,date), 
		day=DAY(date),time_of_Day=
			CASE when DATEPART(HOUR,Time) >=5 and DATEPART(HOUR,Time) <12 THEN 'morning'
				when DATEPART(HOUR,Time) >=12 and DATEPART(HOUR,Time) <17 THEN 'morning'
				else 'evening' 
			END

ALTER TABLE WSD ADD week_day varchar(50)
UPDATE WSD 
	set week_day=DATENAME(weekday,Date)

--Generic Questions
--1.How many unique cities are present in the dataset?
SELECT DISTINCT city, COUNT(DISTINCT city) 
FROM WSD 
GROUP BY City

--2.Which city is associated with each store branch?
SELECT DISTINCT Branch, city 
FROM WSD ORDER BY Branch ASC

--Product Analysis Questions
--1.How many unique product lines are available in the dataset?
SELECT COUNT (DISTINCT product_line) 
FROM WSD

--2.What is the most commonly used payment method?
SELECT TOP 1 payment,COUNT (payment) 
FROM WSD 
GROUP BY Payment 
ORDER BY COUNT(payment) DESC

--3.Which product line hAS the highest number of units sold?
SELECT TOP 1 Product_line, SUM(quantity) 
FROM WSD 
GROUP BY Product_line 
ORDER BY SUM(quantity) DESC

--4.What is the total revenue generated in each month?
SELECT month_number, SUM(total) AS revenue 
FROM WSD 
GROUP BY month_number
ORDER BY month_number ASC

--5.In which month was the cost of goods sold (COGS) the highest?
SELECT 
	TOP 1 DATENAME(MONTH, date) AS sales_month,
	cASt(SUM(cogs) AS decimal(10,2)) 
FROM WSD 
GROUP BY DATENAME(MONTH, date) 
ORDER BY SUM(cogs) DESC

--6.Which product line generated the most revenue?
SELECT 
	TOP 1 Product_line,
	cASt(SUM(total) AS decimal(10,2)) AS revenue
FROM WSD
GROUP BY Product_line
ORDER BY revenue DESC

--7.Which city recorded the highest total revenue?
SELECT TOP 1 City,
	cASt(SUM(total) AS decimal(10,2)) total_revenue
FROM WSD
GROUP BY City
ORDER BY total_revenue DESC

--8.Which product line had the highest average VAT percentage?
SELECT 
	TOP 1 Product_line,
	AVG(tax_5) AS vat 
FROM WSD 
GROUP BY Product_line
ORDER BY vat DESC

--9.Can we classify each product line AS “Good” or “Bad” based on whether its sales volume is above or below the average?
SELECT 
	PRODUCT_line, AVG(quantity) AS sale_volume,
		CASE 
			when AVG(quantity)>(SELECT AVG(quantity) FROM WSD) 
			THEN 'good'
		else 'bad'
	END AS performance 
FROM WSD 
GROUP BY Product_line

--10.Which branch sold more products than the overall average number of products sold?
SELECT 
	branch,SUM(quantity) AS sold_products
FROM WSD
GROUP BY Branch
having SUM(quantity)>(SELECT AVG(quantity) FROM WSD)

--11.For each gender, which product line is purchASed the most?
SELECT 
	TOP 1 gender, Product_line,
	SUM(quantity) AS no_of_purchASed_most 
FROM WSD
GROUP BY gender, Product_line
ORDER BY no_of_purchASed_most DESC

--12.What is the average customer rating for each product line?
SELECT 
	Product_line,
	AVG(rating) AS rating FROM WSD
GROUP BY Product_line
ORDER BY rating DESC

--Sales Analysis Questions
--1.How many sales were made during each time of day (Morning, Afternoon, Evening) for every day of the week?
SELECT 
	day,
	time_of_day, SUM(total) AS revenue 
FROM WSD 
GROUP BY day, time_of_day
ORDER BY cASt(day AS int) ASC 

--2.Which customer type contributes the most to the company’s total revenue?
SELECT 
	TOP 1 CUSTOMER_TYPE,
	SUM(total) AS total_revenue 
FROM WSD
GROUP BY CUSTOMER_TYPE
ORDER BY total_revenue DESC

--3.Which city has the highest average VAT percentage?
SELECT 
	TOP 1 city, AVG(tax_5) AS vat 
FROM WSD 
GROUP BY City
ORDER BY vat DESC

--4.Which customer type pays the most VAT on average?
SELECT 
	TOP 1 CUSTOMER_TYPE, AVG(tax_5) AS vat 
FROM WSD 
GROUP BY CUSTOMER_TYPE
ORDER BY vat DESC

--Customer Analysis Questions
--1.How many unique customer types are present in the dataset?
SELECT 
	COUNT(DISTINCT CUSTOMER_TYPE) AS type_of_customer 
FROM WSD

--2.How many different payment methods are used by customers?
SELECT 
	COUNT(DISTINCT Payment) AS type_of_payment_methods 
FROM WSD

--3.What is the most common customer type?
SELECT 
	TOP 1 CUSTOMER_TYPE,
	COUNT(CUSTOMER_TYPE) AS most_common_CUSTOMER_TYPE 
FROM WSD 
GROUP BY CUSTOMER_TYPE 
ORDER BY most_common_CUSTOMER_TYPE DESC

--4.Which customer type makes the most purchases?
SELECT 
	TOP 1 CUSTOMER_TYPE, 
	COUNT(invoice_id) AS most_purchASed_CUSTOMER_TYPE 
FROM WSD 
GROUP BY CUSTOMER_TYPE 
ORDER BY most_purchASed_CUSTOMER_TYPE DESC

--5.What is the gender distribution among the customers?
SELECT 
	gender, 
	COUNT(gender) AS customers_COUNT 
FROM WSD 
GROUP BY gender 
ORDER BY gender ASC

--6.How does the gender distribution vary across different store branches?
SELECT
	Branch,gender, 
	COUNT(gender) AS customers_COUNT 
FROM WSD 
GROUP BY Branch,gender 
ORDER BY Branch ASC, gender ASC

--7.During which time of the day do customers give the highest average ratings?
SELECT 
	TOP 10 Time,
	AVG(rating) AS highest_AVG_rating 
FROM WSD 
GROUP BY Time 
ORDER BY highest_AVG_rating DESC

--8.During which time of the day do customers in each branch give the best ratings?
SELECT 
	TOP 20 Branch, 
	Time,AVG(rating) AS highest_rating 
FROM WSD 
GROUP BY Branch,Time 
ORDER BY highest_rating DESC, Branch ASC

--9.On which day of the week do customers provide the best average ratings?
SELECT 
	week_day,
	AVG(rating) AS AVG_rating 
FROM WSD 
GROUP BY week_day 
ORDER BY AVG(rating)DESC

--10.For each branch, which day of the week receives the highest number of sales?
with cte AS (SELECT Branch,day, SUM(total) AS revenue, ROW_NUMBER() over(partition by branch
	ORDER BY SUM(total) DESC) AS rank FROM WSD GROUP BY Branch, day)

SELECT 
	branch, 
	day,
	CAST(revenue AS decimal(10,2)) AS revenue 
FROM cte 
where rank =1
