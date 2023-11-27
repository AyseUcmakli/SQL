

---- datadan veri gelirken hatali geliyor . virguller yerine nokta yapmak icin kullanildi . 
--DECLARE @tableName NVARCHAR(255)
--DECLARE @sql NVARCHAR(MAX)
--DECLARE @columnName NVARCHAR(255)

--SET @tableName = 'CovidVaccinations' -- Tablo adýný buraya yazýn

--DECLARE column_cursor CURSOR FOR
--SELECT COLUMN_NAME
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = @tableName
--  AND DATA_TYPE IN ('nvarchar', 'varchar') -- Sadece metin türü sütunlari seçiyoruz

--OPEN column_cursor
--FETCH NEXT FROM column_cursor INTO @columnName

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = REPLACE(' + @columnName + ', '','' , ''.'' );'
--    EXEC sp_executesql @sql

--    FETCH NEXT FROM column_cursor INTO @columnName
--END

--CLOSE column_cursor
--DEALLOCATE column_cursor;

---

select *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4
  -- 


--select *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE location = 'Turkey';

---- Select Data that we are going to be using

SELECT location, date, total_cases,new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths

SELECT   location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM     PortfolioProject..CovidDeaths
ORDER BY 1, 2;

--
SELECT   location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM     PortfolioProject..CovidDeaths
WHERE location = 'turkey'--like 'tur'
ORDER BY 1, 2;

--
SELECT   location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM     PortfolioProject..CovidDeaths
WHERE location  like '%states%' 
AND continent is not null
ORDER BY 1, 2;



-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, population,total_cases, (total_cases/population) * 100 as PercentPopulationInfect
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1, 2


--Looking at Countries with Highest Infection Rate Compared to Population
SELECT location, population, max(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Turkey'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

SELECT*
FROM PortfolioProject..CovidDeaths

--Showing Countries with Highest Death Count per Population
SELECT location,  max(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Turkey'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC



--LETS BREAK THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population

SELECT continent,  max(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Turkey'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC



--GLOBAL NUMBERS


SELECT    SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM     PortfolioProject..CovidDeaths
--WHERE location  like '%states%' 
WHERE   continent is not null
--GROUP BY date 
ORDER BY 1, 2;


--Looking at Total Population vs Vaccinations


SELECT dea .continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location =vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--USE CTE

with PopvsVac (continent, location, date,population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea .continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	   --(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location =vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccinated/population)*100
FROM PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

--
SELECT* 
FROM PercentPopulationVaccinated