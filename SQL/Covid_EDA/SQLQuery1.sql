select *
from Portfolio_Project..Covid_deaths
order by 1,2

select * 
from Portfolio_Project..Covid_Vaccination

--selecting data that we are going to work with
select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project..covid_data
order by 1,2

-- Total cases Vs total_deaths or be specific with a country(interesting for a viz)
select location, date, total_cases, total_deaths, concat(round((total_deaths/total_cases)*100,3),' %') as Total_death_Percentage
from Portfolio_Project..covid_data
--where location like '%egypt%'
order by 5 desc


-- Total cases Vs population(also good for a viz)
select location, date, total_cases, population, round((total_cases/population)*100,3) as Total_death_Percentage
from Portfolio_Project..covid_data
--where location like '%egypt%'
order by 1,2

-- Countries where infection is highest
select location, population, MAX(total_cases) as highest_count_infected
from Portfolio_Project..covid_data
group by location, population
order by 3 desc

-- Countries where infection is highest and % per population(View for Geo-viz )
select location, population, MAX(total_cases) as highest_count_infected, max((total_cases/population)*100) as "%_cases_per_population"
from Portfolio_Project..covid_data
where continent is not null
group by location, population
order by 3 desc

-- Surge of New Cases by Date

 select location, MAX(cast(new_cases as int)) as highest_new_cases_count
 from Portfolio_Project..covid_data
 where continent is not null
 group by location, date 
 order by 2 desc
 

 -- countries with highest death count 

select location, MAX(cast(total_deaths as int)) as total_death_count
from Portfolio_Project..covid_data
where continent is not null
group by location
order by 2 desc



-- highest continent total death count
select location, MAX(cast(total_deaths as int)) as total_death_count
from Portfolio_Project..covid_data
where continent is null
group by location
order by 2 desc

-- Global numbers
select date, sum(new_cases) total_new_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/(sum(new_cases)+ 0.1)*100 as "total_death_%"
from Portfolio_Project..covid_data
where continent is null
group by date
order by 1, 2

-- total people vaccinated vs their population untill May 6t 2021

select dat.location, dat.population, 
	max(cast(vac.total_vaccinations as int))as total_vaccinated,
	round(max(cast(vac.total_vaccinations as int))/dat.population*100, 2) "%_vaccinated"
from Portfolio_Project..covid_data dat
join
Portfolio_Project..Covid_Vaccination vac
on
dat.location = vac.location
and dat.date = vac.date
where dat.continent is not null
and vac.new_vaccinations is not null
group by  dat.location, dat.population
order by 4 desc


--Using CTE for cumulative vaccinated count

with PopVsVac (continent, location, date, population, new_vaccinations, cumulative_vaccinations)
as
(
select dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dat.location order by dat.date, dat.location) as cumulative_vaccinations
from Portfolio_Project..covid_data dat
join
Portfolio_Project..Covid_Vaccination vac
on
dat.location = vac.location
and dat.date = vac.date
where dat.continent is not null
)
select * 
from
	PopVsVac


-- creating a Temp table

Drop table if exists #PopVsVac
create table #PopVsVac
(
continent nvarchar(255),
 location nvarchar(255),
 date Datetime,
 population numeric,
 new_vaccinations numeric,
 cumulative_vaccinations numeric
 )
 insert into #PopVsVac
 select dat.continent, dat.location, dat.date, dat.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dat.location order by dat.date, dat.location) as cumulative_vaccinations
from Portfolio_Project..covid_data dat
join
Portfolio_Project..Covid_Vaccination vac
on
dat.location = vac.location
and dat.date = vac.date
where dat.continent is not null

select *
from #PopVsVac

--Creating a View
Create view PercentCasesPerpop as
select location, population, MAX(total_cases) as highest_count_infected, max((total_cases/population)*100) as "%_cases_per_population"
from Portfolio_Project..covid_data
where continent is not null
group by location, population
--order by 3 desc

select *
from PercentCasesPerpop
