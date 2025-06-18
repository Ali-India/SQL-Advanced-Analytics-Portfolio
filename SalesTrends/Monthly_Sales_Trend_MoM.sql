use RetailAnalyticsDB;

-- =========================================================================
-- File: Monthly_Sales_Trend_MoM.sql
-- Description: Calculates monthly total sales and Month-over-Month (MoM) percentage growth
-- Author: Mohammed Ali
-- Date Created: 2025-06-17
-- Tags: Sales, Trends, MoM, SQL Window Functions, Retail Analytics
-- =========================================================================

-- Step 1: Aggregate sales value by month
WITH salesMonthly AS (
    SELECT
        FORMAT(s.SaleDate, 'yyyy-MM') AS SalesMonth,
        SUM(s.Quantity * p.Price) AS TotalSalesValue
    FROM Sales s
    JOIN Products p ON p.ProductID = s.ProductID
    GROUP BY FORMAT(s.SaleDate, 'yyyy-MM')
),

-- Step 2: Get previous month sales
SalesMoM AS (
    SELECT 
        SalesMonth,
        TotalSalesValue, 
        LAG(TotalSalesValue) OVER (ORDER BY SalesMonth) AS PreviousMonth
    FROM salesMonthly
)

-- Step 3: Calculate MoM % change
SELECT 
    SalesMonth, 
    TotalSalesValue, 
    PreviousMonth,
    ROUND((TotalSalesValue - PreviousMonth) * 100.0 / NULLIF(PreviousMonth, 0), 2) AS MoMPerChange 
FROM SalesMoM
ORDER BY SalesMonth;
