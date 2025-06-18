use RetailAnalyticsDB;


-- =========================================================================
-- File: RFM_Segmentation.sql
-- Description: Calculates Recency, Frequency, and Monetary value for each customer
-- Author: Mohammed Ali
-- Date Created: 2025-06-17
-- Tags: RFM, Customer Segmentation, SQL Portfolio, Advanced Analytics
-- =========================================================================

-- Step 1: Define anchor date as "today"
DECLARE @Today DATE = (SELECT MAX(SaleDate) FROM Sales);

-- Step 2: Calculate RFM metrics for each customer
SELECT
    s.CustomerID,
    DATEDIFF(DAY, MAX(s.SaleDate), @Today) AS Recency,           
    COUNT(DISTINCT s.SaleID) AS Frequency,                           
    SUM(s.Quantity * p.Price) AS Monetary                            
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY s.CustomerID
ORDER BY Monetary DESC;
