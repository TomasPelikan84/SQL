-- Funkce COUNT()
-- Úkol 1: Spočítejte počet řádků v tabulce czechia_price.

SELECT
count(1)
FROM czechia_price 

-- Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce COUNT().

SELECT
count(id)
FROM czechia_payroll ;

-- Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?

SELECT
count(1)
FROM czechia_payroll 
WHERE value_type_code = '316' AND value IS NOT NULL ;

-- Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.

SELECT
category_code , count(1)
FROM czechia_price 
GROUP BY category_code ;

-- Úkol 5: Rozšiřte předchozí dotaz o dadatečné rozdělení dle let měření.

SELECT
category_code , YEAR (date_from) , count(1)
FROM czechia_price 
GROUP BY category_code, YEAR (date_from) ;

-- Funkce SUM()
-- Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.

SELECT SUM(value) AS value_sum
FROM czechia_payroll
WHERE value_type_code = 316;

-- Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.

SELECT
category_code, sum (value)  
FROM czechia_price 
WHERE region_code  = 'CZ064'
GROUP BY category_code 
;

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, 
-- u kterých měření probíhalo od (date_from) 15. 1. 2018.

SELECT
sum (value)
FROM czechia_price 
WHERE date_from = '2018-01-15';

-- Úkol 4: Vypište tři sloupce z tabulky czechia_price: kód kategorie, počet řádků pro ni a 
-- sumu hodnot průměrných cen. To vše pouze pro data v roce 2018.

SELECT 
category_code, count(1), sum (value)  
FROM czechia_price 
WHERE YEAR(date_from) = '2018' 
GROUP BY category_code ;

-- Další agregační funkce
-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.

SELECT
max (value)
FROM czechia_payroll
WHERE value_type_code = 5958;

-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin 
-- její minimum v letech 2015 až 2017.

SELECT
category_code, min (value) 
FROM czechia_price 
WHERE YEAR (date_from) IN ('2015', '2016', '2017')
GROUP BY category_code ;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.

SELECT
industry_branch_code , max (value)
FROM czechia_payroll 
WHERE industry_branch_code IS NOT NULL 
GROUP BY industry_branch_code 
ORDER BY max (value) DESC ;

SELECT
industry_branch_code
FROM czechia_payroll 
WHERE value IN  (
	SELECT
	max(value)
	FROM czechia_payroll 
)

SELECT
    *
FROM czechia_payroll_industry_branch
WHERE code IN (
    SELECT
        industry_branch_code
    FROM czechia_payroll
    WHERE value IN (
        SELECT
            MAX(value)
        FROM czechia_payroll
        WHERE value_type_code = 5958
    )
);

-- Úkol 4: Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference,
-- ve kterém budou hodnoty "rozdíl do 10 Kč", "rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu 
-- minima a maxima. Podle tohoto rozdílu data seřaďte.

SELECT 
category_code ,
min (value) AS min_hodnota,
max (value) AS max_hodnota,
max (value) - min (value) AS differ,
	CASE
		WHEN (max (value) - min (value)) < 10 THEN 'rozdil do 10 Kc'
		WHEN (max (value) - min (value)) < 40 THEN 'rozdil do 40 Kc'
		ELSE 'rozdil nad 40 Kc'
	END	AS difference
FROM czechia_price
GROUP BY category_code
order BY differ DESC  ; 


SELECT
    category_code,
    MIN(value),
    MAX(value),
    CASE
        WHEN MAX(value) - MIN(value) < 10 THEN 'rozdíl do 10 Kč'
        WHEN MAX(value) - MIN(value) < 40 THEN 'rozdíl do 40 Kč'
        ELSE 'rozdíl nad 40 Kč'
    END AS difference
FROM czechia_price
GROUP BY category_code
ORDER BY difference;

SELECT
    category_code,
    MIN(value),
    MAX(value),
    CASE
        WHEN MAX(value) - MIN(value) < 10 THEN 'rozdíl do 10 Kč'
        WHEN MAX(value) - MIN(value) < 40 THEN 'rozdíl do 40 Kč'
        ELSE 'rozdíl nad 40 Kč'
    END AS difference
FROM czechia_price
GROUP BY category_code
ORDER BY MAX(value) - MIN(value);

-- Úkol 5: Vyberte pro každou kategorii potravin minimum, maximum a aritmetický průměr 
-- (v našem případě průměr z průměrů) zaokrouhlený na dvě desetinná místa.


SELECT 
category_code , max (value), min (value), round (avg (value), 2)
FROM czechia_price
GROUP BY category_code ;

-- Úkol 6: Rozšiřte předchozí dotaz tak, že data budou rozdělena i podle kódu kraje a 
-- seřazena sestupně podle aritmetického průměru.

SELECT 
category_code ,region_code , max (value), min (value), round (avg (value), 2) AS average
FROM czechia_price
GROUP BY category_code, region_code 
ORDER BY average DESC  ;











