-- 1
CREATE TABLE minions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

CREATE TABLE towns (
    town_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

-- 2 
ALTER TABLE minions ADD COLUMN town_id INT;

ALTER TABLE minions 
ADD CONSTRAINT fk_minions_towns 
FOREIGN KEY(town_id)
REFERENCES towns(id);

-- 3 
INSERT INTO towns(id, name)
VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3,  'Varna');

INSERT INTO minions(id, name, age, town_id)
VALUES 
(1, 'Kevin' ,22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

-- 4
TRUNCATE TABLE minions;

-- 5
DROP TABLE minions;
DROP TABLE towns;

-- 6
CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10 , 2 ),
    weight DOUBLE(10 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people (name, gender, birthdate)
VALUES 
('TEST1', 'M', DATE(NOW())),
('TEST2', 'F', DATE(NOW())),
('TEST3', 'F', DATE(NOW())),
('TEST4', 'M', DATE(NOW())),
('TEST5', 'F', DATE(NOW()));

-- 7 
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

INSERT INTO users (username, password)
VALUES 
('TEST1', '12345678'),
('TEST2', '12345678'),
('TEST3', '12345678'),
('TEST4', '12345678' ),
('TEST5', '12345678');

-- 8 
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id, username);

-- 9
ALTER TABLE users
CHANGE COLUMN last_login_time last_login_time DATETIME 
DEFAULT NOW();

-- 10
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users 
PRIMARY KEY users(id),
CHANGE COLUMN username 
username VARCHAR(30) UNIQUE; 

-- 11
CREATE DATABASE movies;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(255) NOT NULL,
    notes TEXT
);

INSERT INTO directors(director_name)
VALUES
('Director1'),
('Director2'),
('Director3'),
('Director4'),
('Director5');

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255) NOT NULL,
    notes TEXT
);
INSERT INTO genres(genre_name)
VALUES
('Genre1'),
('Genre2'),
('Genre3'),
('Genre4'),
('Genre5');

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(255) NOT NULL,
    notes TEXT
);
INSERT INTO categories(category_name)
VALUES
('Category1'),
('Category2'),
('Category3'),
('Category4'),
('Category5');

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    director_id INT NOT NULL,
    copyright_year INT,
    length DOUBLE,
    genre_id INT NOT NULL,
    category_id INT NOT NULL,
    rating DOUBLE,
    notes TEXT
);

INSERT INTO movies (title, director_id, genre_id, category_id)
VALUES
('Movie1',1,2,3),
('Movie2',2,4,6),
('Movie3',4,6,1),
('Movie4',7,9,2),
('Movie5',10,3,5);
-- 12
CREATE DATABASE car_rental;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50),
    daily_rate INT,
    weekly_rate INT,
    monthly_rate INT,
    weekend_rate INT
);

INSERT INTO categories(category)
VALUES 
('SEDAN'),
('HETCHBACK'),
('PICKUP');

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(50) NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    car_year INT,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(50),
    available BOOLEAN
);

INSERT INTO cars(plate_number)
VALUES
('A1'),
('B1'),
('C1');

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(50),
    notes TEXT
);
INSERT INTO employees (first_name, last_name)
VALUES
('FIRST', 'SECOND'),
('FirstName', 'LastName'),
('TEST', 'TESTOV');

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT NOT NULL,
    full_name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50),
    zip_code INT,
    notes TEXT
);

INSERT INTO customers (driver_licence_number)
VALUES 
(123),
(1234),
(12345);

CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(50),
    tank_level INT,
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATE,
    end_date DATE,
    total_days INT,
    rate_applied INT,
    tax_rate INT,
    order_status VARCHAR(50),
    notes TEXT
);

INSERT INTO rental_orders(employee_id, car_id)
VALUES
(1,1),
(2,2),
(3,3);

-- 13
CREATE DATABASE soft_uni;

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

INSERT INTO towns(name)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(50),
    town_id INT,
	CONSTRAINT fk_town_id FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

INSERT INTO departments(name)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE,
    salary DOUBLE(10 , 2 ),
    address_id INT,
    CONSTRAINT fk_department_id FOREIGN KEY (department_id)
        REFERENCES departments (id),
    CONSTRAINT fk_address_id FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

-- 14
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- 15
SELECT * FROM towns
ORDER BY name;

SELECT * FROM departments
ORDER BY name;

SELECT * FROM employees
ORDER BY salary DESC;

-- 16
SELECT name FROM towns
ORDER BY name;

SELECT name FROM departments
ORDER BY name;

SELECT first_name, last_name, job_title, salary  FROM employees
ORDER BY salary DESC;

-- 17
UPDATE employees
SET salary = salary * 1.1;
SELECT salary FROM employees;
