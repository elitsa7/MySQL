-- 1
SELECT department_id, 
COUNT(first_name) AS 'Number of employees'
FROM employees
GROUP BY department_id;
-- 2
SELECT department_id, ROUND(AVG(salary), 2) AS 'Average Salary'
FROM employees
GROUP BY department_id;
-- 3
SELECT department_id, ROUND(MIN(salary),2) AS 'Min Salary'
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 800;
-- 4
-- id 2 appetizers
SELECT COUNT(id) AS 'appetizers'
FROM products
WHERE category_id = 2 AND price > 8;
-- 5
SELECT category_id,ROUND(AVG(price), 2) AS 'Average Price', MIN(price) AS 'Cheapest Product',MAX(price) AS 'Most Expensive Product'
FROM products
GROUP BY category_id;