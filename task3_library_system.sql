-- =====================================================
-- Task 3: Library Database
-- =====================================================
-- Lab 16: Database Design and Queries
-- =====================================================

-- Create Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year INT,
    category VARCHAR(50),
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    membership_type VARCHAR(30),
    membership_date DATE NOT NULL,
    expiry_date DATE,
    address VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Loans Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    fine_amount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Reservations Table
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_book_isbn ON Books(isbn);
CREATE INDEX idx_book_author ON Books(author);
CREATE INDEX idx_book_category ON Books(category);
CREATE INDEX idx_member_email ON Members(email);
CREATE INDEX idx_loan_member ON Loans(member_id);
CREATE INDEX idx_loan_book ON Loans(book_id);
CREATE INDEX idx_loan_date ON Loans(loan_date);
CREATE INDEX idx_loan_status ON Loans(status);
CREATE INDEX idx_due_date ON Loans(due_date);
CREATE INDEX idx_reservation_member ON Reservations(member_id);
CREATE INDEX idx_reservation_book ON Reservations(book_id);

-- =====================================================
-- QUERIES: CRUD Operations
-- =====================================================

-- Query 1: Insert a new book record
INSERT INTO Books (isbn, title, author, publisher, publication_year, category, total_copies, available_copies, price)
VALUES ('978-0-13-468599-1', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 'Programming', 5, 5, 35.99);

-- Query 2: Insert a new member
INSERT INTO Members (first_name, last_name, email, phone_number, membership_type, membership_date, expiry_date, address)
VALUES ('Neha', 'Mishra', 'neha.mishra@email.com', '9876543210', 'Premium', '2024-08-01', '2025-08-01', '456 Library Lane');

-- Query 3: Create a loan record (Member checks out a book)
INSERT INTO Loans (member_id, book_id, loan_date, due_date, status)
VALUES (1, 1, '2024-08-15', '2024-09-15', 'Active');

-- Query 4: Create a reservation
INSERT INTO Reservations (member_id, book_id, reservation_date, status)
VALUES (1, 1, '2024-08-10', 'Pending');

-- Query 5: Update book availability (after return)
UPDATE Books 
SET available_copies = available_copies + 1 
WHERE book_id = 1;

-- Query 6: Update loan status to returned
UPDATE Loans 
SET return_date = '2024-08-20', status = 'Returned' 
WHERE loan_id = 1;

-- Query 7: Update member membership expiry
UPDATE Members 
SET expiry_date = '2025-08-01' 
WHERE member_id = 1;

-- =====================================================
-- QUERIES: Fetch Operations
-- =====================================================

-- Query 8: Retrieve all books currently issued
SELECT 
    b.book_id,
    b.isbn,
    b.title,
    b.author,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.loan_date,
    l.due_date,
    l.status,
    DATEDIFF(l.due_date, CURDATE()) AS days_remaining
FROM Books b
INNER JOIN Loans l ON b.book_id = l.book_id
INNER JOIN Members m ON l.member_id = m.member_id
WHERE l.status = 'Active'
ORDER BY l.due_date;

-- Query 9: Find overdue books (loan date > 30 days)
SELECT 
    b.book_id,
    b.title,
    b.author,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS days_overdue,
    l.fine_amount
FROM Books b
INNER JOIN Loans l ON b.book_id = l.book_id
INNER JOIN Members m ON l.member_id = m.member_id
WHERE l.status = 'Active' AND DATEDIFF(CURDATE(), l.due_date) > 0
ORDER BY days_overdue DESC;

-- Query 10: Get book availability status
SELECT 
    book_id,
    title,
    author,
    total_copies,
    available_copies,
    (total_copies - available_copies) AS copies_issued,
    ROUND((available_copies / total_copies) * 100, 2) AS availability_percentage
FROM Books
ORDER BY availability_percentage ASC;

-- Query 11: Get member loan history
SELECT 
    l.loan_id,
    b.title,
    b.author,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status,
    l.fine_amount
FROM Loans l
INNER JOIN Books b ON l.book_id = b.book_id
WHERE l.member_id = 1
ORDER BY l.loan_date DESC;

-- Query 12: Get all active reservations
SELECT 
    r.reservation_id,
    b.title,
    b.author,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    r.reservation_date,
    r.status
FROM Reservations r
INNER JOIN Books b ON r.book_id = b.book_id
INNER JOIN Members m ON r.member_id = m.member_id
WHERE r.status = 'Pending'
ORDER BY r.reservation_date;

-- =====================================================
-- QUERIES: Aggregate Operations
-- =====================================================

-- Query 13: Count number of books loaned by each member
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(l.loan_id) AS total_loans,
    COUNT(CASE WHEN l.status = 'Active' THEN 1 END) AS active_loans,
    COUNT(CASE WHEN l.status = 'Returned' THEN 1 END) AS returned_books
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY total_loans DESC;

-- Query 14: Book borrowing statistics
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.category,
    COUNT(l.loan_id) AS total_times_borrowed,
    COUNT(DISTINCT l.member_id) AS unique_members,
    COUNT(CASE WHEN l.status = 'Active' THEN 1 END) AS currently_issued
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, b.author, b.category
ORDER BY total_times_borrowed DESC;

-- Query 15: Category-wise book statistics
SELECT 
    category,
    COUNT(DISTINCT book_id) AS total_books,
    SUM(total_copies) AS total_copies_available,
    SUM(available_copies) AS copies_in_stock,
    COUNT(DISTINCT l.loan_id) AS total_loans
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id
GROUP BY category
ORDER BY total_books DESC;

-- Query 16: Members with overdue books and fine collection
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    COUNT(l.loan_id) AS overdue_count,
    SUM(l.fine_amount) AS total_fine_due
FROM Members m
LEFT JOIN Loans l ON m.member_id = l.member_id
WHERE l.status = 'Active' AND DATEDIFF(CURDATE(), l.due_date) > 0
GROUP BY m.member_id, m.first_name, m.last_name, m.email
HAVING overdue_count > 0
ORDER BY total_fine_due DESC;

-- Query 17: Most popular authors
SELECT 
    author,
    COUNT(DISTINCT book_id) AS books_by_author,
    COUNT(l.loan_id) AS total_times_loaned,
    ROUND(COUNT(l.loan_id) / COUNT(DISTINCT book_id), 2) AS avg_loans_per_book
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id
GROUP BY author
HAVING COUNT(l.loan_id) > 0
ORDER BY total_times_loaned DESC
LIMIT 10;