CREATE TABLE `doctors` (
  `id_doc` serial,
  `first_name` varchar(15),
  `last_name` varchar(20),
  `adress_id` varchar(128),
  `phone_number` int,
  `email_adress` varchat(64)
);

CREATE TABLE `adress` (
  `id` serial,
  `street` varchar(32),
  `street_number` int,
  `city` varchar(64),
  `zip_code` varchar(5)
);

CREATE TABLE `Patients` (
  `id_pac` serial,
  `first_name` varchar(64),
  `last_name` varchar(64),
  `adress` varchar(64),
  `name_insurance` varchar(64)
);

CREATE TABLE `Medicines` (
  `id` serial,
  `name` varchar(32),
  `price_pacient` int,
  `price_insurance` int,
  `unit` varchar(32)
);

CREATE TABLE `Prescription` (
  `id` serial,
  `id_doctor` int,
  `id_pacient` int,
  `valid_from` datetime,
  `valit_to` datetime,
  `is_released` boolean
);

CREATE TABLE `list_of_medicaments` (
  `prescription_id` int,
  `medicament_id` int,
  `amount` int
);

ALTER TABLE `doctors` ADD FOREIGN KEY (`adress_id`) REFERENCES `adress` (`id`);

ALTER TABLE `Patients` ADD FOREIGN KEY (`adress`) REFERENCES `adress` (`id`);

ALTER TABLE `Prescription` ADD FOREIGN KEY (`id_doctor`) REFERENCES `doctors` (`id_doc`);

ALTER TABLE `Prescription` ADD FOREIGN KEY (`id_pacient`) REFERENCES `Patients` (`id_pac`);

ALTER TABLE `list_of_medicaments` ADD FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`id`);

ALTER TABLE `list_of_medicaments` ADD FOREIGN KEY (`medicament_id`) REFERENCES `Medicines` (`id`);
