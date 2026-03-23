-- =====================================================
-- Task 5: University Examination Database
-- =====================================================
-- Lab 16: Database Design and Queries
-- =====================================================

-- Create Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    date_of_birth DATE,
    department VARCHAR(50),
    semester INT,
    enrollment_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Subjects Table
CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_code VARCHAR(20) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    total_marks INT NOT NULL,
    pass_marks INT NOT NULL,
    department VARCHAR(50),
    semester INT,
    instructor_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Exams Table
CREATE TABLE Exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(100) NOT NULL,
    exam_type VARCHAR(50),
    subject_id INT NOT NULL,
    exam_date DATE NOT NULL,
    exam_time TIME,
    total_marks INT NOT NULL,
    duration_minutes INT,
    venue VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE RESTRICT
);

-- Create Results Table (Stores marks/scores for each exam)
CREATE TABLE Results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    marks_obtained INT NOT NULL,
    grade CHAR(2),
    remarks VARCHAR(100),
    exam_date DATE,
    entered_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    UNIQUE KEY unique_exam_student (exam_id, student_id)
);

-- Create StudentSubjects Table (Tracks which subjects each student studies)
CREATE TABLE StudentSubjects (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_subject (student_id, subject_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_student_rollnumber ON Students(roll_number);
CREATE INDEX idx_student_email ON Students(email);
CREATE INDEX idx_student_department ON Students(department);
CREATE INDEX idx_subject_code ON Subjects(subject_code);
CREATE INDEX idx_exam_subject ON Exams(subject_id);
CREATE INDEX idx_exam_date ON Exams(exam_date);
CREATE INDEX idx_result_exam ON Results(exam_id);
CREATE INDEX idx_result_student ON Results(student_id);
CREATE INDEX idx_studentsubject_student ON StudentSubjects(student_id);
CREATE INDEX idx_studentsubject_subject ON StudentSubjects(subject_id);

-- =====================================================
-- QUERIES: CRUD Operations
-- =====================================================

-- Query 1: Insert a new student record
INSERT INTO Students (roll_number, first_name, last_name, email, phone_number, date_of_birth, department, semester, enrollment_date)
VALUES ('CSE2024001', 'Rohan', 'Patel', 'rohan.patel@university.edu', '9876543210', '2005-03-15', 'Computer Science', 3, '2023-07-01');

-- Query 2: Insert subject records
INSERT INTO Subjects (subject_code, subject_name, credits, total_marks, pass_marks, department, semester)
VALUES 
('CS301', 'Database Systems', 4, 100, 40, 'Computer Science', 3),
('CS302', 'Web Development', 4, 100, 40, 'Computer Science', 3),
('CS303', 'Data Structures', 3, 100, 40, 'Computer Science', 3);

-- Query 3: Enroll student in subjects
INSERT INTO StudentSubjects (student_id, subject_id, enrollment_date, status)
VALUES 
(1, 1, '2024-08-01', 'Active'),
(1, 2, '2024-08-01', 'Active'),
(1, 3, '2024-08-01', 'Active');

-- Query 4: Create exam records
INSERT INTO Exams (exam_name, exam_type, subject_id, exam_date, exam_time, total_marks, duration_minutes, venue)
VALUES 
('Midterm Exam', 'Midterm', 1, '2024-09-15', '10:00:00', 50, 120, 'Room 301'),
('Midterm Exam', 'Midterm', 2, '2024-09-16', '10:00:00', 50, 120, 'Room 302'),
('Final Exam', 'Final', 1, '2024-11-20', '10:00:00', 50, 120, 'Room 301');

-- Query 5: Insert examination results for a student
INSERT INTO Results (exam_id, student_id, marks_obtained, grade, entered_by)
VALUES 
(1, 1, 42, 'A', 'Dr. Rishabh Mittal'),
(2, 1, 38, 'B+', 'Dr. Rishabh Mittal');

-- Query 6: Update examination result
UPDATE Results 
SET marks_obtained = 45, grade = 'A'
WHERE result_id = 1;

-- Query 7: Update student status
UPDATE Students 
SET is_active = TRUE
WHERE student_id = 1;

-- =====================================================
-- QUERIES: Fetch Operations
-- =====================================================

-- Query 8: Retrieve subject-wise marks for a student
SELECT 
    s.subject_code,
    s.subject_name,
    s.credits,
    s.total_marks,
    s.pass_marks,
    e.exam_name,
    e.exam_date,
    r.marks_obtained,
    r.grade,
    ROUND((r.marks_obtained / e.total_marks) * 100, 2) AS percentage
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
INNER JOIN Subjects s ON ss.subject_id = s.subject_id
LEFT JOIN Exams e ON s.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
WHERE st.student_id = 1
ORDER BY s.subject_code, e.exam_date;

-- Query 9: Get all exam results for a specific exam
SELECT 
    r.result_id,
    e.exam_name,
    e.exam_date,
    st.roll_number,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    s.subject_name,
    r.marks_obtained,
    e.total_marks,
    r.grade,
    ROUND((r.marks_obtained / e.total_marks) * 100, 2) AS percentage
FROM Results r
INNER JOIN Exams e ON r.exam_id = e.exam_id
INNER JOIN Students st ON r.student_id = st.student_id
INNER JOIN Subjects s ON e.subject_id = s.subject_id
WHERE e.exam_id = 1
ORDER BY r.marks_obtained DESC;

-- Query 10: Get all exams for a student in current semester
SELECT 
    e.exam_id,
    s.subject_code,
    s.subject_name,
    e.exam_name,
    e.exam_date,
    e.exam_time,
    e.total_marks,
    e.duration_minutes,
    e.venue
FROM Exams e
INNER JOIN Subjects s ON e.subject_id = s.subject_id
INNER JOIN StudentSubjects ss ON s.subject_id = ss.subject_id
WHERE ss.student_id = 1 AND ss.status = 'Active'
ORDER BY e.exam_date;

-- Query 11: Get student's complete academic record
SELECT 
    st.roll_number,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    st.department,
    st.semester,
    ss.enrollment_date,
    s.subject_code,
    s.subject_name,
    s.credits,
    r.marks_obtained,
    r.grade
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
INNER JOIN Subjects s ON ss.subject_id = s.subject_id
LEFT JOIN Exams e ON s.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
WHERE st.student_id = 1
ORDER BY s.subject_code;

-- =====================================================
-- QUERIES: Aggregate Operations
-- =====================================================

-- Query 12: Calculate average marks for each subject
SELECT 
    s.subject_id,
    s.subject_code,
    s.subject_name,
    s.total_marks,
    e.exam_name,
    COUNT(r.result_id) AS number_of_students,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    MAX(r.marks_obtained) AS highest_marks,
    MIN(r.marks_obtained) AS lowest_marks,
    ROUND((AVG(r.marks_obtained) / e.total_marks) * 100, 2) AS average_percentage
FROM Subjects s
INNER JOIN Exams e ON s.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id
GROUP BY s.subject_id, s.subject_code, s.subject_name, s.total_marks, e.exam_name
ORDER BY s.subject_code, e.exam_date;

-- Query 13: Student-wise total marks across all subjects
SELECT 
    st.student_id,
    st.roll_number,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    COUNT(DISTINCT ss.subject_id) AS subjects_enrolled,
    COUNT(r.result_id) AS exams_taken,
    SUM(r.marks_obtained) AS total_marks,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    ROUND((SUM(r.marks_obtained) / (COUNT(DISTINCT ss.subject_id) * 50)) * 100, 2) AS cgpa_equivalent
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
LEFT JOIN Exams e ON ss.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
GROUP BY st.student_id, st.roll_number, st.first_name, st.last_name
ORDER BY average_marks DESC;

-- Query 14: Grade distribution for a specific exam
SELECT 
    r.grade,
    COUNT(r.result_id) AS number_of_students,
    ROUND((COUNT(r.result_id) / (SELECT COUNT(*) FROM Results WHERE exam_id = 1)) * 100, 2) AS percentage
FROM Results r
WHERE r.exam_id = 1
GROUP BY r.grade
ORDER BY r.grade;

-- Query 15: Top performing students
SELECT 
    st.student_id,
    st.roll_number,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    st.department,
    COUNT(DISTINCT ss.subject_id) AS total_subjects,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    ROUND((AVG(r.marks_obtained) / 50) * 10, 2) AS cgpa
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
LEFT JOIN Exams e ON ss.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
WHERE st.is_active = TRUE AND r.marks_obtained IS NOT NULL
GROUP BY st.student_id, st.roll_number, st.first_name, st.last_name, st.department
HAVING AVG(r.marks_obtained) >= 40
ORDER BY average_marks DESC
LIMIT 20;

-- Query 16: Students at risk (scoring below pass marks)
SELECT 
    st.student_id,
    st.roll_number,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    s.subject_code,
    s.subject_name,
    s.pass_marks,
    r.marks_obtained,
    (s.pass_marks - r.marks_obtained) AS marks_short
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
INNER JOIN Subjects s ON ss.subject_id = s.subject_id
INNER JOIN Exams e ON s.subject_id = e.subject_id
INNER JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
WHERE r.marks_obtained < s.pass_marks
ORDER BY st.roll_number, marks_short DESC;

-- Query 17: Department-wise academic performance
SELECT 
    st.department,
    COUNT(DISTINCT st.student_id) AS total_students,
    COUNT(DISTINCT ss.subject_id) AS total_subjects,
    COUNT(r.result_id) AS total_exam_attempts,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    COUNT(CASE WHEN r.marks_obtained >= s.pass_marks THEN 1 END) AS passed_students,
    ROUND((COUNT(CASE WHEN r.marks_obtained >= s.pass_marks THEN 1 END) / COUNT(r.result_id)) * 100, 2) AS pass_percentage
FROM Students st
INNER JOIN StudentSubjects ss ON st.student_id = ss.student_id
INNER JOIN Subjects s ON ss.subject_id = s.subject_id
LEFT JOIN Exams e ON s.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id AND st.student_id = r.student_id
WHERE st.is_active = TRUE
GROUP BY st.department
ORDER BY average_marks DESC;

-- Query 18: Subject difficulty analysis
SELECT 
    s.subject_code,
    s.subject_name,
    s.total_marks,
    s.pass_marks,
    COUNT(r.result_id) AS total_attempts,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    COUNT(CASE WHEN r.marks_obtained >= s.pass_marks THEN 1 END) AS passed_count,
    ROUND((COUNT(CASE WHEN r.marks_obtained >= s.pass_marks THEN 1 END) / COUNT(r.result_id)) * 100, 2) AS pass_percentage
FROM Subjects s
LEFT JOIN Exams e ON s.subject_id = e.subject_id
LEFT JOIN Results r ON e.exam_id = r.exam_id
WHERE r.result_id IS NOT NULL
GROUP BY s.subject_id, s.subject_code, s.subject_name, s.total_marks, s.pass_marks
ORDER BY pass_percentage;