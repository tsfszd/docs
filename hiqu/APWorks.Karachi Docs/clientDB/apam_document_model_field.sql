CREATE TABLE IF NOT EXISTS `apam_document_model_field` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `master_document_model_field_id` INT unsigned NOT NULL,
  `default_value` VARCHAR(32) NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`),
  CONSTRAINT `FK_apam_document_model_field_1` FOREIGN KEY (`company_code`, `master_document_model_id`) REFERENCES `apam_document_model` (`company_code`, `master_document_model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

