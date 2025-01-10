USE publicLibrary_db;

-- Create Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    PublishedYear INT,
    Genre VARCHAR(100)
);

-- Create Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20)
);

-- Create Transactions Table
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    UserID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    UserID INT,
    ReservationDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);



-- Insert sample data into Books
INSERT INTO Books (Title, Author, PublishedYear, Genre) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Fiction'),
('1984', 'George Orwell', 1949, 'Dystopian'),
('To Kill a Mockingbird', 'Harper Lee', 1960, 'Fiction'),
('Pride and Prejudice', 'Jane Austen', 1813, 'Romance');

-- Insert sample data into Users
INSERT INTO Users (UserName, Email, PhoneNumber) VALUES
('John Doe', 'john.doe@example.com', '123-456-7890'),
('Jane Smith', 'jane.smith@example.com', '987-654-3210'),
('Alice Johnson', 'alice.johnson@example.com', '555-555-5555'),
('Bob Brown', 'bob.brown@example.com', '111-222-3333');

-- Insert sample data into Transactions
INSERT INTO Transactions (BookID, UserID, BorrowDate, ReturnDate) VALUES
(1, 1, '2024-06-01', '2024-06-15'),
(2, 2, '2024-06-02', '2024-06-16'),
(3, 3, '2024-06-03', '2024-06-17'),
(4, 4, '2024-06-04', '2024-06-18');

-- Insert sample data into Reservations
INSERT INTO Reservations (BookID, UserID, ReservationDate) VALUES
(1, 2, '2024-06-10'),
(2, 3, '2024-06-11'),
(3, 4, '2024-06-12'),
(4, 1, '2024-06-13');


-- Retrieve all books
SELECT * FROM Books;

-- Find all reservations for a specific book
SELECT * FROM Reservations WHERE BookID = 1;

-- Find all books borrowed by a specific user
SELECT Books.Title, Transactions.BorrowDate, Transactions.ReturnDate
FROM Transactions
JOIN Books ON Transactions.BookID = Books.BookID
WHERE Transactions.UserID = 1;

-- Update a user's email address 
UPDATE Users
SET Email = 'new.email@example.com'
WHERE UserID = 1;

-- Retrieve a user's reservation history
SELECT Books.Title, Reservations.ReservationDate
FROM Reservations
JOIN Books ON Reservations.BookID = Books.BookID
WHERE Reservations.UserID = 1;

-- List all books that have never been borrowed
SELECT Books.BookID, Books.Title
FROM Books
LEFT JOIN Transactions ON Books.BookID = Transactions.BookID
WHERE Transactions.TransactionID IS NULL;


-- Find all books reserved by users who have borrowed more than 5 books
SELECT DISTINCT Books.Title, Reservations.ReservationDate
FROM Reservations
JOIN Books ON Reservations.BookID = Books.BookID
JOIN Users ON Reservations.UserID = Users.UserID
WHERE Users.UserID IN (
    SELECT UserID
    FROM Transactions
    GROUP BY UserID
    HAVING COUNT(TransactionID) > 5
);


-- List all users along with the total number of books they have reserved and borrowed
SELECT Users.UserID, Users.UserName, 
       (SELECT COUNT(*) FROM Transactions WHERE Transactions.UserID = Users.UserID) AS BooksBorrowed,
       (SELECT COUNT(*) FROM Reservations WHERE Reservations.UserID = Users.UserID) AS BooksReserved
FROM Users;

