-- =====================================================
-- Task 4: E-commerce Platform Database
-- =====================================================
-- Lab 16: Database Design and Queries
-- =====================================================

-- Create Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT,
    supplier_id INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) DEFAULT 'Pending',
    shipment_address VARCHAR(255),
    payment_method VARCHAR(50),
    total_amount DECIMAL(12, 2),
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(12, 2),
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE RESTRICT
);

-- Create OrderDetails Table (Items in each order)
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    line_total DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE RESTRICT,
    UNIQUE KEY unique_order_product (order_id, product_id)
);

-- Create Reviews Table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    helpful_count INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_user_email ON Users(email);
CREATE INDEX idx_user_username ON Users(username);
CREATE INDEX idx_product_category ON Products(category);
CREATE INDEX idx_product_sku ON Products(sku);
CREATE INDEX idx_order_user ON Orders(user_id);
CREATE INDEX idx_order_status ON Orders(order_status);
CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_orderdetail_order ON OrderDetails(order_id);
CREATE INDEX idx_orderdetail_product ON OrderDetails(product_id);
CREATE INDEX idx_review_product ON Reviews(product_id);
CREATE INDEX idx_review_user ON Reviews(user_id);

-- =====================================================
-- QUERIES: CRUD Operations
-- =====================================================

-- Query 1: Create a new user account
INSERT INTO Users (username, email, password_hash, first_name, last_name, phone_number, city, state, country)
VALUES ('john_doe', 'john.doe@email.com', 'hashed_password_here', 'John', 'Doe', '9876543210', 'New York', 'NY', 'USA');

-- Query 2: Add a new product
INSERT INTO Products (product_name, sku, category, description, unit_price, stock_quantity, reorder_level)
VALUES ('Wireless Headphones', 'WH001', 'Electronics', 'High-quality Bluetooth headphones', 49.99, 100, 20);

-- Query 3: Create an order
INSERT INTO Orders (user_id, order_date, order_status, shipment_address, payment_method, total_amount, final_amount)
VALUES (1, NOW(), 'Pending', '123 Main St, New York, NY 10001', 'Credit Card', 49.99, 49.99);

-- Query 4: Add items to order
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price, line_total)
VALUES (1, 1, 1, 49.99, 49.99);

-- Query 5: Update product stock after order
UPDATE Products 
SET stock_quantity = stock_quantity - 1 
WHERE product_id = 1;

-- Query 6: Update order status
UPDATE Orders 
SET order_status = 'Shipped', expected_delivery_date = DATE_ADD(CURDATE(), INTERVAL 5 DAY)
WHERE order_id = 1;

-- Query 7: Add product review
INSERT INTO Reviews (product_id, user_id, rating, review_text)
VALUES (1, 1, 5, 'Excellent product! Great sound quality and very comfortable.');

-- =====================================================
-- QUERIES: Fetch Operations
-- =====================================================

-- Query 8: Retrieve all orders by a user
SELECT 
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    o.discount_amount,
    o.final_amount,
    o.expected_delivery_date
FROM Orders o
WHERE o.user_id = 1
ORDER BY o.order_date DESC;

-- Query 9: Get order details with product information
SELECT 
    o.order_id,
    o.order_date,
    o.order_status,
    p.product_id,
    p.product_name,
    p.sku,
    od.quantity,
    od.unit_price,
    od.line_total
FROM Orders o
INNER JOIN OrderDetails od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
WHERE o.order_id = 1;

-- Query 10: Get all products in a category
SELECT 
    product_id,
    product_name,
    sku,
    unit_price,
    stock_quantity,
    description
FROM Products
WHERE category = 'Electronics'
ORDER BY product_name;

-- Query 11: Get all active orders (not yet delivered)
SELECT 
    o.order_id,
    u.username,
    u.email,
    o.order_date,
    o.order_status,
    o.final_amount,
    o.expected_delivery_date
FROM Orders o
INNER JOIN Users u ON o.user_id = u.user_id
WHERE o.order_status IN ('Pending', 'Processing', 'Shipped')
ORDER BY o.order_date DESC;

-- Query 12: Get product reviews with user information
SELECT 
    r.review_id,
    r.rating,
    r.review_text,
    r.review_date,
    u.username,
    p.product_name
FROM Reviews r
INNER JOIN Users u ON r.user_id = u.user_id
INNER JOIN Products p ON r.product_id = p.product_id
WHERE p.product_id = 1
ORDER BY r.review_date DESC;

-- =====================================================
-- QUERIES: Aggregate Operations
-- =====================================================

-- Query 13: Find the most purchased product
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity) AS total_quantity_sold,
    COUNT(DISTINCT od.order_id) AS number_of_orders,
    ROUND(SUM(od.line_total), 2) AS total_revenue
FROM Products p
INNER JOIN OrderDetails od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Query 14: Calculate total revenue in a given month
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.user_id) AS unique_customers,
    ROUND(SUM(o.final_amount), 2) AS total_revenue,
    ROUND(AVG(o.final_amount), 2) AS average_order_value
FROM Orders o
WHERE o.order_status != 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- Query 15: Category-wise sales analysis
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS number_of_products,
    SUM(od.quantity) AS total_units_sold,
    ROUND(SUM(od.line_total), 2) AS category_revenue,
    ROUND(AVG(od.unit_price), 2) AS average_price,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
LEFT JOIN Orders o ON od.order_id = o.order_id
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE o.order_status IS NULL OR o.order_status != 'Cancelled'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Query 16: Top spending customers
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS customer_name,
    u.email,
    COUNT(o.order_id) AS number_of_orders,
    ROUND(SUM(o.final_amount), 2) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
WHERE o.order_status != 'Cancelled'
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_spent DESC
LIMIT 20;

-- Query 17: Best rated products
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS number_of_reviews,
    SUM(od.quantity) AS units_sold
FROM Products p
INNER JOIN Reviews r ON p.product_id = r.product_id
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING COUNT(r.review_id) >= 3
ORDER BY average_rating DESC;

-- Query 18: Low stock products needing reorder
SELECT 
    product_id,
    product_name,
    category,
    stock_quantity,
    reorder_level,
    (reorder_level - stock_quantity) AS units_to_reorder
FROM Products
WHERE stock_quantity <= reorder_level
ORDER BY units_to_reorder DESC;

-- Query 19: Monthly customer acquisition
SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') AS month,
    COUNT(user_id) AS new_users,
    (SELECT COUNT(*) FROM Orders WHERE user_id IN 
        (SELECT user_id FROM Users WHERE DATE_FORMAT(registration_date, '%Y-%m') = DATE_FORMAT(u.registration_date, '%Y-%m'))) AS users_made_purchase
FROM Users u
GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY month DESC;