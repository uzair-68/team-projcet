-- ============================================
-- Step 1: Drop old database safely if exists
-- ============================================
USE master;
GO

IF DB_ID('FlightManagementSystem') IS NOT NULL
BEGIN
    ALTER DATABASE FlightManagementSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FlightManagementSystem;
END
GO

-- ============================================
-- Step 2: Create new database
-- ============================================
CREATE DATABASE FlightManagementSystem;
GO

USE FlightManagementSystem;
GO

-- ============================================
-- Step 3: Create Tables
-- ============================================

-- Airline Table
CREATE TABLE Airline (
    AirlineID INT IDENTITY(1,1) PRIMARY KEY,
    AirlineName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    HQCity VARCHAR(50) NOT NULL
);
GO

-- Airport Table
CREATE TABLE Airport (
    AirportCode VARCHAR(10) PRIMARY KEY,
    AirportName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);
GO

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL
);
GO

-- Flight Table
CREATE TABLE Flight (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    FlightNumber VARCHAR(20) UNIQUE NOT NULL,
    AirlineID INT NOT NULL,
    DepartureAirport VARCHAR(10) NOT NULL,
    ArrivalAirport VARCHAR(10) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    TotalSeats INT NOT NULL,
    AvailableSeats INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Flight_Airline FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID),
    CONSTRAINT FK_Flight_DepAirport FOREIGN KEY (DepartureAirport) REFERENCES Airport(AirportCode),
    CONSTRAINT FK_Flight_ArrAirport FOREIGN KEY (ArrivalAirport) REFERENCES Airport(AirportCode)
);
GO

-- Seat Table
CREATE TABLE Seat (
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(10) NOT NULL,
    Class VARCHAR(20) NOT NULL,
    SeatStatus VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Seat_Flight FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);
GO

-- Booking Table
CREATE TABLE Booking (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT NOT NULL,
    CustomerID INT NOT NULL,
    SeatID INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingStatus VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Booking_Flight FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    CONSTRAINT FK_Booking_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Booking_Seat FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);
GO

-- Payment Table
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDate DATE NOT NULL,
    TransactionDate DATE NOT NULL,
    CONSTRAINT FK_Payment_Booking FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);
GO

-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    AirlineID INT NOT NULL,
    CONSTRAINT FK_Employee_Airline FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID)
);
GO

-- ============================================
-- Step 4: Insert Sample Data
-- ============================================

-- Airlines
INSERT INTO Airline (AirlineName, ContactNumber, HQCity) VALUES
('PIA','051111786','Islamabad'),
('Emirates','+971600555','Dubai'),
('Qatar Airways','+97441445555','Doha');
GO

-- Airports
INSERT INTO Airport (AirportCode, AirportName, City, Country) VALUES
('ISB','Islamabad International Airport','Islamabad','Pakistan'),
('KHI','Jinnah International Airport','Karachi','Pakistan'),
('DXB','Dubai International Airport','Dubai','UAE'),
('DOH','Hamad International Airport','Doha','Qatar');
GO

-- Customers
INSERT INTO Customer (Name, Email, Phone, Password, Address) VALUES
('Imran Wahid','imran@example.com','03001234567','pass123','Islamabad'),
('Ali Khan','ali@example.com','03111234567','pass123','Karachi'),
('Sara Ahmed','sara@example.com','03221234567','pass123','Lahore');
GO

-- Flights
INSERT INTO Flight (FlightNumber, AirlineID, DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, TotalSeats, AvailableSeats, Price) VALUES
('PK301',1,'ISB','DXB','2026-01-20 08:00','2026-01-20 12:00',180,175,50000),
('EK202',2,'DXB','KHI','2026-01-22 10:00','2026-01-22 14:00',200,195,60000),
('QR501',3,'DOH','ISB','2026-01-25 09:00','2026-01-25 13:00',190,185,55000);
GO

-- Seats
INSERT INTO Seat (FlightID, SeatNumber, Class, SeatStatus) VALUES
(1,'A1','Economy','Available'),
(1,'A2','Business','Booked'),
(2,'B1','Economy','Available'),
(2,'B2','Business','Booked'),
(3,'C1','Economy','Available');
GO

-- Bookings
INSERT INTO Booking (FlightID, CustomerID, SeatID, BookingDate, BookingStatus) VALUES
(1,1,1,'2026-01-10','Confirmed'),
(2,2,4,'2026-01-11','Confirmed'),
(3,3,5,'2026-01-12','Pending');
GO

-- Payments
INSERT INTO Payment (BookingID, Amount, PaymentMethod, PaymentDate, TransactionDate) VALUES
(1,50000,'Credit Card','2026-01-10','2026-01-10'),
(2,60000,'Debit Card','2026-01-11','2026-01-11'),
(3,55000,'Cash','2026-01-12','2026-01-12');
GO

-- Employees
INSERT INTO Employee (Name, Email, Role, Password, Phone, AirlineID) VALUES
('Usman Ali','usman@pia.com','Manager','pass123','03009998877',1),
('Ayesha Khan','ayesha@emirates.com','Staff','pass123','03112223344',2),
('Bilal Ahmed','bilal@qatar.com','Staff','pass123','03223334455',3);
GO

-- ============================================
-- Step 5: Test Queries
-- ============================================

-- Check Airlines
SELECT * FROM dbo.Airline;

-- Check Flights
SELECT * FROM dbo.Flight;

-- Check Customers
SELECT * FROM dbo.Customer;

-- Customer Bookings with Flight info
SELECT c.Name AS CustomerName, f.FlightNumber, b.BookingDate, b.BookingStatus
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Flight f ON b.FlightID = f.FlightID;
GO