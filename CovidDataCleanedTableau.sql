/*
 * Covid 19 Data Exploration
 * 
 * Skills used: aggregate functions, temp tables, creating views, joins, CTE
 * 
 */

select * 
from PortfolioProjectWin.CovidDeaths 
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
from PortfolioProjectWin.CovidDeaths
where continent is not null
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


# On average how many new cases is each country seeing everyday

select Location, SUM(new_cases)/COUNT(new_cases) as AvgNumberofNewCasesEveryday   
from PortfolioProjectWin.CovidDeaths
group by Location
order by Location;


# Reproduction rate being affected in any way?

/*
 This might be difficult to analyse because we would also need data of pre-covid to see how the reproduction rates were and then
 analyse how the reproduction rates were during covid to be able to say if there is effect on reproduction due to covid. 
 But because the dataset here is from 2020 to 2024, we can still perform analysis with post-covid data as covid waves died after 2022.
 There's still the issue that reproduction rates could be affected due to several other factors as well and it could have 
 just coincided during covid. 
 
 For the purpose of this analysis, let's assume other factors had a relatively negligible influence.
*/

# Covid was at it's peak from 2020 to beginning of 2022

select Location, SUM(reproduction_rate)/COUNT(reproduction_rate) as AvgReproductionRate   
from PortfolioProjectWin.CovidDeaths
where SUBSTRING(date, -4) IN ('2020', '2021') and location in ('India', 'United States'
, 'United Kingdom', 'China', 'France', 'Germany') -- continent = ''
group by Location
order by AvgReproductionRate;


# Covid had come down dramatically from 2022

select Location, SUM(reproduction_rate)/COUNT(reproduction_rate) as AvgReproductionRate   
from PortfolioProjectWin.CovidDeaths
where SUBSTRING(date, -4) IN ('2022', '2023', '2024') and location in ('India', 'United States'
, 'United Kingdom', 'China', 'France', 'Germany') -- continent = ''
group by Location
order by AvgReproductionRate;

/*
 For whole world, it looks like reproduction rates were higher during covid than post covid. This could be due to being in lockdown
 most of the time. Everyone were always home, reproduction rates may have gone up because of that.

 Even when we observe country wise, it shows the same trend.
*/


# No. of icu patients being added everyday in a country 
# (this can give hospitals an idea for how much arrangement they need to make to handle the increasing no.of ICU patients)

select Location, SUM(icu_patients)/COUNT(icu_patients) as AvgNoOfNewICUPatientsEveryday    
from PortfolioProjectWin.CovidDeaths
where SUBSTRING(date, -4) IN ('2020', '2021') and icu_patients != ''
group by Location
order by AvgNoOfNewICUPatientsEveryday;


