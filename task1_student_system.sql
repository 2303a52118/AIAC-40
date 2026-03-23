-- =====================================================
-- Task 1: Student Information System Schema
-- =====================================================
-- Lab 16: Database Design and Queries
-- =====================================================

-- Create Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    date_of_birth DATE,
    enrollment_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    instructor_name VARCHAR(100),
    semester INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Enrollments Table (Junction Table for Student-Course relationship)
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade CHAR(1),
    marks INT,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_student_email ON Students(email);
CREATE INDEX idx_course_code ON Courses(course_code);
CREATE INDEX idx_enrollment_student ON Enrollments(student_id);
CREATE INDEX idx_enrollment_course ON Enrollments(course_id);

-- =====================================================
-- QUERIES: CRUD Operations
-- =====================================================

-- Query 1: Insert a new student record
INSERT INTO Students (first_name, last_name, email, phone_number, date_of_birth, enrollment_date)
VALUES ('Raj', 'Kumar', 'raj.kumar@email.com', '9876543210', '2005-06-15', '2024-08-01');

-- Query 2: Insert a new course
INSERT INTO Courses (course_code, course_name, credits, instructor_name, semester, description)
VALUES ('CS301', 'Database Management Systems', 4, 'Dr. Rishabh Mittal', 3, 'Fundamental concepts of DBMS and SQL');

-- Query 3: Insert an enrollment record (Student enrolls in a course)
INSERT INTO Enrollments (student_id, course_id, enrollment_date, status)
VALUES (1, 1, '2024-08-01', 'Active');

-- Query 4: Update student information
UPDATE Students 
SET phone_number = '9876543211' 
WHERE student_id = 1;

-- Query 5: Update enrollment grade
UPDATE Enrollments 
SET grade = 'A', marks = 85 
WHERE student_id = 1 AND course_id = 1;

-- Query 6: Delete an enrollment
DELETE FROM Enrollments 
WHERE student_id = 1 AND course_id = 1;

-- =====================================================
-- QUERIES: Fetch Operations
-- =====================================================

-- Query 7: Fetch all courses enrolled by a specific student
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.credits,
    c.instructor_name,
    e.enrollment_date,
    e.grade,
    e.marks
FROM Courses c
INNER JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.student_id = 1;

-- Query 8: Fetch all students in a specific course
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    e.enrollment_date,
    e.grade,
    e.marks
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 1
ORDER BY s.first_name;

-- Query 9: Fetch all active enrollments
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE e.status = 'Active';

-- =====================================================
-- QUERIES: Aggregate Operations
-- =====================================================

-- Query 10: Count number of students in each course
SELECT 
    c.course_code,
    c.course_name,
    COUNT(e.student_id) AS number_of_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY number_of_students DESC;

-- Query 11: Get average marks for each course
SELECT 
    c.course_code,
    c.course_name,
    COUNT(e.student_id) AS total_students,
    AVG(e.marks) AS average_marks,
    MAX(e.marks) AS highest_marks,
    MIN(e.marks) AS lowest_marks
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name
HAVING COUNT(e.student_id) > 0;

-- Query 12: Get student performance summary (average marks across all courses)
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    COUNT(e.course_id) AS courses_enrolled,
    AVG(e.marks) AS average_marks
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY average_marks DESC;

-- Query 13: Find students who scored above 80 in any course
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    e.marks,
    e.grade
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE e.marks > 80
ORDER BY e.marks DESC;