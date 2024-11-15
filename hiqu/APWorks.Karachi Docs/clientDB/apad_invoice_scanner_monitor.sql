CREATE TABLE IF NOT EXISTS `apad_invoice_scanner_monitor` (
  `scanner_monitor_record_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `invoice_document_file_location` varchar(1024) NOT NULL,
  `invoice_document_scan_status_id` INT unsigned NOT NULL,
  `manual_upload_flag` char(1) NOT NULL,
  `invoice_document_scan_update_date` datetime NOT NULL,
  `invoice_document_scan_duration` INT unsigned DEFAULT NULL,
  `invoice_document_scan_error_message` varchar(1024) DEFAULT NULL,
  `invoice_document_scanner_process_tag_string` varchar(1024) DEFAULT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`scanner_monitor_record_id`),
  KEY `FK_apad_invoice_scanner_monitor_1` (`invoice_document_scan_status_id`),
  KEY `FK_apad_invoice_scanner_monitor_2` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_invoice_scanner_monitor_1` FOREIGN KEY (`invoice_document_scan_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_scan_status` (`invoice_document_scan_status_id`),
  CONSTRAINT `FK_apad_invoice_scanner_monitor_2` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

