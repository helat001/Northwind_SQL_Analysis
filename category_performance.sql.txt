--1 Product category performance by revenue contribution and product count, identifying top-performing categories
--Determine which categories generate the most revenue and how products are distributed


--CTE 1: Calculate total sales and product count per category
WITH 
CategoryStats AS (
  SELECT 
    cat.CategoryName,
    COUNT(DISTINCT p.ProductID) AS NumProducts,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalCategorySales
  FROM Categories AS cat
  JOIN Products AS p ON cat.CategoryID = p.CategoryID
  JOIN "Order Details" AS od ON p.ProductID = od.ProductID
  GROUP BY cat.CategoryName
),

--CTE 2: Calculate total revenue across all categories
TotalRevenue AS (
  SELECT SUM(TotalCategorySales) AS OverallSales
  FROM CategoryStats
)

--Calculate performance metrics / Combines CTE data /  Computes averages and percentages
SELECT 
  cs.CategoryName,
  cs.NumProducts,
  cs.TotalCategorySales,
  ROUND(cs.TotalCategorySales / cs.NumProducts, 2) AS AvgRevenuePerProduct,
  ROUND((cs.TotalCategorySales * 100.0) / tr.OverallSales, 2) AS RevenuePercentage
FROM CategoryStats cs, TotalRevenue tr
ORDER BY cs.TotalCategorySales DESC;