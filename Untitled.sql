-- =========================================
--  HOTEL BOOKING SYSTEM (DBMS PROJECT)
-- =========================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS hotel;
USE hotel;

-- 2. Create ROOM Table
CREATE TABLE ROOM (
  RoomNumber VARCHAR(10) NOT NULL PRIMARY KEY,
  RoomType   ENUM('Standard','Deluxe','Suite') NOT NULL,
  Floor      INT NOT NULL,
  Status     ENUM('AVAILABLE','OCCUPIED','MAINTENANCE') DEFAULT 'AVAILABLE'
);

-- 3. Create CUSTOMER Table
CREATE TABLE CUSTOMER (
  CustomerID     INT PRIMARY KEY,
  FullName       VARCHAR(100) NOT NULL,
  Phone          VARCHAR(20) UNIQUE,
  Email          VARCHAR(120) UNIQUE,
  City           VARCHAR(60),
  BookingID      INT UNIQUE,
  RoomNumber     VARCHAR(10),
  CheckInDate    DATE,
  CheckOutDate   DATE,
  PaymentStatus  ENUM('PENDING','PAID','PARTIAL','CANCELLED') DEFAULT 'PENDING',
  PaidUntil      DATE,
  LastPaidOn     DATETIME,
  FOREIGN KEY (RoomNumber) REFERENCES ROOM(RoomNumber)
);

-- =========================================
--  INSERT SAMPLE DATA
-- =========================================

-- Insert into ROOM Table
INSERT INTO ROOM (RoomNumber, RoomType, Floor, Status) VALUES
('101', 'Standard', 1, 'AVAILABLE'),
('102', 'Deluxe', 1, 'OCCUPIED'),
('201', 'Suite', 2, 'AVAILABLE'),
('202', 'Deluxe', 2, 'MAINTENANCE'),
('301', 'Standard', 3, 'AVAILABLE');

-- Insert into CUSTOMER Table
INSERT INTO CUSTOMER (CustomerID, FullName, Phone, Email, City, BookingID, RoomNumber, CheckInDate, CheckOutDate, PaymentStatus, PaidUntil, LastPaidOn) VALUES
(1, 'Aman Singh', '9876543210', 'aman@example.com', 'Delhi', 501, '102', '2025-11-01', '2025-11-05', 'PAID', '2025-11-05', '2025-10-30 15:00:00'),
(2, 'Riya Sharma', '9812345678', 'riya@example.com', 'Mumbai', 502, '201', '2025-11-03', '2025-11-06', 'PENDING', NULL, NULL),
(3, 'Karan Mehta', '9898989898', 'karan@example.com', 'Chandigarh', 503, '101', '2025-11-04', '2025-11-08', 'PARTIAL', '2025-11-06', '2025-11-02 10:30:00');

-- =========================================
--  SQL QUERIES (FOR REPORT)
-- =========================================

-- 1. Display all available rooms
SELECT * FROM ROOM WHERE Status = 'AVAILABLE';

-- 2. Show all customers with booking details
SELECT CustomerID, FullName, City, RoomNumber, CheckInDate, CheckOutDate, PaymentStatus 
FROM CUSTOMER;

-- 3. Find rooms currently occupied
SELECT RoomNumber, RoomType, Status 
FROM ROOM WHERE Status = 'OCCUPIED';

-- 4. List customers with pending payments
SELECT FullName, RoomNumber, PaymentStatus 
FROM CUSTOMER WHERE PaymentStatus = 'PENDING';

-- 5. Join CUSTOMER and ROOM to view full booking information
SELECT C.FullName, C.City, C.CheckInDate, C.CheckOutDate, 
       R.RoomType, R.Floor, C.PaymentStatus
FROM CUSTOMER C
JOIN ROOM R ON C.RoomNumber = R.RoomNumber;

-- 6. Count how many rooms are occupied
SELECT COUNT(*) AS OccupiedRooms 
FROM ROOM WHERE Status = 'OCCUPIED';

-- 7. Update room status after checkout
UPDATE ROOM SET Status = 'AVAILABLE'
WHERE RoomNumber = '102';

-- 8. Delete cancelled bookings
DELETE FROM CUSTOMER WHERE PaymentStatus = 'CANCELLED';

-- 9. View customers with bookings longer than 3 days
SELECT FullName, RoomNumber, DATEDIFF(CheckOutDate, CheckInDate) AS StayDuration
FROM CUSTOMER
WHERE DATEDIFF(CheckOutDate, CheckInDate) > 3;

-- 10. Generate booking summary report
SELECT R.RoomNumber, R.RoomType, C.FullName, C.CheckInDate, C.CheckOutDate, C.PaymentStatus
FROM ROOM R
LEFT JOIN CUSTOMER C ON R.RoomNumber = C.RoomNumber
ORDER BY R.RoomNumber;