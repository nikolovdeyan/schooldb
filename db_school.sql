-- ==========================================================
-- Author: Deyan Nikolov
-- Date: 2023-11-10
-- Version: 1.5
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


-- ----------------------------------------------------------
-- Sample data
-- ----------------------------------------------------------

-- -------------------------------------------------
-- TABLE Teacher
-- -------------------------------------------------
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
      ('Нансимир', 'Тумангело', 'Четрафилски', '1143199857', 2),
      ('Генчо', 'Даче', 'Дришльов', '1052148143', 3),
      ('Джиневра', 'Плюнков', 'Чанлиева', '1152129298', 1),
      ('Деспин', 'Яков', 'Бобев', '1053289499', 1),
      ('Симона', 'Плюнков', 'Балахуров', '1052263718', 3),
      ('Щедю', 'Кобиларо', 'Фенеров', '1041253446', 3),
      ('Вежда', 'Клатикрушев', 'Дзезов', '1146225041', 2),
      ('Христодор', 'Мустакова', 'Патков', '1046083612', 1),
      ('Адем', 'Мочев', 'Крушовска', '1044192066', 2),
      ('Риналдо', 'Манавски', 'Катърова', '1152145109', 1),
      ('Малтина', 'Самсонов', 'Възвъзов', '1143216953', 1),
      ('Бенелена', 'Костов', 'Чутурков', '1044056442', 1),
      ('Алдин', 'Кьоров', 'ЕвроповКирилов', '1053157287', 1),
      ('Божо', 'Парашкевов', 'Цицков', '1146043053', 1),
      ('Рачко', 'Мангъфова', 'Шкембова', '1050037167', 1),
      ('Начиян', 'Пикянски', 'Катъров', '1150248829', 3),
      ('Ружка', 'Мерако', 'Самсонов', '1051239208', 2),
      ('Лукан', 'Яко', 'Кодуков', '1049233524', 2),
      ('Илия', 'Андонов', 'Яназов', '1153023897', 1);


-- -------------------------------------------------
-- TABLE Parent
-- -------------------------------------------------
INSERT INTO tbl_parent (fname, lname, phone, email)
VALUES
      ('Лилко', 'Четрафилски', '0250591960', 'kolchodrishlov@example.com'),
      ('Жива', 'Четрафилскиа', '(0254) 756 834', 'mladenovyatan@example.com'),
      ('Ламбо', 'Дришльов', '(0240) 279 766', 'tsotsovavgustin@example.org'),
      ('Десимиляна', 'Дришльова', '+359(0)941663803', 'tupchileshtovpetrinel@example.com'),
      ('Адриан', 'Чанлиев', '+359(0)091 784920', 'burborkovfratsil@example.net'),
      ('Айрен', 'Чанлиева', '0511876346', 'kolipatkovnanyu@example.com'),
      ('Недялко', 'Бобев', '0671 347 618', 'mochevshishman@example.org'),
      ('Доча', 'Бобева', '+359(0)575 480 204', 'purvanovavula@example.com'),
      ('Фатиме', 'Балахурова', '+359645320095', 'yanik94@example.net'),
      ('Еремия', 'Фенеров', '(0552) 619 292', 'mochevdeyan@example.net'),
      ('Мимоза', 'Фенерова', '(0911) 625-552', 'kurkovpetko@example.org'),
      ('Дефлорина', 'Дзезова', '+359(0)979 112 739', 'mishka1990@example.net'),
      ('Лоти', 'Паткова', '0358 876865', 'patkovlenko@example.net'),
      ('Севда', 'Крушовска', '(0956) 690281', 'robertosamsonov@example.net'),
      ('Еким', 'Катъров', '(0791) 231-420', 'mladenovkhernani@example.net'),
      ('Цветилена', 'Катърова', '(0408) 321305', 'sapundzhievaketi@example.org'),
      ('Правда', 'Възвъзова', '+359(0)185 082 862', 'zanovzoltan@example.com'),
      ('Гетислав', 'Чутурков', '0868465260', 'adriyanzenginov@example.net'),
      ('Гергелюб', 'ЕвроповКирилов', '+359(0)903 380782', 'yugi2019@example.net'),
      ('Николина', 'ЕвроповКирилова', '0289 317954', 'mstanishev@example.net'),
      ('Хасатин', 'Цицков', '0513 510-958', 'yastrebandonov@example.org'),
      ('Драгица', 'Цицкова', '+359(0)788930315', 'inan1979@example.net'),
      ('Чвор', 'Шкембов', '+359(0)139490007', 'nkuchev@example.com'),
      ('Робърт', 'Катъров', '(0602) 671 884', 'prostisveta43@example.net'),
      ('Евстатий', 'Самсонов', '+359(0)764566593', 'zenginovnedyu@example.org'),
      ('Анимира', 'Самсонова', '0494 295 129', 'chupetlovskaionika@example.net'),
      ('Адрианиа', 'Кодукова', '0932 138-115', 'kesovpeio@example.net'),
      ('Фиро', 'Яназов', '+359(0)340 955 952', 'kostovevstakhii@example.org'),
      ('Берислава, 'Яназова', '+359(0)047 132 679', 'anza85@example.com');


-- -------------------------------------------------
-- TABLE StudentParent
-- -------------------------------------------------
INSERT INTO tbl_studentparent (student_id, parent_id)
VALUES
      (1, 1),
      (1, 2),
      (2, 3),
      (2, 4),
      (3, 5),
      (3, 6),
      (4, 7),
      (4, 8),
      (5, 9),
      (6, 10),
      (6, 11),
      (7, 12),
      (8, 13),
      (9, 14),
      (10, 15),
      (10, 16),
      (11, 17),
      (12, 18),
      (13, 19),
      (13, 20),
      (14, 21),
      (14, 22),
      (15, 23),
      (16, 24),
      (17, 25),
      (17, 26),
      (18, 27),
      (19, 28),
      (19, 29);
