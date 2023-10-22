
CREATE TABLE address (
  id serial,
  street varchar(255),
  street_number int,
  city varchar(255),
  zip_code varchar(6)
);

INSERT INTO address(street,street_number,city,zip_code) VALUES ('Doktorská', 1, 'Engetov', '123 00');
INSERT INTO address(street,street_number,city,zip_code) VALUES ('Pacientská', 1, 'Engetov', '111 11');
INSERT INTO address(street,street_number,city,zip_code) VALUES ('Pacientská', 2, 'Engetov', '567 89');

SELECT *
FROM address a ;


CREATE TABLE doctor (
  id serial,
  name varchar(255),
  surname varchar(255),
  address_id int,
  phone_number varchar(20),
  email varchar(255)
);
INSERT INTO doctor(name,surname,address_id,phone_number,email) VALUES ('Jan', 'Doktor', 1, '+420 123 456 789', 'doktor@engeto.cz');

CREATE TABLE patient (
  id serial,
  name varchar(255),
  surname varchar(255),
  address_id int,
  insurance_company varchar(255)
);
INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Petr', 'Pacient', 2, 'Engeto insurance');
INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Libor', 'Pacient', 3, 'Engeto insurance');
INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Stanislav', 'Pacient', 3, 'State insurance');

SELECT* FROM patient ;

CREATE TABLE medicament (
  id serial,
  name varchar(255),
  price_insurance float,
  price_patient float,
  unit varchar(10)
);
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Super Pills', 10.5, 4, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Extra Pills', 18.1, 8.2, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Common Pills', 5, 6.1, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Super Sirup', 12, 8, 'milliliter');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Extra Sirup', 16.3, 10.3, 'milliliter');

CREATE TABLE prescription (
  id serial,
  doctor_id int,
  patient_id int,
  valid_from datetime,
  valid_to datetime,
  is_released boolean
);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-10-06 11:35:12', '2019-10-16 11:35:12', true);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 2, '2019-10-06 12:00:06', '2019-10-16 12:00:06', false);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 3, '2019-10-06 14:04:53', '2019-10-16 14:04:53', true);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-10-08 08:05:40', '2019-10-18 08:05:40', true);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-11-11 09:12:42', '2019-11-21 09:12:42', false);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 2, '2019-11-11 10:07:35', '2019-11-21 10:07:35', false);

CREATE TABLE list_of_medicaments (
  prescription_id int,
  medicament_id int,
  amount int
);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (1, 1, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (1, 4, 100);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (2, 3, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (2, 4, 250);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 1, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 2, 3);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 3, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (4, 3, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (4, 4, 150);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 1, 3);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 2, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 4, 300);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 5, 300);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (6, 2, 4);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (6, 5, 400);

SELECT * FROM list_of_medicaments ;


SELECT insurance_company AS "pojišťovna", COUNT(id) AS "počet pacientů"
FROM patient
GROUP BY insurance_company
ORDER BY insurance_company;

SELECT CONCAT(a.street, ' ', a.street_number) AS "ulice", COUNT(p.id) AS "počet pacientů"
FROM patient AS p
JOIN address AS a ON p.address_id = a.id
GROUP BY a.street, a.street_number
ORDER BY a.street, a.street_number;

-- 1.Získej počet léků v kategoriích rozdělených dle jejich jednotky (atribut unit).

SELECT*,
count(id)
FROM medicament m 
GROUP BY unit;

SELECT unit AS "jednotka", COUNT(id) AS "počet léků v kategorii"
FROM medicament
GROUP BY unit
ORDER BY unit;

-- 2.Seřaď pacienty (jméno a příjmení) sestupně podle vydaných receptů společně s vypsaným počtem těchto receptů.

SELECT CONCAT(p.name, ' ', p.surname) AS "pacient", COUNT(pre.id) AS "počet receptů pro pacienta"
FROM prescription AS pre
JOIN patient AS p ON pre.patient_id = p.id
GROUP BY p.id
ORDER BY p.name, p.surname;

-- 3. Vypiš počty léků, které byly předepsány pacientům a prodávají se v balíčcích (ne v mililitrech). 
-- Prodané léky chceme seskupit podle jejich identifikátoru a také pojišťovny, do které pacient spadá. 
-- Na výstupu budou tedy tři sloupce – pojišťovna, lék a počet prodaných balíčků.

SELECT p.insurance_company AS "pojišťovna", m.name AS "lék", SUM(lm.amount) AS "prodaných balíčků"
FROM prescription AS pre
JOIN patient AS p ON pre.patient_id = p.id
JOIN list_of_medicaments AS lm ON pre.id = lm.prescription_id
JOIN medicament AS m ON lm.medicament_id = m.id
WHERE m.unit = 'package'
GROUP BY p.insurance_company, m.id
ORDER BY p.insurance_company;

-- HAVING

SELECT unit AS "sledované typy jednotky"
FROM medicament
GROUP BY unit
HAVING SUM(price_insurance + price_patient) > 50;

-- Můžeme se také databáze zeptat, na identifikátory lékařů, kteří vydali více než 5 receptů:

SELECT d.id AS "identifikátor lékaře", COUNT(pre.id) AS "počet vydaných receptů"
FROM prescription AS pre
INNER JOIN doctor AS d ON pre.doctor_id = d.id
GROUP BY d.id
HAVING COUNT(pre.id) > 5;

-- 1. Vypiš pouze ty pojišťovny, které mají jednoho a více registrovaných pacientů.

SELECT insurance_company 
FROM patient p 
GROUP BY insurance_company 
HAVING count(id) >= 1;

-- 2. Vyzkoušej předchozí dotaz obohatit o seřazení výsledků od nejpočetnější pojišťovny po tu nejméně početnou.

SELECT insurance_company, count(id) 
FROM patient p 
GROUP BY insurance_company 
HAVING count(id) >= 1
ORDER BY count(id) DESC ;

-- 3. Zjisti, zda pacienti, jejichž křestní jméno je Petr nebo Libor měli alespoň jednou vystavený recept.
-- Pokud ano, vypiš jejich jméno, příjmení a počet receptů.

SELECT p.name AS "jméno", p.surname AS "příjmení", COUNT(pre.id) AS "počet receptů"
FROM prescription AS pre
INNER JOIN patient AS p ON pre.patient_id = p.id
WHERE name = 'Petr' OR name = 'Libor'
GROUP BY name, surname
HAVING COUNT(pre.id) >= 1;

SELECT AVG(price_patient) AS "průměrný doplatek na léky"
FROM medicament;

SELECT COUNT(id) AS "počet receptů, které pacienti uplatnili"
FROM prescription
WHERE is_released = true;

SELECT MAX(price_insurance + price_patient) AS "cena nejdražšího léku"
FROM medicament;

SELECT SUM(price_insurance) > SUM(price_patient) AS "Jsou příspěvky pojišťoven větší než doplatky pacientů?"
FROM medicament;

SELECT name, surname
FROM doctor
UNION
SELECT name, surname
FROM patient;

SELECT * FROM prescription p ;

SELECT * FROM list_of_medicaments ;


SELECT name, surname
FROM doctor
WHERE address_id IN (SELECT id
    FROM address
    WHERE city = 'Engetov');

SELECT id
FROM address
WHERE city = 'Engetov';

SELECT CONCAT(street, ' ', street_number, ', ', city) AS "Adresa",
    (SELECT COUNT(id)
    FROM patient AS p
    WHERE p.address_id = a.id) AS "Počet pacientů na adrese"
FROM address AS a;

-- CASE

SELECT id AS "ID pacienta", 
	CASE 
		insurance_company WHEN 'Engeto insurance' THEN true 
		ELSE false 
		END AS "Je v naší pojišťovně?"
FROM patient AS p;

SELECT p.id AS "ID pacienta", 
	CASE 
		WHEN p.insurance_company = 'Engeto insurance' THEN true 
		ELSE false 
		END AS "Je v naší pojišťovně?"
FROM patient AS p;

SELECT p.id AS "ID pacienta", CASE WHEN p.insurance_company != 'Engeto insurance' THEN false ELSE true END AS "Je v naší pojišťovně?"
FROM patient AS p;

-- Bez ELSE - Vypustka

SELECT *
FROM patient AS p
WHERE CASE WHEN p.insurance_company = 'Engeto insurance' THEN true END;

SELECT p.id AS "ID pacienta",
    CASE p.insurance_company WHEN 'Engeto insurance'
        THEN
            CASE a.street_number WHEN 1
                THEN CONCAT('Spadá do naší pojišťovny a žije na adrese ', a.street, ' ', a.street_number)
                ELSE 'Spadá do naší pojišťovny, ale nebydlí na adrese, která nás zajímá  '
            END
        ELSE 'Nespadá do naší pojišťovny'
    END AS "Status pacienta"
FROM patient AS p
JOIN address AS a ON a.id = p.address_id
ORDER BY p.id;

-- 1.Vypiš jména a příjmení pacientů, kterým je přiřazený recept, který ještě nebyl vydán (is_released = false).

SELECT CONCAT (name, ' ', surname) AS "Jméno pacienta"
FROM patient 
WHERE id IN (SELECT DISTINCT patient_id 
    FROM prescription 
    WHERE is_released = false
);



SELECT * FROM prescription p ;

SELECT * FROM patient p ;





















