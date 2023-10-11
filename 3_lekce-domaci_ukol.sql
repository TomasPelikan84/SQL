-- Úkol 1:

-- Zjistěte celkovou populaci kontinentů.
-- Zjistěte průměrnou rozlohu států rozdělených podle kontinentů
-- Zjistěte počty států podle rozdělených podle hlavního náboženství
-- Státy vhodně seřaďte.

SELECT
continent,   
sum(population)
FROM countries 
GROUP BY continent 
ORDER BY sum(population) DESC ;

SELECT 
continent,
avg(surface_area) AS "area"
FROM countries 
group BY continent  
ORDER BY area DESC ;

SELECT 
religion ,
count(country) AS "pocet"
FROM countries 
WHERE religion IS NOT NULL 
GROUP BY religion 
ORDER BY pocet desc; 

-- Úkol 2:
-- Zjistěte celkovou populaci, průměrnou populaci a počet států pro každý kontinent
-- Zjistěte celkovou rozlohu kontinentu a průměrnou rozlohu států ležících na daném kontinentu
-- Zjistěte celkovou populaci a počet států rozdělených podle hlavního náboženství

SELECT 
continent ,
sum(population),
round(avg(population), 2),
count(country)  
FROM countries 
WHERE population IS NOT NULL 
GROUP BY continent 
ORDER BY sum(population) desc;

SELECT 
continent ,
sum(surface_area),
round(avg(surface_area), 2)
FROM countries 
GROUP BY continent 
ORDER BY sum(surface_area) DESC ;

SELECT 
religion,  
sum(population),
count(*)
FROM countries 
GROUP BY religion  
ORDER BY sum(population) DESC ;

-- Úkol 3: Pro každý kontinent zjistěte podíl počtu vnitrozemských států (sloupec landlocked), 
-- podíl populace žijící ve vnitrozemských státech a podíl rozlohy vnitrozemských států.

select continent , 
    round( sum( landlocked ) / count(*), 2) as landlocked_cnt_share,
    round( sum( landlocked * surface_area ) / sum( surface_area ), 2 ) as landlocked_area_share,
    round( sum( landlocked * population ) / sum( population ), 2 ) as landlocked_population_share
from countries
where continent is not null and landlocked is not null
group by continent 
;

-- Úkol 4: Zjistěte celkovou populaci ve státech rozdělených podle kontinentů a regionů (sloupec region_in_world). 
-- Seřaďte je podle kontinentů abecedně a podle populace sestupně.

SELECT 
continent ,region_in_world, sum(population)
FROM countries
GROUP BY continent, region_in_world  
ORDER BY continent ,sum(population) DESC  ;

-- Úkol 5: Zjistěte celkovou populaci a počet států rozdělených podle kontinentů a podle náboženství. 
-- Kontinenty seřaďte abecedně a náboženství v rámci kontinentů sestupně podle populace.

SELECT 
continent , region_in_world,  
sum(population),
count(*)
FROM countries 
GROUP BY continent , religion 
ORDER BY continent , sum(population) DESC ;

-- Úkol 6: Zjistěte průměrnou roční teplotu v regionech Afriky.


SELECT 
region_in_world,
round(avg(yearly_average_temperature), 2)
FROM countries 
WHERE continent = 'Africa'and yearly_average_temperature IS not NULL 
GROUP BY region_in_world ;

select region_in_world , 
    round( sum( surface_area * yearly_average_temperature ) / sum( surface_area ), 2 ) as average_regional_temperature
from countries
where continent = 'Africa'
    and yearly_average_temperature is not null
group by region_in_world 














































