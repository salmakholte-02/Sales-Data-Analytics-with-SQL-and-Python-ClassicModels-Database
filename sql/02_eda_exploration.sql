-- =========================================================
-- PART 1: EXPLORATORY DATA ANALYSIS
-- =========================================================

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Number of entities
-- ---------------------------------------------------------

-- Number of customers
SELECT COUNT(*) AS total_customers 
FROM customers;

-- ---------------------------------------------------------
-- 2. Customer distribution by country
-- Analyze the geographical distribution of customers
-- ---------------------------------------------------------
SELECT country, COUNT(*) AS number_of_customers
FROM customers
GROUP BY country
ORDER BY number_of_customers DESC;

-- ---------------------------------------------------------
-- 3. Orders distribution by status
-- Understand the lifecycle and status distribution of orders
-- ---------------------------------------------------------
SELECT status, COUNT(*) AS number_of_orders 
FROM orders 
GROUP BY status
ORDER BY number_of_orders DESC;

-- ---------------------------------------------------------
-- 4. Revenue & Average Order Value
-- Analyze revenue performance by comparing gross revenue 
-- (all orders) and actual business revenue (shipped orders), and 
-- calculate the average order value (AOV) based on completed sales.
-- ---------------------------------------------------------

-- Gross revenue (all orders, including cancelled and pending)
SELECT SUM(od.priceEach * od.quantityOrdered) AS gross_revenue
FROM orderdetails od;

-- Shipped revenue (actual business revenue)
SELECT SUM(od.priceEach * od.quantityOrdered) AS shipped_revenue
FROM orders o
JOIN orderdetails od 
  ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped';

-- Average order value (based on shipped orders only)
SELECT SUM(od.priceEach * od.quantityOrdered) / COUNT(DISTINCT o.orderNumber) AS average_order_value
FROM orders o
JOIN orderdetails od 
  ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped';

-- ---------------------------------------------------------
-- 5. Top 10 best-selling products
-- Identify the most sold products based on total quantity ordered
-- ---------------------------------------------------------
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS total_quantity_sold
FROM products p
JOIN orderdetails od
  ON p.productCode = od.productCode
GROUP BY od.productCode
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- ---------------------------------------------------------
-- 6. Top 5 customers by revenue
-- Identify the most valuable customers based on 
-- actual revenue generated from shipped orders
-- ---------------------------------------------------------
SELECT c.customerName, SUM(od.quantityOrdered * od.priceEach) AS shipped_revenue
FROM customers c
JOIN orders o
  ON o.customerNumber = c.customerNumber
JOIN orderdetails od
  ON od.orderNumber = o.orderNumber
WHERE o.status = 'Shipped'
GROUP BY c.customerNumber
ORDER BY shipped_revenue DESC
LIMIT 5;

-- ---------------------------------------------------------
-- 7. Top performing employee
-- Identify the employee who generated the highest 
-- revenue based on shipped orders
-- ---------------------------------------------------------
SELECT e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) AS employee_name, SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM employees e
JOIN customers c
  ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o
  ON o.customerNumber = c.customerNumber
JOIN orderdetails od
  ON od.orderNumber = o.orderNumber
WHERE o.status = 'Shipped'
GROUP BY e.employeeNumber
ORDER BY revenue DESC
LIMIT 1;

-- Top 10 employees by shipped revenue
SELECT e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) AS employee_name, SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM employees e
JOIN customers c
  ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o
  ON o.customerNumber = c.customerNumber
JOIN orderdetails od
  ON od.orderNumber = o.orderNumber
WHERE o.status = 'Shipped'
GROUP BY e.employeeNumber
ORDER BY revenue DESC
LIMIT 10;

-- ---------------------------------------------------------
-- 8. Most profitable product line
-- Identify the product category generating the highest revenue
-- ---------------------------------------------------------
SELECT p.productLine, SUM(od.priceEach * od.quantityOrdered) AS revenue
FROM orderdetails od
JOIN products p
    ON p.productCode = od.productCode
JOIN orders o
    ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped'
GROUP BY p.productLine
ORDER BY revenue DESC
LIMIT 1;

-- Product line revenue ranking (top 10)

SELECT p.productLine, SUM(od.priceEach * od.quantityOrdered) AS revenue
FROM orderdetails od
JOIN products p
    ON p.productCode = od.productCode
JOIN orders o
    ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped'
GROUP BY p.productLine
ORDER BY revenue DESC
LIMIT 10;