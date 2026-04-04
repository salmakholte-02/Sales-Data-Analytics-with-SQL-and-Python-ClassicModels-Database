-- =========================================================
-- SCHEMA INTROSPECTION - CLASSICMODELS DATABASE
-- Objective: Explore the database structure using SQL only
-- =========================================================

-- ---------------------------------------------------------
-- 1. Select the ClassicModels database
-- ---------------------------------------------------------
USE classicmodels;

-- ---------------------------------------------------------
-- 2. List all tables in the database
-- ---------------------------------------------------------
SHOW TABLES;

-- ---------------------------------------------------------
-- 3. Analyze table structure (example: customers)
-- ---------------------------------------------------------

-- View columns and data types
DESCRIBE customers;

-- View full table definition (keys, constraints)
SHOW CREATE TABLE customers;

-- ---------------------------------------------------------
-- 4. Identify foreign keys 
-- ---------------------------------------------------------

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'classicmodels'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

-- ---------------------------------------------------------
-- 5. Analyze indexes (example)
-- ---------------------------------------------------------
SHOW INDEX FROM orderdetails;

-- ---------------------------------------------------------
-- 6. Quick table sizes
-- ---------------------------------------------------------
SELECT
  table_name,
  table_rows
FROM information_schema.TABLES
WHERE table_schema = 'classicmodels'
ORDER BY table_name;