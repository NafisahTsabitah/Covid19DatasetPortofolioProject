
--Covid 19 Dataset 

--View Covid Deaths Dataset
Select * From PortofolioProject1..CovidDeaths
order by 3,4

--View Data 
Select continent, location, date, total_cases, new_cases, total_deaths, new_deaths, population 
from PortofolioProject1..CovidDeaths
Where continent is not null
order by 2,3

--View Total Cases and Total Deaths
Select continent, location, date, total_cases, total_deaths, population 
from PortofolioProject1..CovidDeaths
Where continent is not null
order by 2,3

--View Total Cases and Total Deaths in Indonesia
Select continent, location, date, total_cases, total_deaths, population 
from PortofolioProject1..CovidDeaths
Where location like '%nesia'
order by 2,3

--View the Percentage of Dying due to Covid Cases in Indonesia
Select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from PortofolioProject1..CovidDeaths
Where location like '%nesia'
order by 2,3

--View the Percentage of Population Infected by Covid in Indonesia
Select continent, location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage 
from PortofolioProject1..CovidDeaths
Where location like '%nesia'
order by 2,3

----View the Percentage of Population Dying due to Covid in Indonesia
Select continent, location, date, total_deaths, population, (total_deaths/population)*100 as DeathCovidPercentage
from PortofolioProject1..CovidDeaths
Where location like '%nesia'
order by 2,3

--View Global Percentage of Highest Infected compare with Population
Select Location, Population, MAX(total_cases) as InfectedCases, MAX(total_cases/population)*100 as HighestInfectedPercentage
from PortofolioProject1..CovidDeaths
group by location, population
order by 4 desc

--View Global Percentage of Total Deaths compare with Population
Select Location, Population, MAX(CAST(total_deaths as bigint)) as DeathsCount, MAX(total_deaths/population)*100 as DeathCountPercentage
from PortofolioProject1..CovidDeaths
group by location, population
order by 4 desc

--View Continent with the Highest Count of Death
Select Continent, MAX(CAST(total_deaths as bigint)) as DeathsCount
from PortofolioProject1..CovidDeaths
Where continent is not null
group by continent
order by 2 desc

--View Global World Number 
select date, SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as bigint)) as TotalDeaths, SUM(CAST(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage 
from PortofolioProject1..CovidDeaths
Where continent is not null
group by date
order by date

--View Top Global World Number
select SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as bigint)) as TotalDeaths, SUM(CAST(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage 
from PortofolioProject1..CovidDeaths
Where continent is not null
order by 1




--View Covid Vaccinations Dataset
select * from PortofolioProject1..CovidVaccinations

--View Both Tables
select* from
PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date


--View Total Population been Vaccinated
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null
order by 2,3

--View Total Population been Vaccinated in Indonesia
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.location like '%nesia' 
and dt.continent is not null
order by 2,3

--View Total Population been Vaccinated
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null
order by 2,3

--View Percentage of Population had been Vaccinated
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null
order by 2,3


--USE CTE 
with PopVac (Continent,Location, Date, Population, New_vaccinations, PeopleVaccinated) 
as 
(
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null
) 
select*from PopVac

--USE CTE for Calculating Previous Query
with PopVac (Continent,Location, Date, Population, New_vaccinations, PeopleVaccinated) 
as 
(
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null
) 
select*,(PeopleVaccinated/population)*100 as PercentagePeopleVaccinated
from PopVac


--USE CTE for Calculating Previous Query in Indonesia
with PopVac (Continent,Location, Date, Population, New_vaccinations, PeopleVaccinated) 
as 
(
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.location like '%nesia' 
and dt.continent is not null
) 
select*,(PeopleVaccinated/population)*100 as PercentagePopulationVaccinated
from PopVac




--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date

select*,(PeopleVaccinated/population)*100 as PercentagePopulationVaccinated
from #PercentPopulationVaccinated


--View Data for Visualizations

Create View PercentPopVac as
select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, 
SUM(CONVERT(bigint, vc.new_vaccinations)) OVER (partition by dt.location order by dt.location, dt.date) as PeopleVaccinated
from PortofolioProject1..CovidDeaths dt
Join PortofolioProject1..CovidVaccinations vc
	on dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null