CREATE TABLE IF NOT EXISTS `apam_document_model_request` (
  `document_model_request_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `scanner_monitor_record_id` INT unsigned DEFAULT NULL,
  `request_to_map` char(1) NOT NULL,
  `manual_processing` char(1) NOT NULL,
  `request_completed` char(1) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`document_model_request_id`),
  KEY `FK_apam_document_model_request__scanner_monitor_record_id` (`scanner_monitor_record_id`),
  CONSTRAINT `FK_apam_document_model_request__scanner_monitor_record_id` FOREIGN KEY (`scanner_monitor_record_id`) REFERENCES `apad_invoice_scanner_monitor` (`scanner_monitor_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

