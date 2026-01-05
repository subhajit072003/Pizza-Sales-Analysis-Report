
-- =====================================================
-- PIZZA SALES ANALYSIS
-- =====================================================
-- This file contains all SQL queries used to calculate
-- KPIs and generate insights for the Pizza Sales
-- Analysis Dashboard (Excel + SQL + Power BI)
-- =====================================================


-- =====================================================
-- TABLE CREATION
-- =====================================================
-- 
CREATE TABLE pizza_sales (
    pizza_id serial primary key,
    order_id INT,
    pizza_name_id text,
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price numeric,
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(20),
    pizza_category VARCHAR(50),
    pizza_ingredients text,
    pizza_name VARCHAR(100)
   
);


-- =====================================================
-- KPI METRICS
-- =====================================================

-- 1. TOTAL REVENUE
SELECT 
    SUM(total_price) AS total_revenue
FROM pizza_sales;


-- 2. AVERAGE ORDER VALUE
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id) AS average_order_value
FROM pizza_sales;


-- 3. TOTAL PIZZAS SOLD
SELECT 
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales;


-- 4. TOTAL ORDERS
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;


-- 5. AVERAGE PIZZAS PER ORDER
SELECT 
    cast(cast(SUM(quantity) as decimal(10,2))/ cast(COUNT(DISTINCT order_id) AS decimal(10,2))
    as decimal(10,2))
     as average_pizzas_per_order
FROM pizza_sales;


-- =====================================================
-- TREND ANALYSIS (FOR CHARTS)
-- =====================================================

-- 6. DAILY TREND FOR TOTAL ORDERS
SELECT 
    to_char(order_date,'Day') AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY to_char(order_date,'Day');



-- 7. MONTHLY TREND FOR TOTAL ORDERS
SELECT 
    to_char(order_date,'Month') AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_month
ORDER BY total_orders DESC;


-- =====================================================
-- SALES DISTRIBUTION ANALYSIS
-- =====================================================

-- 8. PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT 
    pizza_category,
    SUM(total_price) AS category_sales,
    cast(
        (SUM(total_price) / 
        (SELECT SUM(total_price) FROM pizza_sales)) * 100
        as decimal(10,2))
        
     AS percentage_sales_by_category
FROM pizza_sales
GROUP BY pizza_category;




-- 9. PERCENTAGE OF SALES BY PIZZA SIZE
SELECT 
    pizza_size,
        SUM(total_price) as total_sales,
        cast((sum(total_price)/ 
        (SELECT SUM(total_price) FROM pizza_sales))*100
        as decimal(10,2))
as percentage_sales_by_size
FROM pizza_sales
GROUP BY pizza_size;





-- 10. TOTAL PIZZAS SOLD BY PIZZA CATEGORY
SELECT 
    pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_quantity DESC;


-- =====================================================
-- BEST & WORST SELLERS ANALYSIS
-- =====================================================

-- 11. TOP 5 BEST SELLERS BY REVENUE
SELECT 
    pizza_name,
    SUM(total_price) AS revenue,
    sum(quantity) as total_quantity,
    count(distinct order_id) as total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;





-- 12. BOTTOM 5 SELLERS BY REVENUE
SELECT 
    pizza_name,
    SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue ASC
LIMIT 5;


-- 13. BOTTOM 5 SELLERS BY TOTAL QUANTITY
SELECT 
    pizza_name,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;


-- 14. BOTTOM 5 SELLERS BY TOTAL ORDERS
SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;


