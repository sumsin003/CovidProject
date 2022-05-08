use portfolio;

select * from cde;
select * from cva;

/* select data to use */

SELECT 
    location,
    record_date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    cde
order by
	1,2;

/* total cases vs total deaths */
/* shows likelihood of dying if you contact covid in the country */

SELECT 
    location,
    record_date,
    total_cases,
    total_deaths,
	(total_deaths/total_cases)*100 as Mortality_Rate
FROM
    cde
order by
	1,2;

/* Looking total cases vs population */

SELECT 
    location,
    record_date,
	population,
    total_cases,
	(total_cases/population)*100 as PercentPopulation
FROM
    cde
order by
	1,2;

/* countries with highest infection rate */

SELECT 
    location,
	population,
    max(total_cases) as Highest_Infection_Count,
	max((total_cases/population)*100) as PercentPopulation
FROM
    cde
group by
	location, population
order by
	PercentPopulation DESC;

/* countries with highest death count per population */

SELECT 
    location,
    max(total_deaths) as Highest_Deaths
FROM
    cde
where
	continent <> ''
group by
	location
order by
	Highest_Deaths DESC;

/* group by continent */

select * from cde
where continent = '';

SELECT 
    continent,
    max(total_deaths) as Highest_Deaths
FROM
    cde
where
	continent <> ''
group by
	continent
order by
	Highest_Deaths DESC;

/* showing continents with highest death count */

SELECT 
    location,
    max(total_deaths) as Highest_Deaths
FROM
    cde
where
	continent = ''
group by
	location
order by
	Highest_Deaths DESC;

/* global numbers */

SELECT 
    record_date,
    sum(new_cases) as total_cases,
	sum(new_deaths) as total_deaths,
    sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
FROM
    cde
where
	continent <> ''
group by
	record_date
order by
	1,2;

/* covid vaccinations table */

select * from cva;

/* join cde and cva */

SELECT 
    *
FROM
    cde
        JOIN
    cva ON cde.location = cva.location
        AND cde.record_date = cva.record_date;

/* total population vs vaccinated population */

SELECT 
    cde.continent,
    cde.location,
    cde.record_date,
    cde.population,
    cva.new_vaccinations,
    (cva.new_vaccinations/cde.population)*100 as PercentVaccinated
FROM
    cde
        JOIN
    cva ON cde.location = cva.location
        AND cde.record_date = cva.record_date
where
	cde.continent <> ''
order by
	2,3;

/* summing total vaccinations (1st & 2nd) done */

SELECT 
    cde.continent,
    cde.location,
    cde.record_date,
    cde.population,
    cva.new_vaccinations,
    (sum(cva.new_vaccinations) over (partition by cde.location order by cde.location, cde.record_date)) as cumRollingPeople_Vaccinated
From
    cde
        JOIN
    cva ON cde.location = cva.location
        AND cde.record_date = cva.record_date
where
	cde.continent <> ''
order by
	2,3;
    
    
/* rollingpeople divide by population */

with PopVsVac (Continent, Location, record_date, Population, new_vaccinations, cumRollingPeople_Vaccinated)
as
(
SELECT 
    cde.continent,
    cde.location,
    cde.record_date,
    cde.population,
    cva.new_vaccinations,
    (sum(cva.new_vaccinations) over (partition by cde.location order by cde.location, cde.record_date)) as cumRollingPeople_Vaccinated
From
    cde
        JOIN
    cva ON cde.location = cva.location
        AND cde.record_date = cva.record_date
where
	cde.continent <> ''
    and cde.location = 'India'
order by
	2,3
)
select * , (cumRollingPeople_Vaccinated/Population)*100 as Total_Vaccinated_Percent
from PopVsVac;


/* views to store data for visualization */

drop view Popvsvac;
create view VPopVsVac as
SELECT 
    cde.continent,
    cde.location,
    cde.record_date,
    cde.population,
    cva.new_vaccinations,
    (sum(cva.new_vaccinations) over (partition by cde.location order by cde.location, cde.record_date)) as cumRollingPeople_Vaccinated
From
    cde
        JOIN
    cva ON cde.location = cva.location
        AND cde.record_date = cva.record_date
where
	cde.continent <> '';

select * from portfolio.vpopvsvac;
