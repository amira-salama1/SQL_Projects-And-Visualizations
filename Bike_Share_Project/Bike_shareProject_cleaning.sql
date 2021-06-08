--Data cleaning 
--Parsing Date Column in trip table 


SELECT start_date, cast(cast(start_date as varchar) as datetime) as start_date_parsed 
FROM trip 

alter table trip
add start_date_parsed datetime;

update trip
set start_date_parsed = cast(cast(start_date as varchar) as datetime) 


--Test 
select start_date_parsed, start_date
from trip

-- Dropping the start_date Column
Alter Table trip
drop Column start_date;


--doing the same for end_date Column
alter table trip
add end_date_parsed datetime;

update trip
set end_date_parsed = cast(cast(end_date as varchar) as datetime) 

alter table trip
drop column end_date

--test
select duration, (datepart(minute, end_date_parsed) - datepart(minute, start_date_parsed)) as minute_duration
from trip 

------------------------------------------------------------------------------------------------------------------
-- changing the schema of several columns the start_date Column

alter table trip
alter column start_station_name  varchar(max)

alter table trip
alter column end_station_name  varchar(max)

alter table trip
alter column subscription_type  varchar(max)

------------------------------------------------------------------------------------------------------------------
-- checking for duplicates in the trip table
select id, start_station_id, count(*)
from trip
group by id, start_station_id
having COUNT(*) >1


------------------------------------------------------------------------------------------------------------------
--trying Parse as date for weather table date column 
select date , parse(cast(date as varchar) as date USING 'en-US') as date_parsed
from weather

alter table weather
add date_parsed date;

update weather
set date_parsed = parse(cast(date as varchar) as date USING 'en-US')

-- test > get the 
SELECT datename(DW, date_parsed) AS day_of_week
from weather

------------------------------------------------------------------------------------------------------------------
-- replacing zipcode column null values with zero 

select isnull(zip_code,0)
from trip
--where zip_code is null;

------------------------------------------------------------------------------------------------------------------



