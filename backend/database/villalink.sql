CREATE DATABASE IF NOT EXISTS villalinkapp_db;
USE villalinkapp_db;

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    flat_number VARCHAR(10),
    user_type ENUM('president', 'member') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Notices table
CREATE TABLE notices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Complaints table
CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('pending', 'in_progress', 'resolved') DEFAULT 'pending',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Maintenance table
CREATE TABLE maintenance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('pending', 'paid') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample data
-- Default president user
INSERT INTO users (name, email, password, phone, flat_number, user_type) VALUES 
('Admin President', 'president@villalink.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9876543210', 'A-101', 'president');

-- Sample member users
INSERT INTO users (name, email, password, phone, flat_number, user_type) VALUES 
('John Doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9876543211', 'B-201', 'member'),
('Jane Smith', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9876543212', 'C-301', 'member'),
('Mike Johnson', 'mike@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9876543213', 'D-401', 'member');

-- Sample notices
INSERT INTO notices (title, description, created_by) VALUES 
('Society Meeting', 'Monthly society meeting scheduled for next Sunday at 10 AM in the community hall.', 1),
('Water Tank Cleaning', 'Water tank cleaning will be done on Saturday. Water supply will be interrupted from 9 AM to 2 PM.', 1),
('New Security Guidelines', 'Please ensure all visitors are registered at the security gate. Visitor passes are mandatory after 8 PM.', 1);

-- Sample complaints
INSERT INTO complaints (title, description, created_by) VALUES 
('Lift Not Working', 'The elevator in Building B has been out of order for 3 days. Please fix urgently.', 2),
('Parking Issue', 'Cars are being parked in visitor slots regularly. Please take action.', 3),
('Garden Maintenance', 'The garden area needs maintenance. Sprinkler system is not working properly.', 4);

-- Sample maintenance records
INSERT INTO maintenance (user_id, amount, due_date) VALUES 
(2, 5000.00, '2024-12-31'),
(3, 5000.00, '2024-12-31'),
(4, 5000.00, '2024-12-31'),
(2, 4500.00, '2024-11-30'),
(3, 4500.00, '2024-11-30'),
(4, 4500.00, '2024-11-30');

-- Update some maintenance as paid
UPDATE maintenance SET status = 'paid' WHERE id IN (4, 5);