/*
 * Covid 19 Data Exploration
 * 
 * Skills used: aggregate functions, temp tables, creating views, joins, CTE
 * 
 */

select * 
from PortfolioProject.CovidDeaths 
order by 3,4;


# Select Data that is going to be used

select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject.CovidDeaths
order by 1,5;


# Total Cases vs Total Deaths
# Shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
from PortfolioProject.CovidDeaths
Where location like '%indIA%' #Checking to see if syntax matters
order by 1,4;


# Total Cases vs Population
# Shows what percentage of population got Covid

select Location, date, population, total_cases, (total_cases/population)*100 as PercentageofPopulationInfected  
from PortfolioProject.CovidDeaths
#Where location like '%india%' 
order by 1,4;


# Countries with Highest Infection Rate compared to Population

select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentageofPopulationInfected  
from PortfolioProject.CovidDeaths
#Where location like '%india%' 
group by Location, Population
order by PercentageofPopulationInfected;


# Countries with Highest Death Count per Population

select Location, max(total_deaths) as TotalDeathCount  
from PortfolioProject.CovidDeaths
where continent != ''
group by Location
order by TotalDeathCount desc;


# BREAKING THINGS DOWN BY CONTINENT

# Showing the continents with the highest deathcount per population

select location, max(total_deaths) as TotalDeathCount  
from PortfolioProject.CovidDeaths
where continent = ''
group by location
order by TotalDeathCount desc;


# Global numbers

select sum(new_cases) as sum_cases , SUM(new_deaths) as sum_deaths, (SUM(new_deaths)/sum(new_cases))*100 as DeathPercentage  
from PortfolioProject.CovidDeaths
where continent != ''
-- group by date
order by 1,2;


# Total Population vs Vaccinations
# Shows percentage of Population that has received at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingValuesPeopleVaccinated 
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent != ''
order by 2,3;


# CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingValuesPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingValuesPeopleVaccinated 
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent != ''
#order by 2,3;
)
Select *, (RollingValuesPeopleVaccinated/Population)*100
From PopvsVac


# TEMP TABLE

DROP Table if exists PortfolioProject.PercentPopulationVaccinated;

Create Temporary Table PortfolioProject.PercentPopulationVaccinated
(
Continent varchar(50),
Location varchar(50),
Date varchar(50),
Population bigint,
New_vaccinations varchar(50),
RollingValuesPeopleVaccinated double
);

Insert into PortfolioProject.PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingValuesPeopleVaccinated 
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
-- where dea.continent != '';
-- order by 2,3;

Select *, (RollingValuesPeopleVaccinated/Population)*100
From PortfolioProject.PercentPopulationVaccinated;


# Creating View to store data for later visualziations

drop view if exists PortfolioProject.PercentPopulationVaccinated;

create view PortfolioProject.PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingValuesPeopleVaccinated 
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent != '';
-- order by 2,3;

select * 
from PortfolioProject.PercentPopulationVaccinated;

