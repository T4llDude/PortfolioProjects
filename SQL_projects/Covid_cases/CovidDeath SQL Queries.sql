USE [PortfolioProjectCovidDeaths]
GO

SELECT *
  FROM [dbo].[CovidDeaths]
  ORDER BY 3, 4

--SELECT *
--  FROM [dbo].[CovidVaccinations]
--  ORDER BY 3, 4



--Select data that we will use:
SELECT 
[location],
[date], 
[total_cases], 
[new_cases], 
[total_deaths], 
[population]
FROM [dbo].[CovidDeaths]
ORDER BY 1,2

--Look at Total Cases vs Total Deaths 
DROP TABLE IF EXISTS #Table1;

SELECT 
[location],
[date], 
CAST([total_cases] as FLOAT) as 'TotalCases', 
CAST([total_deaths] as FLOAT) as 'TotalDeaths'
INTO #Table1
FROM [dbo].[CovidDeaths]
ORDER BY 1,2

--Liklihood of death if contracted Covid.
SELECT 
[location],
[date],
[TotalCases],
[TotalDeaths],
([TotalDeaths]/[TotalCases])*100 as 'Death %'
FROM #Table1
WHERE location = 'United States'
ORDER BY 1,2

------------------------------------------------------------------
--Look at Total Cases vs Population
--Show what percentage of population got Covid.
DROP TABLE IF EXISTS #Table2;

SELECT 
[location],
[date], 
CAST([total_cases] as FLOAT) as 'TotalCases', 
[population]
INTO #Table2
FROM [dbo].[CovidDeaths]
WHERE location = 'United States'
ORDER BY 1,2

SELECT 
[location],
[date], 
[population],
TotalCases, 
([TotalCases]/[population])*100 as 'PopulationContracted%'
FROM #Table2
--WHERE location = 'United States'
ORDER BY 1,2

------------------------------------------------------------------

--Look at Countries with highest infection rate compared to population
DROP TABLE IF EXISTS #Table3;

SELECT 
[location],
[date], 
CAST([total_cases] as FLOAT) as 'TotalCases', 
[population]
INTO #Table3
FROM [dbo].[CovidDeaths]
--WHERE location = 'United States'
ORDER BY 1,2

SELECT 
[location],
[population],
MAX(TotalCases) as 'HighestInfectionCount', 
MAX(([TotalCases]/[population])*100) as 'PercentPopulationInfected'
FROM #Table3
GROUP BY location, population
ORDER BY 4 DESC

----------------------------------------------------------------------------------

--Show countries with higest death count.

DROP TABLE IF EXISTS #Table4;

SELECT 
[location],
CAST([total_deaths] as INT) as 'Total_Deaths'
INTO #Table4
FROM [dbo].[CovidDeaths]
WHERE [continent] IS NOT NULL
ORDER BY 1,2

SELECT 
[location],
MAX([Total_Deaths]) as 'Total Death Count'
FROM #Table4
GROUP BY [location] 
ORDER BY 2 DESC

----------------------------------------------------------------------------------

--Show Continents with highest death count.

SELECT 
location,
MAX(CAST([total_deaths] as INT)) as 'Total_Deaths'
FROM [dbo].[CovidDeaths]
WHERE [continent] IS NULL
AND [location] NOT IN ('Low income', 'Upper middle income', 'Lower middle income', 'High income')
GROUP BY [location]
ORDER BY 'Total_Deaths' DESC

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

--Global Metrics
DROP TABLE IF EXISTS #Table5;

--Death Percentage by Date - Globally
SELECT 
[date] ,
SUM(CAST([new_cases] as FLOAT)) as 'Total New Cases',
SUM(CAST(new_deaths as FLOAT)) as 'Total New Deaths'
--SUM(new_cases)/SUM(CAST(new_deaths as INT))*100
INTO #Table5 
FROM dbo.CovidDeaths
WHERE [continent] is not null
GROUP BY [Date] 
ORDER BY 1,2

SELECT 
[date],
[Total New Cases],
[Total New Deaths],
[Total New Deaths]/[Total New Cases]*100 as 'Global Death %'
FROm #Table5
WHERE ([Total New Deaths] <> 0
AND [Total New Cases] <> 0)
ORDER BY Date

---------------------------------------------------------------------
--Death Percentage Overall - Globally
DROP TABLE IF EXISTS #Table6;


SELECT 
SUM(CAST([new_cases] as FLOAT)) as 'Total New Cases',
SUM(CAST(new_deaths as FLOAT)) as 'Total New Deaths'
--SUM(new_cases)/SUM(CAST(new_deaths as INT))*100
INTO #Table6 
FROM dbo.CovidDeaths
WHERE [continent] is not null
--GROUP BY [Date] 
ORDER BY 1,2

SELECT 
[Total New Cases],
[Total New Deaths],
[Total New Deaths]/[Total New Cases]*100 as 'Global Death %'
FROm #Table6

---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

--Total Population vs Total Vaccination
--Temp table
DROP TABLE IF EXISTS #Table7;

SELECT 
cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cv.location ORDER BY cv.location, cv.date) as 'Running Total Vaccinations'
INTO #Table7
FROM dbo.CovidVaccinations cv
JOIN dbo.CovidDeaths cd ON cd.iso_code = cv.iso_code
	AND cd.location = cv.location
		AND cd.date = cv.date
WHERE cd.continent is not null
--AND new_vaccinations is not null
ORDER BY 2, 3

SELECT 
continent
,location
,date
,population
,new_vaccinations
,[Running Total Vaccinations]
,([Running Total Vaccinations]/population)*100 as '% of Population Vaccinated'
FROM #Table7;
-------------------------------------------------------------------------------------------------

--CTE
WITH PopVSVac (Continent, Location, Date, Population, New_Vaccinations, [Running Total Vaccinations])
AS
(
SELECT 
cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cv.location ORDER BY cv.location, cv.date) as 'Running Total Vaccinations'

FROM dbo.CovidVaccinations cv
JOIN dbo.CovidDeaths cd ON cd.iso_code = cv.iso_code
	AND cd.location = cv.location
		AND cd.date = cv.date
WHERE cd.continent is not null
--AND new_vaccinations is not null
)
SELECT 
Continent,
Location,
Population,
ISNULL(MAX(([Running Total Vaccinations]/Population)*100), 0) as '% of of Population Vaccinated'
FROM PopVSVac
GROUP BY Continent,
Location,
Population
ORDER BY 1, 2


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

--Create views for Visualizations
CREATE VIEW PercentPopulationVaccinated AS 
WITH PopVSVac (Continent, Location, Date, Population, New_Vaccinations, [Running Total Vaccinations])
AS
(
SELECT 
cd.continent, 
cd.location, 
cd.date, 
cd.population, 
cv.new_vaccinations,
SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cv.location ORDER BY cv.location, cv.date) as 'Running Total Vaccinations'

FROM dbo.CovidVaccinations cv
JOIN dbo.CovidDeaths cd ON cd.iso_code = cv.iso_code
	AND cd.location = cv.location
		AND cd.date = cv.date
WHERE cd.continent is not null
--AND new_vaccinations is not null
)
SELECT 
Continent,
Location,
Population,
ISNULL(MAX(([Running Total Vaccinations]/Population)*100), 0) as '% of of Population Vaccinated'
FROM PopVSVac
GROUP BY Continent,
Location,
Population

----------------------------------------------------------------------------------------------------

--Continent with Highest Death Count 
CREATE VIEW ContinentHighDeathCnt
as
SELECT 
location,
MAX(CAST([total_deaths] as INT)) as 'Total_Deaths'
FROM [dbo].[CovidDeaths]
WHERE [continent] IS NULL
AND [location] NOT IN ('Low income', 'Upper middle income', 'Lower middle income', 'High income')
GROUP BY [location]
--ORDER BY 'Total_Deaths' DESC


----------------------------------------------------------------------------------------------------

--Countries with Highest Death Count 

CREATE VIEW CountriesHighDeathCnt 
AS

WITH CountryHighDeathCnt AS
(SELECT 
[location],
CAST([total_deaths] as INT) as 'Total_Deaths'
FROM [dbo].[CovidDeaths]
WHERE [continent] IS NOT NULL
)
SELECT 
[location],
MAX([Total_Deaths]) as 'Total Death Count'
FROM CountryHighDeathCnt
GROUP BY [location] 


----------------------------------------------------------------------------------------------------

--Liklihood of death if Infected

CREATE VIEW DeathIfInfected as 

WITH DeathIfInfected 
AS 
(
SELECT 
[location],
[date], 
CAST([total_cases] as FLOAT) as 'TotalCases', 
CAST([total_deaths] as FLOAT) as 'TotalDeaths'
FROM [dbo].[CovidDeaths]
)
--Liklihood of death if contracted Covid in USA.
SELECT 
[location],
[date],
[TotalCases],
[TotalDeaths],
([TotalDeaths]/[TotalCases])*100 as 'Death %'
FROM DeathIfInfected
--WHERE location = 'United States'


----------------------------------------------------------------------------------------------------
