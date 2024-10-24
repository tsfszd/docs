CREATE TABLE IF NOT EXISTS `apam_master_document_model_field` (
  `master_document_model_id` INT UNSIGNED NOT NULL,
  `master_document_model_field_id` INT UNSIGNED NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `model_def_field_id` INT UNSIGNED NOT NULL,
  `model_def_field_parse_type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`master_document_model_id`,`master_document_model_field_id`),
  KEY `FK_apam_model_field__apai_model_def_field_parse_type` (`model_def_field_parse_type_id`),
  CONSTRAINT `FK_apam_master_document_model` FOREIGN KEY (`master_document_model_id`) REFERENCES `apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apam_model_field__apai_model_def_field_parse_type` FOREIGN KEY (`model_def_field_parse_type_id`) REFERENCES `apai_model_def_field_parse_type` (`model_def_field_parse_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

