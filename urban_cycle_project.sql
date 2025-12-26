CREATE DATABASE urban_cycle_project;
SHOW databases;
USE urban_cycle_project;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(20) -- East, West, North, South
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) -- 'Completed', 'Returned', 'Cancelled'
);
CREATE TABLE inventory (
    warehouse_id VARCHAR(10),
    product_id INT,
    stock_level INT,
    region_served VARCHAR(20)
);
INSERT INTO products VALUES 
(1, 'Speedster Road Bike', 'Road Bike', 1200.00),
(2, 'TrailMaster Mountain Bike', 'Mountain Bike', 1500.00),
(3, 'City Commuter', 'Hybrid', 600.00),
(4, 'Helmet', 'Accessories', 50.00);
INSERT INTO customers VALUES 
(101, 'Alice', 'East'), (102, 'Bob', 'West'), (103, 'Charlie', 'East'), (104, 'Diana', 'North');
INSERT INTO orders VALUES (1, 101, 2, '2023-07-10', 1, 1500.00, 'Completed');
INSERT INTO orders VALUES (2, 102, 1, '2023-07-12', 1, 1200.00, 'Completed');
INSERT INTO orders VALUES (3, 103, 2, '2023-07-15', 1, 1500.00, 'Completed');
INSERT INTO orders VALUES (4, 101, 2, '2023-08-05', 1, 1500.00, 'Completed');
INSERT INTO orders VALUES (5, 104, 3, '2023-08-10', 2, 1200.00, 'Completed');
INSERT INTO orders VALUES (6, 103, 2, '2023-08-20', 1, 1500.00, 'Completed');
INSERT INTO orders VALUES (7, 102, 1, '2023-09-02', 1, 1200.00, 'Completed'); 
INSERT INTO orders VALUES (8, 104, 3, '2023-09-05', 1, 600.00, 'Completed'); 
INSERT INTO orders VALUES (9, 101, 4, '2023-09-10', 1, 50.00, 'Completed'); 
INSERT INTO inventory VALUES ('WH-East', 2, 0, 'East'); 
INSERT INTO inventory VALUES ('WH-West', 2, 50, 'West');
SELECT p.name, SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 8 THEN o.total_amount ELSE 0 END) as aug_sales,
SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 9 THEN o.total_amount ELSE 0 END) as sept_sales,
(SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 9 THEN o.total_amount ELSE 0 END) - 
SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 8 THEN o.total_amount ELSE 0 END)) as diff
FROM orders o JOIN products p ON o.product_id = p.product_id WHERE o.status = 'Completed' GROUP BY 1 ORDER BY diff ASC;
SELECT c.region, COUNT(o.order_id) as mountain_bike_orders FROM orders o JOIN customers c ON o.customer_id = c.customer_id 
JOIN products p ON o.product_id = p.product_id WHERE p.name = 'TrailMaster Mountain Bike' AND o.order_date >= '2023-08-01' GROUP BY 1;
SELECT i.region_served,p.name, i.stock_level FROM inventory i JOIN products p ON i.product_id = p.product_id 
WHERE p.name = 'TrailMaster Mountain Bike';
DROP DATABASE urban_cycle_project;