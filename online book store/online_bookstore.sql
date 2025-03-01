-- create database
CREATE DATABASE onlineBookstore;
-- create tables
CREATE TABLE Books(
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT);
CREATE TABLE Customers(
    Customer_ID SERIAL PRIMARY KEY,
    CName VARCHAR(50),
    Email VARCHAR(70),
    Phone VARCHAR(15),
    City VARCHAR(100),
    Country VARCHAR(100));
CREATE TABLE Orders(
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES customers(Customer_ID),
    Book_ID INT REFERENCES books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2));
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- importing data 
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM '/workspaces/sql-projects-/online book store/Books.csv' 
CSV HEADER;

COPY Customers(Customer_ID,CName,Email,Phone,City,Country)
FROM '/workspaces/sql-projects-/online book store/Customers.csv'
CSV HEADER;

COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM '/workspaces/sql-projects-/online book store/Orders.csv'
CSV HEADER;

---- sql queries ---
-- 1) retriving all books in 'fiction' genre
SELECT * FROM Books Where Genre ='Fiction';

-- 2) finding books published after the year 1950
SELECT * FROM Books 
WHERE Published_Year>1950;

-- 3) lisiting all customers form canada
SELECT * FROM Customers
Where Country = 'Canada';

-- 4) Showing order placed in november 2023
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) retrieving the total stock of books availabe
SELECT SUM(Stock) AS Total_stock FROM Books;

-- 6) finding the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7) showing all the customers who ordered more than 1 quantity of a book
SELECT * FROM Orders WHERE Quantity > 1;

-- 8) retriving all order where the total amount exceeds 20$
SELECT * FROM Orders WHERE Total_Amount > 20;

-- 9) show the list of all the GENRES available
SELECT DISTINCT Genre FROM Books;

-- 10) finding the book with the lowest stock
SELECT * FROM Books ORDER BY Stock LIMIT 1;

-- 11) calulating the total revenue generated from all orders
SELECT SUM(Total_Amount) FROM Orders;

-- 12)retriving total number of books sold for each genre 
SELECT B.Genra, SUM(o.Quantity) AS Total_books_sold FROM Orders o 
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre

-- 13) finding the average price in the "fantasy" GENERATE_UNIQUE
SELECT AVG(Price) AS Average_Price FROM Books
WHERE Genre = 'Fantasy';

-- 14)listing 

-- 15)

-- 16)

-- 17)