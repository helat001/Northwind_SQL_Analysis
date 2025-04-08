CREATE TABLE "mytable" (
  "-- 3. Products Restock Recommendations" text NULL
);

INSERT INTO "mytable" ("-- 3. Products Restock Recommendations")
VALUES
('--Inventory metrics and restock logic'),
('SELECT'),
('p.ProductID'),
('p.ProductName'),
('SUM(od.Quantity) AS RecentUnitsSold'),
('AVG(od.Quantity) AS AvgMonthlySales'),
('p.UnitsInStock'),
('p.UnitsOnOrder'),
('(p.UnitsInStock + p.UnitsOnOrder) AS TotalAvailableStock'),
('p.ReorderLevel'),
('CASE'),
('WHEN p.Discontinued = 1 THEN ''Discontinued (No Restock)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) < p.ReorderLevel THEN ''Restock Now (Below Reorder Level)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) < (AVG(od.Quantity) * 1.5) THEN ''Restock More (Low vs Demand)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) > (AVG(od.Quantity) * 3) THEN ''Restock Less (Overstocked)'''),
('ELSE ''Maintain Stock'''),
('END AS RestockRecommendation'),
(NULL),
('FROM Products p'),
('LEFT JOIN "Order Details" od ON p.ProductID = od.ProductID'),
('LEFT JOIN Orders o ON od.OrderID = o.OrderID'),
('WHERE o.OrderDate >= DATE((SELECT MAX(OrderDate) FROM Orders)'),
('GROUP BY'),
('p.ProductID'),
('ORDER BY'),
('CASE'),
('WHEN p.Discontinued = 1 THEN ''Discontinued (No Restock)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) < p.ReorderLevel THEN ''Restock Now (Below Reorder Level)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) < (AVG(od.Quantity) * 1.5) THEN ''Restock More (Low vs Demand)'''),
('WHEN (p.UnitsInStock + p.UnitsOnOrder) > (AVG(od.Quantity) * 3) THEN ''Restock Less (Overstocked)'''),
('ELSE 4'),
('END'),
('RecentUnitsSold DESC;');
