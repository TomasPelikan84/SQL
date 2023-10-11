select *
from healthcare_provider;

SELECT 
	name, 
	provider_type 
from healthcare_provider; 

SELECT 
	name, 
	provider_type
from healthcare_provider
limit 20;

SELECT 
	name, 
	provider_type, 
	region_code 
from healthcare_provider
order by region_code;

SELECT 
	name,
	region_code,
	district_code 
from healthcare_provider
order by district_code DESC  
limit 500;


/*
 * WHERE
 * 
 */

SELECT *
FROM czechia_region cr; 

SELECT *
FROM healthcare_provider
WHERE region_code = 'CZ010';

SELECT
	name AS jmeno,
	phone AS telefon,
	fax,
	email,
	website AS webovky
FROM healthcare_provider
WHERE region_code != 'CZ010';



SELECT 
	name,
	region_code ,
	residence_region_code 
FROM healthcare_provider
WHERE region_code = residence_region_code ; 


SELECT 
	name,
	phone 
FROM healthcare_provider hp 
WHERE phone IS NOT NULL;

SELECT 
	name,
	phone 
FROM healthcare_provider hp 
WHERE phone IS NULL;

SELECT *
FROM czechia_district
WHERE name = 'Benešov' OR name = 'Beroun';

SELECT * 
FROM healthcare_provider hp
WHERE 
	district_code = 'CZ0201'
	OR district_code = 'CZ202'
ORDER BY district_code 
LIMIT 100;


/*
 * Tvorba tabulek a uprava zaznamu
 * -------
 */

CREATE TABLE t_tom_pelikan_providers_south_moravia AS
SELECT *
FROM healthcare_provider hp 
WHERE region_code = 'CZ064';

SELECT *
FROM t_tom_providers_south_moravia;

DROP TABLE t_tom_providers_south_moravia 

CREATE TABLE t_tomas_pelikan_resume (
	date_start date,
	date_end date,
	education varchar(255),
	job varchar(255)
);

SELECT *
FROM t_tomas_pelikan_resume; 

INSERT INTO t_tomas_pelikan_resume 
VALUES ('1999-09-01', NULL, 'SPS', 'unemployed');

INSERT INTO t_tomas_pelikan_resume 
VALUES ('2005-06-01', '2008-06-01', 'SPS a VOS', 'Tokoz');

UPDATE t_tomas_pelikan_resume 
SET job = 'Cooper'
WHERE job = 'Cooper Standard';

ALTER TABLE t_tomas_pelikan_resume 
ADD COLUMN  role varchar(255);








