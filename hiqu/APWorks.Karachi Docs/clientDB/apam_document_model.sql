CREATE TABLE IF NOT EXISTS `apam_document_model` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `document_model_name` varchar(64) NOT NULL,
  `document_model_name_tag` varchar(32) DEFAULT NULL,
  `vendor_code` varchar(12) DEFAULT NULL,
  `site_id` varchar(32) DEFAULT NULL,
  `invoice_document_sample_file_location` varchar(1024) NOT NULL,
  `document_model_status_id` INT unsigned NOT NULL,
  `document_model_is_active` char(1) NOT NULL,
  `document_model_comments` varchar(512) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`),
  UNIQUE KEY `apam_document_model_I1` (`company_code`,`document_model_name`,`document_model_name_tag`),
  KEY `FK_apam_document_model_1` (`master_document_model_id`),
  KEY `FK_apam_document_model_2` (`document_model_status_id`),
  CONSTRAINT `FK_apam_document_model_1` FOREIGN KEY (`master_document_model_id`) REFERENCES {COMMON_DATABASE}.`apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apam_document_model_2` FOREIGN KEY (`document_model_status_id`) REFERENCES {COMMON_DATABASE}.`apai_document_model_status` (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

