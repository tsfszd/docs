CREATE TABLE IF NOT EXISTS `apad_invoice_document_routing_history` (
  `company_code` INT NOT NULL,
  `invoice_document_id` INT unsigned NOT NULL,
  `sequence_id` INT unsigned NOT NULL,
  `approval_level` INT unsigned NOT NULL,
  `invoice_document_status_id` INT unsigned NOT NULL,
  `approval_rejection_comment` varchar(1024) DEFAULT NULL,
  `approval_rejection_update_date` datetime NOT NULL,
  `approval_rejection_user_id` varchar(32) NOT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`sequence_id`),
  KEY `FK_apad_invoice_document_routing_history_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_routing_history_2` (`invoice_document_status_id`),
  CONSTRAINT `FK_apad_invoice_document_routing_history_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_routing_history_2` FOREIGN KEY (`invoice_document_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_status` (`invoice_document_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

