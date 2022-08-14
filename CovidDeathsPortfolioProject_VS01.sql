SELECT 
  * 
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
WHERE 
  continent is not null
ORDER BY 
  3, 4

SELECT 
  *
FROM
 `my-project001-353008.PortfolioProject.CovidVaccinations` 
WHERE 
  continent is not null
ORDER BY 
  3, 4

##Selecting data for analysis
SELECT 
  location,
  date,
  total_cases, 
  new_cases,
  total_deaths,
  population 
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
WHERE 
  continent is not null
ORDER BY 
  1, 2

##Total cases over total death in Nigeria
SELECT 
  location,
  date,
  total_cases, 
  total_deaths,
  ROUND((total_deaths/total_cases) *100, 2) AS Death_Percentage
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
WHERE 
  location like '%Nigeria%'
and 
  continent is not null
ORDER BY 
  1, 2

##Total cases vs Population
--Percentage of population that got covid
SELECT 
  location,
  date,
  total_cases, 
  population,
  ROUND((total_cases/population) *100, 2) AS Percentage_Population_Infected
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
--WHERE 
  --location like '%Nigeria%'
WHERE 
  continent is not null
ORDER BY 
  1, 2

--Countries with highest infection rate compared to population
SELECT 
  location,
  population,
  MAX(total_cases) AS Highest_infection_Count, 
  ROUND(MAX(total_cases/population) *100, 2) AS Percentage_Population_Infected
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
--WHERE 
  --location like '%Nigeria%'
WHERE 
  continent is not null
GROUP BY
  Location,
  population
ORDER BY 
  Percentage_Population_Infected DESC


--Countries with highest death count per population
SELECT 
  location,
  MAX(total_deaths) AS Total_Death_Count
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
--WHERE 
  --location like '%Nigeria%'
WHERE 
  continent is not null
GROUP BY
  Location
ORDER BY 
  Total_Death_Count DESC

--Breaking down by continent
SELECT 
  location,
  MAX(total_deaths) AS Total_Death_Count
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
--WHERE 
  --location like '%Nigeria%'
WHERE 
  continent is null
GROUP BY
  location
ORDER BY 
  Total_Death_Count DESC

--Continents with the highest death count per population
--view
SELECT 
  continent,
  MAX(total_deaths) AS Total_Death_Count
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
--WHERE 
  --location like '%Nigeria%'
WHERE 
  continent is not null
GROUP BY
  continent
ORDER BY 
  Total_Death_Count DESC

--Global Numbers
SELECT 
  location,
  date,
  total_cases, 
  total_deaths,
  ROUND((total_deaths/total_cases) *100, 2) AS Death_Percentage
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
WHERE
  continent is not null
ORDER BY 
  1, 2

--use for view
SELECT 
  SUM(new_cases) AS total_cases, 
  SUM(new_deaths) AS total_deaths, 
  ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) AS Death_Percentage
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths`
WHERE
  continent is not null
-- GROUP BY
--   date
ORDER BY 
  1, 2

--Total Population Vs Vaccination
WITH PopvsVac AS
(
  SELECT
  dea.continent, 
  dea.location, 
  dea.date, 
  dea.population, 
  Vac.new_vaccinations,
  SUM(Vac.new_vaccinations) OVER (partition by Dea.location order by dea.location, Dea.date) AS Aggregate_People_Vaccinated
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths` Dea
JOIN 
    `my-project001-353008.PortfolioProject.CovidVaccinations` Vac ON
  Dea.location = Vac.location
AND
  Dea.date = Vac.date
WHERE dea.continent is not null
-- ORDER BY
  -- 2, 3
)
SELECT
  *,
  ROUND((Aggregate_People_Vaccinated/population)*100,2)
FROM 
  PopvsVac

##Creating a temp table
DROP TABLE IF EXISTS `my-project001-353008.PortfolioProject.Percent_Population_Vaccinated`;
Create Table `my-project001-353008.PortfolioProject.Percent_Population_Vaccinated`
(
  (`Continent` varchar(255)),
 () `Location` varchar(255)),
  `Date` datetime,
  `Population` numeric,
  `New_vaccinations` numeric,
  `Aggregate_People_Vaccinated` numeric
);

INSERT INTO `Percent_Population_Vaccinated`
SELECT
  dea.continent, 
  dea.location, 
  dea.date, 
  dea.population, 
  Vac.new_vaccinations,
  SUM(Vac.new_vaccinations) OVER (partition by Dea.location order by dea.location, Dea.date) AS Aggregate_People_Vaccinated
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths` Dea
JOIN 
    `my-project001-353008.PortfolioProject.CovidVaccinations` Vac ON
  Dea.location = Vac.location
AND
  Dea.date = Vac.date
WHERE dea.continent is not null
ORDER BY
  2, 3;


SELECT
  *,
  ROUND((Aggregate_People_Vaccinated/population)*100,2)
FROM 
  Aggregate_People_Vaccinated

--Creating views
create view my-project001-353008.PortfolioProject.Percent_Population_Vaccinated as
SELECT
  dea.continent, 
  dea.location, 
  dea.date, 
  dea.population, 
  Vac.new_vaccinations,
  SUM(Vac.new_vaccinations) OVER (partition by Dea.location order by dea.location, Dea.date) AS Aggregate_People_Vaccinated
FROM 
  `my-project001-353008.PortfolioProject.CovidDeaths` Dea
JOIN
    `my-project001-353008.PortfolioProject.CovidVaccinations` Vac ON
  Dea.location = Vac.location
AND
  Dea.date = Vac.date
WHERE dea.continent is not null
ORDER BY
  2, 3;


select * from my-project001-353008.PortfolioProject.Percent_Population_Vaccinated

