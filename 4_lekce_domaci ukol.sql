-- BONUSOVÁ CVIČENÍ
-- Countries: JOIN
-- V následujících cvičeních budeme pracovat s tabulkami countries, religions, life_expectancy a economies.

-- Úkol 1: K tabulce countries připojte tabulku religions. 
-- Vybere název státu, hlavní město, celkovou populaci, název náboženství a počet jeho příslušníků.
-- Vyberte pouze rok 2020.

SELECT c.country , c.capital_city , c.population , r.religion , r.population as adherents
FROM countries c 
JOIN religions r
    ON c.country = r.country
    AND r.year = 2020
    
-- Úkol 2: K tabulce countries připojte tabulku economies. Pro každý stát vyberte hodnoty HDP v milionech dolarů,
-- gini koeficient a daně za období, kdy byla země samostatná (independence_date).
    
SELECT c.country , c.capital_city, c.independence_date , e.year, 
    round( e.GDP / 1000000, 2 ) as GDP_mil_dollars , 
    e.population , e.gini , e.taxes 
FROM countries c 
JOIN economies e 
    on c.country = e.country 
    and c.independence_date <= e.year
;

-- Úkol 3: Zjistěte, které země se nacházejí v tabulce countries, ale ne v tabulce economies. 
-- Seřaďte je sestupně podle počtu obyvatel.

SELECT c.country , c.population
FROM countries c 
LEFT JOIN economies e 
    on c.country = e.country 
    and e.year=2018 -- vyberu si jenom jeden rok
WHERE e.country is null
ORDER BY c.population desc
;

-- Úkol 4: Joiny můžeme používat nejenom pro spojování dvou různých tabulek. 
-- Můžeme napojovat i jednu tabulku samu na sebe, abychom z ní zjistili nové informace. 
-- Použijte tabulku life_expectancy abyste pro každý stát zjistili podíl doby dožití v roce 2015 a v roce 1970.


SELECT a.country, a.life_exp_1970 , b.life_exp_2015,
    round( b.life_exp_2015 / a.life_exp_1970, 2 ) as life_exp_ratio
FROM (
    SELECT le.country , le.life_expectancy as life_exp_1970
    FROM life_expectancy le 
    WHERE year = 1970
    ) a JOIN (
    SELECT le.country , le.life_expectancy as life_exp_2015
    FROM life_expectancy le 
    WHERE year = 2015
    ) b
    ON a.country = b.country
;

-- Úkol 5: Z tabulky economies spočítejte meziroční procentní nárůst populace a procentní nárůst HDP pro každou zemi.

SELECT e.country, e.year, e2.year + 1 as year_prev, 
    round( ( e.GDP - e2.GDP ) / e2.GDP * 100, 2 ) as GDP_growth,
    round( ( e.population - e2.population ) / e2.population * 100, 2) as pop_growth_percent
FROM economies e 
JOIN economies e2 
    ON e.country = e2.country 
    AND e.year = e2.year + 1
    AND e.year < 2020

-- Úkol 6: Počty věřících v tabulce religions pro rok 2020 přepočítejte na procentní podíl.

SELECT r.country , r.religion , 
    round( r.population / r2.total_population_2020 * 100, 2 ) as religion_share_2020
FROM religions r 
JOIN (
        SELECT r.country , r.year,  sum(r.population) as total_population_2020
        FROM religions r 
        WHERE r.year = 2020 and r.country != 'All Countries'
        GROUP BY r.country
    ) r2
    ON r.country = r2.country
    AND r.year = r2.year
    AND r.population > 0
    
       
-- COVID-19: JOIN
-- Úkol 1a: Vytvořte view z lookup_table, kde je sloupec provincie null

CREATE OR REPLACE VIEW v_tomas_pelikan_ukol_1 as
SELECT * 
FROM lookup_table lt
WHERE province IS NULL ;

-- Úkol 1b: Spojte pomocí left join tabulku covid19_basic s view vytvořeným v předchozím úkolu přes country

SELECT *
FROM covid19_basic cb 
LEFT JOIN v_tomas_pelikan_ukol_1 vtpu 
	ON cb.country = vtpu.country ;

-- Úkol 2: Spojte tabulky covid19_basic a covid19_basic_difference pomocí left join

SELECT *
FROM covid19_basic cb 
LEFT JOIN covid19_basic_differences cbd 
	ON cb.country = cbd.country
	AND cb.`date` = cbd.`date` ;

-- Úkol 3: Spojte tabulky covid19_detail_us a covid19_detail_us_differences skrze sloupce date, country, admin2.
-- Z tabulky covid19_detail_us vyberte všechny sloupce a tabulky covid19_detail_us_differences jen confirmed a 
-- přejmenujte ho na confirmed_diff. Pro spojení použijte left join

SELECT 
cdu.*, cdud.confirmed AS confirmed_diff
FROM covid19_detail_us cdu 
LEFT JOIN covid19_detail_us_differences cdud 
	ON cdu.`date` = cdud.`date` 
	AND cdu.country = cdud.country 
	AND cdu.admin2 = cdud.admin2
	AND cdu.province = cdud.province  ; 

-- Úkol 4: Spojte pomocí left join tabulky covid19_detail_us, covid19_detail_us_differences a lookup_table

SELECT 
        *
FROM covid19_detail_us base 
LEFT JOIN covid19_detail_us_differences a
ON     base.date = a.date
   AND base.country = a.country
   AND base.province = a.province 
   AND base.admin2 = a.admin2 
LEFT JOIN lookup_table b 
ON     base.country = b.country
   AND base.province = b.province 
   AND base.admin2 = b.admin2
   
-- Úkol 5: Spojte pomocí left join tabulky covid19_detail_global a covid19_detail_global_differences
   
SELECT *
FROM covid19_detail_global base
LEFT JOIN covid19_detail_global_differences a
	ON base.country = a.country 
	AND base.province = a.province
	AND base.`date` = a.`date` ;

-- Úkol 6: Spojte pomocí left join tabulky covid19_detail_global , covid19_detail_global_differences a lookup_table

SELECT*
FROM covid19_detail_global base
LEFT JOIN covid19_detail_global_differences a
	ON base.country = a.country 
	AND base.`date` = a.`date` 
	AND base.province = a.province
	AND base.confirmed = a.confirmed 
LEFT JOIN lookup_table lt
	ON base.country = lt.country 
	AND base.province  = lt.province 
	
-- Úkol 7: Jaký je průbeh počtu nakažených na milion obyvatel v Česke republice a v Německu
	
SELECT
        base.date,
        base.country,
        (base.confirmed*1000000)/a.population
FROM (
          SELECT 
                  date,
                country,
                confirmed 
          FROM covid19_basic cb
          WHERE country IN ('Czechia','Germany')
         ) base
LEFT JOIN 
         (
          SELECT
                  country,
                  population
          FROM lookup_table lt 
          WHERE country IN ('Czechia','Germany')
                AND province is null
         ) a
ON base.country = a.country
ORDER BY date desc, country

-- Úkol 8: Seřaďte státy podle počtu celkově nakažených na milion obyvatel k 30.8.2020?

SELECT 
base.country, (base.confirmed*1000000)/ a.population
FROM 
	(
		SELECT 
		country , confirmed
		FROM covid19_basic_differences cbd
		WHERE `date` = '2020-08-30'
		) base
LEFT JOIN 
		(
		SELECT
                  country,
                  population
          FROM lookup_table lt 
          WHERE province is NULL
         ) a
ON base.country = a.country
GROUP BY base.country

-- Úkol 9: Ukaž celosvětový průběh celkově nakaženych na milion obyvatel

SELECT 
base.date, 
(sum(base.confirmed)*1000000)/sum(a.population) as confirmed_per_milion
FROM 
	(
		SELECT
		date ,country, confirmed 
		FROM covid19_basic cb 
	) base
LEFT JOIN 
	(
	SELECT 
	country ,population 
	FROM lookup_table lt
	WHERE province IS NULL
	) a
	ON base.country = a.country
GROUP BY base.date
ORDER BY base.date DESC ;	

-- Úkol 10: Z tabulky lookup_table vyberte pouze země s populací menší než milion a připojte k této tabulce 
-- průběh jejich nakažených. (Použijte inner join)

SELECT
        a.*,
        base.population
FROM 
        (
        SELECT
                country,
                population
        FROM lookup_table lt 
        WHERE province is NULL 
          AND population < 1000000
        ) base
INNER JOIN covid19_basic a
ON base.country = a.country 

-- Úkol 11: Udělejte seznam všech zemí pro všechny datumy z tabulky covid19_basic

SELECT 
    datumy.date,
    zeme.country
FROM (
     SELECT DISTINCT 
         date
     FROM covid19_basic
     ) datumy
CROSS JOIN
    (
     SELECT DISTINCT 
         country
     FROM covid19_basic
     ) zeme

-- Úkol 12: Udělejte seznam všech zemí pro všechny datumy z tabulky covid19_basic. 
-- K této tabulce připojte přírůstky a kde nejsou data vložte 0.

SELECT 
    datumy.date,
    zeme.country,
    CASE WHEN diff.confirmed is null THEN 0 
         ELSE diff.confirmed END AS confirmed 
FROM (
     SELECT DISTINCT 
         date
     FROM covid19_basic
     ) datumy
CROSS JOIN
    (
     SELECT DISTINCT 
         country
     FROM covid19_basic
     ) zeme
LEFT JOIN covid19_basic_differences diff 
ON  datumy.date = diff.date 
AND zeme.country = diff.country

-- COVID-19: pokračování JOIN
-- Úkol 1: K tabulce covid19_detail_global_differences připojte tabulku lookup_table. 
-- Zjistěte počty nakažených na milion obyvatel v Anglii, Walesu, Skotsku a Severním Irsku.
-- Podívejte se, jestli se počty významně liší o víkendu a ve všedních dnech.

    
SELECT c.country , c.province , c.date, 
    case when WEEKDAY(c.date) in (5, 6) then 1 else 0 end as weekend, 
    c.confirmed , lt.population , 
    round( c.confirmed / lt.population * 1000000, 2 ) as cases_per_million
FROM covid19_detail_global_differences c
JOIN lookup_table lt 
    on c.country = lt.country 
    and c.province = lt.province 
    and c.country = 'United Kingdom'
    and lt.population > 1000000
    and month(c.date) = 11
ORDER BY c.province , c.date desc  
     
-- Úkol 2: Srovnejte počty nově nakažených na sto tisíc obyvatel v České republice a ve Skotsku 
-- za posledních 14 dní. Výsledná tabulka bude mít 4 sloupce: datum, počet v ČR, počet ve Skotsku 
-- a binární proměnnou pro víkend.
     
     
SELECT cz.date , case when weekday(cz.date) in (5,6) then 1 else 0 end as weekend,
    round( cz.confirmed_czech / cz.pop_czech * 100000 ) as confirmed_czech,
    round( sc.confirmed_scot / sc.pop_scot * 100000 ) as confirmed_scot
FROM (
        SELECT a.country , a.date , a.confirmed as confirmed_czech , lt.population as pop_czech
        FROM covid19_basic_differences a 
        JOIN lookup_table lt 
            on a.country = lt.country 
        WHERE a.country = 'Czechia' 
            and a.date >= DATE_ADD(CURRENT_DATE(), INTERVAL - 14 day) 
    ) cz JOIN ( 
        SELECT b.province , b.date , b.confirmed as confirmed_scot , lt2.population as pop_scot
        FROM covid19_detail_global_differences b
        JOIN lookup_table lt2
            on b.province = lt2.province 
        WHERE b.province = 'Scotland'
    ) sc on cz.date = sc.date
ORDER BY cz.date desc

-- Úkol 3: Z tabulky covid19_basic vyberte počty nově nakažených pro Českou republiku v říjnu. 
-- K této tabulce připojte maximální denní teplotu z tabulky weather.

SELECT c.country, c.date, c.confirmed , lt.iso3 , c2.capital_city , w.max_temp
FROM covid19_basic as c
JOIN lookup_table lt 
    on c.country = lt.country 
    and c.country = 'Czechia'
    and month(c.date) = 10
JOIN countries c2
    on lt.iso3 = c2.iso3
JOIN (  SELECT w.city , w.date , max(w.temp) as max_temp
        FROM weather w 
        GROUP BY w.city, w.date) w
    on c2.capital_city = w.city 
    and c.date = w.date
ORDER BY c.date desc
;




		
		
		
     





	
SELECT *
FROM covid19_detail_us cdu  ;

SELECT *
FROM covid19_detail_us_differences cdud ;

SELECT *
FROM lookup_table lt ;
























