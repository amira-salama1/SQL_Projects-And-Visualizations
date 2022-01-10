select * 
from retail_sales


---------------------------------------------------------------------------------------------
-- Grouping Total Retail and food services sales by Year  
select 
	DATEPART(year, sales_month) as Year,
	sum(sales) as Total_Sales
from 
	retail_sales
where kind_of_business = 'Retail and food services sales, total'
group by DATEPART(year, sales_month)

---------------------------------------------------------------------------------------------
-- Examining Trends over the years for Leisure activities

create view Leisure_activities as
(
select 
	DATEPART(year, sales_month) as Year,
	kind_of_business,
	sum(sales) as Total_Sales
from 
	retail_sales
where kind_of_business in ('Book stores','Sporting goods stores','Hobby, toy, and game stores')
group by DATEPART(year, sales_month), kind_of_business )

---------------------------------------------------------------------------------------------
--Exploring Sales Gap between Women_sales and Men_sales across the years
with t as (
SELECT 
	DATEPART(year, sales_month) as Year,
	sum(Case when kind_of_business = 'Women''s clothing stores' then sales end) as Women_sales,
	sum(Case when kind_of_business = 'Men''s clothing stores' then sales  end) as men_sales
	
FROM 
	retail_sales
WHERE 
	kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
group by 
	DATEPART(year, sales_month))
Select 
	Year,
	Women_sales,
	men_sales, 
	(Women_sales - men_sales) as Sales_Gap
from t

---------------------------------------------------------------------------------------------
with t as (
SELECT 
	DATEPART(year, sales_month) as Year,
	sum(Case when kind_of_business = 'Women''s clothing stores' then sales end) as Women_sales,
	sum(Case when kind_of_business = 'Men''s clothing stores' then sales  end) as men_sales
	
FROM 
	retail_sales
WHERE 
	kind_of_business in ('Men''s clothing stores','Women''s clothing stores') and
	sales_month <= '2019-01-01'
group by 
	DATEPART(year, sales_month))
Select 
	Year,
	round((Women_sales/men_sales -1)* 100, 2) as Percent_Gap	 
from t

---------------------------------------------------------------------------------------------
-- calculate the percent oftotal sales for each category

with t as (
SELECT 
	a.sales_month, 
	a.kind_of_business, 
	a.sales,
	sum(b.sales) as total_sales
FROM retail_sales a
JOIN retail_sales b on a.sales_month = b.sales_month
and b.kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
WHERE a.kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
GROUP BY a.sales_month, a.kind_of_business, a.sales
--order by 1
)
select 
	sales_month,
	kind_of_business,
	round((sales/total_sales)*100, 2) as Percnt_sales
from
	t
order by 1

--Alternative method with window functions

Select
	sales_month,
	kind_of_business,
	sales,
	sum(sales) over (partition by sales_month) as total_sales,
	round(sales * 100 / sum(sales) over (partition by sales_month),2) as Percnt_sales
FROM 
	retail_sales
Where
	kind_of_business in ('Men''s clothing stores','Women''s clothing stores')

---------------------------------------------------------------------------------------------
-- Calculating moving average for Women's clothing stores' over the years
SELECT
	sales_month,
	avg(sales) over (order by sales_month rows between 11 preceding and current row) as moving_avg,
	count(sales) over (order by sales_month rows between 11 preceding and current row) as records_count
From
	retail_sales
where 
	kind_of_business in ('Women''s clothing stores')

---------------------------------------------------------------------------------------------
-- Calculating the running total for sales year to date
SELECT
	sales_month,
	sales,
	sum(sales) over (partition by datepart(year, sales_month) order by sales_month ) as sales_ytd
from 
	retail_sales
where 
	kind_of_business = 'Women''s clothing stores'
---------------------------------------------------------------------------------------------
-- calculate MoM growth for book stores
SELECT
	kind_of_business,
	sales_month,
	sales,
	lag(sales_month) over (partition by kind_of_business order by sales_month) as previous_month,
	lag(sales) over (partition by kind_of_business order by sales_month) as previous_month_sales
from 
	retail_sales
where 
	kind_of_business = 'Book stores'

---------------------------------------------------------------------------------------------	
-- calculate YoY growth for book stores
with t as 
(
Select 
	DATEPART(year, sales_month) as sales_year,
	sum(sales) as total_sales
from 
	retail_sales
where 
	kind_of_business = 'Book stores'
group by DATEPART(year, sales_month)
)

Select 
	sales_year,
	total_sales,
	lag(total_sales) over (order by sales_year) as previous_year_sales,
	round((total_sales/lag(total_sales) over (order by sales_year)-1 )* 100, 2) as pct_yoy_growth
from t

