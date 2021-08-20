--We're defining high-value customers as those who've made at least 1 order with a total value (not including the discount) 
--equal to $10,000 or more.
--We only want to consider orders made in the year 1998.
SELECT
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	Total_Order = sum(o.Quantity * o.UnitPrice)
from Customers c
	join Orders 
	on c.CustomerID = Orders.CustomerID
	join OrderDetails o
	on o.OrderID = Orders.OrderID
where  year(OrderDate) = 1998
group by c.CustomerID, c.CompanyName, o.OrderID
having sum(o.Quantity * o.UnitPrice) >= 10000 
order by 4 desc;

-----------------------------------------------------------------------------------------------
-- Grouping AT the customer's level not the order level ( Customers with purchases > = 15K)
SELECT
	c.CustomerID,
	c.CompanyName,
	--o.OrderID,
	Total_Order = sum(o.Quantity * o.UnitPrice)
from Customers c
	join Orders 
	on c.CustomerID = Orders.CustomerID
	join OrderDetails o
	on o.OrderID = Orders.OrderID
where  year(OrderDate) = 1998
group by c.CustomerID, c.CompanyName
--, o.OrderID
having sum(o.Quantity * o.UnitPrice) >= 15000 
order by 3 desc;

-----------------------------------------------------------------------------------------------
--High valued customers with discount
SELECT
	c.CustomerID,
	c.CompanyName,
	TotalwithDiscount = sum((o.Quantity * o.UnitPrice) * (1- o.Discount)),
	TotalwithoutDiscount = sum(o.Quantity * o.UnitPrice)
from Customers c
	join Orders 
	on c.CustomerID = Orders.CustomerID
	join OrderDetails o
	on o.OrderID = Orders.OrderID
where  year(OrderDate) = 1998
group by c.CustomerID, c.CompanyName
having sum((o.Quantity * o.UnitPrice) * (1- o.Discount)) >= 10000 
order by 3 desc;

-----------------------------------------------------------------------------------------------
--Show all orders made on the last day of the month. Order by EmployeeID and OrderID

SELECT
	e.EmployeeID,
	count(o.OrderID) as Order_count,
	OrderDate = EOMONTH(o.OrderDate)
FROM Employees e
	join Orders o
	on e.EmployeeID = o.EmployeeID
Group by e.EmployeeID, EOMONTH(o.OrderDate)
order by e.EmployeeID

Select 
	EmployeeID ,
	count(OrderID) as order_count,
	OrderDate = EOMONTH(OrderDate ) 
From Orders 
--Where OrderDate = EOMONTH(OrderDate ) 
group by EmployeeID,  EOMONTH(OrderDate ) 
Order by EmployeeID ,OrderID

-----------------------------------------------------------------------------------------------
-- Show the 10 orders with the most line items, in order of total line items

SELECT top 10 with ties
	o.OrderID,
	count(*) as total_line_order
FROM Orders o
	join OrderDetails d
	on o.OrderID = d.OrderID
group by o.OrderID
order by 2 desc;

-----------------------------------------------------------------------------------------------
--Show a random set of 2% of all orders,
--The Northwind mobile app developers would like to just get a random assortment of orders for beta testing on their app.
Select top 2 percent
OrderID
From Orders
order by NEWID()

-----------------------------------------------------------------------------------------------
--Show all the OrderIDs with line items that were double-entered, but with a different ProductID ,in order of OrderID
--the quantity was 60 or more.
SELECT 
	OrderID
from OrderDetails
where Quantity >= 60
group by OrderID, Quantity
having COUNT(*) > 1

-----------------------------------------------------------------------------------------------
with t as (
SELECT 
	DISTINCT OrderID
from OrderDetails
where Quantity >= 60
group by OrderID, Quantity
having COUNT(*) > 1 )

SELECT *
from OrderDetails
where OrderID in ( Select OrderID from t)
order by OrderID, Quantity

-----------------------------------------------------------------------------------------------

--Which orders are late?
SELECT
	OrderID,
	OrderDate,
	RequiredDate,
	ShippedDate,
	DATEDIFF(DAY, ShippedDate, RequiredDate) as days_late
FROM Orders
where RequiredDate <= ShippedDate
order by days_late;

-----------------------------------------------------------------------------------------------
--Which salespeople have the most orders arriving late?

SELECT
	e.EmployeeID,
	e.LastName,
	Total_lateOrders = count(*)
FROM Employees e 
	join Orders o 
	on o.EmployeeID = e.EmployeeID
where o.RequiredDate < o.ShippedDate
group by e.EmployeeID, e.LastName
order by 3 desc
-----------------------------------------------------------------------------------------------
--orders arriving late for each salesperson isn't a good idea. 
--It needs to be compared against the total number of orders per salesperson.

SELECT
	e.EmployeeID,
	e.LastName,
	Total_lateOrders = count(case when o.RequiredDate <= o.ShippedDate then 1 else NULL end),
	Total_orders = count(*)
FROM Employees e 
	join Orders o 
	on o.EmployeeID = e.EmployeeID
group by e.EmployeeID, e.LastName
order by 3 desc


-- Another method using CTE
With LateOrders as ( 
	Select EmployeeID ,
	TotalOrders = Count(*) From Orders 
	Where RequiredDate <= ShippedDate Group By EmployeeID 
	), 
	AllOrders as ( 
	Select EmployeeID,
	TotalOrders = Count(*) From Orders 
	Group By EmployeeID)
SELECT 
	Employees.EmployeeID ,
	LastName ,
	AllOrders = AllOrders.TotalOrders ,
	LateOrders = LateOrders.TotalOrders 
	From Employees 
	Join AllOrders 
	on AllOrders.EmployeeID = Employees.EmployeeID 
	Left Join LateOrders 
	on LateOrders.EmployeeID = Employees.EmployeeID

-----------------------------------------------------------------------------------------------
--get the percentage of late orders over total orders
With LateOrders as ( 
	Select EmployeeID ,
	TotalOrders = Count(*) From Orders 
	Where RequiredDate <= ShippedDate Group By EmployeeID 
	), 
	AllOrders as ( 
	Select EmployeeID,
	TotalOrders = Count(*) From Orders 
	Group By EmployeeID)
SELECT 
	Employees.EmployeeID ,
	LastName ,
	AllOrders = AllOrders.TotalOrders ,
	LateOrders = LateOrders.TotalOrders,
	Late_orders_perc = LateOrders.TotalOrders/ CAST(AllOrders.TotalOrders AS DECIMAL(7,2)) 
	From Employees 
	Join AllOrders 
	on AllOrders.EmployeeID = Employees.EmployeeID 
	Left Join LateOrders 
	on LateOrders.EmployeeID = Employees.EmployeeID

-----------------------------------------------------------------------------------------------
-- Fixing Decimal points
With LateOrders as ( 
	Select EmployeeID ,
	TotalOrders = Count(*) From Orders 
	Where RequiredDate <= ShippedDate Group By EmployeeID 
	), 
	AllOrders as ( 
	Select EmployeeID,
	TotalOrders = Count(*) From Orders 
	Group By EmployeeID)
SELECT 
	Employees.EmployeeID ,
	LastName ,
	AllOrders = AllOrders.TotalOrders ,
	LateOrders = LateOrders.TotalOrders,
	Late_orders_perc = CONVERT(Decimal(10,2) , (LateOrders.TotalOrders * 1.00)/ AllOrders.TotalOrders)
	From Employees 
	Join AllOrders 
	on AllOrders.EmployeeID = Employees.EmployeeID 
	Left Join LateOrders 
	on LateOrders.EmployeeID = Employees.EmployeeID

-----------------------------------------------------------------------------------------------
--categorize customers into groups 0 to 1,000, 1,000 to 5,000, 5,000 to 10,000, and over 10,000
with t as (
Select 
	Customers.CustomerID ,
	Customers.CompanyName ,
	TotalOrderAmount = SUM(Quantity * UnitPrice) 
From Customers 
	Join Orders 
	on Orders.CustomerID = Customers.CustomerID 
	Join OrderDetails on Orders.OrderID = OrderDetails.OrderID 
Where
	year(OrderDate) >= 1998
Group By Customers.CustomerID ,
		 Customers.CompanyName 
--Order By TotalOrderAmount Desc;
)
SELECT 
	*, 
	CustomerGroup = case when TotalOrderAmount <= 1000 then 'low'
						 when TotalOrderAmount  > 1000  and TotalOrderAmount <= 5000 then 'Medium'
						 when TotalOrderAmount  > 5000 and TotalOrderAmount <= 10000 then 'high'
						 else 'very high' end
from t
order by TotalOrderAmount desc;
-----------------------------------------------------------------------------------------------
--show all the defined CustomerGroups, and the percentage in each. Sort by the total in each group, in descending order.

with t as 
(
Select 
	Customers.CustomerID ,
	Customers.CompanyName ,
	TotalOrderAmount = SUM(Quantity * UnitPrice) 
From Customers 
	Join Orders 
	on Orders.CustomerID = Customers.CustomerID 
	Join OrderDetails on Orders.OrderID = OrderDetails.OrderID 
Where
	year(OrderDate) >= 1998
Group By Customers.CustomerID ,
		 Customers.CompanyName 
--Order By TotalOrderAmount Desc;
) 
 ,Cust_group as 
	(SELECT *, 
		CustomerGroup = case when TotalOrderAmount <= 1000 then 'low'
						when TotalOrderAmount  > 1000  and TotalOrderAmount <= 5000 then 'Medium'
						when TotalOrderAmount  > 5000 and TotalOrderAmount <= 10000 then 'high'
						else 'very high' end
	from t
--order by TotalOrderAmount desc;
)
Select 
CustomerGroup,
total_ingroup = count(*),
perc_group = count(*) * 1.0 / (select count(*) from Cust_group)
from Cust_group
group by CustomerGroup
order by 3 desc;

-----------------------------------------------------------------------------------------------
-- see a list of all countries where suppliers and/or customers are based.
Select 
	Country
from Customers
Union
Select 
	Country
from Suppliers
-----------------------------------------------------------------------------------------------
--Countries with suppliers or customers

;with supplier_countries as 
	(select Distinct Country from Suppliers)
, customerCountries as 
	(select Distinct Country from Customers)
select 
	supplier_countries.Country as suppliercountry,
	customerCountries.Country as customer_country
from supplier_countries
	full outer join customerCountries
	on supplier_countries.Country = customerCountries.Country ;
-----------------------------------------------------------------------------------------------
--see the country name, the total suppliers, and the total customers

;with supplier_countries as 
	(select Country, count(*) as Total_suppliers from Suppliers group by Country)
, customerCountries as 
	(select Country, count(*) as Total_customers from Customers group by Country)
select 
	Country = isnull(supplier_countries.Country, customerCountries.Country),
	Total_supplier = isnull(supplier_countries.Total_suppliers,0),
	Total_Customer = isnull(customerCountries.Total_customers,0)
from supplier_countries
	full outer join customerCountries
	on supplier_countries.Country = customerCountries.Country;
-----------------------------------------------------------------------------------------------
--Looking at the Orders table—we’d like to show details for each order that was the first in that particular country, ordered by OrderID.
--So, we need one row per ShipCountry, and CustomerID, OrderID, and OrderDate should be of the first order from that country.

;with t as 
(SELECT
	ShipCountry,
	CustomerID,
	OrderID,
	cast(OrderDate as date) as Order_date,
	rowno = ROW_NUMBER() over (partition by ShipCountry order by ShipCountry, OrderID)
FROM Orders
--order by ShipCountry, OrderID
)
SELECT 
	ShipCountry,
	CustomerID,
	OrderID,
	Order_date
from t
where rowno = 1
order by ShipCountry;
-----------------------------------------------------------------------------------------------
--Customers with multiple orders in 5 day period

SELECT 
	initial_order.CustomerId,
	initial_orderID = initial_order.OrderID,
	initial_orderdate = cast(initial_order.OrderDate as date),
	next_orderId = next_order.OrderID,
	next_orderdate =  cast(next_order.OrderDate as date),
	Daysbetween = DATEDIFF(dd, initial_order.OrderDate, next_order.OrderDate)
from Orders initial_order
join Orders next_order
on initial_order.CustomerID = next_order.CustomerID
where initial_order.OrderID < next_order.OrderID and
DATEDIFF(dd, initial_order.OrderDate, next_order.OrderDate) <= 5
order by 1, 2;
-----------------------------------------------------------------------------------------------
--using window function to solve the problem above
with t as (
Select
	CustomerID,
	OrderDate = cast(OrderDate as date),
	NextOrderdate = convert(date, Lead(OrderDate, 1) over (partition by CustomerID order by CustomerID, OrderDate))
from Orders
--order by 1, 2
)
Select *,
	date_diff = DATEDIFF(dd, OrderDate, NextOrderdate)
from t
where DATEDIFF(dd, OrderDate, NextOrderdate) <= 5

