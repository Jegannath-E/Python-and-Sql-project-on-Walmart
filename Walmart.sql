use walmart_db;
show tables;
select * from walmart;
select
      payment_method,
      count(*) as no_of_payments,
      SUM(quantity) as no_qty_sold
from walmart
group by payment_method

SELECT * 
FROM (
    SELECT branch, 
           category, 
           AVG(rating) AS avg_rating, 
           RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS `rank`
    FROM walmart
    GROUP BY branch, category
) AS ranked 
WHERE `rank` = 1;
#Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS 'rank'
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE 'rank' = 1;

#Calculate the total quantity of items sold per payment method

Select
      payment_method,
      SUM(quantity) as no_of_qty_sold
From walmart
GROUP BY payment_method; 	

#Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;

#Q6: Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

# Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS 'rank'
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE 'rank' = 1;

# Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

