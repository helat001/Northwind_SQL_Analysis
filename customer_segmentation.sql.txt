---2. customer ranking based on total sales and country
-- 1. CTE: Customer Sales & Percentile Calculation
WITH cust_sales AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.Country,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
        PERCENT_RANK() OVER (ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC) AS pct_rank
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN "Order Details" od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Country
)

-- Customer Tier Assignment by Percentile
SELECT 
    CustomerID,
    CompanyName,
    Country,
    TotalSales,
    CASE
        WHEN pct_rank < 0.25 THEN 'High-Value'
        WHEN pct_rank < 0.75 THEN 'Mid-Value'
        ELSE 'Low-Value'
    END AS Segment
FROM cust_sales
ORDER BY TotalSales DESC;

-- 3. Aggregated Sales & Customer Count by Country & Tier
SELECT 
    Country,
    Segment,
    COUNT(CustomerID) AS NumCustomers,
    SUM(TotalSales) AS TotalSalesPerSegment
FROM (
    SELECT 
        CustomerID,
        Country,
        TotalSales,
        CASE
            WHEN pct_rank < 0.25 THEN 'High-Value'
            WHEN pct_rank < 0.75 THEN 'Mid-Value'
            ELSE 'Low-Value'
        END AS Segment
    FROM cust_sales
) AS classified_customers
GROUP BY Country, Segment
ORDER BY Country, TotalSalesPerSegment DESC;