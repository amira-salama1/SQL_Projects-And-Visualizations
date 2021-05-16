--the total sales in usd for each account.
SELECT a.name, sum(o.total_amt_usd) as total_amount
from Project_Parch_posey..orders o
join Project_Parch_posey..accounts a
on o.account_id = a.id
group by name
order by 2 desc;

--Which account (by name) placed the earliest order?
SELECT Top 1 * 
from Project_Parch_posey..orders o
join Project_Parch_posey..accounts a
on o.account_id = a.id
order by o.occurred_at;

--Find the total number of times each type of channel from the web_events was used.
SELECT w.channel, COUNT(w.channel) total_events
from Project_Parch_posey..web_events w
group by w.channel
order by 2 desc;

--What was the smallest order placed by each account in terms of total usd
SELECT top 5 a.name, sum(o.total_amt_usd) as total_amount
from Project_Parch_posey..orders o
join Project_Parch_posey..accounts a
on o.account_id = a.id
group by name
order by 2;

--How many of the sales reps have more than 5 accounts that they manage
select s.id, s.name, count(a.name) no_of_accounts
from Project_Parch_posey..sales_reps s 
join Project_Parch_posey..accounts a
on s.id = a.sales_rep_id
group by s.id, s.name
having count(a.name) > 5
order by 3;

--Which account has the most orders?
SELECT TOP 1 a.name, count(*) as No_of_orders
from Project_Parch_posey..orders o
join Project_Parch_posey..accounts a
on o.account_id = a.id
group by a.name
order by 2 desc;

--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, w.channel, count(*) use_of_channel
from Project_Parch_posey..accounts a
join Project_Parch_posey..web_events w
on a.id = w.account_id
group by a.name, w.channel 
having w.channel like 'facebook' and count(w.channel) > 6
order by 3 desc;



--Find the sales in terms of total dollars for all orders in each *year*, ordered from greatest to least.
select Datepart(year, occurred_at) as "year", sum(o.total_amt_usd) as total_amount
from Project_Parch_posey..orders o
group by Datepart(year, occurred_at)
order by 2 desc;

--Sales broken down by month
select Datepart(year, occurred_at) as "year", Datepart(month, occurred_at) as "month", sum(o.total_amt_usd) as total_amount
from Project_Parch_posey..orders o
group by Datepart(year, occurred_at), Datepart(month, occurred_at)
order by 1,2 ;


-- Using Case Statements
-- A table that includes the level of each account, the account name, the total sales of all orders for the customer, and their level.
SELECT a.name, sum(o.total_amt_usd) as "total_amount", 
case when sum(o.total_amt_usd) > 200000 then 'Top level'
	 when sum(o.total_amt_usd) between 100000 and 200000 then 'Middle level'
	 else 'Third level' end 'customer level'
from Project_Parch_posey..orders o
join Project_Parch_posey..accounts a
on o.account_id = a.id
group by name
order by 2 desc;

--Top performing sales reps whose total orders are > 200 orders and their values
Select distinct s.id, s.name, count(*) total_orders, sum(o.total_amt_usd) total_amount, 
	 case when  count(*) > 200 or sum(o.total_amt_usd) > 750000 then 'Top'
	 when  count(*) > 150 or sum(o.total_amt_usd) > 500000 then 'Middle'
	 else 'Low' end as reps_level
from Project_Parch_posey..sales_reps s 
join Project_Parch_posey..accounts a
on s.id = a.sales_rep_id
join Project_Parch_posey..orders o
on a.id = o.account_id
group by s.id, s.name
order by 3 desc;


--CTE and subqueries:
--the average number of events for each day for each channel
Select channel, avg(event_count) as avg_event_count 
from 
	(Select datename(day, occurred_at) "day", channel, count(channel) as event_count
	 from Project_Parch_posey..web_events
	 group by datename(day, occurred_at), channel
	 ) as temp
	group by channel
	order by 2 desc;

--The name of the sales_rep in each region with the largest amount of total_amt_usd sales.

with t1 as 
	(Select distinct s.id rep_id, s.name rep_name, r.name as region_name, sum(o.total_amt_usd) total_amount 
	from Project_Parch_posey..sales_reps s 
	join Project_Parch_posey..region r
	on r.id = s.region_id
	join Project_Parch_posey..accounts a
	on s.id = a.sales_rep_id
	join Project_Parch_posey..orders o
	on a.id = o.account_id
	group by s.id, s.name, r.name
	--order by 4 desc
	),
	t2 as 
	(select region_name, max(total_amount) Total_sales
	from t1
	group by region_name
	--order by 2 desc
	)
select t1.rep_name, t1.region_name, t2.Total_sales
from t1
join t2 
on t2.region_name = t1.region_name and t2.Total_sales = t1.total_amount
order by 3 desc;


