CREATE TABLE IF NOT EXISTS `apam_document_model_field_detail` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `master_document_model_field_id` INT unsigned NOT NULL,
  `master_document_model_field_seq_id` INT unsigned NOT NULL,
  `field_sample_value` varchar(128) NOT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`,`master_document_model_field_seq_id`),
  CONSTRAINT `FK_apam_document_model_field_detail_1` FOREIGN KEY (`company_code`, `master_document_model_id`, `master_document_model_field_id`) REFERENCES `apam_document_model_field` (`company_code`, `master_document_model_id`, `master_document_model_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

