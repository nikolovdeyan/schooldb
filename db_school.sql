-- ==========================================================
-- Author: Deyan Nikolov
-- Date: 2023-11-10
-- Version: 1.4
-- Desc: Database script for an imaginary school data system
-- ==========================================================

DROP SCHEMA IF EXISTS db_school;

CREATE SCHEMA IF NOT EXISTS db_school DEFAULT CHARACTER SET utf8;
USE db_school;


-- ----------------------------------------------------------
-- Table Teacher
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_teacher(
  teacher_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  fname VARCHAR(50) NOT NULL COMMENT 'Име на учител',
  lname VARCHAR(50) NOT NULL COMMENT 'Фамилия на учител',
  phone VARCHAR(20) NULL COMMENT 'Телефон на учител',
  email VARCHAR(50) NULL COMMENT 'Емайл на учител'
)
ENGINE = InnoDB
COMMENT 'Таблица с данни за учители';


-- ----------------------------------------------------------
-- Table Parent
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_parent (
  parent_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  fname VARCHAR(50) NOT NULL COMMENT 'Име на родител',
  lname VARCHAR(50) NOT NULL COMMENT 'Фамилия на родител',
  phone VARCHAR(20) NULL COMMENT 'Телефон на родител',
  email VARCHAR(50) NULL COMMENT 'Емайл на родител'
)
  ENGINE = InnoDB
  COMMENT 'Таблица с данни за родители';


-- ----------------------------------------------------------
-- Table Class
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_class(
  class_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(10) NOT NULL COMMENT 'Име на клас',
  teacher_id INT(10) NOT NULL COMMENT 'Класен ръководител',
  CONSTRAINT fk_class_teacher FOREIGN KEY (teacher_id) REFERENCES tbl_teacher (teacher_id)
)
ENGINE = InnoDB
COMMENT 'Таблица с данни за клас';


-- ----------------------------------------------------------
-- Table Student
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_student (
  student_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  fname VARCHAR(50) NOT NULL COMMENT 'Име на ученик',
  mname VARCHAR(50) NULL COMMENT 'Презиме на ученик',
  lname VARCHAR(50) NOT NULL COMMENT 'Фамилия на ученик',
  egn CHAR(10) NULL COMMENT 'ЕГН на ученик',
  class_id INT(10),
  CONSTRAINT fk_student_class FOREIGN KEY (class_id) REFERENCES tbl_class (class_id)
)
ENGINE = InnoDB
COMMENT 'Таблица с данни за ученици';


-- ----------------------------------------------------------
-- Table StudentParent
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_studentparent (
  student_id INT(10) NOT NULL,
  parent_id INT(10) NOT NULL,
  PRIMARY KEY(student_id, parent_id),
  CONSTRAINT fk_studentparent_student FOREIGN KEY (student_id) REFERENCES tbl_student (student_id),
  CONSTRAINT fk_studentparent_parent FOREIGN KEY (parent_id) REFERENCES tbl_parent (parent_id)
)
ENGINE = InnoDB
COMMENT 'Таблица-мост ученици-родители';


-- ----------------------------------------------------------
-- Table Schedule
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_schedule (
  schedule_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  schedule_datetime DATETIME NULL COMMENT 'Начало на занятието',
  class_id INT(10) NOT NULL COMMENT 'Клас, с който се провежда занятието',
  subject VARCHAR(50) NULL COMMENT 'Предмет на занятието',
  teacher_id INT(10) NOT NULL COMMENT 'Учител, водещ занятието',
  CONSTRAINT fk_schedule_class FOREIGN KEY (class_id) REFERENCES tbl_class (class_id),
  CONSTRAINT fk_schedule_teacher FOREIGN KEY (teacher_id) REFERENCES tbl_teacher (teacher_id)
)
ENGINE = InnoDB
COMMENT 'Таблица с учебна програма';


-- ----------------------------------------------------------
-- Table Absence
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_absence (
  absence_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  schedule_id INT(10) NOT NULL COMMENT 'Занятие, в което е настъпило отсъствието',
  student_id INT(10) NOT NULL COMMENT 'Ученик, който е отсъствал',
  notes VARCHAR(100) NULL COMMENT 'Допълнителна информация',
  CONSTRAINT fk_absence_schedule FOREIGN KEY (schedule_id) REFERENCES tbl_schedule (schedule_id),
  CONSTRAINT fk_absence_student FOREIGN KEY (student_id) REFERENCES tbl_student (student_id)
)
ENGINE = InnoDB
COMMENT 'Таблица с отсъствия';


-- ----------------------------------------------------------
-- Table Grade
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_grade (
  grade_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  schedule_id INT(10) NOT NULL COMMENT 'Занятие, в което е настъпило оценяването',
  student_id INT(10) NOT NULL COMMENT 'Ученик, който е оценен',
  grade DECIMAL(2,1) NOT NULL COMMENT 'Оценка',
  notes VARCHAR(100) NULL COMMENT 'Допълнителна информация',
  CONSTRAINT fk_grade_schedule FOREIGN KEY (schedule_id) REFERENCES tbl_schedule (schedule_id),
  CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES tbl_student (student_id)
)
ENGINE = InnoDB
COMMENT 'Таблица с оценки';


-- ----------------------------------------------------------
-- Table WriteUp
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_writeup (
  writeup_id INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  schedule_id INT(10) NOT NULL COMMENT 'Занятие, в което е направена забележката',
  student_id INT(10) NOT NULL COMMENT 'Ученик, на когото/ято е направена забележката',
  contents VARCHAR(100) NOT NULL COMMENT 'Съдържание на забележката',
  CONSTRAINT fk_writeup_schedule FOREIGN KEY (schedule_id) REFERENCES tbl_schedule (schedule_id),
  CONSTRAINT fk_writeup_student FOREIGN KEY (student_id) REFERENCES tbl_students (student_id)
)
  ENGINE = InnoDB
  COMMENT 'Таблица със забележки';


-- ----------------------------------------------------------
-- Sample data
-- ----------------------------------------------------------

INSERT INTO tbl_teacher (fname, lname, phone, email)
VALUES ('Антония', 'Гуркова', '+359811111111', 'agurkova@sou1.bg'),
       ('Велизара', 'Иванова', '+359871222222', 'vivanova@sou1.bg'),
       ('Кирил', 'Кирилов', '+359877123456', 'kkirilov@sou1.bg');

INSERT INTO tbl_parent (fname, lname, phone, email)
VALUES ('Христо', 'Петров', '+359817234912', 'hristo@abv.bg'),
       ('Димитрина', 'Петрова', '+3597618219321', 'd.petrova@gmail.com'),
       ('Тодорка', 'Димова', Null, 't.dimova@alabala.com');

INSERT INTO tbl_class (name, teacher_id)
VALUES ('7а', 1),
       ('7б', 2);

INSERT INTO tbl_student (fname, mname, lname, egn, class_id)
VALUES ('Петкан', 'Иванов', 'Петров', '1234567890', 1),
       ('Сульо', 'Мирчев', 'Димов', '0987654321', 2);

INSERT INTO tbl_studentparent (student_id, parent_id)
VALUES (1, 1),
       (1, 2),
       (2, 3);

INSERT INTO tbl_schedule (schedule_datetime, class_id, subject, teacher_id)
VALUES ('2023-10-01 08:00:00', 1, 'Английски език', 1),
       ('2023-10-01 09:00:00', 1, 'Математика', 2),
       ('2023-10-01 10:00:00', 1, 'История', 3);

INSERT INTO tbl_absence(schedule_id, student_id, notes)
VALUES (1, 1, Null),
       (2, 1, 'Ученикът е болен');

INSERT INTO tbl_grade (schedule_id, student_id, grade, notes)
VALUES (1, 2, 5.5, 'Контролно'),
       (2, 1, 2, Null);

INSERT INTO tbl_writeup (schedule_id, student_id, contents)
VALUES (1, 2, 'Не внимава в час'),
       (2, 2, 'Говори в час');
