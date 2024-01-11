-- 1
SELECT title FROM books
WHERE title LIKE 'The%'
ORDER BY id;
-- 2
UPDATE books
SET title = REPLACE(title, 'The', '***')
WHERE title LIKE 'The%';

SELECT title FROM books
WHERE title LIKE '***%'
ORDER BY id;
-- 3
SELECT FORMAT(SUM(cost),2) AS total_prices
FROM books;
-- 4
SELECT CONCAT(first_name, ' ', last_name), 
TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived' FROM authors;

-- 5
SELECT title FROM books
WHERE title LIKE 'Harry Potter%'
ORDER BY id;