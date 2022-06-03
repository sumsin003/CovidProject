use portfolio;

/* Tableau (1) */
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From cde
where continent <> ''
order by 1,2;


/* Tableau (2) */
Select location, SUM(new_deaths) as TotalDeathCount
From cde
Where continent = '' 
and location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc;

/* Tableau (3) */
Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as PercentPopulationInfected
From cde
Group by Location, Population
order by PercentPopulationInfected desc;

/* Tableau (4) */
Select Location, Population, record_date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population)*100) as PercentPopulationInfected
From cde
Group by Location, Population, record_date
order by PercentPopulationInfected desc;
