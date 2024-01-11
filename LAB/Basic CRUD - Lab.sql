-- 1
SELECT id,first_name, last_name, job_title FROM employees ORDER BY id;

-- 2
SELECT 
    id AS 'No.',
    CONCAT(first_name, ' ', last_name) AS 'Full name',
    job_title AS 'Job title',
    salary AS 'Salary'
FROM employees
WHERE salary > 1000
ORDER BY id;

-- 3
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary FROM employees;

-- 4
CREATE VIEW v_top_paid_employee AS
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

-- 5
SELECT  id, first_name, last_name, job_title, department_id, salary
FROM employees
WHERE department_id = 4 AND salary >= 1000;

-- 6
DELETE FROM employees
WHERE department_id = 2 OR department_id = 1;
SELECT * FROM employees;
 