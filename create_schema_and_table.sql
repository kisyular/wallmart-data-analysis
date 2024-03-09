-- Drop table if exists
DROP TABLE IF EXISTS sales;

-- Create table
CREATE TABLE IF NOT EXISTS sales
(
    invoice_id              VARCHAR(30) PRIMARY KEY,
    branch                  VARCHAR(5)     NOT NULL,
    city                    VARCHAR(30)    NOT NULL,
    customer_type           VARCHAR(30)    NOT NULL,
    gender                  VARCHAR(10)    NOT NULL,
    product_line            VARCHAR(100)   NOT NULL,
    unit_price              DECIMAL(10, 2) NOT NULL,
    quantity                INT            NOT NULL,
    vat                     FLOAT          NOT NULL,
    total                   DECIMAL(10, 2) NOT NULL,
    date                    DATE           NOT NULL,
    time                    VARCHAR(50)    NOT NULL,
    payment_method          VARCHAR(15)    NOT NULL,
    cogs                    DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT,
    gross_income            DECIMAL(10, 2),
    rating                  FLOAT
);

-- Show the data in sales table
SELECT *
FROM sales;

-- Lets change the time column to time
ALTER TABLE sales
    ALTER COLUMN time TYPE time without time zone USING time::time without time zone;

-- See the data
SELECT *
FROM sales
LIMIT 10;

-- ADDITIONAL COLUMNS
-- Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This
-- will help answer the question on which part of the day most sales are made.
SELECT time,
       CASE
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:00:00' AND '18:00:00' THEN 'Afternoon'
           WHEN time BETWEEN '18:00:00' AND '20:00:00' THEN 'Evening'
           ELSE 'Night'
           END AS time_period
FROM sales;

-- Add column
ALTER TABLE sales
    ADD COLUMN time_period VARCHAR(50);

-- Insert Data
UPDATE sales
SET time_period = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '18:00:00' THEN 'Afternoon'
        WHEN time BETWEEN '18:00:00' AND '20:00:00' THEN 'Evening'
        ELSE 'Night'
        END
    );

-- See Updated data
SELECT time, time_period
FROM sales
LIMIT 10;

SELECT DISTINCT (time_period)
FROM sales;


-- Add a new column named day_name that contains the extracted days of the week on which the given transaction
-- took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each
-- branch is busiest.
ALTER TABLE sales
    ADD COLUMN day_name VARCHAR(50);

SELECT date,
       to_char(date, 'Day') AS day_name
FROM sales;

UPDATE sales
SET day_name = to_char(date, 'Day');

-- See updated data
SELECT date, day_name
FROM sales
LIMIT 10;

-- Add a new column named month_name that contains the extracted months of the year on which the given
-- transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and
-- profit.

ALTER TABLE sales
    ADD COLUMN month_name VARCHAR(50);

SELECT date,
       to_char(date, 'Month') AS month_name
FROM sales;

UPDATE sales
SET month_name = to_char(date, 'Month');

-- See updated data
SELECT date, month_name
FROM sales
LIMIT 10;

-- Exploratory Data Analysis (EDA):

-- GENERIC QUESTIONS
-- How many unique cities does the data have?
SELECT DISTINCT (city)
FROM sales;
-- In which city is each branch?
SELECT DISTINCT (city), branch
FROM sales;

-- PRODUCT QUESTIONS
-- How many unique product lines does the data have?
SELECT DISTINCT (product_line)
FROM sales;

-- What is the most common payment method?
SELECT payment_method, COUNT(payment_method) AS payment_method_count
FROM sales
GROUP BY payment_method
ORDER BY payment_method_count DESC;

-- What is the most selling product line?
SELECT product_line, COUNT(product_line) AS product_line_count
FROM sales
GROUP BY product_line
ORDER BY product_line_count DESC;
-- What is the total revenue by month?
SELECT month_name, SUM(total) AS total_per_month
FROM sales
GROUP BY month_name
ORDER BY total_per_month DESC;

-- What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if it's
-- greater than average sales
SELECT product_line,
       CASE WHEN SUM(quantity) > (SELECT AVG(quantity) FROM sales) THEN 'Good' ELSE 'Bad' END AS sales_quality
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold?
SELECT branch, SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(*) AS count
FROM sales
GROUP BY gender, product_line
ORDER BY count DESC;

-- What is the average rating of each product line?
SELECT product_line, AVG(rating) AS average_rating
FROM sales
GROUP BY product_line;


-- SALES QUESTIONS

-- Number of sales made in each time of the day per weekday
SELECT day_name, time_period, COUNT(*) AS sales_count
FROM sales
GROUP BY day_name, time_period
ORDER BY day_name, time_period;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, MAX(vat) AS largest_vat
FROM sales
GROUP BY city;

-- Which customer type pays the most in VAT?
SELECT customer_type, SUM(vat) AS total_vat
FROM sales
GROUP BY customer_type
ORDER BY total_vat DESC;


-- CUSTOMER QUESTIONS

-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types
FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type, SUM(quantity) AS total_quantity
FROM sales
GROUP BY customer_type
ORDER BY total_quantity DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC;

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS count
FROM sales
GROUP BY branch, gender
ORDER BY branch, count DESC;

-- Which time of the day do customers give most ratings?
SELECT time_period, AVG(rating) AS average_rating
FROM sales
GROUP BY time_period
ORDER BY average_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT branch, time_period, AVG(rating) AS average_rating
FROM sales
GROUP BY branch, time_period
ORDER BY branch, average_rating DESC;
-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS average_rating
FROM sales
GROUP BY day_name
ORDER BY average_rating DESC;
-- Which day of the week has the best average ratings per branch?
SELECT branch, day_name, AVG(rating) AS average_rating
FROM sales
GROUP BY branch, day_name
ORDER BY branch,average_rating DESC;



















































































