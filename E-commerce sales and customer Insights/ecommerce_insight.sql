-- Creating the database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Order Details Table
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- Import Customers
COPY Customers(customer_id, name, email, phone, address, created_at)
FROM '/workspaces/sql-projects-/E-commerce sales and customer Insights/customers.csv'
DELIMITER ',' CSV HEADER;

-- Import Products
COPY Products(product_id, name, category, price, stock, created_at)
FROM '/workspaces/sql-projects-/E-commerce sales and customer Insights/products.csv'
DELIMITER ',' CSV HEADER;

-- Import Orders
COPY Orders(order_id, customer_id, order_date, total_amount, status)
FROM '/workspaces/sql-projects-/E-commerce sales and customer Insights/orders.csv'
DELIMITER ',' CSV HEADER;

-- Import OrderDetails
COPY OrderDetails(order_detail_id, order_id, product_id, quantity, subtotal)
FROM '/workspaces/sql-projects-/E-commerce sales and customer Insights/order_details.csv'
DELIMITER ',' CSV HEADER;

-- 1. Retrieve all customers
SELECT * FROM Customers;

-- 2. Retrieve all products
SELECT * FROM Products;

-- 3. Retrieve all orders
SELECT * FROM Orders;

-- 4. Retrieve all order details
SELECT * FROM OrderDetails;

-- 5. Get all products in a specific category (e.g., 'Electronics')
SELECT * FROM Products WHERE category = 'Electronics';

-- 6. Get all orders of a specific customer (e.g., customer_id = 1)
SELECT * FROM Orders WHERE customer_id = 1;

-- 7. Get the total number of customers
SELECT COUNT(*) AS total_customers FROM Customers;

-- 8. Get the total number of products in stock
SELECT SUM(stock) AS total_stock FROM Products;

-- 9. Get all pending orders
SELECT * FROM Orders WHERE status = 'Pending';

-- 10. Get all delivered orders
SELECT * FROM Orders WHERE status = 'Delivered';

-- 1. Get the total sales amount for each product
SELECT Products.name, SUM(OrderDetails.subtotal) AS total_sales
FROM OrderDetails
JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY Products.name;

-- 2. Find the total revenue generated
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- 3. Get the most recent 10 orders
SELECT * FROM Orders ORDER BY order_date DESC LIMIT 10;

-- 4. Get the customer who placed the most orders
SELECT Customers.name, COUNT(Orders.order_id) AS total_orders
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
GROUP BY Customers.name
ORDER BY total_orders DESC
LIMIT 1;

-- 5. Get products that are out of stock
SELECT * FROM Products WHERE stock = 0;

-- 1. Get monthly sales revenue
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS monthly_revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- 2. Find customers who have not placed any orders
SELECT * FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM Orders);

-- 3. Identify products that have never been ordered
SELECT * FROM Products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM OrderDetails);

-- 4. Get the average order value
SELECT AVG(total_amount) AS average_order_value FROM Orders;

-- 5. Identify the top 3 customers by total spending
SELECT Customers.name, SUM(Orders.total_amount) AS total_spent
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
GROUP BY Customers.name
ORDER BY total_spent DESC
LIMIT 3;
