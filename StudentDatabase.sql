CREATE DATABASE IF NOT EXISTS EduData;
USE EduData;

CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255),
    student_add VARCHAR(255),
    student_gradelvl VARCHAR(20),
    student_gpa DECIMAL(3,2),
    student_dob DATE,
    student_phone VARCHAR(15)
);

INSERT INTO Students (student_id, student_name, student_add, student_gradelvl, student_gpa, student_dob, student_phone) VALUES
(850283175, 'Alice Johnson', '1555 Seminole Ct.', 'Freshman', 3.74, '2005-02-08', '704-552-1810'),
(850295618, 'Bob Smith', '878 Madison Ave.', 'Sophomore', 3.87, '2004-06-03', '336-316-5434'),
(850296174, 'Ben Lopez', '4200 Olive Ave.', 'Junior', 4.00, '2002-02-09', '803-432-6225'),
(850295278, 'Lily Martinez', '608 Old Post Rd.', 'Senior', 2.95, '1999-10-08', '404-243-7379'),
(850199374, 'Ava Harris', '235 Easton Ave.', 'Freshman', 3.42, '2001-07-18', '904-992-7234'),
(850992648, 'Daniel Wright', '2508 W. Shaw Rd.', 'Sophomore', 3.62, '2004-02-22', '919-809-2545'),
(850193625, 'Emily Davis', '200 Pembury Ln.', 'Junior', 2.84, '1999-04-21', '803-432-7600'),
(850291764, 'Carter Cooper', '4990 S. Pine St.', 'Senior', 3.48, '2002-03-25', '919-355-0034'),
(850199285, 'Logan Bennett', '1200 Little St.', 'Freshman', 3.82, '2005-04-25', '803-432-1987'),
(850228498, 'Jack Ramirez', '7822 N. Ridge Rd.', 'Sophomore', 3.55, '2000-12-05', '904-725-4672'),
(850002648, 'Sophia Jenkins', '4090 Caldweld St.', 'Junior', 4.00, '2003-04-25', '704-365-7655'),
(850111258, 'Samuel Turner', '3320 W. Main St.', 'Sophomore', 3.60, '2001-09-14', '704-372-9000'),
(850349264, 'Betty Draper', '1600 Sardis Rd.', 'Freshman', 3.28, '2002-01-08', '918-941-9121');

CREATE TABLE IF NOT EXISTS Courses (
    course_id INT PRIMARY KEY,
    faculty_id INT,
    course_name VARCHAR(255),
    semester VARCHAR(20),
    credits INT,
    course_fee DECIMAL(6,2)
);

INSERT INTO Courses (course_id, faculty_id, course_name, semester, credits, course_fee) VALUES
(100, 8501, 'Mathematics 101', 'Fall', 3, 55.50),
(200, 8502, 'English Composition', 'Spring', 3, 80.00),
(300, 8504, 'History of Art', 'Fall', 3, 90.00),
(350, 8503, 'Biology', 'Fall', 3, 85.75),
(400, 8503, 'Physics', 'Fall', 4, 50.50),
(500, 8505, 'Physical Education', 'Summer', 3, 50.00),
(600, 8506, 'Intro to SQL', 'Spring', 5, 100.50),
(700, 8501, 'Statistics', 'Fall', 3, 50.50),
(800, 8503, 'Chemistry', 'Spring', 3, 50.75),
(850, 8504, 'Painting', 'Summer', 4, 70.00);

CREATE TABLE IF NOT EXISTS Faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(255),
    department VARCHAR(255),
    start_date DATE
);

INSERT INTO Faculty (faculty_id, faculty_name, department, start_date) VALUES
(8501, 'Mrs. Taylor', 'Mathematics', '2018-10-28'),
(8502, 'Mrs. Moore', 'English', '2013-11-03'),
(8503, 'Mr. Patel', 'Science', '2021-11-14'),
(8504, 'Mr. Jones', 'Art & History', '2017-11-20'),
(8505, 'Mr. Smith', 'Physical Education', '2011-11-20'),
(8506, 'Mrs. Miller', 'Computer Science', '2019-12-19');

CREATE TABLE IF NOT EXISTS Grades (
    student_id INT,
    course_id INT,
    finalgrade INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Grades (student_id, course_id, finalgrade) VALUES
(850291764, 850, 75),
(850111258, 600, 84),
(850349264, 100, 72),
(850349264, 100, 85),
(850295618, 500, 97),
(850992648, 600, 85),
(850228498, 200, 72),
(850992648, 700, 81),
(850283175, 300, 90),
(850193625, 700, 82),
(850002648, 200, 79),
(850295278, 600, 62),
(850296174, 400, 68),
(850291764, 600, 75),
(850111258, 200, 95),
(850228498, 800, 92),
(850295278, 350, 57);

-- 1. Create a view named 'Honor_Roll'
CREATE VIEW Honor_Roll AS
SELECT student_id, student_name, student_gradelvl, student_gpa
FROM Students
WHERE student_gpa >= 3.6;

-- 2. Create a view named 'Under_80'
CREATE VIEW Under_80 AS
SELECT student_name, student_gradelvl, finalgrade
FROM Students
JOIN Grades ON Students.student_id = Grades.student_id
WHERE finalgrade < 80;

-- 3. Create a view named 'English'
CREATE VIEW English AS
SELECT student_name, student_phone, finalgrade
FROM Students
JOIN Grades ON Students.student_id = Grades.student_id
JOIN Courses ON Grades.course_id = Courses.course_id
JOIN Faculty ON Courses.faculty_id = Faculty.faculty_id
WHERE Faculty.department = 'English';

-- 4. Create a view named 'Faculty_Start'
CREATE VIEW Faculty_Start AS
SELECT course_name, semester, credits, faculty_name
FROM Courses
JOIN Faculty ON Courses.faculty_id = Faculty.faculty_id
WHERE Faculty.start_date BETWEEN '2011-01-01' AND '2018-01-01';

-- 5. Create a view named 'Advanced_Courses'
CREATE VIEW Advanced_Courses AS
SELECT course_id, course_name, semester, faculty_name
FROM Courses
JOIN Faculty ON Courses.faculty_id = Faculty.faculty_id
WHERE course_fee LIKE '5%';

-- 6. Create indexes
CREATE INDEX student_id ON Students (student_id);
CREATE INDEX name ON Students (student_name);
CREATE INDEX grade ON Grades (student_id, finalgrade);

-- 7. Drop the 'name' index
DROP INDEX name ON Students;

-- 8. Specify GPA integrity constraint
ALTER TABLE Students
ADD CONSTRAINT check_gpa_range CHECK (student_gpa BETWEEN 0.0 AND 4.0);

-- 9. Create foreign keys
ALTER TABLE Courses
ADD CONSTRAINT fk_faculty_id FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id);

ALTER TABLE Grades
ADD CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES Students(student_id);

-- 10. Add 'pay' field to Faculty table
ALTER TABLE Faculty
ADD pay INT;

-- 11. Update 'pay' field for Mr. Smith
UPDATE Faculty
SET pay = 60000
WHERE faculty_name = 'Mr. Smith';

-- 12. Change length of 'department' field
ALTER TABLE Faculty
MODIFY department VARCHAR(30);

-- 13. Command to delete Faculty table
-- DROP TABLE Faculty;

SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';






