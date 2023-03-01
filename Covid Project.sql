select *
from dbo.CovidDeaths

--This shows the total Covid cases and deaths in Africa, it also includes their dates.

select continent, location, total_cases, total_deaths, date
from dbo.CovidDeaths
where continent like 'Africa'

--Cases narrowed down to Nigeria.

select location, date, total_cases, total_deaths
from dbo.CovidDeaths
where location like 'Nigeria'
order by 1,2

--looking at total cases verse total deaths(Death Percentage)

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from dbo.CovidDeaths
where location like 'Nigeria' 

--total cases vs population

select location, total_cases, population, (total_cases/population)*100 as CasePercentage
from dbo.CovidDeaths
where location like 'Nigeria' 

--countries with the highest infection rate compared to their population, in descending order.(Africa)
--from the query below, it's observed that South Africa had the highest infection count, while Tanxzania had the lowest infection count.

select continent, location, population, max(total_cases) as HighestInfectionCount
from dbo.CovidDeaths
where continent like 'Africa' 
group by continent, location, population
order by  HighestInfectionCount desc

--The death count however, wasn't same as the infection count, as Egypt takes the lead with a count of 9,994, while Burundi records the lowest death count at 9.

select continent, location, population, max(total_deaths) as HighestDeathCount
from dbo.CovidDeaths
where continent like 'Africa' 
group by continent, location, population
order by  HighestDeathCount desc

--Away from Africa, highest death count on a global scale. This excludes locations with zero recordings.

select location, Max(cast(total_deaths as int)) as DeathCount
from dbo.CovidDeaths
WHERE total_deaths is not null
group by location
order by DeathCount desc

--The locations below didn't record any deaths within the period covered in this data.

select location, total_deaths
from dbo.CovidDeaths
where total_deaths is null

--Total population vs vaccinations. There's an existing pattern of less vaccinations at the beginning of Covid, and more vaccinations towards the end of 2021. This means that, more vaccinations were done as Covid began to spread. Inotherwords, the wider the spread,, the more vaccinations were done.

select Dts.location, Dts.population, Vac.total_vaccinations, Dts.date
from dbo.CovidDeaths Dts
join dbo.CovidVaccinations Vac
on Dts.location = Vac.location
	and Dts.date = Vac.date
where Vac.total_vaccinations is not null and Dts.population is not null
order by 1

--Global numbers

select sum(new_cases) as tot_cases, sum(cast(new_deaths as int)) as tot_deaths, sum(cast
	(new_deaths as int))/sum(new_cases)*100 as deathgpercentage
from dbo.CovidDeaths
where continent is not null
order by 1,2

--Continents with hughest death counts per population

select continent, max(cast(total_deaths as int)) as tot_death_count
from dbo.CovidDeaths
where continent is not null
group by continent
order by tot_death_count desc

--View created for visualization

create view HighestInfectionRate as
select continent, location, population, max(total_cases) as HighestInfectionCount
from dbo.CovidDeaths
where continent like 'Africa' 
group by continent, location, population
--order by  HighestInfectionCount desc