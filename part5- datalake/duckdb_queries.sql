-- ============================================================
-- PART 5 — DATA LAKES WITH DUCKDB
-- Q5.1   — CROSS FORMAT QUERIES
-- ============================================================

-- Reset views so the script can be run multiple times safely
DROP VIEW IF EXISTS customers;
DROP VIEW IF EXISTS orders;
DROP VIEW IF EXISTS products;
 
-- Create views as readable aliases over the raw files
-- This avoids repeating the full read_* function in every query
CREATE VIEW customers AS
SELECT * FROM read_csv_auto('../datasets/customers.csv');
 
CREATE VIEW orders AS
SELECT * FROM read_json_auto('../datasets/orders.json');
 
CREATE VIEW products AS
SELECT * FROM read_parquet('../datasets/products.parquet');
 
-- ============================================================
-- Q1: List all customers along with the total number of
--     orders they have placed
-- ============================================================

SELECT
    c.customer_id,
    c.name,
    c.city,
    COALESCE(COUNT(o.order_id), 0)        AS total_orders,
    DENSE_RANK() OVER (
        ORDER BY COUNT(o.order_id) DESC
    )                                      AS order_rank
FROM read_csv_auto('../datasets/customers.csv') c
LEFT JOIN read_json_auto('../datasets/orders.json') o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name,
    c.city
ORDER BY total_orders DESC, c.name ASC;

-- ============================================================
-- Q2: Find the top 3 customers by total order value
-- ============================================================
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.name,
        c.city,
        SUM(o.total_amount)   AS total_spent,
        COUNT(o.order_id)     AS num_orders,
        ROUND(
            SUM(o.total_amount) * 1.0 / COUNT(o.order_id),
            2
        )                     AS avg_order_value
    FROM read_csv_auto('../datasets/customers.csv') c
    INNER JOIN read_json_auto('../datasets/orders.json') o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.name,
        c.city
)
SELECT
    customer_id,
    name,
    city,
    total_spent,
    num_orders,
    avg_order_value
FROM customer_spend
ORDER BY total_spent DESC
LIMIT 3;

-- ============================================================
-- Q3: List all products purchased by customers from Bangalore
-- ============================================================
WITH bangalore_customers AS (
    SELECT customer_id, name AS customer_name
    FROM read_csv_auto('../datasets/customers.csv')
    WHERE UPPER(city) = 'BANGALORE'
),
bangalore_orders AS (
    SELECT
        bc.customer_name,
        o.order_id,
        o.order_date,
        o.status
    FROM bangalore_customers bc
    INNER JOIN read_json_auto('../datasets/orders.json') o
        ON bc.customer_id = o.customer_id
)
SELECT
    bo.customer_name,
    bo.order_id,
    bo.order_date,
    bo.status,
    p.product_name,
    p.category,
    p.quantity,
    p.unit_price,
    p.total_price
FROM bangalore_orders bo
INNER JOIN read_parquet('../datasets/products.parquet') p
    ON bo.order_id = p.order_id
ORDER BY
    bo.order_date,
    p.product_name;

-- ============================================================
-- Q4: Join all three files to show:
--     customer name, order date, product name, and quantity
-- ============================================================
SELECT
    c.name                  AS customer_name,
    c.city,
    o.order_date,
    o.status,
    p.product_name,
    p.category,
    p.quantity,
    p.unit_price,
    p.total_price
FROM read_csv_auto('../datasets/customers.csv') c
INNER JOIN read_json_auto('../datasets/orders.json') o
    ON c.customer_id = o.customer_id
INNER JOIN read_parquet('../datasets/products.parquet') p
    ON o.order_id = p.order_id
ORDER BY
    o.order_date ASC,
    c.name ASC;