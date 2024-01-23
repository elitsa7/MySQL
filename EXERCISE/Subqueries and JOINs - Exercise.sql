-- 1. Employee Address
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees AS e
JOIN addresses AS a ON e.address_id = a.address_id
ORDER BY address_id
LIMIT 5;

-- 2. Addresses with Towns
SELECT e.first_name, e.last_name, t.name AS 'town', a.address_text
FROM employees AS e
JOIN addresses AS a ON e.address_id = a.address_id
JOIN towns AS t ON a.town_id = t.town_id
ORDER BY first_name,last_name
LIMIT 5;

-- 3. Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY employee_id DESC;

-- 4. Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 5. Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees AS e
LEFT JOIN employees_projects AS e_p ON e.employee_id = e_p.employee_id
WHERE e_p.project_id is NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- 6. Employees Hired After
SELECT e.first_name,e.last_name,e.hire_date,d.name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.hire_date > '1999/1/1' AND d.name IN ('Sales','Finance')
ORDER BY e.hire_date;

-- 7. Employees with Project
SELECT e.employee_id, e.first_name,p.name AS 'project_name'
FROM employees AS e
JOIN employees_projects AS e_p ON e.employee_id = e_p.employee_id
JOIN projects AS p ON e_p.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, p.name
LIMIT 5;

-- 8. Employee 24
SELECT e.employee_id, e.first_name, p.name AS 'project_name'
FROM employees AS e
JOIN employees_projects AS e_p ON e.employee_id = e_p.employee_id
LEFT OUTER JOIN projects AS p ON e_p.project_id = p.project_id
AND p.start_date < '2005/01/01'
WHERE e.employee_id = 24
ORDER BY p.name;

-- 9. Employee Manager
SELECT 
e.employee_id,
e.first_name,
m.employee_id AS 'manager_id',
m.first_name AS 'manager_name'
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
WHERE e.manager_id IN (3,7)
ORDER BY e.first_name;

-- 10. Employee Summary
SELECT e.employee_id, 
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
CONCAT(m.first_name, ' ', m.last_name) AS manager_name, 
d.name
FROM employees AS e
JOIN employees AS m ON m.employee_id = e.manager_id
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.manager_id IS NOT NULL
ORDER BY employee_id
LIMIT 5;

-- 11. Min Average Salary
SELECT AVG(salary) AS min_average_salary
FROM employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;

-- 12. Highest Peaks in Bulgaria
SELECT mc.country_code, m.mountain_range, p.peak_name,p.elevation
FROM mountains_countries AS mc 
JOIN mountains AS m ON mc.mountain_id = m.id
JOIN peaks AS p ON m.id = p.mountain_id
WHERE p.elevation > 2835 AND mc.country_code = 'BG'
ORDER BY p.elevation DESC;

-- 13. Count Mountain Ranges
SELECT c.country_code, COUNT(m.mountain_range) AS mountain_range
FROM countries AS c
JOIN mountains_countries AS mc ON mc.country_code = c.country_code
JOIN mountains AS m ON mc.mountain_id = m.id
WHERE c.country_code IN ('US', 'RU', 'BG')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

-- 14. Countries with Rivers
SELECT c.country_name, r.river_name
FROM countries AS c
LEFT OUTER JOIN countries_rivers AS cr ON c.country_code = cr.country_code
LEFT OUTER JOIN rivers AS r ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 15. *Continents and Currencies
SELECT rank_currencies.continent_code, rank_currencies.currency_code, rank_currencies.count
FROM (
SELECT c.continent_code, 
c.currency_code, 
COUNT(c.currency_code) AS count, 
DENSE_RANK() OVER (PARTITION BY c.continent_code ORDER BY COUNT(c.currency_code) DESC ) AS 'rank' 
FROM countries AS c
GROUP BY c.continent_code, c.currency_code) AS rank_currencies
WHERE rank_currencies.rank = 1 and rank_currencies.count > 1;

-- 16. Countries without any Mountains
SELECT COUNT(c.country_code) AS country_count FROM countries AS c
LEFT OUTER JOIN mountains_countries AS m ON c.country_code = m.country_code
WHERE m.mountain_id IS NULL;


-- 17. Highest Peak and Longest River by Country
SELECT c.country_name, MAX(p.elevation) AS highest_peak_elevation, MAX(r.length) AS longest_river_length
FROM countries AS c
LEFT OUTER JOIN mountains_countries AS mc ON c.country_code = mc.country_code
LEFT OUTER JOIN peaks AS p ON mc.mountain_id = p.mountain_id
LEFT OUTER JOIN countries_rivers AS cr ON c.country_code = cr.country_code
LEFT OUTER JOIN rivers AS r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name
LIMIT 5;