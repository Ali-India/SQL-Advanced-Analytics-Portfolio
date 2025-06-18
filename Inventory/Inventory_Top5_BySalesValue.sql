use RetailAnalyticsDB

-- =========================================================================
-- File: Inventory_Top5_BySalesValue.sql
-- Description: Identifies top 5 low-stock products by total sales value
-- Author: Mohammed Ali
-- Date Created: 2025-06-16
-- Tags: Inventory, Sales, Retail Analytics, SQL Portfolio
-- =========================================================================

-- Step 1: Join Inventory, Products, and Sales to calculate total sales value
-- Step 2: Filter for products with StockLevel < 10
-- Step 3: Group by ProductID and order by TotalSalesValue

SELECT TOP 5 
    p.ProductID,
    p.ProductName,
    SUM(s.Quantity * p.Price) AS TotalSalesValue,
    MIN(i.StockLevel) AS CurrentStockLevel
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
JOIN Inventory i ON p.ProductID = i.ProductID AND s.StoreID = i.StoreID
WHERE i.StockLevel < 10
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSalesValue DESC;
