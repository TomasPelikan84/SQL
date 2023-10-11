SELECT
country ,national_dish 
FROM countries
WHERE region_in_world = 'Eastern Europe';


SELECT 
country, currency_code, currency_name  
FROM countries
WHERE lower(currency_name) LIKE ('%dollar%');

SELECT 
country ,currency_name 
FROM countries 
WHERE currency_name LIKE '%US Dollar%';

SELECT * 
FROM countries
WHERE lower(abbreviation) != SUBSTRING(domain_tld, 2, 2); 


SELECT
	country , capital_city 
FROM countries
WHERE capital_city LIKE '% %';

SELECT
country ,independence_date 
FROM countries 
WHERE independence_date IS NOT NULL AND religion = 'Christianity'
ORDER BY independence_date;

SELECT 
country ,elevation , yearly_average_temperature, population, population_density  
FROM countries
WHERE elevation > 2000 OR 
	yearly_average_temperature < 5 OR yearly_average_temperature > 25 
	OR	(population > 10000000 AND population_density  > 1000); 

CREATE VIEW v_tomas_pelikan_hostile_countries as
SELECT 
country ,elevation , yearly_average_temperature, population, population_density,
	IF ( elevation > 2000, 1, 0) AS mountainous,
	IF ( yearly_average_temperature < 5, 1, 0) AS cold_weather,
	IF ( yearly_average_temperature > 25, 1, 0) AS hot_weather,
	IF ( population > 10000000 AND population_density > 1000, 1, 0) AS overpopulated
FROM countries
WHERE elevation > 2000 OR 
	yearly_average_temperature < 5 OR yearly_average_temperature > 25 
	OR	(population > 10000000 AND population_density  > 1000);


SELECT *
FROM v_tomas_pelikan_hostile_countries
WHERE mountainous + cold_weather + hot_weather + overpopulated > 1;

SELECT
country , life_expectancy 
FROM countries 
WHERE life_expectancy IS NOT NULL  
ORDER BY life_expectancy;


SELECT vlec.*,
	life_expectancy_2019 - life_expectancy_1950 AS life_expectancy_differ 
FROM v_life_expectancy_comparison vlec
ORDER BY life_expectancy_2019 - life_expectancy_1950 DESC ;

SELECT vlec.*,
	life_expectancy_2019 - life_expectancy_1950 AS life_expectancy_differ 
FROM v_life_expectancy_comparison vlec
WHERE country IN ('Zambia', 'Malawi', 'Mozambique', 'Angola', 'Zimbabwe');

SELECT 
country ,independence_date 
FROM countries
WHERE independence_date < 1500;

SELECT
country ,national_symbol 
FROM countries
WHERE national_symbol != 'animal' OR national_symbol IS null;

SELECT 
country ,religion 
FROM countries
WHERE religion != 'Islam' AND  religion != 'Christianity'; 

SELECT 
country ,currency_name ,religion 
FROM countries
WHERE currency_name = 'Euro' AND religion != 'Christianity';

SELECT 
country , capital_city , religion , yearly_average_temperature 
FROM countries 
WHERE yearly_average_temperature < 0 OR yearly_average_temperature > 30;

SELECT 
country , capital_city , independence_date 
FROM countries
WHERE independence_date > 1800 AND independence_date < 1900
ORDER BY independence_date ;


SELECT 
country , population, surface_area , population_density,
	round (population / surface_area , 2)  AS population_density2, 
	round (population_density , 2 ) AS population_density, 
	abs ( round( population / surface_area , 2) - ROUND( population_density , 2 )) AS diff
FROM countries ;

SELECT 
country ,yearly_average_temperature,
	(1.8 * yearly_average_temperature) + 32 AS farnhait 
FROM countries ;

SELECT 
country , yearly_average_temperature,
	CASE 
		WHEN yearly_average_temperature IS NULL THEN '---not definet---'
		WHEN yearly_average_temperature < 0 THEN 'freezing' 
		WHEN yearly_average_temperature < 10 THEN 'chilly'
		WHEN yearly_average_temperature < 20 THEN 'mild'
		WHEN yearly_average_temperature < 30 THEN 'warm'
		ELSE 'scorching'
	END AS climate
FROM countries ;

SELECT
country, north ,south,
	CASE 
		WHEN north > 1 THEN 'north'
		WHEN north < -1 THEN 'south'
		WHEN north >= -1 AND north <= 1 THEN 'equator'
		END	AS N_S_hemisphere
FROM countries


-- COVID 19 cviceni

-- Ukol 1

SELECT
country ,date, confirmed 
FROM covid19_basic
WHERE country = 'Austria'
ORDER BY date DESC ; 

-- Ukol 2
SELECT 
country ,deaths 
FROM covid19_basic
WHERE country = 'Czechia';

-- Ukol 3
SELECT 
deaths 
FROM covid19_basic
WHERE country = 'Czechia'
ORDER BY date DESC ;

-- Ukol 4
SELECT sum(confirmed)
FROM covid19_basic
WHERE date = '2020-08-31'; 

-- Ukol 5
SELECT DISTINCT  
 province 
FROM covid19_detail_us
ORDER BY province DESC ; 

-- Ukol 6
SELECT 
country ,recovered ,confirmed, 
	recovered - confirmed AS differ
FROM covid19_basic 
WHERE country = 'Czechia'
ORDER BY date;

-- Ukol 7
SELECT *
FROM covid19_basic_differences 
WHERE date = '2020-07-01'
ORDER BY confirmed DESC 
LIMIT 10;

-- Ukol 8
SELECT *,
	CASE 
		WHEN confirmed > 10000 THEN 1
		ELSE 0
	END	AS amount_confirmed
FROM covid19_basic_differences 
WHERE date = '2020-08-30'
ORDER BY confirmed DESC ; 

-- Ukol 9
SELECT *
FROM covid19_detail_us 
ORDER BY date desc;

SELECT *
FROM covid19_detail_us 
ORDER BY date;

-- Ukol 10
SELECT *
FROM covid19_basic 
ORDER BY country, date desc;

-- Covid-19: Case expression 
-- Ukol 1
SELECT *,
	CASE 
		WHEN confirmed > 10000 THEN 1
		ELSE 0
	END	AS flag_vic_nez_10000
FROM covid19_basic
WHERE date = '2020-08-30'
ORDER BY confirmed DESC ;

-- Ukol 2

SELECT *,
	CASE 
		WHEN country IN ('Spain', 'France', 'Germany') THEN 'Evropa'
		ELSE 'Ostatni'
	END	AS flag_Evropa
FROM covid19_basic; 
-- WHERE country IN ('Spain', 'France', 'Germany');

-- Ukol 3
SELECT *,
	CASE 
		WHEN country LIKE 'Ge%' THEN 'GE zeme'
		ELSE 'Ostatni'
	END AS flag_GE	
FROM covid19_basic ;

-- Ukol 4
SELECT *,
	CASE
		WHEN confirmed IS NULL THEN '--nezadano--'
		WHEN confirmed < 1000 THEN 'low'
		WHEN confirmed >= 1000 AND confirmed < 10000 THEN 'middle'
		WHEN confirmed > 10000 THEN 'vice nez 10000'
		ELSE 'error'
	END	AS category
FROM covid19_basic_differences

-- Ukol 5
SELECT *,
	CASE 
		WHEN country IN ('US', 'India') AND confirmed > 10000 THEN 1
		ELSE 0
	END	AS three_lands
FROM covid19_basic_differences 
ORDER BY three_lands DESC  ;

-- Ukol 6
SELECT *,
	CASE
		WHEN country LIKE ('%a') THEN 'A zeme' 
		ELSE 'ne A zeme'
	END	AS flag_and_A
FROM covid19_basic_differences ;

-- COVID-19: WHERE, IN a LIKE
-- Ukol 1
CREATE OR REPLACE VIEW  t_tomas_pelikan_covid19 as
SELECT *
FROM covid19_basic_differences 
WHERE country IN ('US', 'India', 'China'); 

-- Ukol 2
SELECT *
FROM covid19_basic 
WHERE country IN (
SELECT DISTINCT  
country
FROM countries 
WHERE population > 100000000
);

SELECT DISTINCT  
country
FROM countries 
WHERE population > 100000000;

-- Ukol 3
SELECT *
FROM covid19_basic
WHERE country IN (
SELECT DISTINCT 
country 
FROM covid19_detail_us
)

SELECT DISTINCT 
country 
FROM covid19_detail_us; 

-- Ukol 4 nevim moc neslo
SELECT 
country, confirmed  
FROM covid19_basic 
WHERE country IN (
SELECT DISTINCT 
country 
FROM covid19_basic_differences 
WHERE confirmed >= 10000
)


SELECT DISTINCT 
country
FROM covid19_basic_differences 
WHERE confirmed >= 10000;

-- Ukol 5
SELECT DISTINCT 
country 
FROM covid19_basic
WHERE country NOT IN (
SELECT DISTINCT 
country 
FROM covid19_basic_differences 
WHERE confirmed > 1000
)


SELECT DISTINCT 
country 
FROM covid19_basic_differences 
WHERE confirmed > 1000;


-- Ukol 6
SELECT DISTINCT 
country 
FROM covid19_basic 
WHERE country LIKE 'A%';