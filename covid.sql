create database portfolio ;

use portfolio;


-- creating table covid_deaths
drop table covid_vaccination ;
create table covid_deaths (
Iso_code varchar(50),
continent  varchar(50),
location varchar(50),
date DATE ,
population int(50),
total_cases  int(50),
new_cases  int(50),
new_cases_smoothed float(10,4),
total_deaths int(50),
new_deaths int(50),
new_deaths_smoothed  float(10,4),
total_cases_per_million float(10,4),
new_cases_per_million float(10,4),
new_cases_smoothed_per_million float(10,4),
total_deaths_per_million float(10,4),
new_deaths_per_million float(10,4),
new_deaths_smoothed_per_million float(10,4),
reproduction_rate float(10,4),
icu_patients float(10,4),
icu_patients_per_million float(10,4),
hosp_patients float(10,4),
hosp_patients_per_million float(10,4),
weekly_icu_admissions float(10,4),
weekly_icu_admissions_per_million float(10,4),
weekly_hosp_admissions float(50),
weekly_hosp_admissions_per_million float(50)
);

-- creating table covid_vaccination


create table covid_vaccination (
iso_code varchar(50),
continent varchar(50),
location varchar(50),
date Date,
new_tests int (50),
total_tests_per_thousand float(10,3),
new_tests_per_thousand  float(10,3),
new_tests_smoothed int(50),
new_tests_smoothed_per_thousand  float(10,4),
positive_rate  float(10,4),
tests_per_case  float(10,1),
tests_units varchar(50),
total_vaccinations int(50),
people_vaccinated int(50),
people_fully_vaccinated int(50),
total_boosters int(50),
new_vaccinations int(50),
new_vaccinations_smoothed int(50),
total_vaccinations_per_hundred float(10,2) ,
people_vaccinated_per_hundred float(10,2),
people_fully_vaccinated_per_hundred float(10,2),
total_boosters_per_hundred int(50),
new_vaccinations_smoothed_per_million int(50),
new_people_vaccinated_smoothed int(50),
new_people_vaccinated_smoothed_per_hundred float(10,3),
stringency_index float(10,2),
population_density float(10,3),
median_age float(10,2),
aged_65_older float(10,3),
aged_70_older float(10,3),
gdp_per_capita float(10,3),
extreme_poverty float(10,1),
cardiovasc_death_rate float(10,3),
diabetes_prevalence float(10,1),
female_smokers float(10,1),
male_smokers float(10,2),
handwashing_facilities float(10,3),
hospital_beds_per_thousand int(50),
life_expectancy float(10,2),
human_development_index float(10,3),
excess_mortality_cumulative_absolute float(10,4),
excess_mortality_cumulative float(10,2),
excess_mortality float(10,2),
excess_mortality_cumulative_per_million float(10,5)
);

-- setting local_infile on

Show  variables like "local_infile";
set global local_infile = 1;

-- importing data into covid_deaths

LOAD DATA  LOCAL INFILE '/Users/darshanpatel/Desktop/covid project /covid_deaths.csv'
INTO TABLE covid_deaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
  
-- importing data into covid_vaccination

LOAD DATA  LOCAL INFILE '/Users/darshanpatel/Desktop/covid project /covid_vaccination.csv'
INTO TABLE covid_vaccination
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--
select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths ;



--  total cases vs total deaths in india and pakistan

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS Deathpercentage
FROM
    covid_deaths
WHERE
    location LIKE '%india%'
        OR location LIKE '%pakistan%'
ORDER BY 1 , 2 ;

-- total cases vs population in inida and pakistan where date is >= 2021
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS percentage_of_population
FROM
    covid_deaths
WHERE
    (location LIKE '%india%'
        OR location LIKE '%pakistan%')
        AND date >= '2021-01-08'
ORDER BY 1 , 2;

-- countries with total number of cases 
SELECT 
    location, MAX(total_cases) AS Highest_infection_count
FROM
    covid_deaths
GROUP BY location , population
ORDER BY Highest_infection_count DESC;


-- countries with the higest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS Highest_infection_count,
    MAX(total_cases / population) * 100 AS percentage_population_infected
FROM
    covid_deaths
GROUP BY location , population
ORDER BY percentage_population_infected DESC;

-- countries with total number of deaths
SELECT 
    location, MAX(total_deaths) AS total_death_count
FROM
    covid_deaths
GROUP BY location
ORDER BY total_death_count DESC;

-- countries with the higest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_deaths) AS total_death_count,
    MAX(total_deaths / population) * 100 AS percentage_population_died
FROM
    covid_deaths
GROUP BY location , population
ORDER BY percentage_population_died DESC;

-- global number 
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS Death_percentage
FROM
    covid_deaths
GROUP BY date
ORDER BY 1 , 2; 

-- new vaccination per population in india 
with  vaccination (continent, location, date, population, new_vaccinations, new_vaccinated_per_population, Total_vaccination )
as
(SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    (vac.new_vaccinations / dea.population) * 100 AS new_vac_per_pop,
    sum(vac.new_vaccinations) over (partition by dea.location order by 
    dea.location, dea.date) as total_vaccination
FROM
    covid_deaths dea
        JOIN
    covid_vaccination vac ON dea.location = vac.location
        AND dea.date = vac.date
)
select  *,(total_vaccination/population)*100 as total_vac_per_pop
from 
vaccination
where location like '%india%'
order by date desc limit 5;

-- create for view for result for new vaccination per population 

create view new_vaccination_per_population_india as
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    (vac.new_vaccinations / dea.population) * 100 AS new_vac_per_pop,
    sum(vac.new_vaccinations) over (partition by dea.location order by 
    dea.location, dea.date) as total_vaccination
FROM
    covid_deaths dea
        JOIN
    covid_vaccination vac ON dea.location = vac.location
        AND dea.date = vac.date ;


















     
    







