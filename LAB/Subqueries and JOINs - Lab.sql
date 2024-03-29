-- 1. MANAGERS
SELECT e.employee_id as 'employee_id',
CONCAT(e.first_name, ' ', e.last_name) as 'full_name',
d.department_id,
d.name as 'department_name'
FROM departments as d
JOIN employees as e
ON d.manager_id = e.employee_id
ORDER BY e.employee_id
LIMIT 5;

-- 2.TOWNS-ADDRESSES
SELECT t.town_id, t.name AS 'town_name', a.address_text FROM towns AS t
JOIN addresses AS a ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id, a.address_id;

-- 3.EMPLOYEES
SELECT employee_id,first_name,last_name,department_id,salary 
FROM employees
WHERE manager_id is NULL;

-- 4.HIGH-SALARY
SELECT COUNT(*) AS 'count'
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

