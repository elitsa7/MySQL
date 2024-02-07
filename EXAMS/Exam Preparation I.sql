-- (DDL) – 40 pts
-- 1. 
CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) UNIQUE NOT NULL,
    `continent` VARCHAR(30) NOT NULL,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `genres`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE `actors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
	`last_name`  VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `height` INT,
    `awards` INT,
    `country_id` INT NOT NULL,
    CONSTRAINT `fk_actors_countries` FOREIGN KEY (`country_id`) REFERENCES `countries`(`id`)
);

CREATE TABLE `movies_additional_info`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`rating` DECIMAL(10,2) NOT NULL,
    `runtime` INT NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `budget` DECIMAL(10,2),
    `release_date` DATE NOT NULL,
    `has_subtitles` TINYINT(1),
    `description` TEXT
);

CREATE TABLE `movies`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(70) UNIQUE NOT NULL,
    `country_id` INT NOT NULL,
    `movie_info_id` INT UNIQUE NOT NULL,
    CONSTRAINT `fk_movies_countries` FOREIGN KEY (`country_id`) REFERENCES `countries`(`id`),
    CONSTRAINT `fk_movies_movies_additional_info` FOREIGN KEY (`movie_info_id`) REFERENCES `movies_additional_info`(`id`)
);

CREATE TABLE `movies_actors`(
	`movie_id` INT,
    `actor_id` INT,
	KEY `pk_movies_actors` (`movie_id`, `actor_id`),
    CONSTRAINT `fk_movies_movies_actors` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`id`),
    CONSTRAINT `fk_movies_actors_actors` FOREIGN KEY (`actor_id`) REFERENCES `actors`(`id`)
);

CREATE TABLE `genres_movies`(
	`genre_id` INT,
    `movie_id` INT,
	KEY `pk_genres_movies` (`genre_id`, `movie_id`),
    CONSTRAINT `fk_genres_movies_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres`(`id`),
    CONSTRAINT `fk_genres_movies_movies` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`id`)
);

-- (DML) – 30 pts
-- 2
INSERT INTO `actors` (`first_name`,`last_name`,`birthdate`,`height`,`awards`,`country_id`)
SELECT (REVERSE (`first_name`)), 
	(REVERSE (`last_name`)), 
	(DATE (`birthdate` - 2)), 
	(`height` + 10), 
	(`country_id`), 
	(3) 
FROM `actors`
WHERE `id` <= 10;

-- 3
UPDATE `movies_additional_info`
SET `runtime` = `runtime` - 10
WHERE `id` BETWEEN 15 AND 25;

-- 4
DELETE c FROM `countries` AS c
LEFT JOIN `movies` AS m ON c.`id`= m.`country_id`
WHERE m.`country_id` IS NULL;

-- Querying – 50 pts
-- 5
SELECT * FROM countries
ORDER BY currency DESC, id;

-- 6
SELECT m.`id`, m.`title`, ma.`runtime`, ma.`budget`, ma.`release_date` FROM `movies` AS m
JOIN `movies_additional_info` AS ma ON m.`movie_info_id` = ma.`id`
WHERE YEAR(ma.`release_date`) BETWEEN 1996 AND 1999
ORDER BY ma.`runtime`, m.`id`
LIMIT 20;

-- 7
SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'full_name', 
	CONCAT(REVERSE(`last_name`), LENGTH(`last_name`), '@cast.com') AS 'email',
	2022 - YEAR(`birthdate`) AS 'age',
	`height`
FROM `actors`
WHERE `id` NOT IN (SELECT `actor_id` FROM `movies_actors`)
ORDER BY `height`;

-- 8
SELECT c.`name`, COUNT(m.`id`) AS 'movies_count' FROM `countries` AS c
JOIN `movies` AS m ON c.`id`= m.`country_id`
GROUP BY c.`name`
HAVING `movies_count` >= 7
ORDER BY c.`name` DESC;

-- 9
SELECT m.`title`, 
	(CASE
		WHEN ma.`rating` <= 4 THEN 'poor'
        WHEN ma.`rating` <= 7 THEN 'good'
        ELSE 'excellent'
    END) AS 'rating', 
	IF (ma.`has_subtitles` = 1, 'english', '-') AS 'subtitles', 
	ma.`budget`
FROM `movies` AS m 
JOIN `movies_additional_info` AS ma ON m.`movie_info_id` = ma.`id`
ORDER BY ma.`budget` DESC;

-- Programmability – 30 pts
-- 10
DELIMITER $$
CREATE FUNCTION `udf_actor_history_movies_count` (full_name VARCHAR(50))
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE history_movies_count INT;
    SET history_movies_count := (
        SELECT COUNT(*) AS 'history_movies'
        FROM `actors` AS a
        JOIN `movies_actors` AS ma ON a.`id` = ma.`actor_id`
        JOIN `genres_movies` AS gm USING (`movie_id`)
        JOIN `genres` AS g ON gm.`genre_id` = g.`id`
        WHERE g.`name` = 'History' AND CONCAT(a.`first_name`, ' ' , a.`last_name`) = full_name
    );
    RETURN history_movies_count;
END$$

-- 11
DELIMITER $$
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN
	UPDATE `actors` AS a
    JOIN `movies_actors` AS ma ON a.`id` = ma.`actor_id`
    JOIN `movies` AS m ON ma.`movie_id` = m.`id`
    SET a.`awards` = a.`awards` + 1
    WHERE m.`title` = movie_title;
END$$
