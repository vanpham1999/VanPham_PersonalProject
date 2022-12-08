
Select*
From PortfolioProject..CovidDeaths
Where continent like '%Asia%'
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent like '%Asia%'
Order by 1,2

--Total cases and total deaths in Asia 
Select Location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as
PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent like '%Asia%'
Order by PercentPopulationInfected

--Looking at Death percentage in Asian countries everyday
Select Location, date, Population, (total_cases)/Population*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent like '%Asia%'
Order by 1,2

--Looking at Highest Infection Rate compared to population in Asian countries
Select Location, Population, MAX(total_cases) as 
HighestInfectionCount, MAX(total_cases/Population)*100 
as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent like '%Asia%'
Group by Location, Population
Order by PercentPopulationInfected desc


--Showing Countries with highest Death Count per Population 
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent like '%Asia%'
group by Location
Order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
Order by TotalDeathCount desc

--Showing continent with the highest 
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
Order by TotalDeathCount desc


-- Look at numbers in North America
Select Location, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null and continent like '%North America%'
group by Location
Order by 1,2

--Look at numbers in Europe
Select Location, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null and continent like '%Europe%'
group by Location
Order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




