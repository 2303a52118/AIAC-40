-- =====================================================
-- Task 2: Hospital Management Database
-- =====================================================
-- Lab 16: Database Design and Queries
-- =====================================================

-- Create Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    experience_years INT,
    available_hours VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    phone_number VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    registration_date DATE NOT NULL,
    medical_history TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    appointment_duration INT,
    reason_for_visit VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    UNIQUE KEY unique_appointment (doctor_id, patient_id, appointment_date, appointment_time),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_doctor_license ON Doctors(license_number);
CREATE INDEX idx_doctor_specialization ON Doctors(specialization);
CREATE INDEX idx_patient_email ON Patients(email);
CREATE INDEX idx_appointment_doctor ON Appointments(doctor_id);
CREATE INDEX idx_appointment_patient ON Appointments(patient_id);
CREATE INDEX idx_appointment_date ON Appointments(appointment_date);
CREATE INDEX idx_appointment_status ON Appointments(status);

-- =====================================================
-- QUERIES: CRUD Operations
-- =====================================================

-- Query 1: Insert a new doctor record
INSERT INTO Doctors (doctor_name, license_number, specialization, phone_number, email, experience_years, available_hours)
VALUES ('Dr. Priya Singh', 'MED123456', 'Cardiology', '9876543210', 'priya.singh@hospital.com', 10, '9AM-5PM');

-- Query 2: Insert a new patient record
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, phone_number, email, address, registration_date)
VALUES ('Amit', 'Sharma', '1990-05-20', 'Male', '9876543211', 'amit.sharma@email.com', '123 Medical Plaza', '2024-08-01');

-- Query 3: Schedule an appointment
INSERT INTO Appointments (doctor_id, patient_id, appointment_date, appointment_time, appointment_duration, reason_for_visit, status)
VALUES (1, 1, '2024-09-15', '10:00:00', 30, 'Regular checkup', 'Scheduled');

-- Query 4: Update appointment status
UPDATE Appointments 
SET status = 'Completed', notes = 'Patient stable, continue medication'
WHERE appointment_id = 1;

-- Query 5: Update patient medical history
UPDATE Patients 
SET medical_history = 'Hypertension, Diabetes Type 2' 
WHERE patient_id = 1;

-- Query 6: Cancel an appointment
UPDATE Appointments 
SET status = 'Cancelled' 
WHERE appointment_id = 1;

-- =====================================================
-- QUERIES: Fetch Operations
-- =====================================================

-- Query 7: List all appointments for a specific doctor
SELECT 
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone_number,
    a.reason_for_visit,
    a.status
FROM Appointments a
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
INNER JOIN Patients p ON a.patient_id = p.patient_id
WHERE d.doctor_id = 1
ORDER BY a.appointment_date, a.appointment_time;

-- Query 8: List all appointments for a specific date
SELECT 
    a.appointment_id,
    a.appointment_time,
    d.doctor_name,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.reason_for_visit,
    a.status
FROM Appointments a
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
INNER JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date = '2024-09-15'
ORDER BY a.appointment_time;

-- Query 9: Retrieve patient history by patient ID
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.date_of_birth,
    p.gender,
    p.medical_history,
    a.appointment_id,
    d.doctor_name,
    d.specialization,
    a.appointment_date,
    a.reason_for_visit,
    a.notes
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE p.patient_id = 1
ORDER BY a.appointment_date DESC;

-- Query 10: Get all appointments by status
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointments a
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
INNER JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date;

-- =====================================================
-- QUERIES: Aggregate Operations
-- =====================================================

-- Query 11: Count total patients treated by each doctor
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    COUNT(DISTINCT a.patient_id) AS total_patients_treated,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization
ORDER BY total_patients_treated DESC;

-- Query 12: Get doctor appointments count by status
SELECT 
    d.doctor_name,
    d.specialization,
    a.status,
    COUNT(a.appointment_id) AS appointment_count
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization, a.status
ORDER BY d.doctor_name, a.status;

-- Query 13: Find busiest doctors (most appointments)
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    AVG(a.appointment_duration) AS avg_appointment_duration
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization
HAVING COUNT(a.appointment_id) > 0
ORDER BY total_appointments DESC;

-- Query 14: Get appointments scheduled for coming week
SELECT 
    a.appointment_id,
    d.doctor_name,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date,
    a.appointment_time,
    a.reason_for_visit
FROM Appointments a
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
INNER JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
AND a.status = 'Scheduled'
ORDER BY a.appointment_date, a.appointment_time;

-- Query 15: Get doctors by specialization with patient count
SELECT 
    specialization,
    COUNT(DISTINCT doctor_id) AS number_of_doctors,
    COUNT(DISTINCT p.patient_id) AS total_patients_in_specialty
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY specialization
ORDER BY number_of_doctors DESC;