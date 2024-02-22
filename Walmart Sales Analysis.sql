CREATE DATABASE salesdatawallmart;

USE salesdatawallmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


DESCRIBE sales;

SELECT * FROM sales;





-- -------------------------------FEATURE ENGINEERING------------------------------------
-- ----------------------------------------------------------------------------------------- 

SELECT time,
   (CASE  
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END) AS time_of_day
FROM sales;
        
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20); 



-- For this to work turn off safe mode for update-----
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to serve-- 

UPDATE sales
SET time_of_day=(
    CASE  
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "evening"
	END
);

-- Add day_name column------------------------------------------------------------ 
SELECT
	date,
	DAYNAME(date)
FROM sales;


ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);




UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column------------------------------------------------- 
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);




 -- --How many unique cities does the data have?-- 
 
SELECT DISTINCT city FROM sales;
 
 -- In which city is each branch?--
 
 SELECT DISTINCT city,branch FROM sales;
 
 
--  ----------------------------------PRODUCT---------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
 -- How many unique product lines does the data have?--
 
SELECT DISTINCT product_line FROM sales;

select * from sales;



-- What is the most selling product line--

SELECT SUM(quantity),product_line FROM sales
GROUP BY product_line
ORDER BY SUM(quantity)  DESC;





-- What is the total revenue by month--

SELECT month_name,SUM(total) AS total_revenue FROM sales
GROUP BY month_name
ORDER BY total_revenue;


-- What month had the largest COGS?--


SELECT month_name,SUM(cogs) AS cogs FROM sales
GROUP BY month_name
ORDER BY cogs DESC;


-- What product line had the largest revenue?--

SELECT product_line,SUM(total) AS total_revenue FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- Which is the branch,city with the largest revenue?--

SELECT branch, city,SUM(total) AS total_revenue FROM sales
GROUP BY branch,city
ORDER BY total_revenue DESC;


-- What product line had the largest VAT?--

SELECT product_line,AVG(VAT) AS avg_tax FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

SELECT * FROM sales;

SELECT
	product_line,
	AVG(vat) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- -- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales--

SELECT AVG(total) FROM sales;
SELECT product_line,total, 
	CASE 
      WHEN total>(SELECT AVG(total) FROM sales) THEN "good" 
	  ELSE "BAD"
   END as good_bad_product
FROM sales;  

SELECT * FROM sales;
 
-- which branch sold more product than avrg products sold?--


SELECT AVG(quantity) FROM sales;

SELECT branch,SUM(quantity) AS qty FROM sales
GROUP BY branch
ORDER BY qty DESC;


-- what is the most common product by gender?--

SELECT product_line,gender,COUNT(gender) FROM sales
GROUP BY gender,product_line
ORDER BY COUNT(gender) DESC;


-- what is the average rating of each product_line?--


SELECT product_line , AVG(rating) FROM sales
GROUP BY product_line
ORDER BY AVG(rating);


-- ------------------------------------ Sales-------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

-- number of sales made in each time of the day per weekday?--

SELECT day_name,time_of_day,SUM(quantity) FROM sales
GROUP BY day_name,time_of_day
ORDER BY SUM(quantity) DESC;

-- which of the customer types brings the most revenue?--


SELECT customer_type,SUM(total) FROM sales
GROUP BY customer_type
ORDER BY SUM(total) DESC;

-- which city has the largest tax percent / VAT ( value added tax)?--

SELECT city,AVG(vat) FROM sales
GROUP BY city
ORDER BY AVG(vat) DESC;

-- which customer_type pays the most in VAT?--

SELECT customer_type,AVG(vat) FROM sales
GROUP BY customer_type 
ORDER BY AVG(vat) DESC;


-- -----------------------------------------------Customer----------------------------------------------
-- -----------------------------------------------------------------------------------------------------

-- how many unique customer_types does the data have and its counts?


SELECT DISTINCT customer_type AS customer_type,COUNT(customer_type) AS count FROM sales
GROUP BY customer_type
ORDER BY count DESC;


-- how many unique payment methods does the data have?--


SELECT DISTINCT payment_method FROM sales;


 -- what is the most customer type?--
 
SELECT DISTINCT customer_type AS customer_type,COUNT(customer_type) AS count FROM sales
GROUP BY customer_type
ORDER BY count DESC;

 -- which customer type buys the most?--
 
 
 SELECT customer_type,COUNT(*) FROM sales
 GROUP BY customer_type
 ORDER BY COUNT(*);
 
  -- what is the gender of the most of the customers?--
  
  SELECT gender,COUNT(*) FROM sales
  GROUP BY gender
  ORDER BY COUNT(*);

-- --what is the gender distribution per  branch?--
  SELECT * FROM sales;
  
  SELECT branch,gender,COUNT(*) FROM sales
  GROUP BY gender,branch
  ORDER BY branch;
  
  
  -- what time of the day do customers give most ratings?--
  
  SELECT COUNT(rating),time_of_day FROM sales
  GROUP BY time_of_day
  ORDER BY COUNT(rating) DESC;
  
  -- which day of the week has the best average ratings?--
  
  SELECT day_name,AVG(rating) FROM sales
  GROUP BY day_name
  ORDER BY AVG(rating) DESC;
  
  
  -- which day of the week has the best average ratings per branch?--
  
  SELECT day_name,branch,AVG(rating) FROM sales
  GROUP BY day_name,branch
  ORDER BY branch,AVG(rating) DESC;
  
  
  


  
 
















       


