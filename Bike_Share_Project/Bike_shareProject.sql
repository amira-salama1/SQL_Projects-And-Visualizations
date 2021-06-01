-- Exploring Station Table
select count(*)
from Bike_share_Project..station

select *
from Bike_share_Project..station

-- Exploring Trip Table
select count(*)
from Bike_share_Project..trip

select *
from Bike_share_Project..trip

-- Exploring Trip Table
select count(*)
from Bike_share_Project..weather

select *
from Bike_share_Project..weather
------------------------------------------------------------------------------------------------------------------

-- How Many Trips Have Been Made To Each Start Station, which is the most popular start station?
select cast(start_station_name as varchar(max)) AS start_station,  count(*) as count_start_station
from Bike_share_Project..trip
group by cast(start_station_name as varchar(max))
order by 2 desc

--Answer :San Francisco Caltrain (Townsend at 4th) :49092 times

------------------------------------------------------------------------------------------------------------------

--How Many Subs/Cus. Are Per Station?
Select cast(subscription_type as varchar(max)) AS subscription_type,  count(*) as count_subscription_type
from Bike_share_Project..trip
group by cast(subscription_type as varchar(max))
order by 2 desc

------------------------------------------------------------------------------------------------------------------
--What are the top 10 start stations based on *total* trip duration?
Select Top 10 cast(start_station_name as varchar(max)) AS start_station,  Sum(duration) as "Total_Duration"
from Bike_share_Project..trip
group by cast(start_station_name as varchar(max))
order by 2 desc

------------------------------------------------------------------------------------------------------------------

--calculate the average trip duration for each type of subscription
Select cast(start_station_name as varchar(max)) AS start_station,  avg(duration) as "Avg_Duration",
		cast(subscription_type as varchar(max)) AS subscription_type
from Bike_share_Project..trip
group by cast(start_station_name as varchar(max)), cast(subscription_type as varchar(max))
order by 2 desc

------------------------------------------------------------------------------------------------------------------

--find the top 10 start stations based on the total number of trips
Select Top 10 cast(start_station_name as varchar(max)) AS start_station,  count(*) as "station_Trips"
from Bike_share_Project..trip
group by cast(start_station_name as varchar(max))
order by 2 desc

------------------------------------------------------------------------------------------------------------------

--Which starting stations have an average trip duration greater than 1 hour?

Select cast(start_station_name as varchar(max)) AS start_station,  avg(duration) as avg_duration
from Bike_share_Project..trip
group by cast(start_station_name as varchar(max))
having avg(duration)> 3600
order by 2 desc

------------------------------------------------------------------------------------------------------------------

--Create a new column to label the number of docks as high, med, low

select dock_count,
	   Case when dock_count >= 25 then 'High'
	   when dock_count > 15 then 'Med'
	   else 'Low' End As dock_rank
from Bike_share_Project..station
order by 2 ;


------------------------------------------------------------------------------------------------------------------

--Write a query that includes a column that is flagged "yes" when the max temperature on a given day is over 90
--, and sort the results with those dates first

select date, max_temperature_f, 
	   case when max_temperature_f> 90 then 'yes'
	   else 'no' End as flagged
from Bike_share_Project..weather
order by 2 desc