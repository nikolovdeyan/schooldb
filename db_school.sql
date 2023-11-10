-- ==========================================================
-- Author: Deyan Nikolov
-- Date: 2023-11-10
-- Version: 1.1
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
  teacher_id INT(10) NOT NULL COMMENT 'Класен ръководител'
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
  class_id INT(10)
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
