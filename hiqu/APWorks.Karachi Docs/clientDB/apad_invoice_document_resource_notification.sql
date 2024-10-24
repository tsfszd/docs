CREATE TABLE IF NOT EXISTS `apad_invoice_document_resource_notification` (
  `company_code` INT NOT NULL,
  `invoice_document_id` INT unsigned NOT NULL,
  `resource_id` char(16) NOT NULL,
  `notification_date` datetime NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`resource_id`),
  KEY `FK_apad_invoice_document_resource_notification_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_resource_notification_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_notification_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_notification_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

