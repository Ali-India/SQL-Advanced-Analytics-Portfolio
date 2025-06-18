
use RetailAnalyticsDB

- =========================================================================
-- File: ReturnRate_ByCategory.sql
-- Description: Calculates the return rate per product category using Sales and Returns data
-- Author: Mohammed Ali
-- Date Created: 2025-06-17
-- Tags: Returns, Sales, Category, Retail Analytics, SQL Portfolio
-- =========================================================================

-- Step 1: Join Returns → Sales → Products to get category-level return data
-- Step 2: Count distinct sales transactions and total returns per category
-- Step 3: Calculate return rate as (Returns / Sales Transactions)
-- Step 4: Round return rate and order by highest return rate

with cte as (
	select  
		p.Category, Count(distinct s.SaleID)  totalSalestxn,
		count(r.ReturnID) as TotalReturn
	from Returns r
	join Sales s ON s.SaleID = r.SaleID
	join Products p on s.ProductID = p.ProductID
	group by p.Category)

select
	*,
	ReturnRate = round(cast(TotalReturn as float) / totalSalestxn, 2)
from cte