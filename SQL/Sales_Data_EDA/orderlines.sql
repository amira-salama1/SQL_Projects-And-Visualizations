with orders as (
select 
	orderid , productid , count(*) as cnt

from dbo.orderlines
group by orderid , productid )

select cnt , count(*) as product_count , min(orderid)as min_orderid , max(orderid) as max_orderid
from orders
group by cnt
order by cnt

-------------------------------------------------------------------------------------------------------
--calculating the ratio of non repeating products 

with t as (
select orderid , count(*) as numlines,
	count(Distinct productid ) as numproducts
from dbo.orderlines
group by orderid
 )
 select numlines , count(*) as numorders, 
	sum(case when numproducts < numlines  then 1 else 0 end) as multiorder,
	avg(case when numproducts < numlines  then 1.0 else 0 end) as ratio_multiorder,
	min(orderid) as minorderid , max(orderid) as maxorderid
 from t
 group by numlines
 order by numorders
-------------------------------------------------------------------------------------------------------

select State, count(*) as numorders,
	sum(case when paymenttype = 'AE' then 1 else 0 end) as numAE,
	avg(case when paymenttype = 'AE' then 1.0 else 0 end) as avAE
	from dbo.orders 
	group by State
	order by avAE desc
-------------------------------------------------------------------------------
--Ratio of sales for each state by broken payment type
select  distinct state, paymenttype,
	sum(totalprice) over (partition by state) overallstate,
	sum(totalprice) over (partition by state, paymenttype) as sales_st_ptype,
	count(paymenttype) over (partition by state, paymenttype) cntptype,
	(sum(totalprice) over (partition by state, paymenttype) / sum(totalprice) over (partition by state))  as salesratio_by_paytype_st
from orders
order by state ,salesratio_by_paytype_st desc

-------------------------------------------------------------------------------
--Ratio of sales by payment types 
select distinct  paymenttype, 
	sum(totalprice) over (partition by paymenttype ) / sum(totalprice) over () as Paytype_ratio
from orders
order by Paytype_ratio desc

-------------------------------------------------------------------------------

--Summary Stats for State column
with ordersum as(
	select 'State' as col , State as val , count(*) as freq
from orders
group by state ),
summary as (
	select min(freq) as minfreq, max(freq) as maxfreq,
			min(val) as minval , max(val) as maxval,
			sum(case when val is null then 1 else 0 end) as nullfreq
	from ordersum)

select ordersum.col, count(*) as numvalues,
	max(nullfreq) as nullfreq,
	min(minval) as  minval,
	sum(case when val = minval then freq else 0 end) as numminvals,
	max(maxval) as maxval,
	sum(case when val = maxval then freq else 0 end) as nummaxvals,
	min(case when freq = maxfreq then val  end) as mode,
	sum(case when freq = maxfreq then 1 else 0 end) as nummodes,
	max(maxfreq) as modefreq,
	min(case when freq = minfreq then val end) as antimode,
	sum(case when freq = minfreq then 1 else 0 end) as num_antimode,
	max(minfreq) as antimodefreq,
	sum(case when freq = 1 then freq else 0 end) as numuniques
from ordersum
cross join summary
group by ordersum.col
--------------------------------
---summary stats for total price column
with ordersum as(
	select 'Total Price' as col , floor(totalprice) as val , count(*) as freq
from orders
group by floor(totalprice) ),
summary as (
	select min(freq) as minfreq, max(freq) as maxfreq,
			min(val) as minval , max(val) as maxval,
			sum(case when val is null then 1 else 0 end) as nullfreq
	from ordersum)
select * from summary
select ordersum.col, count(*) as numvalues,
	max(nullfreq) as nullfreq,
	min(minval) as  minval,
	sum(case when val = minval then freq else 0 end) as numminvals,
	max(maxval) as maxval,
	sum(case when val = maxval then freq else 0 end) as nummaxvals,
	min(case when freq = maxfreq then val  end) as mode,
	sum(case when freq = maxfreq then 1 else 0 end) as nummodes,
	max(maxfreq) as modefreq,
	min(case when freq = minfreq then val end) as antimode,
	sum(case when freq = minfreq then 1 else 0 end) as num_antimode,
	max(minfreq) as antimodefreq,
	sum(case when freq = 1 then freq else 0 end) as numuniques
from ordersum
cross join summary
group by ordersum.col

-------------------------------------------------------------------------------
