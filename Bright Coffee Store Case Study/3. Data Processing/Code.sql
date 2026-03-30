-------------------------------------------------------------------------
---1. Query to check if the table is loaded correctly 
-------------------------------------------------------------------------
select * from `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--2.Checking the date range
-------------------------------------------------------------------------
--Data collection start date? (2023-01-01)

SELECT MIN(transaction_date) AS start_date
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--3.What is the last date for data collection? (2023-06-01)
-------------------------------------------------------------------------

SELECT MAX(transaction_date) AS latest_date
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--4.Checking the names of store location
-- There are 3 store locations; Lower Manhattan, Hell's Kitchen and Astoria
-------------------------------------------------------------------------

SELECT DISTINCT store_location,
                store_id
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--5. Checking products sold at each store
-------------------------------------------------------------------------
SELECT DISTINCT product_category
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--6. Checking product types sold at our stores, there are 29 product types
-------------------------------------------------------------------------
SELECT DISTINCT product_type
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--7. Checking product types sold at our stores, there are 80 different product details
-------------------------------------------------------------------------
SELECT DISTINCT product_detail
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--8.Checking for NULLs
-------------------------------------------------------------------------
SELECT *
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
WHERE unit_price IS NULL
OR transaction_qty IS NULL
OR transaction_date IS NULL;

-------------------------------------------------------------------------
--9.Checking lowest and highest unit price
-------------------------------------------------------------------------

SELECT MIN(unit_price) AS Lowest_unit_price,
       MAX(unit_price) AS Highest_unit_price
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--10.Checking average price per unit
-------------------------------------------------------------------------
SELECT product_category,
       AVG(unit_price) AS Average_Price
FROM`brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category
ORDER BY Average_Price DESC;


-------------------------------------------------------------------------
--10.Checking store trasactional data
-------------------------------------------------------------------------
SELECT DISTINCT store_location,
                COUNT (transaction_id) AS transaction_Count
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location
ORDER BY transaction_Count DESC;

-------------------------------------------------------------------------
--11.Check total_amount by store_location
-------------------------------------------------------------------------
SELECT DISTINCT store_location,
        SUM (unit_price * transaction_qty) AS total_amount
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location
ORDER BY total_amount DESC;

---PRODUCT ANALYSIS
-------------------------------------------------------------------------
--12. Check which products are sold across each store
-------------------------------------------------------------------------
SELECT DISTINCT product_category
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--13.Checking which product information in the dataset
-------------------------------------------------------------------------
SELECT DISTINCT product_category AS category,
                product_detail AS product_name
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--14.Checking which product information in the dataset
-------------------------------------------------------------------------
SELECT DISTINCT product_type
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--15.Checking which product information in the dataset
-------------------------------------------------------------------------
SELECT DISTINCT product_category AS category,
                product_type,
                product_detail AS product_name
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--16.product count to retrieve products that are most purchased
-------------------------------------------------------------------------
SELECT product_category,
       COUNT(product_id) AS number_of_transactions
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category
ORDER BY number_of_transactions DESC;

-------------------------------------------------------------------------
--17.Top 5 products that have generated the highest revenue
-------------------------------------------------------------------------
SELECT DISTINCT product_type, 
                MAX(unit_price * transaction_qty) AS max_total_Revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_type
ORDER BY max_total_Revenue DESC
LIMIT 1;

-------------------------------------------------------------------------
--18.Top 5 products that have generated the lowest revenue
-------------------------------------------------------------------------
SELECT DISTINCT product_type, 
                MIN(unit_price * transaction_qty) AS min_total_Revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_type
ORDER BY min_total_Revenue ASC
LIMIT 1;

-------------------------------------------------------------------------
--19.Extracting the day and month names
-------------------------------------------------------------------------
SELECT 
      transaction_date,
      Dayname(transaction_date) AS Day_name,
      Monthname(transaction_date) AS Month_name
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--20. Calculating revenue by rows
-------------------------------------------------------------------------
SELECT unit_price,
       transaction_qty,
       unit_price*transaction_qty AS Revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;

-------------------------------------------------------------------------
--21.Total sales generated by each product
-------------------------------------------------------------------------
SELECT product_category,
       SUM(unit_price * transaction_qty) AS product_revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category
ORDER BY product_revenue DESC;

-------------------------------------------------------------------------
--22.Total sales generated 
-------------------------------------------------------------------------
SELECT SUM(unit_price * transaction_qty) AS Total_Revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;


--23. Combining functiuons to get a clean and enhanced data set
SELECT transaction_id,
       transaction_date,
       transaction_time,
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,
-- 24.Adding columns to enhance the table for better insights
      Dayname(transaction_date) AS Day_name,
      Monthname(transaction_date) AS Month_name,
      Dayofmonth(transaction_date) AS Date_of_month,
CASE 
    WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
    ELSE 'Weekday'
END AS Day_classification,

CASE 
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN  '01.Early Morning Rush'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN  '02.Mid Morning'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN  '03.Afternoon'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '17:59:59' THEN  '04.Late Afternoon Rush'
    ELSE '05.Evening'
END AS Time_classification,

--25.Spend buckets
CASE 
    WHEN (transaction_qty*unit_price)<= 50 THEN 'Low_Spend'
    WHEN (transaction_qty*unit_price) BETWEEN 51 AND 200 THEN 'Medium_Spend'
    WHEN (transaction_qty*unit_price) BETWEEN 201 AND 300 THEN 'High_Spend'
ELSE 'Top_Spend'
END AS Spend_Bucket,

--26.Final column Revenue
   transaction_qty*unit_price AS Revenue
FROM `brightlight`.`default`.`bright_coffee_shop_analysis`;
