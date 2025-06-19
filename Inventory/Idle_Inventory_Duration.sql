use RetailAnalyticsDB;

-- =========================================================================
-- File: Idle_Inventory_Duration.sql
-- Description: Calculates the number of days between restocking and first sale
-- Author: Mohammed Ali
-- Date Created: 2025-06-17
-- Tags: Inventory Analytics, Idle Stock, Retail Optimization
-- =========================================================================

SELECT 
    i.ProductID,
    i.StoreID,
    i.RestockDate,
    MIN(s.SaleDate) AS FirstSaleAfterRestock,
    DATEDIFF(DAY, i.RestockDate, MIN(s.SaleDate)) AS IdleDays
FROM Inventory i
JOIN Sales s 
    ON i.ProductID = s.ProductID 
   AND i.StoreID = s.StoreID
   AND s.SaleDate >= i.RestockDate
GROUP BY i.ProductID, i.StoreID, i.RestockDate
ORDER BY IdleDays DESC;


