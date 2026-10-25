# 🛒 Walmart Sales Analysis – SQL Project

An end-to-end SQL analysis of Walmart sales data using **Microsoft SQL Server (SSMS)**. The project imports one CSV file, adds new time-based columns, and answers 26 business questions about products, sales, and customers. The repo includes my own solution and a reference solution from my mentor.

---

## 🗂️ Repository Structure

| File | Description |
|------|-------------|
| `WalmartSalesData.csv` | Raw sales dataset (one row per sale) |
| `Question.txt` | The list of questions solved in this project |
| `Arun_Wsol.sql` | My own solution |
| `WalmartSalesProject.sql` | Reference solution provided by my mentor |
| `README.md` | Project documentation |

> ⚠️ Rename the files above to match the exact names and extensions in your repo.

---

## 📋 Dataset Overview

**Source file:** `WalmartSalesData.csv`

| Column | Description | Values / Notes |
|--------|-------------|----------------|
| `Branch` | Store branch | A, B, C |
| `City` | City of the branch | Yangon (A), Mandalay (B), Naypyitaw (C) |
| `Customer type` | Type of customer | Member, Normal |
| `Gender` | Customer gender | Female, Male |
| `Product line` | Product category | Health and beauty, Electronic accessories, Home and lifestyle, Sports and travel, Food and beverages, Fashion accessories |
| `Unit price` | Price per unit | Numeric |
| `Quantity` | Units purchased | Numeric |
| `Tax 5%` | 5% VAT amount | Numeric |
| `Total` | Total including tax | Numeric |
| `Date` | Date of sale | Date |
| `Time` | Time of sale | Time |
| `Payment` | Payment method | Ewallet, Cash, Credit card |
| `cogs` | Cost of goods sold | Numeric |
| `gross margin percentage` | Gross margin % | Numeric |
| `gross income` | Gross income | Numeric |
| `Rating` | Customer rating | Numeric |

> When the CSV is imported into SQL Server, column names with spaces become underscores (for example `Customer type` → `Customer_type`, `Tax 5%` → `Tax_5`). Check the exact names in your table.

### Derived Columns (added with `ALTER TABLE` + `UPDATE`)

| Column | Description |
|--------|-------------|
| `month_number` | Month number extracted from `Date` |
| `week_number` | Day-of-week number from `Date` |
| `day` | Day of the month from `Date` |
| `time_of_day` | Morning / Afternoon / Evening, based on the hour of `Time` |
| `week_day` | Weekday name (Monday, Tuesday, …) |

---

## ⚙️ Setup Instructions

1. Open **SQL Server Management Studio (SSMS)**.
2. Create the database:
   ```sql
   CREATE DATABASE walmart;
   USE walmart;
   ```
3. Right-click the database → **Tasks → Import Flat File**, select `WalmartSalesData.csv`, and name the table `WSD`.
4. Check data types: `Date` as `date`, `Time` as `time`, and numeric columns as `decimal` / `int`.
5. Open a solution file and run it from top to bottom. The `ALTER` and `UPDATE` statements that create the derived columns must run first.

---

## ❓ Questions Solved

### 🔹 Generic
1. How many unique cities are present in the dataset?
2. Which city is associated with each store branch?

### 🔹 Product Analysis
1. How many unique product lines are available?
2. What is the most commonly used payment method?
3. Which product line has the highest number of units sold?
4. What is the total revenue generated in each month?
5. In which month was the cost of goods sold (COGS) the highest?
6. Which product line generated the most revenue?
7. Which city recorded the highest total revenue?
8. Which product line had the highest average VAT?
9. Classify each product line as "Good" or "Bad" based on sales volume vs the average.
10. Which branch sold more products than the average?
11. For each gender, which product line is purchased the most?
12. What is the average customer rating for each product line?

### 🔹 Sales Analysis
1. How many sales were made during each time of day for every day of the week?
2. Which customer type contributes the most revenue?
3. Which city has the highest average VAT?
4. Which customer type pays the most VAT on average?

### 🔹 Customer Analysis
1. How many unique customer types are present?
2. How many different payment methods are used?
3. What is the most common customer type?
4. Which customer type makes the most purchases?
5. What is the gender distribution among customers?
6. How does gender distribution vary across branches?
7. During which time of day do customers give the highest average ratings?
8. During which time of day do customers in each branch give the best ratings?
9. On which day of the week do customers give the best average ratings?
10. For each branch, which day receives the highest sales?

---

## 🛠️ SQL Concepts Used

- Feature engineering: `ALTER TABLE`, `UPDATE`, `CASE WHEN`
- Date functions: `MONTH()`, `DAY()`, `DATEPART()`, `DATENAME()`
- Aggregates: `SUM()`, `AVG()`, `COUNT()`, `COUNT(DISTINCT …)`
- `GROUP BY`, `HAVING`, `ORDER BY`, `TOP`
- Subqueries
- CTEs and window functions (`ROW_NUMBER() OVER (PARTITION BY …)`)
- `CAST()` for clean numeric output

---

## 💡 Sample Query

**Highest-sales weekday for each branch**

```sql
WITH cte AS (
    SELECT Branch, week_day, SUM(total) AS revenue,
           ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY SUM(total) DESC) AS rnk
    FROM WSD
    GROUP BY Branch, week_day
)
SELECT Branch, week_day, CAST(revenue AS decimal(10,2)) AS revenue
FROM cte
WHERE rnk = 1;
```

---

## 🔍 My Solution vs Mentor Solution

- `Arun_Wsol.sql` is my own approach to all the questions.
- `WalmartSalesProject.sql` is the reference solution from my mentor.
- Comparing the two helped me see different ways to write the same logic, such as how to classify time of day, rank results per group, and compare against averages.

---

## 📊 Key Insights

> Fill this in after running the queries with your actual results.

- **Top product line by revenue:** _your value_
- **Top city by revenue:** _your value_
- **Most common payment method:** _your value_
- **Highest-revenue month:** _your value_
- **Customer type contributing the most revenue:** _your value_
- **Best day / time for customer ratings:** _your value_

---

## 🚀 How to Use This Repo

1. Clone the repository.
2. Import `WalmartSalesData.csv` into SQL Server as table `WSD`.
3. Run `Arun_Wsol.sql` or `WalmartSalesProject.sql` in SSMS.
4. Compare the outputs and note your findings in Key Insights.

---

## 👤 Author

**Arun**
Data & Accounts Analyst | Excel · SQL · Python · Power BI

Feedback and suggestions are welcome.
