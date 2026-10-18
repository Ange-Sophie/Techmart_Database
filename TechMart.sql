CREATE DATABASE TechMart;
USE TechMart;

CREATE TABLE Customers (
                           CustomerID INT AUTO_INCREMENT PRIMARY KEY,
                           FirstName VARCHAR(50) NOT NULL,
                           LastName VARCHAR(50) NOT NULL,
                           Email VARCHAR(100) NOT NULL UNIQUE,
                           JoinDate DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE Products (
                          ProductID INT AUTO_INCREMENT PRIMARY KEY,
                          ProductName VARCHAR(100),
                          Price DECIMAL(10,2) NOT NULL,
                          StockQuantity INT NOT NULL DEFAULT 0,
                          CONSTRAINT chk_price CHECK (Price > 0),
                          CONSTRAINT chk_stock CHECK (StockQuantity >= 0)
) ENGINE=InnoDB;

CREATE TABLE Orders (
                        OrderID INT AUTO_INCREMENT PRIMARY KEY,
                        CustomerID INT NOT NULL,
                        OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
                        CONSTRAINT chk_status CHECK (Status IN ('Pending','Shipped','Delivered')),
                        CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
) ENGINE=InnoDB;

CREATE TABLE OrderItems (
                            OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
                            OrderID INT NOT NULL,
                            ProductID INT NOT NULL,
                            Quantity INT NOT NULL,
                            CONSTRAINT chk_quantity CHECK (Quantity > 0),
                            CONSTRAINT fk_orderitems_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
                            CONSTRAINT fk_orderitems_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;

-- PART 2: Schema changes (before inserting records)
ALTER TABLE Products MODIFY ProductName VARCHAR(100) NOT NULL;
ALTER TABLE Products ADD COLUMN Category VARCHAR(50);
ALTER TABLE Customers ADD COLUMN PhoneNumber VARCHAR(20) UNIQUE;

-- PART 3: Data manipulation
INSERT INTO Customers (FirstName,LastName,Email,PhoneNumber) VALUES
    ('Alice','Uwase','alice@techmart.com','0781000001');
INSERT INTO Customers (FirstName,LastName,Email,JoinDate,PhoneNumber) VALUES
                                                                          ('Eric','Mugisha','eric@techmart.com','2026-09-15','0781000002'),
                                                                          ('Grace','Ineza','grace@techmart.com','2026-10-01','0781000003');

INSERT INTO Products (ProductName,Price,StockQuantity,Category) VALUES
                                                                    ('Laptop',850000.00,12,'Computers'),
                                                                    ('Wireless Mouse',15000.00,30,'Accessories'),
                                                                    ('Keyboard',25000.00,20,'Accessories');
INSERT INTO Products (ProductName,Price,Category) VALUES
    ('USB Cable',5000.00,'Accessories');

INSERT INTO Orders (CustomerID) VALUES (1);
INSERT INTO Orders (CustomerID,Status) VALUES (2,'Shipped');

INSERT INTO OrderItems (OrderID,ProductID,Quantity) VALUES
                                                        (1,1,1),
                                                        (1,2,2),
                                                        (2,3,1);

-- INTENTIONAL ERRORS: run individually, not in the main import
-- Duplicate email violates UNIQUE:
-- INSERT INTO Customers (FirstName,LastName,Email) VALUES ('Test','User','alice@techmart.com');
-- Negative price violates chk_price CHECK:
-- INSERT INTO Products (ProductName,Price) VALUES ('Broken Item',-5.00);
-- Nonexistent customer violates fk_orders_customer FOREIGN KEY:
-- INSERT INTO Orders (CustomerID) VALUES (9999);

UPDATE Customers SET Email='alice.uwase@techmart.com' WHERE CustomerID=1;
UPDATE Products SET StockQuantity=StockQuantity+50 WHERE ProductID=2;
-- Product 4 is not referenced by OrderItems, so it can be deleted.
DELETE FROM Products WHERE ProductID=4;

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
