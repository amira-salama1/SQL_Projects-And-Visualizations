-- Advanced Quries for The Bike Share Project

-- calculate a running total of minutes spent on bicycle trips per day
select duration, start_station_name, 
	   sum(duration) over (partition by start_station_name ) as running_total_in_seconds
from trip 
order by 3 desc;

------------------------------------------------------------------------------------------------------------------
/* For each station, what is the difference between the number of rides started at the station and the number of rides 
that ended at the station? */

select start_station_name,
	   COUNT(start_station_name) as Start_trips_count,
	   COUNT(start_station_name) - (select count(*)
	   from trip t1
	   where t.start_station_name = t1.end_station_name) as trips_diff
from trip t
group by start_station_name
order by 2 desc


------------------------------------------------------------------------------------------------------------------
--calculate the overall count of bicycle docks at a station without grouping the result? use name and dock columns
Select cast(name as varchar) as name,
	   dock_count,
	   --count(dock_count) over () as overall_dock_count
	   (select count(*) from station)
from station

------------------------------------------------------------------------------------------------------------------
/* Are the most popular stations to start a trip also the most popular stations to end a trip? 
Can you set up and join a CTE to the trip table to get this result? */

with s as 
	(Select start_station_name, count(start_date_parsed) as starts
	from trip 
	group by start_station_name ),
e as 
	(Select end_station_name, count(end_date_parsed) as ends 
	from trip 
	group by end_station_name)

select s.start_station_name, s.starts
from s
join e
on s.start_station_name = e.end_station_name
order by 2 desc;

------------------------------------------------------------------------------------------------------------------
--Find the start station name with the highest average trip duration
--1st method
select top 1 start_station_name, avg(duration) as max_avg_dur
from trip 
group by start_station_name 
order by 2 desc
		
		
--2nd method
select start_station_name, avg_dur, rank() over (order by avg_dur desc)
from 
	  (select 
	  start_station_name, avg(duration) as avg_dur
	  from trip
	  group by start_station_name) as t


--3rd method
--Source https://stackoverflow.com/questions/47398251/sql-getting-max-avg

with t as
	  (select 
	  start_station_name, avg(duration) as avg_dur
	  from trip
	  group by start_station_name)
select t.start_station_name, t.avg_dur
from t 
where t.avg_dur = (select max(avg_dur) from t)

------------------------------------------------------------------------------------------------------------------
--How can you view stations with total trips lower than average using a nested subquery ? DataCamp Query

select start_station_name, count(*) as starts_count
from trip
group by start_station_name
having count(*) < 
		(select avg(trp) from (
		select start_station_name, count(*) as trp
		from trip
		group by start_station_name) as s)
order by 2 desc

------------------------------------------------------------------------------------------------------------------
--Calculate a running count of every start_station name using a window function

select start_station_name, 
	   count(*) over (partition by start_station_name ) as running_count
from trip 
