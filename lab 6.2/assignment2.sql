-- ============================================================================
-- DBMS LAB ASSIGNMENT 2: IMPLEMENTATION OF KEYS IN RELATIONAL DATABASES
-- Topic: University Management Database System
-- Tables: Department, Student, Course, Enrollment
-- ============================================================================

-- Enable Foreign Key enforcement (Required in SQLite; enabled by default in MySQL/PostgreSQL/Oracle)
PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- STEP 1: DROP TABLES (FOR CLEAN RE-RUNNABILITY)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 2: CREATE TABLES WITH APPROPRIATE CONSTRAINTS (TASK 1 & TASK 7)
-- ----------------------------------------------------------------------------

-- 1. Department Table
-- Stores department details: Department ID, Department Name, and HOD Name.
-- Constraints:
--   - Primary Key: Department_ID (Entity Integrity)
--   - Unique Key: Department_Name (No duplicate department names allowed)
CREATE TABLE Department (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50) NOT NULL UNIQUE,
    HOD_Name VARCHAR(50) NOT NULL
);

-- 2. Course Table
-- Stores course details: Course ID, Course Name, and Credits.
-- Constraints:
--   - Primary Key: Course_ID
--   - Check Constraint: Credits > 0 (Domain Integrity)
CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(100) NOT NULL,
    Credits INT NOT NULL CHECK (Credits > 0)
);

-- 3. Student Table
-- Stores student details: Student ID, Roll Number, Student Name, Email, and Department ID.
-- Constraints:
--   - Primary Key: Student_ID
--   - Candidate / Alternate Keys: Roll_Number (UNIQUE), Email (UNIQUE)
--   - Foreign Key: Department_ID references Department(Department_ID) (Referential Integrity)
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Roll_Number VARCHAR(20) NOT NULL UNIQUE,
    Student_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Department_ID INT NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 4. Enrollment Table (TASK 7: Composite Primary Key)
-- Stores courses registered by students: Student ID, Course ID, Semester, and Grade.
-- Constraints:
--   - Composite Primary Key: (Student_ID, Course_ID)
--   - Foreign Keys: Student_ID references Student(Student_ID)
--                   Course_ID references Course(Course_ID)
--   - Check Constraint: Semester between 1 and 8
CREATE TABLE Enrollment (
    Student_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Semester INT NOT NULL CHECK (Semester >= 1 AND Semester <= 8),
    Grade VARCHAR(2) DEFAULT 'NA',
    PRIMARY KEY (Student_ID, Course_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------
-- STEP 3: INSERT RECORDS (TASK 2 - At least 4-5 records per table)
-- ----------------------------------------------------------------------------

-- Insert into Department
INSERT INTO Department (Department_ID, Department_Name, HOD_Name) VALUES
(101, 'Computer Science & Engineering', 'Dr. Aris Thorne'),
(102, 'Electronics & Communication', 'Dr. Meera Nambiar'),
(103, 'Mechanical Engineering', 'Dr. Robert Vance'),
(104, 'Information Technology', 'Dr. Sunita Rao');

-- Insert into Course
INSERT INTO Course (Course_ID, Course_Name, Credits) VALUES
(501, 'Database Management Systems', 4),
(502, 'Data Structures & Algorithms', 4),
(503, 'Digital Signal Processing', 3),
(504, 'Thermodynamics', 3),
(505, 'Computer Networks', 3);

-- Insert into Student
INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) VALUES
(1, '23CS101', 'Aarav Sharma', 'aarav.sharma@univ.edu', 101),
(2, '23CS102', 'Bhavna Patel', 'bhavna.patel@univ.edu', 101),
(3, '23EC101', 'Chetan Kumar', 'chetan.kumar@univ.edu', 102),
(4, '23ME101', 'Divya Sen', 'divya.sen@univ.edu', 103),
(5, '23IT101', 'Eshan Verma', 'eshan.verma@univ.edu', 104);

-- Insert into Enrollment
INSERT INTO Enrollment (Student_ID, Course_ID, Semester, Grade) VALUES
(1, 501, 4, 'A+'),
(1, 502, 4, 'A'),
(2, 501, 4, 'A'),
(2, 505, 4, 'B+'),
(3, 503, 4, 'A'),
(4, 504, 4, 'B'),
(5, 501, 4, 'O');

-- ----------------------------------------------------------------------------
-- STEP 4: DISPLAY ALL RECORDS (TASK 3)
-- ----------------------------------------------------------------------------
SELECT '=== 1. DEPARTMENT TABLE RECORDS ===' AS Output;
SELECT * FROM Department;

SELECT '=== 2. COURSE TABLE RECORDS ===' AS Output;
SELECT * FROM Course;

SELECT '=== 3. STUDENT TABLE RECORDS ===' AS Output;
SELECT * FROM Student;

SELECT '=== 4. ENROLLMENT TABLE RECORDS ===' AS Output;
SELECT * FROM Enrollment;

-- ----------------------------------------------------------------------------
-- STEP 5: DEMONSTRATING CONSTRAINTS & OBSERVING ERRORS (TASKS 4, 5, 6, 8, 9)
-- ----------------------------------------------------------------------------

-- TASK 4: Demonstrate Primary Key Constraint
-- Attempting to insert a duplicate Primary Key value in Student table (Student_ID = 1 already exists)
-- EXPECTED RESULT: ERROR - UNIQUE constraint failed: Student.Student_ID
-- ----------------------------------------------------------------------------
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) 
-- VALUES (1, '23CS199', 'Duplicate PK Student', 'duplicate.pk@univ.edu', 101);

-- TASK 5: Demonstrate Unique Key (Alternate Key) Constraint
-- 5a. Attempting duplicate Roll Number ('23CS101' already exists)
-- EXPECTED RESULT: ERROR - UNIQUE constraint failed: Student.Roll_Number
-- ----------------------------------------------------------------------------
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) 
-- VALUES (6, '23CS101', 'Duplicate Roll Student', 'newroll@univ.edu', 101);

-- 5b. Attempting duplicate Email ('bhavna.patel@univ.edu' already exists)
-- EXPECTED RESULT: ERROR - UNIQUE constraint failed: Student.Email
-- ----------------------------------------------------------------------------
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) 
-- VALUES (7, '23CS103', 'Duplicate Email Student', 'bhavna.patel@univ.edu', 101);

-- TASK 6: Demonstrate Foreign Key Constraint
-- Attempting to insert a student with a non-existent Department ID (999 does not exist in Department table)
-- EXPECTED RESULT: ERROR - FOREIGN KEY constraint failed
-- ----------------------------------------------------------------------------
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) 
-- VALUES (8, '23CS104', 'Invalid Dept Student', 'invalid.dept@univ.edu', 999);

-- TASK 8: Demonstrate Composite Primary Key Constraint in Enrollment
-- Attempting duplicate combination of (Student_ID = 1, Course_ID = 501)
-- EXPECTED RESULT: ERROR - UNIQUE constraint failed: Enrollment.Student_ID, Enrollment.Course_ID
-- ----------------------------------------------------------------------------
-- INSERT INTO Enrollment (Student_ID, Course_ID, Semester, Grade) 
-- VALUES (1, 501, 4, 'A');

-- TASK 9: Insert the same student into a DIFFERENT course (Valid Composite Key combination)
-- Student_ID = 1 enrolling in Course_ID = 505 (Student 1 in 505 does not exist yet)
-- EXPECTED RESULT: ACCEPTED / SUCCESSFUL
-- ----------------------------------------------------------------------------
INSERT INTO Enrollment (Student_ID, Course_ID, Semester, Grade)
VALUES (1, 505, 4, 'A');

SELECT '=== TASK 9 VERIFICATION: Student 1 enrolled in new Course 505 ===' AS Output;
SELECT * FROM Enrollment WHERE Student_ID = 1 AND Course_ID = 505;

-- ----------------------------------------------------------------------------
-- STEP 6: JOIN OPERATIONS & QUERIES (TASKS 10, 11, 12)
-- ----------------------------------------------------------------------------

-- TASK 10: Display student details along with their corresponding department names
SELECT '=== TASK 10: Student Details with Department Name (INNER JOIN) ===' AS Output;
SELECT 
    s.Student_ID,
    s.Roll_Number,
    s.Student_Name,
    s.Email,
    d.Department_Name,
    d.HOD_Name
FROM Student s
INNER JOIN Department d ON s.Department_ID = d.Department_ID
ORDER BY s.Student_ID;

-- TASK 11: Display the courses registered by a particular student (e.g., Student_ID = 1)
SELECT '=== TASK 11: Courses Registered by Student 1 (Aarav Sharma) ===' AS Output;
SELECT 
    s.Student_ID,
    s.Student_Name,
    s.Roll_Number,
    c.Course_ID,
    c.Course_Name,
    c.Credits,
    e.Semester,
    e.Grade
FROM Student s
INNER JOIN Enrollment e ON s.Student_ID = e.Student_ID
INNER JOIN Course c ON e.Course_ID = c.Course_ID
WHERE s.Student_ID = 1;

-- TASK 12: Display comprehensive enrollment details using multi-table JOIN operations
SELECT '=== TASK 12: Comprehensive Student Enrollment Details (3-Table JOIN) ===' AS Output;
SELECT 
    s.Roll_Number,
    s.Student_Name,
    d.Department_Name,
    c.Course_ID,
    c.Course_Name,
    c.Credits,
    e.Semester,
    e.Grade
FROM Enrollment e
INNER JOIN Student s ON e.Student_ID = s.Student_ID
INNER JOIN Department d ON s.Department_ID = d.Department_ID
INNER JOIN Course c ON e.Course_ID = c.Course_ID
ORDER BY s.Student_ID, c.Course_ID;
