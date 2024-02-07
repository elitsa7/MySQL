-- CREATE DATABASE `real_estate`;

-- DDL - 40pts
-- 1. 
CREATE TABLE `cities`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE `property_types`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `type` VARCHAR(40) UNIQUE NOT NULL,
    `description` TEXT
);

CREATE TABLE `properties`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`address` VARCHAR(80) UNIQUE NOT NULL,
    `price` DECIMAL(19,2) NOT NULL,
    `area` DECIMAL(19,2),
    `property_type_id` INT,
    `city_id` INT,
    CONSTRAINT `fk_properties_cities` FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`),
    CONSTRAINT `fk_properties_types` FOREIGN KEY (`property_type_id`) REFERENCES `property_types`(`id`)
);

CREATE TABLE `agents`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) UNIQUE NOT NULL,
    `email` VARCHAR(50) UNIQUE NOT NULL,
    `city_id` INT,
    CONSTRAINT `fk_agents_cities` FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`)
);

CREATE TABLE `buyers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) UNIQUE NOT NULL,
    `email` VARCHAR(50) UNIQUE NOT NULL,
    `city_id` INT,
    CONSTRAINT `fk_buyers_cities` FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`)
);

CREATE TABLE `property_offers`(
	`property_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `price` DECIMAL(19,2),
    `offer_datetime` DATETIME,
    CONSTRAINT `fk_property_offers_properties` FOREIGN KEY (`property_id`) REFERENCES `properties`(`id`),
    CONSTRAINT `fk_property_offers_agents` FOREIGN KEY (`agent_id`) REFERENCES `agents`(`id`)
);

CREATE TABLE `property_transactions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`property_id` INT NOT NULL,
    `buyer_id` INT NOT NULL,
    `transaction_date` DATE,
    `bank_name` VARCHAR(30),
    `iban` VARCHAR(40) UNIQUE,
    `is_successful` TINYINT(1),
    CONSTRAINT `fk_property_transactions_buyers` FOREIGN KEY (`buyer_id`) REFERENCES `buyers`(`id`),
    CONSTRAINT `fk_property_transactions_properties` FOREIGN KEY (`property_id`) REFERENCES `properties`(`id`)
);

-- DML - 30pts
-- 2.
INSERT INTO `property_transactions` (`property_id`, `buyer_id`, `transaction_date`, `bank_name`, `iban`, `is_successful`)
SELECT 
(`agent_id` + DAY(`offer_datetime`)),
(`agent_id` + MONTH(`offer_datetime`)),
(DATE(`offer_datetime`)),
(CONCAT('Bank ', `agent_id`)),
(CONCAT('BG', `price`, `agent_id`)),
(1)
FROM `property_offers`
WHERE `agent_id` <= 2;

-- 3.
UPDATE `properties` 
SET `price` = `price` - 50000
WHERE `price` >= 800000;

-- 4. 
DELETE FROM `property_transactions`
WHERE `is_successful` = 0;

-- Querying – 50pts
-- 5.
SELECT * FROM `agents`
ORDER BY `city_id` DESC, `phone` DESC;

-- 6.
SELECT * FROM `property_offers`
WHERE YEAR(`offer_datetime`) = 2021
ORDER BY `price`
LIMIT 10; 

-- 7.
SELECT
LEFT(p.`address`, 6) AS 'agent_name', 
CHAR_LENGTH(p.`address`) * 5430 AS 'price' 
FROM `properties` AS p
LEFT JOIN `property_offers` AS po ON p.`id`= po.`property_id`
WHERE po.`agent_id` IS NULL
ORDER BY `agent_name` DESC, `price` DESC;

-- 8.
SELECT `bank_name`, COUNT(*) AS 'count' FROM `property_transactions`
GROUP BY `bank_name`
HAVING count >= 9
ORDER BY `bank_name`, `count` DESC;

-- 9.
SELECT `address`, `area`,
(CASE 
	WHEN `area` <= 100 THEN 'small'
    WHEN `area` <= 200 THEN 'medium'
    WHEN `area` <= 500 THEN 'large'
    ELSE 'extra large'
END) AS 'size'
FROM `properties`
ORDER BY `area`, `address` DESC;

--  Programmability – 30pts
-- 10.
DELIMITER $$
CREATE FUNCTION `udf_offers_from_city_name`(cityName VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE count INT;
    SET count := (
		SELECT  COUNT(c.`id`) FROM `property_offers` AS po
        JOIN `properties` AS p ON po.`property_id` = p.`id`
        JOIN `cities` AS c ON p.`city_id` = c.`id`
        WHERE c.`name` = cityName);
	RETURN count;
END$$

-- 11.
DELIMITER $$
CREATE PROCEDURE `udp_special_offer` (first_name VARCHAR(50))
BEGIN
	UPDATE `property_offers` AS po
    JOIN `agents` AS a ON po.`agent_id` = a.`id`
    SET po.`price`= po.`price` * 0.9
    WHERE a.`first_name` = first_name;
END$$

