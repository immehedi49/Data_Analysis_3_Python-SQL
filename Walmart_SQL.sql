SELECT * FROM walmart;

SELECT COUNT(*) FROM walmart;

SELECT 
	 "payment_method",COUNT(*)
FROM walmart
GROUP BY "payment_method";

SELECT 
	COUNT(DISTINCT "Branch") 
FROM walmart;

SELECT MIN(quantity) as "Minimum" FROM walmart;

--Find different payment method and number of transactions, number of quantity sold
SELECT 
	 payment_method,
	 COUNT(*) as "No_payments",
	 SUM(quantity) as "No_quantity_sold"
FROM walmart
GROUP BY payment_method;

-- Identify the highest-rated category in each branch, displaying the branch, category, AVG rating
SELECT * 
FROM
(	SELECT 
		"Branch",
		category,
		AVG(rating) as "Avg_rating",
		RANK() OVER(PARTITION BY "Branch" ORDER BY AVG(rating) DESC) as "Rank"
	FROM walmart
	GROUP BY 1, 2
)
WHERE "Rank" = 1

-- Identify the busiest day for each branch based on the number of transactions
SELECT * 
FROM
	(SELECT 
		"Branch",
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as "Day_name",
		COUNT(*) as "No_transactions",
		RANK() OVER(PARTITION BY "Branch" ORDER BY COUNT(*) DESC) as "Rank"
	FROM walmart
	GROUP BY 1, 2
	)
WHERE "Rank" = 1

-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT 
	 payment_method,
	  COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.
SELECT 
	"City",
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2

-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.
WITH cte 
AS
(SELECT 
	"Branch",
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY "Branch" ORDER BY COUNT(*) DESC) as "Rank"
FROM walmart
GROUP BY 1, 2
)
SELECT *
FROM cte
WHERE "Rank" = 1

-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices
SELECT
	"Branch",
CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC

--Top 3 Categories by Sales Quantity
SELECT
    category,
    SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Monthly Revenue Trend for Each Branch in 2019
SELECT
    "Branch",
    EXTRACT(MONTH FROM TO_DATE(date, 'DD/MM/YY')) AS month_number,
    SUM(CAST(REPLACE(unit_price, '$', '') AS NUMERIC) * quantity) AS total_monthly_revenue -- Corrected line: REPLACE '$' before CAST
FROM
    walmart
WHERE
    EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2019
GROUP BY
    "Branch",
    month_number
ORDER BY
    "Branch",
    month_number;