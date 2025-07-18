--DataSet Exploration 
Select * 
from Project_Nashville_Cleaning..Nashville_housing_data


--Changing the Date column from datetime to just date  and dropping the Sale_date column

Alter Table Project_Nashville_Cleaning..Nashville_housing_data
add Sale_date_converted Date;

update Project_Nashville_Cleaning..Nashville_housing_data
set Sale_date_converted = CONVERT (Date, Sale_Date);
 
-- Dropping the Sale_Date Column
Alter Table Project_Nashville_Cleaning..Nashville_housing_data
drop Column Sale_Date;

select 
--Sale_Date, 
Sale_date_converted
from Project_Nashville_Cleaning..Nashville_housing_data;
---------------------------------------------------------------------------------------------------------------------------


--Removing Duplicate rows from Parcel_Id column in the Table

select Parcel_ID, Property_Address, Count(*)
from Project_Nashville_Cleaning..Nashville_housing_data
where Property_Address is Null
group by Parcel_ID, Property_Address
Having Count(*) > 1
order by Parcel_ID
;

with t as (
select Parcel_ID, Property_Address, 
Row_Number() over(Partition by Parcel_ID, Property_Address order by Parcel_ID) as Duplicate_count
from Project_Nashville_Cleaning..Nashville_housing_data
where Property_Address is Null) 

delete from t
where Duplicate_count >1;

---------------------------------------------------------------------------------------------------------------------------
-- Breaking Owner Name into First and Last_Name 
Select 
Owner_Name,
Trim(',' from Left(Owner_Name, CHARINDEX(',', Owner_Name))) as Last_Name,
Trim(SUBSTRING(Owner_Name,CHARINDEX(',', Owner_Name) +1, Len(Owner_Name))) as First_Name
from Project_Nashville_Cleaning..Nashville_housing_data

---------------------------------------------------------------------------------------------------------------------------
--Concating Address with City and State
Select CONCAT(Address, ',', City, ',', State) as whole_address
from Project_Nashville_Cleaning..Nashville_housing_data


---------------------------------------------------------------------------------------------------------------------------

-- Replacing Null Values in Land_Value
select Count(*)--Land_Value
from Project_Nashville_Cleaning..Nashville_housing_data
where Land_Value is Null 


select Coalesce(Land_Value, 0)
from Project_Nashville_Cleaning..Nashville_housing_data
--group by Land_Value

--or

Select ISNULL(Land_Value, 0)
from Project_Nashville_Cleaning..Nashville_housing_data


-- or

update Project_Nashville_Cleaning..Nashville_housing_data
set Land_Value = 0
where Land_Value is Null

--Test
Select Land_Value
from Project_Nashville_Cleaning..Nashville_housing_data
--where Land_Value is null
