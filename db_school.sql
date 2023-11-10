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

-- -------------------------------------------------
-- TABLE Teacher
-- -------------------------------------------------
INSERT INTO tbl_teacher (fname, lname, phone, email)
VALUES
      (Махно, Николов, +359(0)672 110684, mnikolov@fakesou.bg),
      (Щилянка, Бодуров, +359885421430, shtbodurov@fakesou.bg),
      (Магдалена, Манавски, 0324451956, mmanavski@fakesou.bg),
      (Бела, Прошков, +359(0)374 184 049, bproshkov@fakesou.bg),
      (Руска, Стойков, (0366) 946723, rstoykov@fakesou.bg),
      (Петромил, Манавски, +359(0)107488752, pmanavski@fakesou.bg),
      (Огнена, Младенов, +359(0)637 425695, omladenov@fakesou.bg),
      (Линда, Габровлиева, +359510349931, lgabrovlieva@fakesou.bg),
      (Севар, Андонов, 0700514505, sandonov@fakesou.bg),
      (Паун, Мераков, +359(0)691 493 742, pmerakov@fakesou.bg),
      (Начо, Колипатков, (0259) 050 725, nkolipatkov@fakesou.bg),
      (Толек, Златков, (0173) 631 000, tzlatkov@fakesou.bg),
      (Тошка, Чутурков, (0290) 879 350, tchuturkov@fakesou.bg),
      (Емилиян, Многознаева, 0637337670, emnogoznaeva@fakesou.bg),
      (Маноел, Щърбов, 0363 730-044, mshtarbov@fakesou.bg);


-- -------------------------------------------------
-- TABLE Class
-- -------------------------------------------------
INSERT INTO tbl_class (name, teacher_id)
VALUES
      ('7а', 1),
      ('7б', 2),
      ('7в', 3);


-- -------------------------------------------------
-- TABLE Student
-- -------------------------------------------------
INSERT INTO tbl_student (fname, mname, lname, egn, class_id)
VALUES
      (Нансимир, Тумангело, Четрафилски, 1148099990, 1),
      (Лимон, Рангело, Въртунински, 1050016472, 2),
      (Ирко, Парашкевов, Яков, 1047023982, 3),
      (Гиздален, Сапунджиев, Колипатков, 1049102563, 3),
      (Лазура, Николов, Чупетловска, 1147077590, 2),
      (Мариян, Симеонов, Количков, 1144092549, 2),
      (Токимир, Бранков, Градинарова, 1145175919, 1),
      (Кинта, Плюцов, Балахуров, 1149175880, 1),
      (Ростиана, Многознаев, Скринска, 1048127286, 1),
      (Дениян, Катърова, Патков, 1050066817, 1),
      (Малтина, Самсонов, Възвъзов, 1050034706, 2),
      (Фьодор, Занов, Тодоров, 1147019198, 2),
      (Трифонка, Канчин, Парашкевов, 1047087484, 2),
      (Ревка, Яков, Мангъфова, 1147274586, 1),
      (Десимиляна, Тумангелов, Куртакова, 1149196222, 3),
      (Панкртийян, Площако, Тодоров, 1044175187, 3),
      (Елемаг, Колев, Яркова, 1151222524, 3),
      (Яцо, Пръндачк, Крушовска, 1149203605, 2),
      (Пеню, Крушовска, Йоткова, 1047193625, 1);


-- -------------------------------------------------
-- TABLE Parent
-- -------------------------------------------------
INSERT INTO tbl_parent (fname, lname, phone, email)
VALUES
      (Лилко, Четрафилски, 0250591960, kolchodrishlov@example.com),
      (Златоцвет, Въртунински, (0756) 834-567, prundachkaeliz@example.org),
      (Пантера, Въртунинскиа, (0240) 279 766, tsotsovavgustin@example.org),
      (Ламбю, Яков, 0380 329 587, shusho01@example.org),
      (Въльо, Якова, 0849 205-180, shturbovkarin@example.org),
      (Жанин, Колипаткова, 0637611195, shenol67@example.org),
      (Липе, Чупетловск, +359(0)825 222575, roshlovobirdar@example.org),
      (Динна, Чупетловска, +359(0)418179781, nastradin64@example.com),
      (Любина, Количкова, (0794) 879976, vrazhalskifugo@example.net),
      (Боне, Градинаров, (0292) 453 959, todorovapepelota@example.net),
      (Дуда, Градинарова, 0552 409081, tisho1976@example.org),
      (Галена, Балахурова, +359(0)739 469 373, mochevelian@example.net),
      (Ъглен, Скринск, 0865 476 904, roshlovmariyan@example.net),
      (Шана, Скринска, (0566) 902 817, mtatozov@example.com),
      (Ройо, Патков, 0912 314-202, khernanizlatkov@example.net),
      (Цветилена, Паткова, (0408) 321305, sapundzhievaketi@example.org),
      (Ростислав, Възвъзов, 0218 508 286, tukhchievchernorizets@example.com),
      (Станиела, Възвъзова, (0162) 248684, khrelo1992@example.org),
      (Здравелин, Тодоров, (0042) 121-903, proikovaavo@example.com),
      (Хенриета, Тодорова, +359(0)765 289 317, tincho46@example.net),
      (Пацо, Парашкевов, (0947) 513-510, romeo87@example.com),
      (Васенка, Парашкевова, +359(0)078 893 031, kobilarovpetikongres@example.org),
      (Щерю, Мангъфов, (0013) 949000, slavilsimeonov@example.org),
      (Момера, Мангъфова, +359546960267, tocheva-klopovatonitsveta@example.com),
      (Максимилияна, Куртакова, +359(0)307 645 665, kloya1984@example.com),
      (Латьо, Тодоров, 0942951291, qkanchin@example.net),
      (Занка, Тодорова, (0715) 079-321, manavskichepo@example.org),
      (Пейо, Ярков, (0212) 023-409, karakashevicho@example.net),
      (Надка, Яркова, +359(0)230 020 471, laskar1979@example.com),
      (Истилян, Крушовск, 0660 022534, bumovpato@example.org),
      (Миглена, Крушовска, 0581 335 283, gradinarovagalina@example.org),
      (Асифа, Йоткова, 0622697550, slavilgokov@example.com);


-- -------------------------------------------------
-- TABLE StudentParent
-- -------------------------------------------------
INSERT INTO tbl_studentparent (student_id, parent_id)
VALUES
      (1, 1),
      (2, 2),
      (2, 3),
      (3, 4),
      (3, 5),
      (4, 6),
      (5, 7),
      (5, 8),
      (6, 9),
      (7, 10),
      (7, 11),
      (8, 12),
      (9, 13),
      (9, 14),
      (10, 15),
      (10, 16),
      (11, 17),
      (11, 18),
      (12, 19),
      (12, 20),
      (13, 21),
      (13, 22),
      (14, 23),
      (14, 24),
      (15, 25),
      (16, 26),
      (16, 27),
      (17, 28),
      (17, 29),
      (18, 30),
      (18, 31),
      (19, 32);

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
