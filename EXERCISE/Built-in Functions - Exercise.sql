-- PART ONE
-- 1
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;
-- 2
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;
-- 3
SELECT first_name FROM employees
WHERE department_id IN (3,10) 
AND (SELECT YEAR(hire_date)) >= 1995 
AND (SELECT YEAR(hire_date)) <= 2005
ORDER BY employee_id;
-- 4
SELECT first_name, last_name FROM employees
WHERE NOT job_title LIKE '%engineer%'
ORDER BY employee_id;
-- 5
SELECT name FROM towns
WHERE LENGTH (name) = 5 OR LENGTH (name) = 6
ORDER BY name;
-- 6
SELECT town_id, name FROM towns
WHERE name LIKE 'M%' OR name LIKE 'K%' OR name LIKE 'B%' OR name LIKE 'E%'
ORDER BY name;
-- 7
SELECT town_id, name FROM towns
WHERE NOT (name LIKE 'D%' OR name LIKE 'R%' OR name LIKE 'B%') 
ORDER BY name;
-- 8
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees
WHERE (SELECT YEAR (hire_date) > 2000);
SELECT * FROM v_employees_hired_after_2000;
-- 9
SELECT first_name, last_name FROM employees
WHERE LENGTH(last_name) = 5;
-- PART TWO
-- 10
SELECT country_name, iso_code FROM countries
WHERE LENGTH(country_name) - LENGTH(REPLACE(UPPER(country_name), 'A', '')) >= 3
ORDER BY iso_code;
-- 11
SELECT peak_name, river_name, LOWER(CONCAT(peak_name,SUBSTRING(river_name, 2, LENGTH(river_name)))) AS mix
FROM peaks, rivers
WHERE RIGHT(peak_name, 1) = LEFT(river_name, 1)
ORDER BY mix;
-- PART THREE
-- 12
SELECT name, DATE_FORMAT(start, '%Y-%m-%d') AS start
FROM games
WHERE YEAR(start) IN (2011, 2012)
ORDER BY start, name
LIMIT 50;
-- 13
SELECT user_name, SUBSTRING_INDEX(email,'@', -1) AS 'email provider' FROM users
ORDER BY `email provider`, user_name;
-- 14
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;
-- 15
SELECT name AS 'game',
CASE 
WHEN HOUR(start) >= 0 AND HOUR(start) < 12 THEN 'Morning'
WHEN HOUR(start) >= 12 AND HOUR(start) < 18 THEN 'Afternoon'
ELSE 'Evening'
END AS 'Part of day',
CASE
WHEN duration <= 3 THEN 'Extra Short'
WHEN duration > 3 AND duration <= 6 THEN 'Short'
WHEN duration > 6 AND duration <= 10 THEN 'Long'
ELSE 'Extra Long'
END AS 'Duration'
FROM games;
-- PART FOUR
-- 16
SELECT product_name,
order_date, 
ADDDATE(order_date, interval 3 day) AS `pay_due`,
ADDDATE(order_date, interval 1 month) AS `order_due`
FROM orders;
