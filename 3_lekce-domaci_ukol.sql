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

-- COVID-19: funkce SUM()

-- Úkol 1: Vytvořte v tabulce covid19_basic nový sloupec, kde od confirmed odečtete polovinu recovered 
-- a přejmenujete ho jako novy_sloupec. Seřaďte podle data sestupně.

SELECT*, 
confirmed - (recovered / 2) AS xxx
FROM covid19_basic
ORDER BY date DESC ;

-- Úkol 2: Kolik lidí se celkem uzdravilo na celém světě k 30.8.2020?

SELECT
sum(recovered)
FROM covid19_basic
WHERE date = '2020-08-30';

-- Úkol 3: Kolik lidí se celkem uzdravilo, a kolik se jich nakazilo na celém světě k 30.8.2020?

SELECT
sum(confirmed)
FROM covid19_basic
WHERE date = '2020-08-30';

-- Úkol 4: Jaký je rozdíl mezi nakaženými a vyléčenými na celém světě k 30.8.2020?


SELECT
sum(confirmed) - sum(recovered) AS rozdil
FROM covid19_basic 
WHERE date = '2020-08-30';

-- Úkol 5: Z tabulky covi19_basic_differences zjistěte, kolik lidí se celkem nakazilo v 
-- České republice k 30.8.2020.

SELECT
sum(confirmed) 
FROM covid19_basic_differences
WHERE country = 'Czechia' AND date = '2020-08-30';

-- Úkol 6: Kolik lidí se nakazilo v jednotlivých zemích během srpna 2020?

SELECT
country, sum (confirmed)  
FROM covid19_basic 
WHERE date >= '2020-08-01' AND date <= '2020-08-31'
GROUP BY country ;

-- Úkol 7: Kolik lidí se nakazilo v České republice, na Slovensku a v Rakousku 
-- mezi 20.8.2020 a 30.8.2020 včetně?

SELECT
country, sum (confirmed)  
FROM covid19_basic 
WHERE date >= '2020-08-20' AND date <= '2020-08-30' AND country IN ('Czechia', 'Austria', 'Slovakia')
GROUP BY country ;

-- Úkol 8: Jaký byl největší přírůstek v jednotlivých zemích?

SELECT 
country , max (confirmed)
FROM covid19_basic_differences 
GROUP BY country ;

-- Úkol 9: Zjistěte největší přírůstek v zemích začínajících na C.

SELECT
country ,max (confirmed)
FROM covid19_basic_differences 
WHERE country LIKE 'C%'
GROUP BY country ;

-- Úkol 10: Zjistěte celkový přírůstek všech zemí s populací nad 50 milionů. 
-- Tabulku seřaďte podle datumu od srpna 2020.

SELECT
date, country ,
sum(confirmed)
FROM covid19_basic_differences 
WHERE country IN  (
	SELECT
	country  
	FROM countries
	WHERE population  > 50000000
) AND date >= '2020-08-01'
GROUP BY date, country 
ORDER BY `date` ;

SELECT
country  
FROM countries
WHERE population  > 50000000;

-- Úkol 11: Zjistěte celkový počet nakažených v Arkansasu (použijte tabulku covid19_detail_us_differences).

SELECT
province , sum (confirmed)
FROM covid19_detail_us_differences
WHERE province = 'Arkansas';

-- Úkol 12: Zjistětě nejlidnatější provincii v Brazílii.

SELECT
country , province , population,
max (population)
FROM lookup_table 
WHERE country = 'Brazil' AND province IS NOT NULL 
ORDER BY population  DESC ;

select DISTINCT province
from lookup_table lt 
where country = 'Brazil' and province is not null
order by population desc
limit 1;

SELECT DISTINCT
        province
FROM lookup_table lt2 
WHERE    country='Brazil' 
    AND population in (
        SELECT 
                max(population) 
        FROM lookup_table lt 
        WHERE   country='Brazil' 
             AND province is not null
             )

-- Úkol 13: Zjistěte celkový a průměrný počet nakažených denně po dnech a 
-- seřaďte podle data sestupně (průměr zaokrouhlete na dvě desetinná čísla)

SELECT
date,
sum (confirmed), round (avg (confirmed), 2)
FROM covid19_basic_differences
GROUP BY date
ORDER BY `date` DESC  ; 

-- Úkol 14: Zjistěte celkový počet nakažených lidí v jednotlivých provinciích USA dne 30.08.2020 
-- (použijte tabulku covid19_detail_us).

SELECT 
province , sum (confirmed)
FROM covid19_detail_us
WHERE `date` = '2020-08-30' AND country = 'US'
GROUP BY province ;


-- Úkol 15: Zjistěte celkový přírůstek podle datumu a země.

SELECT
date, country , sum (confirmed)
FROM covid19_basic_differences
GROUP BY date , country ;

-- COVID-19: funkce AVG() a COUNT()
-- Úkol 1: Zjistěte průměrnou populaci ve státech ležících severně od 60 rovnoběžky.

SELECT
country , north, avg (population)
FROM countries 
WHERE north >= 60
GROUP BY country 
ORDER BY north DESC ;

SELECT avg(population)
FROM lookup_table lt 
WHERE lat >= 60
    AND province IS NULL    
;

-- Úkol 2: Zjistěte průměrnou, nejvyšší a nejnižší populaci v zemích ležících severně od 60 rovnoběžky. 
-- Spočítejte, kolik takových zemích je. Vytvořte sloupec max_min_ratio,
-- ve kterém nejvyšší populaci vydělíte nejnižší.

SELECT
max (population), min (population), avg (population),
count(DISTINCT country),
max (population) / min (population) AS max_min_ratio
FROM lookup_table
WHERE lat >= 60 ;

-- Úkol 3: Zjistěte průměrnou populaci a rozlohu v zemích seskupených podle náboženství. 
-- Zjistěte také počet zemí pro každé náboženství.

-- Nápověda: Sloupce religion, population, surface_area

SELECT 
religion ,avg (population), avg (surface_area), count(country)
FROM countries
WHERE religion IS NOT NULL 
GROUP BY religion
;

-- Úkol 4: Zjistěte počet zemí, kde se platí dolarem (jakoukoli měnou, která má v názvu dolar).
-- Zjistěte nejvyšší a nejnižší populaci mezi těmito zeměmi.
-- Nápověda: Sloupec currency_name.

SELECT
count (DISTINCT country), max (population), min (population)
FROM countries 
WHERE currency_name LIKE '%dollar%' AND population IS NOT NULL ;

SELECT count(country), max(population), min(population)
FROM countries c 
WHERE LOWER(currency_name) LIKE LOWER('%dollar%')
;

-- Úkol 5: Zjistěte, kolik zemí platících Eurem leží v Evropě a kolik na jiných kontinentech.

SELECT
continent ,count(country) 
FROM countries 
WHERE currency_code  = 'EUR'
GROUP BY continent ;


SELECT continent , count(country)
FROM countries c 
WHERE currency_code = 'EUR'
GROUP BY continent 
;

-- Úkol 6: Zjistěte, pro kolik zemí známe průměrnou výšku jejích obyvatel.

SELECT
count (1)
FROM countries 
WHERE avg_height IS NOT NULL ;

-- Úkol 7: Zjistěte průměrnou výšku obyvatel na jednotlivých kontinentech.

SELECT 
continent , avg (avg_height), round( sum(population*avg_height)/sum(population) , 2)
FROM countries
WHERE avg_height IS NOT NULL 
GROUP BY continent ;

-- Toto řešení však může být zavádějící, protože nebere v potaz počet obyvatel země. 
-- Ve výsledném čísle potom bude míst stejnou váhu výška 168.3 cm v Číně, která má přes miliardu obyvatel, 
-- a výška 175 cm v devítimilionovém Izraeli. Pokud počítáme průměr průměrů, měli bychom zvážit, 
-- jestli nemáme počítat vážený průměr. V našem případě bude váhou počet obyvatel dané země. 
-- Vážený průměr je

SELECT continent , round( sum(population*avg_height)/sum(population) , 2) AS weighted_average
FROM countries c 
WHERE avg_height IS NOT NULL
GROUP BY continent
ORDER BY round( sum(population*avg_height)/sum(population) , 2) DESC

-- Úkol 8: Zjistěte průměrnou hustotu zalidnění pro světový region (region_in_world). 
-- Srovnejte obyčejný a vážený průměr. Váhou bude v tomto případě rozloha státu (surface_area). 
-- Výslednou tabulku uložte jako v_{jméno}_{příjmení}_population_density.

-- Poznámka: V tomto případě nepočítáme 'průměr průměrů', ale průměr zlomků (hustota zalidnění = populace / rozloha).
-- Vyzkoušejte si, co by se stalo, pokud bychom jako váhu použili nikoli rozlohu (jmenovatel), 
-- ale populaci (čitatel). Jaká varianta Vám přijde vhodnější?

CREATE TABLE v_tomas_pelikan_population_density

SELECT
region_in_world, population_density , round (avg(population / surface_area), 2),
round (avg(population / surface_area), 2) - population_density AS rozdil
FROM countries
WHERE region_in_world IS NOT NULL 
GROUP BY region_in_world ; 

DROP TABLE v_tomas_pelikan_population_density 

CREATE OR REPLACE VIEW v_tomas_pelikan_population_density as
SELECT region_in_world ,
    round( avg(population_density), 2 ) AS simple_avg_density,
    round( sum(surface_area*population_density) / sum(surface_area), 2 ) AS weighted_avg_density
FROM countries c 
WHERE population_density IS NOT NULL AND region_in_world IS NOT NULL
GROUP BY region_in_world 

-- Úkol 9: Načtěte tabulku (lépe řečeno pohled), který jste vytvořili v minulém úkolu. 
-- Vytvořte nový sloupec diff_avg_density, který bude absolutní hodnotou (funkce abs) rozdílu mezi
-- obyčejným a váženým průměrem. Tabulku seřaďte podle tohoto nového sloupce sestupně.

-- Zdaleka největší rozdíl mezi průměry je ve východní Asii a Západní Evropě. V dalším úkolu se na 
-- jeden z těchto regionů podíváme blíže, abychom si lépe ukázali rozdíl mezi obyčejným a váženým průměrem.


SELECT*,
abs (simple_avg_density - weighted_avg_density) AS diff_avg_density
FROM v_tomas_pelikan_population_density
ORDER BY diff_avg_density DESC ; 

-- Úkol 10: Vyberte název, hustotu zalidnění a rozlohu zemí v západní Evropě. 
-- Najděte stát s nejvyšší hustotou zalidnění. Spočítejte obyčejný a vážený průměr hustoty zalidnění 
-- v západní Evropě kromě státu s nejvyšší hustotou. Výsledky srovnejte s oběma průměry spočítanými ze všech zemí.

SELECT
-- max (population_density),
round (avg (population_density), 2) AS simple_avg_density,
round( sum(surface_area*population_density) / sum(surface_area), 2) AS weigh_avg_density
FROM countries
WHERE region_in_world = 'Western Europe' AND country != "Monaco"
ORDER BY population_density DESC ;


SELECT 
    0 AS `Monaco_included`,
    round( avg(population_density), 2 ) AS simple_avg_density ,
    round( sum(surface_area*population_density) / sum(surface_area), 2 ) AS weighted_avg_density
FROM countries c 
WHERE region_in_world = 'Western Europe' AND country != 'Monaco'
UNION

SELECT
    1 AS `Monaco_included`,
    simple_avg_density , 
    weighted_avg_density 
FROM v_tomas_pelikan_population_density  
WHERE region_in_world = 'Western Europe'
;

















