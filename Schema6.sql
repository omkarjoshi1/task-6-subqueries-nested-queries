
-- Task 6: Subqueries & Nested Queries (SELECT / WHERE / FROM)


USE ECommerceDB;

-- 0) Quick sanity
SELECT COUNT(*) AS users FROM Users;
SELECT COUNT(*) AS products FROM Products;
SELECT COUNT(*) AS orders FROM Orders;
SELECT COUNT(*) AS order_items FROM OrderItems;
SELECT COUNT(*) AS payments FROM Payments;

-------------------------------
-- A) Scalar subqueries (SELECT)
-------------------------------

-- A1) Each product with its category name via scalar subquery
SELECT
  p.ProductID,
  p.Name AS ProductName,
  (SELECT c.CategoryName FROM Categories c
   WHERE c.CategoryID = p.CategoryID) AS CategoryName
FROM Products p;

-- A2) Order with a computed 'items_total' via scalar subquery
SELECT
  o.OrderID,
  o.UserID,
  o.TotalAmount,
  (SELECT SUM(oi.Quantity * oi.Price)
     FROM OrderItems oi
     WHERE oi.OrderID = o.OrderID) AS ItemsTotal
FROM Orders o;

-- A3) Users with their total number of orders (scalar subquery)
SELECT
  u.UserID,
  u.Name,
  (SELECT COUNT(*) FROM Orders o WHERE o.UserID = u.UserID) AS OrderCount
FROM Users u;

------------------------------------------
-- B) Subqueries in WHERE (IN / EXISTS /=)
------------------------------------------

-- B1) Products priced above overall average price
SELECT ProductID, Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- B2) Products in categories named 'Electronics' OR 'Books' (subquery + IN)
SELECT ProductID, Name, Price
FROM Products
WHERE CategoryID IN (
  SELECT CategoryID FROM Categories
  WHERE CategoryName IN ('Electronics','Books')
);

-- B3) Users who have placed at least one order (EXISTS)
SELECT u.UserID, u.Name
FROM Users u
WHERE EXISTS (
  SELECT 1 FROM Orders o
  WHERE o.UserID = u.UserID
);

-- B4) Users with NO orders (NOT EXISTS)
SELECT u.UserID, u.Name
FROM Users u
WHERE NOT EXISTS (
  SELECT 1 FROM Orders o
  WHERE o.UserID = u.UserID
);

-- B5) Orders that have a payment (EXISTS)
SELECT o.OrderID, o.Status
FROM Orders o
WHERE EXISTS (
  SELECT 1 FROM Payments p
  WHERE p.OrderID = o.OrderID
);

-- B6) Orders with NO payment (NOT EXISTS)
SELECT o.OrderID, o.Status
FROM Orders o
WHERE NOT EXISTS (
  SELECT 1 FROM Payments p
  WHERE p.OrderID = o.OrderID
);

---------------------------------
-- C) Correlated subqueries (WHERE)
---------------------------------

-- C1) Orders where stored TotalAmount matches actual sum of items
SELECT o.OrderID, o.TotalAmount
FROM Orders o
WHERE o.TotalAmount = (
  SELECT SUM(oi.Quantity * oi.Price)
  FROM OrderItems oi
  WHERE oi.OrderID = o.OrderID
);

-- C2) Find products that are the most expensive within their category
SELECT p.ProductID, p.Name, p.Price, c.CategoryName
FROM Products p
JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.Price = (
  SELECT MAX(p2.Price)
  FROM Products p2
  WHERE p2.CategoryID = p.CategoryID
);

-- C3) For each order item, show if its price is the max price for that product across all order items
SELECT
  oi.OrderItemID,
  oi.OrderID,
  oi.ProductID,
  oi.Price,
  CASE
    WHEN oi.Price = (
      SELECT MAX(oi2.Price)
      FROM OrderItems oi2
      WHERE oi2.ProductID = oi.ProductID
    ) THEN 'MaxForThisProduct'
    ELSE 'NotMax'
  END AS PriceFlag
FROM OrderItems oi;

------------------------------------
-- D) Subquery in FROM (derived tbl)
------------------------------------

-- D1) Derived table: order totals from items, then join orders
SELECT
  o.OrderID,
  o.UserID,
  o.OrderDate,
  dt.ItemsTotal,
  o.TotalAmount
FROM Orders o
JOIN (
  SELECT oi.OrderID, SUM(oi.Quantity * oi.Price) AS ItemsTotal
  FROM OrderItems oi
  GROUP BY oi.OrderID
) AS dt ON dt.OrderID = o.OrderID
ORDER BY o.OrderID;

-- D2) Customers with AVG order amount > overall AVG order amount
SELECT
  u.UserID,
  u.Name,
  cu.avg_order_amount
FROM (
  SELECT o.UserID, AVG(o.TotalAmount) AS avg_order_amount
  FROM Orders o
  GROUP BY o.UserID
) AS cu
JOIN Users u ON u.UserID = cu.UserID
WHERE cu.avg_order_amount > (
  SELECT AVG(TotalAmount) FROM Orders
);

-----------------------------------
-- E) ANY / ALL (extra practice)
-----------------------------------

-- E1) Products whose price is > ALL prices in 'Books'
SELECT ProductID, Name, Price
FROM Products
WHERE Price > ALL (
  SELECT Price FROM Products p
  JOIN Categories c ON c.CategoryID = p.CategoryID
  WHERE c.CategoryName = 'Books'
);

-- E2) Products whose price >= ANY price in 'Electronics'
SELECT ProductID, Name, Price
FROM Products
WHERE Price >= ANY (
  SELECT Price FROM Products p
  JOIN Categories c ON c.CategoryID = p.CategoryID
  WHERE c.CategoryName = 'Electronics'
);
