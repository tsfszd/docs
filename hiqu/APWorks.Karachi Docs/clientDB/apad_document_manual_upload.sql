CREATE TABLE IF NOT EXISTS `apad_document_manual_upload` (
  `document_manual_upload_record_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `document_manual_upload_file_location` varchar(1024) NOT NULL,
  `document_manual_upload_file_update_date` datetime NOT NULL,
  `scanned_flag` char(1) NOT NULL,
  `scanner_monitor_record_id` INT unsigned DEFAULT NULL,
  `document_model_request_id` INT unsigned DEFAULT NULL,
  `invoice_document_id` INT unsigned DEFAULT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`document_manual_upload_record_id`),
  KEY `FK_apad_document_manual_upload_1` (`company_code`,`resource_id`),
  KEY `FK_apad_document_manual_upload_2` (`scanner_monitor_record_id`),
  KEY `FK_apad_document_manual_upload_3` (`document_model_request_id`),
  KEY `FK_apad_document_manual_upload_4` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_document_manual_upload_5` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_document_manual_upload_1` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`),
  CONSTRAINT `FK_apad_document_manual_upload_2` FOREIGN KEY (`scanner_monitor_record_id`) REFERENCES `apad_invoice_scanner_monitor` (`scanner_monitor_record_id`),
  CONSTRAINT `FK_apad_document_manual_upload_3` FOREIGN KEY (`document_model_request_id`) REFERENCES `apam_document_model_request` (`document_model_request_id`),
  CONSTRAINT `FK_apad_document_manual_upload_4` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_document_manual_upload_5` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

