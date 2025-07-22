--Query that shows Employees BirthDate field,
--only the date portion of the BirthDate field without the timestamp

select 
	FirstName,
	LastName,
	Title,
	cast(BirthDate as date) as OnlyBirthDate
from Employees
order by BirthDate
-------------------------------------------------------------------------------------------

select 
	FirstName,
	LastName,
	FullName = concat(FirstName,' ', LastName )
from Employees

-------------------------------------------------------------------------------------------
--In the OrderDetails table, we have the fields UnitPrice and Quantity. 
--Create a new field, TotalPrice, that multiplies these two together.

select *,
	--UnitPrice,
	--Quantity,
	Total_price = (UnitPrice * Quantity),
	TotalAfter_Discount = (UnitPrice * Quantity) * (1 - Discount)
from 
	OrderDetails

-------------------------------------------------------------------------------------------
Select 
	ContactTitle,
	count(ContactTitle) as count
from Customers
group by ContactTitle
order by 2 desc;

-------------------------------------------------------------------------------------------
/*We’d like to show, for each product, the associated Supplier. 
Show the ProductID, ProductName, and the CompanyName of the Supplier. Sort by ProductID.*/

Select 
	p.ProductID,
	p.ProductName,
	s.CompanyName as Supplier
	--s.ContactName
from Products p
join Suppliers s
on p.SupplierID = s.SupplierID

--------------------------------------------------------------------------------------------

/*show a list of the Orders that were made, including the Shipper that was used. 
Show the OrderID, OrderDate (date only), and CompanyName of the Shipper, and sort by OrderID. */

Select 
	o.OrderID,
	cast(o.OrderDate as date) as Order_Date,
	s.CompanyName as Shippers
from Orders o
join Shippers s
on o.ShipVia = s.ShipperID
order by 1


--------------------------------------------------------------------------------------------
/*we’d like to see the total number of products in each category. Sort the results by the total number of products, 
in descending order. */

Select
	c.CategoryName, 
	count(*) as TotalProducts
from Products p
join Categories c
on c.CategoryID = p.CategoryID
group by c.CategoryName
order by 2 desc;

--------------------------------------------------------------------------------------------
--show the total number of customers per Country and City.
SELECT
	Country,
	 City,
	 Total_Customers = count(*)
from Customers
group by Country, City 
order by 3 desc;

--------------------------------------------------------------------------------------------
--What products do we have in our inventory that should be reordered?
--For now, just use the fields UnitsInStock and ReorderLevel, where UnitsInStock is less than the ReorderLevel, 
--ignoring the fields UnitsOnOrder and Discontinued. Order the results by ProductID.
--products_reordering = UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel
--The Discontinued flag is false (0).
SELECT
	ProductID, 
	ProductName,
	UnitsInStock,
	ReorderLevel,
	Discontinued,
	products_reordering = UnitsInStock + UnitsOnOrder
from Products
where (UnitsInStock + UnitsOnOrder ) <= ReorderLevel and Discontinued = 0
order by 1;

--------------------------------------------------------------------------------------------
--see a list of all customers, sorted by region, alphabetically.

Select 
	CustomerID,
	CompanyName,
	Region
From Customers
order by 
	case when Region is Null then 1 else 0 end,
	Region, CustomerID
--------------------------------------------------------------------------------------------
--Return the three ship countries with the highest average freight overall, in descending order by average freight.
Select top 3
	ShipCountry,
	AvgFreight = avg(Freight)
From Orders
where year(OrderDate ) >= 1998
group by ShipCountry
order by AvgFreight desc;

--------------------------------------------------------------------------------------------
-- Alternative method
Select top 3
	ShipCountry,
	AvgFreight = avg(Freight)
From Orders
where OrderDate >= dateadd(yy,-1,(select max(OrderDate) from Orders))
group by ShipCountry
order by AvgFreight desc;

--------------------------------------------------------------------------------------------

--inventory, and need to show information , for all orders. Sort by OrderID and Product ID.
Select
	e.EmployeeID,
	e.LastName,
	o.OrderID,
	p.ProductName,
	d.Quantity
from Employees e
join Orders o
on e.EmployeeID = o.EmployeeID
join OrderDetails d
on d.OrderID = o.OrderID
join Products p
on p.ProductID = d.ProductID
order by o.OrderID,p.ProductID ;

--------------------------------------------------------------------------------------------

-- customers who have never actually placed an order.( Left Join)

SELECT 
	c.CustomerID,
	o.OrderID
from Customers c
left join Orders o
on o.CustomerID = c.CustomerID
where o.OrderID is NULL
--------------------------------------------------------------------------------------------
-- Customers with no orders for EmployeeID 4
SELECT 
	c.CustomerID,
	o.OrderID
from Customers c
left join Orders o
on o.CustomerID = c.CustomerID
and o.EmployeeID = 4
where o.OrderID is NULL

--------------------------------------------------------------------------------------------
