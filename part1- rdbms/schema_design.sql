 -- assignmnet
 

CREATE DATABASE order_data;
USE order_data;





CREATE TABLE sales_reps (
sales_rep_id VARCHAR(10) NOT NULL, 
sales_rep_name VARCHAR(100) NOT NULL,
sales_rep_email VARCHAR(120),
office_address VARCHAR(200),

CONSTRAINT pk_sales_reps
PRIMARY KEY (sales_rep_id)
);





CREATE TABLE customers (
customer_id VARCHAR(10) NOT NULL, 
customer_name VARCHAR(100) NOT NULL,
customer_email VARCHAR(120) NOT NULL,
customer_city VARCHAR(60),

CONSTRAINT pk_customers
PRIMARY KEY (customer_id)
);





CREATE TABLE products (
product_id VARCHAR(10) NOT NULL,
product_name VARCHAR(120) NOT NULL,
category  VARCHAR(80),
unit_price DECIMAL (10,2) NOT NULL,

CONSTRAINT pk_products
PRIMARY KEY (product_id)
);





CREATE TABLE orders (
order_id VARCHAR(12) NOT NULL,
customer_id VARCHAR(10) NOT NULL,
sales_rep_id VARCHAR(10),
order_date DATE,

CONSTRAINT pk_orders
PRIMARY KEY (order_id),

CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id),

CONSTRAINT fk_orders_sales_rep
FOREIGN KEY (sales_rep_id)
REFERENCES sales_reps(sales_rep_id)
);




CREATE TABLE order_items (
order_id VARCHAR(12) NOT NULL,
product_id VARCHAR(10) NOT NULL,
quantity INT NOT NULL,

CONSTRAINT  pk_order_items
PRIMARY KEY (order_id, product_id),

CONSTRAINT fk_orderitems_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id),

CONSTRAINT  fk_orderitems_product
FOREIGN KEY (product_id)
REFERENCES products(product_id)
);






INSERT INTO sales_reps
SELECT sales_rep_id,MAX(sales_rep_name),MAX(sales_rep_email), MAX(office_address)
FROM orders_flat
GROUP BY sales_rep_id;


INSERT INTO customers
SELECT customer_id, MAX(customer_name), MAX(customer_email),MAX(customer_city)
FROM orders_flat
GROUP BY customer_id;


INSERT INTO products
SELECT product_id, MAX(product_name),MAX(category), MAX(unit_price)
FROM orders_flat
GROUP BY product_id;


INSERT INTO orders
SELECT order_id, MAX(customer_id), MAX(sales_rep_id),MAX(order_date)
FROM orders_flat
GROUP BY order_id;


INSERT INTO order_items (order_id, product_id, quantity)
SELECT DISTINCT order_id, product_id, quantity
FROM orders_flat;














