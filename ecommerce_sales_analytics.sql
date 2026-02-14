-- E-Commerce Sales Analytics System

CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO users (name, email, city, signup_date) VALUES
('Rahul', 'rahul@gmail.com', 'Bangalore', '2024-01-10'),
('Anita', 'anita@gmail.com', 'Chennai', '2024-02-15'),
('Karthik', 'karthik@gmail.com', 'Hyderabad', '2024-03-01');

INSERT INTO products (product_name, category, price) VALUES
('iPhone 14', 'Electronics', 70000),
('Laptop', 'Electronics', 55000),
('Headphones', 'Accessories', 3000),
('Shoes', 'Fashion', 2500);

INSERT INTO orders (user_id, order_date, order_status) VALUES
(1, '2024-04-01', 'Delivered'),
(2, '2024-04-10', 'Delivered'),
(1, '2024-05-05', 'Cancelled');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(2, 4, 1);

INSERT INTO payments (order_id, payment_method, payment_status) VALUES
(1, 'UPI', 'Success'),
(2, 'Credit Card', 'Success'),
(3, 'UPI', 'Failed');


SELECT 
    SUM(p.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 3;

SELECT 
    p.category,
    SUM(p.price * oi.quantity) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category;

SELECT u.name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.name
HAVING SUM(p.price * oi.quantity) >
       (SELECT AVG(price) FROM products);

SELECT payment_method, COUNT(*) AS usage_count
FROM payments
WHERE payment_status = 'Success'
GROUP BY payment_method
ORDER BY usage_count DESC;















