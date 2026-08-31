-- ============================================================================
-- DBMS LAB: IMPLEMENTATION OF DIFFERENT TYPES OF KEYS IN RELATIONAL DATABASE
-- Topic: University Database System (Department, Student, Course, Enrollment)
-- ============================================================================

-- Enable Foreign Key enforcement (required for SQLite; default in MySQL/PostgreSQL/Oracle)
PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- STEP 1: DROP TABLES IF THEY ALREADY EXIST (CLEAN RE-RUN CAPABILITY)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;

-- ----------------------------------------------------------------------------
-- STEP 2: TABLE CREATION WITH CONSTRAINTS (TASK 1 & TASK 7)
-- ----------------------------------------------------------------------------

-- 1. Department Table
-- Primary Key: Department_ID
-- Unique Key: Department_Name
CREATE TABLE Department (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50) NOT NULL UNIQUE,
    HOD_Name VARCHAR(50) NOT NULL
);

-- 2. Course Table
-- Primary Key: Course_ID
CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(100) NOT NULL,
    Credits INT NOT NULL CHECK (Credits > 0)
);

-- 3. Student Table
-- Primary Key: Student_ID
-- Unique Keys: Roll_Number, Email (Candidate Keys / Alternate Keys)
-- Foreign Key: Department_ID references Department(Department_ID)
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

-- 4. Enrollment Table
-- Composite Primary Key: (Student_ID, Course_ID) (TASK 7)
-- Foreign Keys: Student_ID references Student(Student_ID)
--               Course_ID references Course(Course_ID)
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
-- STEP 3: INSERT SAMPLE DATA (TASK 2 - At least 4-5 records per table)
-- ----------------------------------------------------------------------------

-- Insert records into Department
INSERT INTO Department (Department_ID, Department_Name, HOD_Name) VALUES
(101, 'Computer Science & Engineering', 'Dr. Aris Thorne'),
(102, 'Electronics & Communication', 'Dr. Meera Nambiar'),
(103, 'Mechanical Engineering', 'Dr. Robert Vance'),
(104, 'Information Technology', 'Dr. Sunita Rao');

-- Insert records into Course
INSERT INTO Course (Course_ID, Course_Name, Credits) VALUES
(501, 'Database Management Systems', 4),
(502, 'Data Structures & Algorithms', 4),
(503, 'Digital Signal Processing', 3),
(504, 'Thermodynamics', 3),
(505, 'Computer Networks', 3);

-- Insert records into Student
INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) VALUES
(1, '23CS101', 'Aarav Sharma', 'aarav.sharma@univ.edu', 101),
(2, '23CS102', 'Bhavna Patel', 'bhavna.patel@univ.edu', 101),
(3, '23EC101', 'Chetan Kumar', 'chetan.kumar@univ.edu', 102),
(4, '23ME101', 'Divya Sen', 'divya.sen@univ.edu', 103),
(5, '23IT101', 'Eshan Verma', 'eshan.verma@univ.edu', 104);

-- Insert records into Enrollment
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
SELECT '--- DEPARTMENT TABLE ---' AS Output;
SELECT * FROM Department;

SELECT '--- COURSE TABLE ---' AS Output;
SELECT * FROM Course;

SELECT '--- STUDENT TABLE ---' AS Output;
SELECT * FROM Student;

SELECT '--- ENROLLMENT TABLE ---' AS Output;
SELECT * FROM Enrollment;

-- ----------------------------------------------------------------------------
-- STEP 5: DEMONSTRATING CONSTRAINTS & OBSERVING ERRORS (TASKS 4, 5, 6, 8, 9)
-- ----------------------------------------------------------------------------

-- TASK 4: Demonstrate Primary Key Constraint
-- Attempting to insert a duplicate Primary Key value in Student table (Student_ID = 1 already exists)
-- EXPECTED RESULT: ERROR (UNIQUE constraint failed / Duplicate entry for Primary Key)
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID) 
-- VALUES (1, '23CS199', 'Ghost Student', 'ghost@univ.edu', 101);

-- TASK 5: Demonstrate Unique Key Constraint
-- 5a. Attempting duplicate Roll Number ('23CS101' already exists for Aarav Sharma)
-- EXPECTED RESULT: ERROR (UNIQUE constraint failed: Student.Roll_Number)
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID)
-- VALUES (6, '23CS101', 'Duplicate Roll User', 'newroll@univ.edu', 101);

-- 5b. Attempting duplicate Email ('bhavna.patel@univ.edu' already exists)
-- EXPECTED RESULT: ERROR (UNIQUE constraint failed: Student.Email)
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID)
-- VALUES (7, '23CS103', 'Duplicate Email User', 'bhavna.patel@univ.edu', 101);

-- TASK 6: Demonstrate Foreign Key Constraint
-- Attempting to insert a student with a non-existent Department ID (999 does not exist in Department)
-- EXPECTED RESULT: ERROR (FOREIGN KEY constraint failed)
-- INSERT INTO Student (Student_ID, Roll_Number, Student_Name, Email, Department_ID)
-- VALUES (8, '23CS104', 'Invalid Dept Student', 'invalid@univ.edu', 999);

-- TASK 8: Demonstrate Composite Primary Key Constraint in Enrollment
-- Attempting duplicate combination of (Student_ID = 1, Course_ID = 501)
-- EXPECTED RESULT: ERROR (UNIQUE constraint failed: Enrollment.Student_ID, Enrollment.Course_ID)
-- INSERT INTO Enrollment (Student_ID, Course_ID, Semester, Grade)
-- VALUES (1, 501, 4, 'A');

-- TASK 9: Insert the same student into a DIFFERENT course (Valid Composite Key combination)
-- Student_ID = 1 enrolling in Course_ID = 505 (Student 1 in 505 does not exist yet)
-- EXPECTED RESULT: ACCEPTED / SUCCESSFUL INSERTION
INSERT INTO Enrollment (Student_ID, Course_ID, Semester, Grade)
VALUES (1, 505, 4, 'A');

-- Verify insertion for Task 9
SELECT '--- TASK 9 VERIFICATION: Student 1 in Course 505 ---' AS Output;
SELECT * FROM Enrollment WHERE Student_ID = 1 AND Course_ID = 505;

-- ----------------------------------------------------------------------------
-- STEP 6: JOIN OPERATIONS & QUERIES (TASKS 10, 11, 12)
-- ----------------------------------------------------------------------------

-- TASK 10: Display student details along with their corresponding department names
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

-- TASK 11: Display the courses registered by a particular student (e.g., Student_ID = 1 or 'Aarav Sharma')
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

-- TASK 12: Display comprehensive enrollment details using appropriate JOIN operations
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
