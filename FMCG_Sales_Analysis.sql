USE sales;

# Exploration of the tables
SHOW TABLES;

DESCRIBE transactions;



-- Basic Data Analysis ----------------------------


# Duration of Time
SELECT 
    MIN(date) AS Start_Date, MAX(date) AS End_Date
FROM
    date;


# Total number of transaction records.
SELECT
    count(*) AS Total_records
FROM
    transactions;
    
    
# Transactions data where market code is mark001.
SELECT 
    *
FROM
    transactions
WHERE
    market_code = 'mark001';
    
    
# How many transactions have the USD currency?
SELECT 
    *
FROM
    transactions
WHERE
    currency = "USD";
    
    
#
SELECT 
    COUNT(DISTINCT product_code) AS Num_of_unique_product
FROM
    transactions
WHERE
    market_code = 'Mark001'
ORDER BY 1;
    
    
# How many transactions happened in 2020?
SELECT 
    COUNT(*) AS Num_of_records
FROM
    transactions t
        LEFT JOIN
    date d ON t.order_date = d.date
WHERE
    d.year = 2020;
    

# How much Business happened at Chennai in 2020?
SELECT 
    m.Markets_Name, SUM(sales_amount) AS Total_Sales
FROM
    markets m
        LEFT JOIN
    transactions t ON m.markets_code = t.market_code
WHERE
    markets_name = 'Chennai'
        AND YEAR(order_date) = 2020
GROUP BY 1;
    
    

# What's the Total Revenue and Revenue Growth % throughout the all Year?
WITH Rev_Growth AS (
    SELECT
        d.Year,
        SUM(t.sales_amount) AS Total_Revenue,
        LAG(SUM(t.sales_amount)) OVER() AS Prev_Rev
    FROM
        transactions t
            LEFT JOIN
        date d ON t.order_date = d.date
    GROUP BY 1)
    
    
SELECT 
    Year,
    Total_Revenue,
    CONCAT(ROUND(((total_revenue - prev_rev) / prev_rev) * 100 , 2), ' %') AS Per_Growth
FROM 
    rev_growth;
    
    
# Sales distribution by customer_type
SELECT
    customer_type,
    SUM(sales_amount) AS Total_Sales
FROM
    customers c
        LEFT JOIN
    transactions t ON c.customer_code = t.customer_code
GROUP BY 1
ORDER BY total_sales DESC;


# Sales distribution by Year
SELECT 
    d.Year, SUM(t.sales_amount) AS Total_Revenue
FROM
    date d
        LEFT JOIN
    transactions t ON t.order_date = d.date
GROUP BY 1;


# Sales distribution by Market_Zone
SELECT 
    zone, SUM(t.sales_amount) AS Total_Revenue
FROM
    markets m
        LEFT JOIN
    transactions t ON m.markets_code = t.market_code
GROUP BY 1
ORDER BY total_revenue DESC;


# Sales distribution by product_type
SELECT 
    Product_Type, SUM(t.sales_amount) AS Total_Revenue
FROM
    products p
        LEFT JOIN
    transactions t ON p.product_code = t.product_code
GROUP BY 1
ORDER BY total_revenue DESC;