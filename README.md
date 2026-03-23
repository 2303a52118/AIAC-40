
# Lab 16 - Database Design and Queries

## 
- Designed 5 real-world database systems
- Implemented normalized schemas (1NF, 2NF, 3NF)
- Wrote optimized SQL queries with joins and aggregations
- Applied indexing and performance optimization techniques


---

## Overview
This lab focuses on understanding schema design principles for relational databases and writing optimized SQL queries. Each task includes:
- Creating normalized database schemas
- Designing primary keys, foreign keys, and relationships
- Writing CRUD operations (Create, Read, Update, Delete)
- Implementing aggregate queries and joins
- Query optimization strategies

---

## Task 1: Student Information System Schema
**File:** `task1_student_system.sql`

### Schema Design
Three main tables designed with proper relationships:
- **Students:** Stores student personal information
- **Courses:** Maintains course details with credits and instructor info
- **Enrollments:** Junction table establishing many-to-many relationship

### Key Features
- Primary keys for unique identification
- Foreign keys for referential integrity
- Unique constraints on email addresses
- Indexes on frequently queried fields

### Sample Queries
✅ Insert new student records  
✅ Fetch courses enrolled by a student  
✅ Count students in each course  
✅ Calculate average marks per course  
✅ Identify top-performing students

---

## Task 2: Hospital Management Database
**File:** `task2_hospital_system.sql`

### Schema Design
Four main tables with healthcare-specific fields:
- **Doctors:** Doctor profiles with specialization and licenses
- **Patients:** Patient demographic and medical history
- **Appointments:** Schedules linking doctors and patients

### Key Features
- License number uniqueness constraint
- Status tracking for appointments
- Medical history tracking
- Appointment scheduling with date/time validation

### Sample Queries
✅ List appointments for a specific doctor  
✅ Retrieve patient history by patient ID  
✅ Count total patients treated by each doctor  
✅ Find busiest doctors  
✅ Get appointments scheduled for coming week

---

## Task 3: Library Database
**File:** `task3_library_system.sql`

### Schema Design
Five main tables for library operations:
- **Books:** Book catalog with ISBN and availability
- **Members:** Library member profiles
- **Loans:** Track book checkouts and returns
- **Reservations:** Allow members to reserve books

### Key Features
- ISBN as unique identifier
- Stock quantity tracking
- Due date management for overdue books
- Fine calculation for late returns
- Reservation system for high-demand books

### Sample Queries
✅ Retrieve all books currently issued  
✅ Find overdue books (>30 days)  
✅ Count books loaned by each member  
✅ Most popular authors ranking  
✅ Book availability status report  
✅ Member loan history with statistics

---

## Task 4: E-commerce Platform Database
**File:** `task4_ecommerce_system.sql`

### Schema Design
Five main tables for online shopping:
- **Users:** Customer profiles and registration
- **Products:** Product catalog with pricing
- **Orders:** Customer purchase orders
- **OrderDetails:** Line items in each order
- **Reviews:** Product ratings and feedback

### Key Features
- Product stock management
- Order status tracking (Pending, Processing, Shipped, Delivered)
- Aggregate revenue calculations
- Customer purchase history
- Product review and rating system

### Sample Queries
✅ Retrieve all orders by a user  
✅ Find most purchased products  
✅ Calculate total revenue by month  
✅ Top spending customers analysis  
✅ Best rated products with reviews  
✅ Low stock products needing reorder  
✅ Monthly customer acquisition trends

---

## Task 5: University Examination Database
**File:** `task5_university_exam.sql`

### Schema Design
Five main tables for examination management:
- **Students:** Student enrollment and academic records
- **Subjects:** Course/subject details
- **Exams:** Exam scheduling and details
- **Results:** Marks and grades for each exam
- **StudentSubjects:** Student course enrollment tracking

### Key Features
- Roll number as unique student identifier
- Subject code and credits tracking
- Grade calculation and pass mark validation
- CGPA equivalent calculations
- Referential integrity constraints

### Sample Queries
✅ Insert examination results for students  
✅ Retrieve subject-wise marks for student  
✅ Calculate average marks for each subject  
✅ Top performing students ranking  
✅ Students at risk (scoring below pass marks)  
✅ Department-wise academic performance  
✅ Subject difficulty analysis

---

## Database Design Principles Applied

### 1. **Normalization**
- First Normal Form (1NF): Atomic values in all columns
- Second Normal Form (2NF): No partial dependencies
- Third Normal Form (3NF): No transitive dependencies

### 2. **Relationships**
- **One-to-Many:** Student → Enrollments → Courses
- **Many-to-Many:** Students ↔ Courses (via Enrollments)
- **Foreign Key Constraints:** Maintain referential integrity

### 3. **Indexing Strategy**
- Primary Key Indexes: Automatic on unique identifiers
- Foreign Key Indexes: For join operations
- Search Indexes: On frequently queried columns (email, code, status)
- Date Indexes: On date fields for range queries

### 4. **Data Integrity**
- NOT NULL constraints for required fields
- UNIQUE constraints for single-valued identifiers
- CHECK constraints for valid ranges
- DEFAULT values for common scenarios

---

## Query Optimization Tips

### 1. **SELECT Specific Columns**
```sql
-- Good
SELECT student_id, name, email FROM Students;

-- Avoid
SELECT * FROM Students;
```

### 2. **Use JOIN Instead of Subqueries**
```sql
-- Efficient
SELECT s.name, c.course_name 
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
```

### 3. **Add WHERE Clauses Early**
```sql
-- Good
SELECT * FROM Orders 
WHERE status = 'Active' AND order_date > DATE_SUB(NOW(), INTERVAL 30 DAY);
```

### 4. **Use Aggregate Functions Efficiently**
```sql
-- Efficient
SELECT category, COUNT(*), SUM(price) 
FROM Products 
GROUP BY category;
```

### 5. **Leverage Indexes**
- Query indexed columns in WHERE clause
- Use indexes for JOIN conditions
- Consider composite indexes for multiple column searches

---

## How to Use These Files

### 1. **Execute in MySQL/MariaDB:**
```bash
mysql -u username -p database_name < task1_student_system.sql
```

### 2. **Copy-paste queries in GUI tools:**
- MySQL Workbench
- DBeaver
- phpMyAdmin
- SQLite Browser

### 3. **Modify for Your Database:**
- Replace table names if needed
- Update field names for compatibility
- Adjust data types as required

---

## Additional Resources

### Foreign Key Constraints
- `ON DELETE CASCADE`: Automatically delete related records
- `ON DELETE RESTRICT`: Prevent deletion if related records exist
- `ON UPDATE CASCADE`: Update related records on parent update

### Aggregate Functions
- `COUNT()`: Number of rows
- `SUM()`: Total of numeric values
- `AVG()`: Average value
- `MAX()`/`MIN()`: Highest/lowest values

### Date Functions
- `CURDATE()`: Current date
- `DATE_ADD()`: Add days to date
- `DATEDIFF()`: Calculate days between dates
- `DATE_FORMAT()`: Format date output

---

## Common Modifications

### Change Database Engine
```sql
CREATE TABLE ... ENGINE = InnoDB;  -- Default for foreign keys
CREATE TABLE ... ENGINE = MyISAM;  -- Faster read-heavy operations
```

### Add Soft Delete (instead of actual delete)
```sql
ALTER TABLE Students ADD COLUMN deleted_at TIMESTAMP NULL;
SELECT * FROM Students WHERE deleted_at IS NULL;
```

### Enable Full-Text Search
```sql
CREATE FULLTEXT INDEX idx_search ON Products(title, description);
SELECT * FROM Products WHERE MATCH(title) AGAINST('keyword');
```

---

## Testing Your Queries

### 1. **Insert Sample Data**
Use the provided INSERT statements to populate tables with test data.

### 2. **Verify Relationships**
Check that foreign key constraints work correctly.

### 3. **Test Edge Cases**
- Empty result sets
- Duplicate records
- NULL values
- Boundary conditions

### 4. **Performance Testing**
Monitor query execution time using EXPLAIN:
```sql
EXPLAIN SELECT * FROM Students WHERE email = 'test@email.com';
```

---

## Lab Submission Checklist

- ✅ All 5 SQL files created with complete schemas
- ✅ Primary and foreign keys defined
- ✅ Relationships properly established
- ✅ CRUD queries demonstrated
- ✅ Aggregate queries with GROUP BY and HAVING
- ✅ JOIN operations across multiple tables
- ✅ Indexes created for optimization
- ✅ Constraints for data integrity
- ✅ Comments explaining design decisions
- ✅ Sample queries demonstrate all requirements

---

## Created By
**AI Assistant** - Assisting with Lab 16: Database Design and Queries  
**Course:** AI Assisted Coding (23CS002PC304)  
**Date:** 2024

For questions or clarifications, consult with **Dr. Rishabh Mittal** or your course instructors.
=======

