use RetailAnalyticsDB;

-- =========================================================================
-- File: RFM_Segmentation_With_Labels.sql
-- Description: Performs RFM (Recency, Frequency, Monetary) segmentation for each customer,
--              assigns RFM scores using quartiles, and classifies customers into behavioral segments.
-- Author: Mohammed Ali
-- Date Created: 2025-06-17
-- Tags: RFM, Customer Segmentation, SQL, Portfolio, Advanced Analytics
-- =========================================================================

-- Step 1: Define anchor date based on latest sale
DECLARE @Today DATE = (SELECT MAX(SaleDate) FROM Sales);

-- Step 2: Create RFM base table
WITH Base AS (
    SELECT 
        s.CustomerID,
        SUM(s.Quantity * p.Price) AS Monetary,
        DATEDIFF(DAY, MAX(s.SaleDate), @Today) AS Recency,
        COUNT(DISTINCT s.SaleID) AS Frequency
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    GROUP BY s.CustomerID
),

-- Step 3: Assign quartile-based RFM scores
RFM_Scored AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY Recency DESC) AS R_Score,      -- Lower Recency = better
        NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Score,    -- Higher Frequency = better
        NTILE(4) OVER (ORDER BY Monetary DESC) AS M_Score      -- Higher Monetary = better
    FROM Base
)

-- Step 4: Generate RFM segment code and assign labels
SELECT *,
    CAST(R_Score AS VARCHAR) + CAST(F_Score AS VARCHAR) + CAST(M_Score AS VARCHAR) AS RFM_Segment,
    CASE 
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champion Customer'
        WHEN R_Score = 4 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customer'
        WHEN R_Score = 4 AND F_Score <= 2 AND M_Score <= 2 THEN 'Recent Buyer'
        WHEN R_Score = 3 AND F_Score = 3 AND M_Score >= 3 THEN 'Potential Loyalist'
        WHEN R_Score = 1 AND F_Score >= 3 AND M_Score >= 3 THEN 'At Risk (Used to be active)'
        WHEN R_Score = 1 AND F_Score <= 2 AND M_Score >= 3 THEN 'Lost Big Spender'
        WHEN R_Score = 1 AND F_Score <= 2 AND M_Score <= 2 THEN 'Inactive/Cold'
        WHEN (R_Score IN (2,3)) AND M_Score = 4 THEN 'High Value Opportunity'
        ELSE 'Others'
    END AS SegmentLabel
FROM RFM_Scored
ORDER BY RFM_Segment DESC;
