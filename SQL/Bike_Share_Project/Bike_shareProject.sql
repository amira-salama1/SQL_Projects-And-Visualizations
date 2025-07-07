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
	   else 'no' End as flagged_hot
from Bike_share_Project..weather
order by 2 desc


------------------------------------------------------------------------------------------------------------------
--Selecting all unique zip codes from both the "weather" and the "trip" tables using Union(stacking)

SELECT distinct w.zip_code
from Bike_share_Project..weather w

Union 

select distinct t.zip_code 
from Bike_share_Project..trip t
order by zip_code

------------------------------------------------------------------------------------------------------------------

--Write a query that appends the start_station_name and end_station_name from 'trip' table. 
--Do not include duplicate values. Filter the start_station_name to only stations with names starting with the letter 'A',
--and filter the end_station_name to stations with names starting with "C" (both case-sensitive). 
--Only return a single column named 'station_name'.

SELECT cast(start_station_name as varchar(max)) AS start_station
from Bike_share_Project..trip 
where start_station_name like 'A%'

Union 

select cast(end_station_name as varchar(max))
from Bike_share_Project..trip 
where end_station_name like 'C%';

------------------------------------------------------------------------------------------------------------------
--What is the average trip duration for starting stations by city?

SELECT cast(city as varchar(max)) AS City, avg(t.duration) avg
from Bike_share_Project..station s 
join trip t
on t.start_station_id = s.id
group by cast(city as varchar(max))
order by 2 desc;

------------------------------------------------------------------------------------------------------------------
/*Write a query that displays the average cloud cover for all trips with starting stations in valid 5-digit zip codes in the Bay Area.
Return columns for 'start_station_name' and 'AVG(cloud_cover)'.*/

select avg(w.cloud_cover) as avg_cloud, t.zip_code zip_code
from trip t
join weather w
on t.zip_code = w.zip_code
where t.zip_code IN ('94558', '94533', '95620', '95476', '94559', '94954', 
	'94571', '94535', '94503', '94949', '94945', '94512', '94591', '94510', 
	'94592', '94589', '94947', '94590', '94946', '94561', '94525', '94569', 
	'94585', '94103', '94565', '94903', '94520', '94572', '94553', '94547', 
	'94963', '94938', '94502', '94509', '94960', '94513', '94109', '94521', 
	'94930', '94973', '94933', '94598', '94564', '94801', '94519', '94806', 
	'94901', '94531', '94803', '94601', '94523', '94518', '94904', '94115', 
	'94549', '94517', '94805', '94804', '94939', '94964', '94530', '94925', 
	'94596', '94708', '94105', '94941', '94563', '94720', '94707', '94514', 
	'94970', '94706', '94710', '94104', '94595', '94709', '94703', '94704', 
	'94507', '94702', '94965', '94556', '94920', '94118', '94705', '94611', 
	'94618', '94609', '94550', '94608', '94528', '94526', '94506', '94130', 
	'94607', '94123', '94610', '94583', '94602', '94612', '94546', '94133', 
	'94129', '94606', '94111', '94619', '94121', '94102', '94552', '94501', 
	'94108', '94605', '94613', '94117', '94122', '94621', '94114', '94107', 
	'94110', '94588', '94131', '94603', '94116', '94124', '94127', '94577', 
	'94132', '94112', '94134', '94568', '94578', '94015', '94005', '94014', 
	'94579', '94580', '94541', '94566', '94542', '94544', '94044', '94545', 
	'94586', '94080', '94587', '94066', '94128', '94401', '94019', '94030', 
	'94555', '94038', '94010', '94536', '94539', '94402', '94404', '94403', 
	'94538', '94560', '94065', '94063', '94027', '94002', '94070', '95134', 
	'95002', '94062', '94089', '94301', '94025', '94303', '95035', '95140', 
	'94061', '94043', '94304', '94305', '94035', '94306', '94028', '94040', 
	'94022', '94085', '94086', '94024', '94087')
group by t.zip_code;

------------------------------------------------------------------------------------------------------------------

--Add city name to each trip record in the "trip" table
--Display all columns from the "trip" table and randomly select 1000 rows
select 
top 1000 
s.city, t.*
from trip t
left join station s
on t.start_station_id = s.id
order by RAND()

------------------------------------------------------------------------------------------------------------------

