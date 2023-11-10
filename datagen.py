## Python script to generate fake data for the school database exercise
import csv
import datetime
import random
from faker import Faker
from transliterator import transliterate

def generate_parents(lname):
    "Generate one or two parents for a student while preserving the last name of the student."
    lname = lname[:-1] if lname.endswith("а") else lname
    parents = []
    num_parents = random.randint(1, 2)
    if num_parents == 1:
        sex = random.choice(["male", "female"])
        if sex == "male":
            parent = {
                "fname": fake.first_name_male(),
                "lname": lname,
                "phone": fake.phone_number(),
                "email": fake.email(),
            }
        else:
            parent = {
                "fname": fake.first_name_female(),
                "lname": lname + "а",
                "phone": fake.phone_number(),
                "email": fake.email(),
            }
        parents.append(parent)
    else:
        parent_m = {
            "fname": fake.first_name_male(),
            "lname": lname,
            "phone": fake.phone_number(),
            "email": fake.email(),
        }
        parent_f = {
            "fname": fake.first_name_female(),
            "lname": lname + "а",
            "phone": fake.phone_number(),
            "email": fake.email(),
        }
        parents.append(parent_m)
        parents.append(parent_f)
    return parents

def generate_egn():
    "A quick egn generator, control code and sex are not taken into consideration."
    year_of_birth = random.choice(["10", "11"])
    month_of_birth = str(random.randint(41, 53))
    day_of_birth = random.randint(1, 28)
    control_code = str(random.randint(2000, 9999))
    egn = f"{year_of_birth}{month_of_birth}{day_of_birth:02d}{control_code}"
    return egn

with open("db_school.sql", "w") as f:
    f.write("""
-- ==========================================================
-- Author: Deyan Nikolov
-- Date: 2023-11-10
-- Version: 1.6
-- Desc: Database script for an imaginary school data system
-- ==========================================================
""")

    f.write("\n")
    f.write("""
DROP SCHEMA IF EXISTS db_school;

CREATE SCHEMA IF NOT EXISTS db_school DEFAULT CHARACTER SET utf8;
USE db_school;
""")

    f.write("\n")
    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")
    f.write("\n")

    f.write("""
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
""")

    f.write("\n")
    f.write("""
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
""")


    f.write("\n")
    f.write("""
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
""")


    fake = Faker('bg_BG')
    Faker.seed(4)

    f.write("\n")
    f.write("""
-- ==========================================================
-- Generated Data
-- ==========================================================
""")

    f.write("""
-- ----------------------------------------------------------
-- TABLE Teacher
-- ----------------------------------------------------------
INSERT INTO tbl_teacher (fname, lname, phone, email)
VALUES
""")
    for _ in range(14):
        fname = fake.first_name()
        lname = fake.last_name()
        phone = fake.phone_number()
        email = transliterate(fname[0]).lower() + transliterate(lname).lower() + "@fakesou.bg"
        f.write(f"      ('{fname}', '{lname}', '{phone}', '{email}'),\n")
    fname = fake.first_name()
    lname = fake.last_name()
    phone = fake.phone_number()
    email = transliterate(fname[0]).lower() + transliterate(lname).lower() + "@fakesou.bg"
    f.write(f"      ('{fname}', '{lname}', '{phone}', '{email}');\n")


    f.write("""
-- ----------------------------------------------------------
-- TABLE Class
-- ----------------------------------------------------------
INSERT INTO tbl_class (name, teacher_id)
VALUES
      ('7а', 1),
      ('7б', 2),
      ('7в', 3);

""")


    students = []
    for i in range(1, 20):
        student = {
            "id": i,
            "fname": fake.first_name(),
            "mname": fake.last_name()[:-1] if fake.last_name().endswith("а") else fake.last_name(),
            "lname": fake.last_name(),
            "egn": generate_egn(),
            "class": random.randint(1,3),
        }
        student["parents"] = generate_parents(student["lname"])
        students.append(student)

        parents = []
        parent_id = 1
        for student in students:
            for p in student["parents"]:
                parent = {
                    "parent_id": parent_id,
                    "student_id": student["id"],
                    "fname": p["fname"],
                    "lname": p["lname"],
                    "phone": p["phone"],
                    "email": p["email"]
                }
            parents.append(parent)
            parent_id += 1

    f.write("""
-- ----------------------------------------------------------
-- TABLE Student
-- ----------------------------------------------------------
INSERT INTO tbl_student (fname, mname, lname, egn, class_id)
VALUES
""")
    for student in students[:-1]:
        f.write(f"      ('{student['fname']}', '{student['mname']}', '{student['lname']}', '{student['egn']}', {student['class']}),\n")
    f.write(f"      ('{students[-1]['fname']}', '{students[-1]['mname']}', '{students[-1]['lname']}', '{students[-1]['egn']}', {students[-1]['class']});\n")

    f.write("""
-- ----------------------------------------------------------
-- TABLE Parent
-- ----------------------------------------------------------
INSERT INTO tbl_parent (fname, lname, phone, email)
VALUES
""")
    for parent in parents[:-1]:
        f.write(f"      ('{parent['fname']}', '{parent['lname']}', '{parent['phone']}', '{parent['email']}'),\n")
    f.write(f"      ('{parents[-1]['fname']}', '{parents[-1]['lname']}', '{parents[-1]['phone']}', '{parents[-1]['email']}');\n")


    f.write("""
-- ----------------------------------------------------------
-- TABLE StudentParent
-- ----------------------------------------------------------
INSERT INTO tbl_studentparent (student_id, parent_id)
VALUES
""")
    for parent in parents[:-1]:
        f.write(f"      ({parent['student_id']}, {parent['parent_id']}),\n")
    f.write(f"      ({parents[-1]['student_id']}, {parents[-1]['parent_id']});\n")
