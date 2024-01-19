-- 1. ONE-TO-ONE
CREATE TABLE people(
person_id INT NOT NULL,
first_name VARCHAR(50),
salary DECIMAL(8,2),
passport_id INT UNIQUE
);
SELECT * FROM people;

CREATE TABLE passports(
passport_id INT NOT NULL,
passport_number VARCHAR(50)
);

INSERT INTO people (person_id,first_name,salary,passport_id)
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

INSERT INTO passports(passport_id, passport_number)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

ALTER TABLE people
ADD CONSTRAINT pk_person_id PRIMARY KEY (person_id);

ALTER TABLE passports 
ADD CONSTRAINT pk_passport_id PRIMARY KEY (passport_id);

ALTER TABLE people
ADD CONSTRAINT fk_people_passports FOREIGN KEY(passport_id)
REFERENCES passports (passport_id);

-- 2. ONE-TO-MANY
CREATE TABLE manufacturers (
    manufacturer_id INT NOT NULL,
    name VARCHAR(50),
    established_on DATE
);

CREATE TABLE models (
    model_id INT NOT NULL,
    name VARCHAR(50),
    manufacturer_id INT
);

CREATE TABLE students (
    student_id INT NOT NULL,
    name VARCHAR(50)
);

INSERT INTO manufacturers
VALUES
(1, 'BMW', '1916-03-01'), 
(2, 'Tesla', '2003-01-01'),
(3, 'Lada', '1966-05-01');

INSERT INTO models
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

INSERT INTO students
VALUES
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron');

ALTER TABLE manufacturers
ADD CONSTRAINT pk_manufacturer_id PRIMARY KEY(manufacturer_id);

ALTER TABLE models
ADD CONSTRAINT pk_model_id PRIMARY KEY(model_id);

ALTER TABLE models
ADD CONSTRAINT fk_models_manufacturers
FOREIGN KEY(manufacturer_id) REFERENCES manufacturers(manufacturer_id);

-- 3. MANY-TO-MANY
CREATE TABLE exams (
    exam_id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE students_exams (
    student_id INT,
    exam_id INT,
    CONSTRAINT pk_studentID_examID PRIMARY KEY (student_id , exam_id),
    CONSTRAINT fk_studentsExams_students FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT  fk_studentsExams_examID FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id)
);

INSERT INTO students
VALUES
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron');

INSERT INTO exams
VALUES
(101, 'Spring MVC'),
(102, ' Neo4j'),
(103, ' Oracle 11g');

INSERT INTO students_exams
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103);

-- 4. SELF-REFERENCING
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manager_id INT
);

INSERT INTO teachers (teacher_id, name, manager_id) 
VALUES
    (101, 'John', NULL),        
    (102, 'Maya', 106),
    (103, 'Silvia', 106),
    (104, 'Ted', 105),
    (105, 'Mark', 101),
    (106, 'Greta', 101);

ALTER TABLE teachers
ADD CONSTRAINT fk_manager_id
FOREIGN KEY (manager_id) REFERENCES teachers(teacher_id);

-- 5. ONLINE STORE
CREATE DATABASE online_store;

CREATE TABLE cities (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE item_types (
    item_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birthday DATE,
    city_id INT,
    CONSTRAINT fk_customers_cities FOREIGN KEY (city_id)
        REFERENCES cities (city_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    item_type_id INT NOT NULL,
    CONSTRAINT fk_items_type FOREIGN KEY (item_type_id)
        REFERENCES item_types (item_type_id)
);
CREATE TABLE order_items (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY (order_id , item_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_item FOREIGN KEY (item_id)
        REFERENCES items (item_id)
);
-- 6. UNIVERSITY_DATABASE
CREATE DATABASE university;

CREATE TABLE subjects (
    subject_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(50)
);

CREATE TABLE majors (
    major_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE students (
    student_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(12) UNIQUE,
    student_name VARCHAR(50),
    major_id INT(11),
    CONSTRAINT fk_student_major
    FOREIGN KEY (major_id)
    REFERENCES majors(major_id)
);

CREATE TABLE payments (
    payment_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_amount DECIMAL(8, 2),
    student_id INT(11),
    CONSTRAINT fk_payments_students
    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
);

CREATE TABLE agenda (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    CONSTRAINT pk_agenda
    PRIMARY KEY(student_id, subject_id),
    CONSTRAINT fk_agenda_students
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    CONSTRAINT fk_agenda_subjects
    FOREIGN KEY (subject_id)
    REFERENCES subjects(subject_id)
);
-- 9. PEAKS-IN-RILA
SELECT m.mountain_range,p.peak_name,p.elevation FROM mountains AS m
JOIN peaks AS p ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;

