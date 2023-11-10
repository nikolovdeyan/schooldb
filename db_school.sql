
-- ==========================================================
-- Author: Deyan Nikolov
-- Date: 2023-11-10
-- Version: 1.6
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
  CONSTRAINT fk_writeup_student FOREIGN KEY (student_id) REFERENCES tbl_student (student_id)
)
  ENGINE = InnoDB
  COMMENT 'Таблица със забележки';


-- ==========================================================
-- Generated Data
-- ==========================================================

-- ----------------------------------------------------------
-- TABLE Teacher
-- ----------------------------------------------------------
INSERT INTO tbl_teacher (fname, lname, phone, email)
VALUES
      ('Махно', 'Николов', '+359(0)672 110684', 'mnikolov@fakesou.bg'),
      ('Щилянка', 'Бодуров', '+359885421430', 'shtbodurov@fakesou.bg'),
      ('Магдалена', 'Манавски', '0324451956', 'mmanavski@fakesou.bg'),
      ('Бела', 'Прошков', '+359(0)374 184 049', 'bproshkov@fakesou.bg'),
      ('Руска', 'Стойков', '(0366) 946723', 'rstoykov@fakesou.bg'),
      ('Петромил', 'Манавски', '+359(0)107488752', 'pmanavski@fakesou.bg'),
      ('Огнена', 'Младенов', '+359(0)637 425695', 'omladenov@fakesou.bg'),
      ('Линда', 'Габровлиева', '+359510349931', 'lgabrovlieva@fakesou.bg'),
      ('Севар', 'Андонов', '0700514505', 'sandonov@fakesou.bg'),
      ('Паун', 'Мераков', '+359(0)691 493 742', 'pmerakov@fakesou.bg'),
      ('Начо', 'Колипатков', '(0259) 050 725', 'nkolipatkov@fakesou.bg'),
      ('Толек', 'Златков', '(0173) 631 000', 'tzlatkov@fakesou.bg'),
      ('Тошка', 'Чутурков', '(0290) 879 350', 'tchuturkov@fakesou.bg'),
      ('Емилиян', 'Многознаева', '0637337670', 'emnogoznaeva@fakesou.bg'),
      ('Маноел', 'Щърбов', '0363 730-044', 'mshtarbov@fakesou.bg');

-- ----------------------------------------------------------
-- TABLE Class
-- ----------------------------------------------------------
INSERT INTO tbl_class (name, teacher_id)
VALUES
      ('7а', 1),
      ('7б', 2),
      ('7в', 3);


-- ----------------------------------------------------------
-- TABLE Student
-- ----------------------------------------------------------
INSERT INTO tbl_student (fname, mname, lname, egn, class_id)
VALUES
      ('Нансимир', 'Тумангело', 'Четрафилски', '1049029952', 3),
      ('Генчо', 'Даче', 'Дришльов', '1049258628', 1),
      ('Джиневра', 'Плюнков', 'Чанлиева', '1149033327', 3),
      ('Агъци', 'Татьозов', 'Балахуров', '1053285647', 3),
      ('Золтан', 'Пръндачк', 'Въртунински', '1147193245', 2),
      ('Белисима', 'Тодоров', 'Кобиларов', '1041284613', 1),
      ('Ирла', 'Плюнкова', 'Площаков', '1041214962', 2),
      ('Веселинка', 'Цоцо', 'Мангъфова', '1041133591', 1),
      ('Люсила', 'Кито', 'Възвъзов', '1049016201', 1),
      ('Вежда', 'Джогов', 'Хвърчилков', '1150252526', 2),
      ('Смирна', 'Първанова', 'Бобев', '1144118009', 3),
      ('Недялко', 'Кобиларо', 'Кучкуделова', '1048106825', 3),
      ('Периана', 'Въртунински', 'Самсонов', '1044229235', 2),
      ('Елма', 'Чупетловска', 'Въртунински', '1142155090', 1),
      ('Ваклина', 'Прошко', 'Келешев', '1053256959', 1),
      ('Албияна', 'Кърков', 'Чупетловска', '1147249786', 1),
      ('Билена', 'Първанова', 'Кесьов', '1044154574', 1),
      ('Лилян', 'Младенова', 'Шкембова', '1153102908', 2),
      ('Елемаг', 'Колев', 'Яркова', '1145179481', 2);

-- ----------------------------------------------------------
-- TABLE Parent
-- ----------------------------------------------------------
INSERT INTO tbl_parent (fname, lname, phone, email)
VALUES
      ('Жива', 'Четрафилскиа', '(0254) 756 834', 'mladenovyatan@example.com'),
      ('Десимиляна', 'Дришльова', '+359(0)941663803', 'tupchileshtovpetrinel@example.com'),
      ('Анелина', 'Чанлиева', '+359(0)091 784920', 'burborkovfratsil@example.net'),
      ('Рия', 'Балахурова', '0713 476 182', 'milachkovdemir@example.net'),
      ('Исихия', 'Въртунинскиа', '0453 200 958', 'kharitonkesov@example.com'),
      ('Емма', 'Кобиларова', '(0591) 162 555', 'vuzvuzovshteno@example.org'),
      ('Зинаида', 'Площакова', '(0469) 373 453', 'ipeeva@example.net'),
      ('Периана', 'Мангъфова', '0902 817 594', 'mustakovastaniela@example.org'),
      ('Янадин', 'Възвъзов', '+359142026998', 'qkuchkudelova@example.org'),
      ('Диван(надядоДианидядоИван)', 'Хвърчилков', '+359(0)511404922', 'iiordanov@example.net'),
      ('Славе', 'Бобев', '+359(0)828623478', 'kurtazhovadinna@example.org'),
      ('Десимиляна', 'Кучкуделова', '+359(0)903 380782', 'yugi2019@example.net'),
      ('Хана', 'Самсонова', '(0317) 954 690', 'liberta1984@example.com'),
      ('Васка', 'Въртунинскиа', '+359510958751', 'klatikrushevberin@example.com'),
      ('Ермиля', 'Келешева', '(0159) 241-880', 'katurovakitchitsa@example.net'),
      ('Данка', 'Чупетловска', '+359535469602', 'naumkolchev@example.net'),
      ('Жейна', 'Кесьова', '0523 076 456', 'unedyalkov@example.net'),
      ('Занка', 'Шкембова', '(0715) 079-321', 'manavskichepo@example.org'),
      ('Надка', 'Яркова', '+359(0)230 020 471', 'laskar1979@example.com');

-- ----------------------------------------------------------
-- TABLE StudentParent
-- ----------------------------------------------------------
INSERT INTO tbl_studentparent (student_id, parent_id)
VALUES
      (1, 1),
      (2, 2),
      (3, 3),
      (4, 4),
      (5, 5),
      (6, 6),
      (7, 7),
      (8, 8),
      (9, 9),
      (10, 10),
      (11, 11),
      (12, 12),
      (13, 13),
      (14, 14),
      (15, 15),
      (16, 16),
      (17, 17),
      (18, 18),
      (19, 19);
