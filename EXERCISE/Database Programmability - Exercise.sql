-- PART I
-- 1. Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
	SELECT first_name,last_name FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END$$

-- 2. Employees with Salary Above Number
CREATE PROCEDURE usp_get_employees_salary_above (min_salary DECIMAL(18,4))
BEGIN 
	SELECT first_name, last_name FROM employees
    WHERE salary >= min_salary
    ORDER BY first_name, last_name, employee_id;
END$$

-- 3. Town Names Starting With
-- First solution
CREATE PROCEDURE usp_get_towns_starting_with (letter VARCHAR(10))
BEGIN
    SELECT name FROM towns
    WHERE LEFT(name, LENGTH(letter)) = letter
    ORDER BY name;
END$$
-- Judge don't like second :)
CREATE PROCEDURE usp_get_towns_starting_with (letter VARCHAR(10))
BEGIN 
	SET @pattern = CONCAT(letter, '%');
	SELECT name FROM towns
    WHERE name LIKE @pattern
    ORDER BY name;
END$$

-- 4. Employees from Town
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
    SELECT first_name, last_name
    FROM employees AS e
    JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.name = town_name
    ORDER BY first_name, last_name, e.employee_id;
END$$

-- 5. Salary Level Function
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN 
    DECLARE salary_level VARCHAR(10);

    IF (salary < 30000) THEN
        SET salary_level = 'Low';
    ELSEIF salary BETWEEN 30000 AND 50000 THEN 
        SET salary_level = 'Average';
    ELSE 
        SET salary_level = 'High';
    END IF;
    
    RETURN salary_level;
END$$

-- 6. Employees by Salary Level
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(10))
BEGIN
    SELECT first_name, last_name
    FROM employees
    WHERE ufn_get_salary_level(salary) = salary_level
    ORDER BY first_name DESC, last_name DESC;
END$$

-- 7. Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR (50))
RETURNS INT
DETERMINISTIC
BEGIN
	 DECLARE i INT DEFAULT 1;
    DECLARE set_of_letters_length INT;
    
    SET set_of_letters_length = LENGTH(set_of_letters);
    
    WHILE i <= set_of_letters_length DO
        IF POSITION(SUBSTRING(word, i, 1) IN set_of_letters) = 0 THEN
            RETURN 0; 
        END IF;

        SET i = i + 1;
    END WHILE;
    
    RETURN 1;
END $$

-- PART II
-- 8. Find Full Name
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
	SELECT CONCAT(first_name,' ', last_name) AS full_name FROM account_holders
    ORDER BY full_name, id;
END $$

-- 9. People with Balance Higher Than
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(number INT)
BEGIN 
	SELECT ah.first_name, ah.last_name FROM account_holders AS ah
    JOIN accounts AS a ON ah.id = a.account_holder_id
    GROUP BY ah.id, ah.first_name, ah.last_name
    HAVING SUM(a.balance) > number
    ORDER BY ah.id;
END $$

-- 10. Future Value Function
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(10,4), yearly_interest_rate DOUBLE, number_of_years INT)
RETURNS DECIMAL(10,4)
DETERMINISTIC
BEGIN
	DECLARE future_value DECIMAL(10,4);
    SET future_value = sum * POWER(1 + yearly_interest_rate, number_of_years);
    RETURN future_value;
END $$

-- 11. Calculating Interest
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(19,4))
BEGIN
    SELECT a.id AS account_id, ah.first_name, ah.last_name, 
    a.balance AS current_balance, ufn_calculate_future_value(a.balance, interest_rate, 5) AS balance_years
    FROM account_holders AS ah
    JOIN accounts AS a ON a.account_holder_id = ah.id
    WHERE a.id = id;
END $$

-- 12. Deposit Money
CREATE PROCEDURE usp_deposit_money(
	account_id INT,
    money_amount DECIMAL(10,4)
)
BEGIN 
	START TRANSACTION;
    IF (money_amount <= 0) THEN
		ROLLBACK;
	ELSE 
		UPDATE accounts AS a SET a.balance = a.balance + money_amount
         WHERE a.id = id;
	END IF;
    
    SELECT id, account_holder_id, balance FROM accounts;
END $$

-- 13. Withdraw Money 
CREATE PROCEDURE usp_withdraw_money(
account_id INT,
money_amount DECIMAL(19,4)
)
BEGIN
	START TRANSACTION;
    IF (SELECT balance FROM accounts AS a WHERE a.id = account_id) < money_amount OR 
		money_amount <= 0 THEN
			ROLLBACK;
    ELSE 
		UPDATE accounts AS a SET a.balance = a.balance - money_amount
		WHERE a.id = account_id;
		COMMIT;
    END IF;
END $$

-- 14. Money Transfer
CREATE PROCEDURE usp_transfer_money(
	from_account_id INT, 
	to_account_id INT, 
	amount DECIMAL (19, 4)
)
BEGIN
	START TRANSACTION;
	IF 
		from_account_id = to_account_id OR 
		amount <= 0 OR 
        (SELECT balance FROM accounts WHERE id = from_account_id) < amount OR
        (SELECT COUNT(id) FROM accounts WHERE id = from_account_id) <> 1 OR
		(SELECT COUNT(id) FROM accounts WHERE id = to_account_id) <> 1 
        THEN ROLLBACK;
	ELSE
		UPDATE accounts SET balance = balance - amount 
		WHERE id = from_account_id;
		UPDATE accounts SET balance = balance + amount 
		WHERE id = to_account_id;
        COMMIT;
	END IF;
END $$

-- 15. Log Accounts Trigger
CREATE TABLE logs (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
	account_id INT NOT NULL,
    old_sum DECIMAL(20,4),
    new_sum DECIMAL(20,4)
);
DELIMITER $$
CREATE TRIGGER tr_accounts_change 
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN 
	INSERT INTO logs (account_id, old_sum,new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END $$

-- 16. Emails Trigger 
CREATE TABLE notification_emails(
	id INT PRIMARY KEY AUTO_INCREMENT,
    recipient INT NOT NULL,
    subject VARCHAR(50) NOT NULL,
    body VARCHAR(255) NOT NULL
);
DELIMITER $$
CREATE TRIGGER tr_notification_emails
AFTER INSERT 
ON logs
FOR EACH ROW
BEGIN
    INSERT INTO notification_emails (recipient, subject, body)
    VALUES (
        NEW.account_id, 
        CONCAT('Balance change for account: ', NEW.account_id), 
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ',
        ROUND(NEW.old_sum, 2), ' to ',ROUND(NEW.new_sum, 2), '.'));
END $$

