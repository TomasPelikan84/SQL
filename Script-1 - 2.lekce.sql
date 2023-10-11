SELECT 
	name,
	provider_type 
FROM healthcare_provider
ORDER BY trim (name);

SELECT 
	provider_id ,
	name ,
	provider_type 
FROM healthcare_provider
ORDER BY 
	region_code ,
	district_code ;

SELECT *
FROM czechia_district
ORDER BY code DESC ;

SELECT *
FROM czechia_region cr
ORDER BY name DESC
LIMIT 5;

SELECT *
FROM healthcare_provider h
ORDER BY
	provider_type,
	name DESC;

/*
 * Case expression
 */

SELECT TRUE;
SELECT FALSE ;


SELECT *,
	CASE 
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_Prague	
FROM healthcare_provider;

SELECT *,
	CASE 
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_Prague	
FROM healthcare_provider
WHERE region_code = 'CZ010';

SELECT 
	longitude 
FROM healthcare_provider hp 
WHERE longitude IS NOT NULL 
ORDER BY longitude;


-- nejvice na vychode 18,805--
-- nejvice na zapade 12,167--
-- 1 nejvice na zapade (mene nez 14)
-- 2 mene na zapade (vice nebo rovno 14 a mene nez 16)
-- 3 vice na vychode(vice nebo rovno 16 a mene nez 18)
-- 4nejvice na vychode(vice nebo rovno 18)

SELECT 
	name,
	municipality ,
	longitude,
	CASE 
		WHEN longitude IS NULL THEN '----neni znamo----'
		WHEN longitude < 14 THEN 'nejvice na zapade'
		WHEN longitude >= 14 AND longitude < 16 THEN 'mene na zapade'
		WHEN longitude >= 16 AND longitude < 18 THEN 'vice na vychode'
		WHEN longitude >= 18 THEN 'nejvice na vychode'
	END AS position_in_czechia
FROM healthcare_provider;

-- Úkol 4: Vypište název a typ poskytovatele a v novém sloupci 
-- odlište, zda jeho typ je Lékárna nebo Výdejna zdravotnických prostředků.--

SELECT 
	name,
	provider_type,
		CASE 
			WHEN provider_type = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
			ELSE 0
		END AS is_special_provider_type		
FROM healthcare_provider;

SELECT 
	name,
	provider_type,
		CASE 
			WHEN provider_type IN ('Lékárna', 'Výdejna zdravotnických prostředků') THEN 1
			ELSE 0
		END AS is_special_provider_type		
FROM healthcare_provider;

SELECT 
	name,
	provider_type,
		CASE 
			WHEN provider_type LIKE  '%Lékárna%' OR provider_type like '%Výdejna zdravotnických prostředků%' THEN 1
			ELSE 0
		END AS is_special_provider_type		
FROM healthcare_provider
WHERE provider_type LIKE 'Lékárna,%';


SELECT 
	name, provider_type 
FROM healthcare_provider;

/*
 * where in a like
 */

SELECT *
FROM healthcare_provider
WHERE name LIKE '%nemocnice%';

SELECT 	
	name,
	CASE 
		WHEN name LIKE 'lékárna' THEN 1
	END AS starts_with_searcher_string	
FROM healthcare_provider
WHERE name LIKE '%lekarna%';


SELECT 
	name,
	municipality 
FROM healthcare_provider
WHERE municipality LIKE '____';

SELECT 
	name,
	municipality 
FROM healthcare_provider
WHERE CHAR_LENGTH(municipality) = 4;



-- Úkol 5: Pomocí vnořeného SELECT vypište kódy krajů pro Jihomoravský a Středočeský kraj z tabulky 
-- czechia_region. Ty použijte pro vypsání ID, jména a kraje jen těch vyhovujících poskytovatelů z 
-- tabulky healthcare_provider.

SELECT 
	provider_id ,
	name,
	region_code 
FROM healthcare_provider
WHERE region_code IN (
	SELECT 
	code
FROM czechia_region cr 
WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj')
);

SELECT 
	code
FROM czechia_region cr 
WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj');


--  Ukol 6.: Z tabulky czechia_district vypište jenom ty okresy, ve kterých se vyskytuje název města, 
-- které má délku čtyři písmena (znaky).

SELECT *
FROM czechia_district
WHERE code IN (
	SELECT 
	DISTINCT  district_code  
FROM healthcare_provider
WHERE municipality LIKE '____'
);

SELECT 
	DISTINCT  district_code  
FROM healthcare_provider
WHERE municipality LIKE '____';


-- Pohledy ViEW

/*
 * Úkol 1: Vytvořte pohled (VIEW) s ID, jménem, městem a okresem místa poskytování u 
 * těch poskytovatelů, kteří jsou z Brna, Prahy nebo Ostravy. Pohled pojmenujte 
 * v_healthcare_provider_subset.
 */

CREATE OR REPLACE  VIEW v_healthcare_provider_subset_TP as 
SELECT 
provider_id ,
name ,municipality ,district_code 
FROM healthcare_provider hp
WHERE municipality IN ('Brno', 'Praha', 'Ostrava');

SELECT *
FROM v_healthcare_provider_subset;

/*
 * Úkol 2: Vytvořte dva SELECT nad tímto pohledem. První vybere vše z něj,
 *  druhý vybere všechny poskytovatele z tabulky healthcare_provider, kteří se 
 * nenacházejí v pohledu v_healthcare_provider_subset.
 */

SELECT *
FROM healthcare_provider
WHERE provider_id  NOT IN (
	SELECT provider_id 
	FROM v_healthcare_provider_subset_TP 
);

DROP VIEW IF EXISTS v_healthcare_provider_subset;


