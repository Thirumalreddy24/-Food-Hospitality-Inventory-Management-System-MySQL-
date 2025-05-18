-- Create the database and use it
CREATE DATABASE FOODHOSPITALITY12;
USE FOODHOSPITALITY12;

-- Recipes Table
CREATE TABLE Recipes1 (
    RecipeID INT PRIMARY KEY AUTO_INCREMENT,
    RecipeName VARCHAR(100) NOT NULL,
    CuisineType VARCHAR(50),
    PrepTime INT CHECK (PrepTime > 0),
    Instructions TEXT NOT NULL
);
desc Recipes1;
DESCRIBE Recipes1;
SHOW COLUMNS FROM Recipes1;

SHOW TABLES;


-- Ingredients Table
CREATE TABLE Ingredientsspl (
    IngredientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Unit VARCHAR(20) NOT NULL,
    StockQty DECIMAL(10,2) DEFAULT 0 CHECK (StockQty >= 0),
    ReorderLevel DECIMAL(10,2) DEFAULT 0 CHECK (ReorderLevel >= 0)
);
DESC Ingredientsspl;
-- RecipeIngredients Table (Many-to-Many Relationship)
CREATE TABLE RecipeIngredients1 (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    RecipeID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityRequired DECIMAL(10,2) NOT NULL CHECK (QuantityRequired > 0),
    FOREIGN KEY (RecipeID) REFERENCES Recipes1(RecipeID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredientsspl(IngredientID)
);
DESC  RecipeIngredients1;
-- Suppliers Table
CREATE TABLE Suppliers1 (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Address TEXT
);
DESC Suppliers1;
-- Purchases Table (Links Suppliers and Ingredients)
CREATE TABLE Purchases1 (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT NOT NULL,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0),
    PurchaseDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers1(SupplierID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredientsspl(IngredientID)
);

-- InventoryLogs Table (Logs Ingredient Stock Changes)
CREATE TABLE InventoryLogs1 (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    IngredientID INT NOT NULL,
    ChangeQty DECIMAL(10,2) NOT NULL,
    Reason VARCHAR(100),
    LoggedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IngredientID) REFERENCES Ingredientsspl(IngredientID)
);

-- ALTER: Modify Ingredients Name column size (increase to 150)
ALTER TABLE Ingredientsspl
MODIFY COLUMN Name VARCHAR(150);
desc Ingredientsspl;

-- ALTER: Drop Phone column from Suppliers table
ALTER TABLE Suppliers1
DROP COLUMN Phone;
DESC Suppliers1;
-- If you want to rename "Ingredients" table, make sure no conflicting table exists
-- Check if a table already exists with the same name
-- RENAME TABLE Ingredients TO FoodIngredientsSPL;

-- Backup and rename sequence
-- Step 1: Backup the existing Ingredients table to a new table
CREATE TABLE FoodIngredients_backup AS SELECT * FROM Ingredients1;

-- Step 2: Drop Ingredients table
DROP TABLE Ingredients1;

-- Step 3: Rename table from FoodIngredientsSPL to FoodIngredients
RENAME TABLE FoodIngredientsSPL TO Ingredients1;

-- Insert data into Recipes table
INSERT INTO Recipes1 (RecipeName, CuisineType, PrepTime, Instructions) VALUES
('Pasta', 'Italian', 30, 'Boil pasta, add sauce, mix, and serve.'),
('Pizza', 'Italian', 40, 'Prepare dough, add toppings, bake at 350°F for 20 minutes.'),
('Biryani', 'Indian', 60, 'Cook rice and spices together, add marinated meat and cook.'),
('Burger', 'American', 20, 'Grill patty, add to bun, top with veggies and sauce.'),
('Sushi', 'Japanese', 45, 'Prepare sushi rice, wrap with nori, add fish and veggies.'),
('Salad', 'American', 15, 'Chop veggies, add dressing, mix and serve.'),
('Pancakes', 'American', 30, 'Mix ingredients, pour batter on pan, cook both sides.'),
('Tacos', 'Mexican', 25, 'Fill taco shells with meat, cheese, and salsa.'),
('Chowmein', 'Chinese', 35, 'Stir fry noodles and veggies, add sauce.'),
('Momos', 'Tibetan', 40, 'Fill dough with veggies or meat, steam until cooked.'),
('Fried Rice', 'Chinese', 20, 'Stir-fry rice with veggies, egg, and sauce.'),
('Lasagna', 'Italian', 90, 'Layer pasta, cheese, and meat sauce, bake for 45 minutes.'),
('Samosa', 'Indian', 30, 'Stuff dough with potatoes and spices, fry until crispy.'),
('Pav Bhaji', 'Indian', 50, 'Cook mashed vegetables with spices, serve with bread.'),
('Dosa', 'Indian', 40, 'Prepare dough, pour onto pan, cook both sides.'),
('Noodles', 'Chinese', 30, 'Stir-fry noodles with veggies and sauce.'),
('Waffles', 'Belgian', 25, 'Pour batter into waffle iron, cook until golden brown.'),
('Curry', 'Indian', 60, 'Cook meat and spices together, add gravy, and simmer.'),
('Kebabs', 'Middle Eastern', 45, 'Grill marinated meat on skewers.'),
('Steak', 'American', 30, 'Grill steak, serve with sides like mashed potatoes.');

select * from Recipes1;

SELECT RecipeID, RecipeName, COUNT(*)
FROM Recipes1
GROUP BY RecipeID, RecipeName
HAVING COUNT(*) > 1;

SHOW TABLE STATUS LIKE 'Recipes1';
SHOW CREATE VIEW Recipes1;
SELECT * FROM Recipes1 LIMIT 20;

SHOW TRIGGERS LIKE 'Recipes1';


-- Insert data into Ingredients table
INSERT INTO Ingredientsspl (Name, Unit, StockQty, ReorderLevel) VALUES
('Wheat Flour', 'kg', 100, 20),
('Tomato', 'kg', 50, 10),
('Cheese', 'kg', 30, 5),
('Chicken', 'kg', 70, 15),
('Beef', 'kg', 40, 8),
('Carrot', 'kg', 60, 12),
('Onion', 'kg', 50, 10),
('Rice', 'kg', 200, 50),
('Egg', 'pieces', 500, 100),
('Noodles', 'kg', 80, 20),
('Lettuce', 'kg', 40, 8),
('Pepper', 'kg', 10, 3),
('Milk', 'liter', 100, 20),
('Olive Oil', 'liters', 30, 5),
('Salt', 'kg', 150, 30),
('Sugar', 'kg', 120, 25),
('Garlic', 'kg', 30, 6),
('Spinach', 'kg', 50, 10),
('Lemon', 'pieces', 80, 15),
('Cucumber', 'kg', 40, 8);

-- Insert data into RecipeIngredients table
INSERT INTO RecipeIngredients1 (RecipeID, IngredientID, QuantityRequired) VALUES
(1, 1, 0.5),
(1, 2, 0.2),
(2, 1, 0.3),
(2, 3, 0.2),
(3, 1, 0.6),
(3, 2, 0.3),
(4, 1, 0.4),
(4, 2, 0.2),
(5, 1, 0.2),
(5, 3, 0.1),
(6, 2, 0.3),
(6, 4, 0.1),
(7, 5, 0.2),
(7, 6, 0.2),
(8, 5, 0.3),
(8, 7, 0.2),
(9, 8, 0.3),
(9, 9, 0.2),
(10, 6, 0.3),
(10, 10, 0.1);

DESCRIBE Suppliers1;
 ALTER TABLE Suppliers1 ADD COLUMN Phone VARCHAR(15);
-- Insert data into Suppliers table (as provided earlier)
INSERT INTO Suppliers1 (Name, Phone, Email, Address) VALUES
('Tharun Ravula', '1234567890', 'tharun@example.com', 'Warangal'),
('Vamshi Musk', '9876543210', 'vamshi@example.com', 'Vijayawada'),
('Likitha Reddy', '5551234567', 'likitha@example.com', 'Srishelam'),
('Bhanu', '5559876543', 'bhanu@example.com', 'Hyderabad'),
('Mrunal', '5553334444', 'mrunal@example.com', 'Khammam'),
('Shashi', '5551112222', 'shashi@example.com', 'Nizamabad'),
('Dinesh', '5557778888', 'dinesh@example.com', 'Hyderabad'),
('Bannu', '5559990000', 'bannu@example.com', 'Khammam'),
('Ashwan', '5554445555', 'ashwan@example.com', 'Nellore'),
('Thirumal Reddy', '5556667777', 'thirumal@example.com', 'Kadapa'),
('Raghu Nandhan', '5558889999', 'raghu@example.com', 'Ongole'),
('Gayathri', '5552223333', 'gayathri@example.com', 'Nalgonda'),
('Kavya', '5554447777', 'kavya@example.com', 'Buvanagiri'),
('Phalguna', '5555555555', 'phalguna@example.com', 'Warangal'),
('Srivani', '5556663333', 'srivani@example.com', 'Vijayawada'),
('Rohith', '5557779999', 'rohith@example.com', 'Srishelam'),
('Vineeth', '5558886666', 'vineeth@example.com', 'Hyderabad'),
('Laxman Vivaan', '5551239876', 'laxman@example.com', 'Khammam'),
('Aryan', '5554567890', 'aryan@example.com', 'Nizamabad'),
('Pruthvi', '5557778888', 'pruthvi@example.com', 'Nellore'),
('Gnaneshwar', '5559990000', 'gnaneshwar@example.com', 'Kadapa'),
('Sony', '5554445555', 'sony@example.com', 'Ongole'),
('Chandu', '5552223333', 'chandu@example.com', 'Nalgonda'),
('Manasa', '5556667777', 'manasa@example.com', 'Buvanagiri');
SELECT * FROM Suppliers1 ORDER BY SupplierID;
SELECT * FROM Suppliers1 WHERE Name = 'Tharun Ravula' OR Name = 'Vamshi Musk';
SHOW CREATE TABLE Suppliers1;
TRUNCATE TABLE Suppliers1;
-- then re-run your full INSERT INTO statement

DESCRIBE Suppliers1;
select * from Suppliers1;
ALTER TABLE Suppliers1 ADD COLUMN Phone VARCHAR(15);





-- Insert data into Purchases table
INSERT INTO Purchases1 (SupplierID, IngredientID, Quantity, PurchaseDate) VALUES
(1, 1, 50, '2025-05-01'),
(2, 2, 30, '2025-05-01'),
(3, 3, 20, '2025-05-02'),
(4, 4, 40, '2025-05-02'),
(5, 5, 25, '2025-05-03'),
(6, 6, 15, '2025-05-03'),
(7, 7, 60, '2025-05-04'),
(8, 8, 50, '2025-05-04'),
(9, 9, 35, '2025-05-05'),
(10, 10, 40, '2025-05-05'),
(11, 11, 45, '2025-05-06'),
(12, 12, 50, '2025-05-06'),
(13, 13, 25, '2025-05-07'),
(14, 14, 20, '2025-05-07'),
(15, 15, 30, '2025-05-08'),
(16, 16, 50, '2025-05-08'),
(17, 17, 40, '2025-05-09'),
(18, 18, 30, '2025-05-09'),
(19, 19, 35, '2025-05-10'),
(20, 20, 45, '2025-05-10');

INSERT INTO InventoryLogs1 (IngredientID, ChangeQty, Reason, LoggedAt) VALUES
(1, 10, 'Restock', '2025-05-01 10:00:00'),
(2, 5, 'Restock', '2025-05-02 11:00:00'),
(3, 8, 'Restock', '2025-05-03 12:00:00'),
(4, 6, 'Restock', '2025-05-04 13:00:00'),
(5, 4, 'Restock', '2025-05-05 14:00:00'),
(6, 7, 'Restock', '2025-05-06 15:00:00'),
(7, 5, 'Restock', '2025-05-07 16:00:00'),
(8, 9, 'Restock', '2025-05-08 17:00:00'),
(9, 2, 'Restock', '2025-05-09 18:00:00'),
(10, 3, 'Restock', '2025-05-10 19:00:00'),
(11, 10, 'Restock', '2025-05-11 20:00:00'),
(12, 6, 'Restock', '2025-05-12 21:00:00'),
(13, 8, 'Restock', '2025-05-13 22:00:00'),
(14, 4, 'Restock', '2025-05-14 23:00:00'),
(15, 3, 'Restock', '2025-05-15 23:59:00'),
(16, 9, 'Restock', '2025-05-16 01:00:00'),
(17, 5, 'Restock', '2025-05-17 02:00:00'),
(18, 7, 'Restock', '2025-05-18 03:00:00'),
(19, 6, 'Restock', '2025-05-19 04:00:00'),
(20, 8, 'Restock', '2025-05-20 05:00:00');

select * from InventoryLogs1;

-- Update specific rows based on conditions.
UPDATE Suppliers1
SET Phone = '9999999999878'
WHERE Name = 'Tharun Ravula';
select * from Suppliers1;
-- Delete one or more records using conditions.
DELETE FROM Suppliers1
WHERE Name = 'Mrunal';
DELETE FROM Suppliers1
WHERE Name IN ('Tharun Ravula', 'Vamshi Musk');
select * from Suppliers1;


-- Insert multiple rows using a single statement.
INSERT INTO Suppliers1 (Name, Phone, Email, Address)
VALUES
    ('Nandhan Raghu Meega', '1234567890', 'nandhan@example.com', 'Warangal'),
    ('Meega Nandhan', '9876543210', 'meega@example.com', 'Vijayawada'),
    ('Thirumalll', '5551234567', 'thirumalll@example.com', 'Srishelam');
select * from Suppliers1;
LOCK TABLE Suppliers1 WRITE;
LOCK TABLES Suppliers1 WRITE;

-- Now you can do write operations safely
INSERT INTO Suppliers1 (Name, Phone, Email, Address)
VALUES ('Test Supplier', '0000000000', 'test@example.com', 'TestCity');

-- Unlock after done
UNLOCK TABLES;

UNLOCK TABLES;
LOCK TABLES Suppliers1 READ;

-- You can only run SELECT statements
SELECT * FROM Suppliers1;
-- This will cause an error
INSERT INTO Suppliers1 (Name, Phone, Email, Address)
VALUES
    ('likitha.y', '12345666790', 'liki@example.com', 'Warangal');

UNLOCK TABLES;
SELECT * FROM Suppliers1; -- retrieve alldata from a table
 
 
 
 -- Select specific columns with WHERE conditions.
SELECT Name, Phone         
FROM Suppliers1
WHERE Address = 'Vijayawada';

SELECT * FROM Suppliers1
WHERE Phone BETWEEN '5000000000' AND '6000000000';

SELECT * FROM Suppliers1
WHERE Address IN ('Warangal', 'Hyderabad');

SELECT * FROM Suppliers1
WHERE Phone IS NULL;

SELECT * FROM Suppliers1
WHERE Name LIKE 'A%';

SELECT * FROM Suppliers1
ORDER BY Name
LIMIT 5;

-- Combine filters using AND, OR, and NOT.
SELECT * FROM Suppliers1
WHERE Address = 'Hyderabad' AND Phone IS NOT NULL;

SELECT * FROM Suppliers1
WHERE Address = 'Hyderabad' OR Address = 'khammam';


SELECT * FROM Suppliers1
WHERE NOT Address = 'Hyderabad';

-- Display unique values from a column using DISTINCT.
SELECT DISTINCT Address
FROM Suppliers1;

-- Sort records in ascending/descending order using ORDER by
SELECT * FROM Suppliers1
ORDER BY Name ASC;

SELECT * FROM Suppliers1
ORDER BY SupplierID DESC;

SELECT * FROM Suppliers1
LIMIT 5 OFFSET 0;

SELECT * FROM Suppliers1
LIMIT 5 OFFSET 5;

-- Use COUNT, SUM, AVG, MIN, MAX on relevant numeric columns.
SELECT SUM(Quantity) AS TotalQuantityPurchased
FROM Purchases1;
unlock tables;
SELECT AVG(Quantity) AS AverageQuantity
FROM Purchases1;
LOCK TABLES Purchases1 READ;

SELECT AVG(Quantity) AS AverageQuantity
FROM Purchases1;

UNLOCK TABLES;

SELECT MIN(StockQty) AS MinStock, MAX(StockQty) AS MaxStock
FROM Ingredientsspl;

SELECT COUNT(*) AS TotalPurchases
FROM Purchases1;

-- 1. Total quantity purchased from each supplier
SHOW TABLES;

SELECT * FROM Purchases1 LIMIT 10;

SELECT SupplierID, SUM(Quantity) AS TotalQuantity
FROM Purchases1
GROUP BY SupplierID;


-- 2. Average purchase quantity per ingredient
SELECT IngredientID, AVG(Quantity) AS AverageQuantity
FROM Purchases1
GROUP BY IngredientID;

-- 3. Suppliers who made more than 3 purchases Group using having
SELECT SupplierID, COUNT(*) AS PurchaseCount
FROM Purchases1
GROUP BY SupplierID
HAVING COUNT(*) > 1;

-- Use INNER JOIN to combine data from at least two related tables.

SELECT r.RecipeName, i.Name AS Ingredient, ri.QuantityRequired
FROM RecipeIngredients1 ri
INNER JOIN Recipes1 r ON ri.RecipeID = r.RecipeID
INNER JOIN Ingredientsspl i ON ri.IngredientID = i.IngredientID;

-- Use LEFT JOIN or RIGHT JOIN to display unmatched data as well
SELECT r.RecipeName, i.Name AS Ingredient
FROM Recipes1 r
LEFT JOIN RecipeIngredients1 ri ON r.RecipeID = ri.RecipeID
LEFT JOIN Ingredientsspl i ON ri.IngredientID = i.IngredientID;

SELECT p.PurchaseID, s.Name AS SupplierName, i.Name AS IngredientName, p.Quantity, p.PurchaseDate
FROM Purchases1 p
INNER JOIN Suppliers1 s ON p.SupplierID = s.SupplierID
INNER JOIN Ingredientsspl i ON p.IngredientID = i.IngredientID;

SELECT 
    p.PurchaseID, 
    s.Name AS SupplierName, 
    i.Name AS IngredientName, 
    p.Quantity, 
    p.PurchaseDate
FROM Purchases1 p
INNER JOIN Suppliers1 s ON p.SupplierID = s.SupplierID
INNER JOIN Ingredientsspl i ON p.IngredientID = i.IngredientID;

-- Write a subquery in WHERE to compare against aggregated data.
SELECT SupplierID, Quantity
FROM Purchases1
WHERE Quantity > (
    SELECT AVG(Quantity)
    FROM Purchases1
);

-- Use a subquery in FROM as a derived table.
SELECT s.Name, t.TotalQuantity
FROM (
    SELECT SupplierID, SUM(Quantity) AS TotalQuantity
    FROM Purchases1
    GROUP BY SupplierID
) AS t
JOIN Suppliers1 s ON t.SupplierID = s.SupplierID;

SELECT *
FROM Purchases1 p1
WHERE Quantity > (
    SELECT AVG(Quantity)
    FROM Purchases1 p2
    WHERE p2.SupplierID = p1.SupplierID
);

-- Concatenate two or more columns into one.
SELECT CONCAT(Name, ' - ', Email) AS ContactInfo
FROM Suppliers1;


SELECT UPPER(Name) AS Supplier_Upper
FROM Suppliers1;

SELECT LOWER(Name) AS Supplier_Lower
FROM Suppliers1;

-- Use SUBSTRING, REPLACE, or REVERSE on text fields.
SELECT 
    SUBSTRING(Name, 1, 5) AS ShortName
FROM Ingredientsspl;

SELECT REPLACE(Address, 'Hyd', 'Hyderabad') AS FullAddress
FROM Suppliers1;

SELECT REVERSE(Name) AS ReversedName
FROM Suppliers1;

SELECT LEFT(Name, 3) AS Start, RIGHT(Name, 3) AS End
FROM Suppliers1;

-- Extract parts of a date (year, month, day) using YEAR(), MONTH(), etc.


-- Get current date/time using NOW(), CURDATE(), CURTIME().

SELECT 
  PurchaseID,
  YEAR(PurchaseDate) AS PurchaseYear,
  MONTH(PurchaseDate) AS PurchaseMonth,
  DAY(PurchaseDate) AS PurchaseDay
FROM Purchases1;

SELECT 
  NOW() AS CurrentDateTime,
  CURDATE() AS Today,
  CURTIME() AS CurrentTime;
  
  SELECT  -- data difference
  IngredientID,
  LoggedAt,
  DATEDIFF(NOW(), LoggedAt) AS DaysSinceLog
FROM InventoryLogs1;

SELECT 
  LogID,
  IngredientID,
  LogDate,
  DATE_ADD(LogDate, INTERVAL 5 DAY) AS ExpectedDelivery
FROM InventoryLogs1;

SELECT *
FROM InventoryLogs1
WHERE LoggedAt < DATE_SUB(NOW(), INTERVAL 10 DAY);

-- Use CASE to assign labels (e.g., rating, status, grade) based on column values.
SELECT 
  Name,
  StockQty,
  CASE 
    WHEN StockQty = 0 THEN 'Out of Stock'
    WHEN StockQty < ReorderLevel THEN 'Low Stock'
    ELSE 'In Stock'
  END AS StockStatus
FROM Ingredientsspl;

SELECT 
  PurchaseID,
  Quantity,
  CASE 
    WHEN Quantity >= 100 THEN 'Bulk Order'
    WHEN Quantity >= 50 THEN 'Medium Order'
    ELSE 'Small Order'
  END AS OrderSize
FROM Purchases1;


  SELECT 
  Name,
  StockQty
FROM Ingredientsspl
ORDER BY 
  CASE 
    WHEN StockQty = 0 THEN 1
    WHEN StockQty < ReorderLevel THEN 2
    ELSE 3
  END;
  
  
  UPDATE InventoryLogs1
SET Reason = 
  CASE 
    WHEN ChangeQty < 0 THEN 'Used in Recipe'
    WHEN ChangeQty > 0 THEN 'Restocked'
    ELSE 'No Change'
  END;

CREATE VIEW TopIngredients AS
SELECT 
    i.Name AS IngredientName,
    SUM(p.Quantity) AS TotalPurchased
FROM Purchases1 p
JOIN Ingredientsspl i ON p.IngredientID = i.IngredientID
GROUP BY p.IngredientID
ORDER BY TotalPurchased DESC;

SELECT * FROM TopIngredients
LIMIT 5;

-- Create a view for public reporting (e.g., showing only non-sensitive data).
-- Query the view using filters and joins.

CREATE VIEW PublicSuppliers AS
SELECT 
    SupplierID,
    Name,
    Address
FROM Suppliers1;

SELECT *
FROM TopIngredients
WHERE TotalPurchased > 200;

SELECT ps.Name AS SupplierName, p.Quantity, p.PurchaseDate
FROM Purchases1 p
JOIN PublicSuppliers ps ON p.SupplierID = ps.SupplierID
WHERE p.Quantity > 50;

-- Create Recipes1 Table
CREATE TABLE Recipes1 (
    RecipeID INT PRIMARY KEY AUTO_INCREMENT,
    RecipeName VARCHAR(100) NOT NULL,
    CuisineType VARCHAR(50),
    PrepTime INT CHECK (PrepTime > 0),
    Instructions TEXT NOT NULL
);

-- Create Orders Table (for the join in the view)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    RecipeID INT,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    FOREIGN KEY (RecipeID) REFERENCES Recipes1(RecipeID)
);
-- Create View: Popular Recipes
CREATE VIEW popular_recipes AS
SELECT 
    r.RecipeID, 
    r.RecipeName, 
    COUNT(o.OrderID) AS times_ordered
FROM Recipes1 r
JOIN Orders o ON r.RecipeID = o.RecipeID
GROUP BY r.RecipeID, r.RecipeName
ORDER BY times_ordered DESC;
INSERT INTO Orders (RecipeID, CustomerName, OrderDate)
VALUES 
(1, 'Raghu Nandhan', '2025-05-01'),
(1, 'Thirumal', '2025-05-02'),
(2, 'Gayathri', '2025-05-01');
SELECT * FROM popular_recipes;

CREATE VIEW public_ingredient_inventory AS
SELECT IngredientID, Name, Stock_Qty
FROM Ingredientsspl;

CREATE VIEW public_ingredients_view AS
SELECT 
    IngredientID,
    Name,
    Unit,
    StockQty,
    ReorderLevel
FROM Ingredientsspl;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SELECT * FROM public_ingredients_view;

SELECT * 
FROM public_ingredients_view
WHERE StockQty < ReorderLevel;

CREATE TABLE IngredientSupplier (
    IngredientID INT,
    SupplierID INT,
    PricePerUnit DECIMAL(10,2),
    FOREIGN KEY (IngredientID) REFERENCES Ingredientsspl(IngredientID)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

CREATE VIEW ingredient_supplier_view AS
SELECT 
    i.IngredientID,
    i.Name,
    i.Unit,
    s.SupplierName,
    sp.PricePerUnit
FROM Ingredientsspl i
JOIN IngredientSupplier sp ON i.IngredientID = sp.IngredientID
JOIN Suppliers1 s ON s.SupplierID = sp.SupplierID;

SELECT Unit, COUNT(*) AS IngredientCount
FROM Ingredientsspl
GROUP BY Unit;

SELECT Unit, COUNT(*) AS IngredientCount
FROM Ingredientsspl
GROUP BY Unit
HAVING COUNT(*) > 3;
