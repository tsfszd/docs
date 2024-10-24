CREATE TABLE IF NOT EXISTS `apad_invoice_document_resource_routing_history` (
  `company_code`        INT NOT NULL,
  `invoice_document_id` INT UNSIGNED NOT NULL,
  `sequence_id`         INT UNSIGNED NOT NULL,
  `resource_id`         CHAR(16) NOT NULL,
  `comments`            VARCHAR(1024) DEFAULT NULL,
  `suggestion_flag`     CHAR(1) DEFAULT 'N' NOT NULL,
  `create_id`           VARCHAR(32) NOT NULL,
  `create_date`         DATETIME NOT NULL,
  `modify_id`           VARCHAR(32) NULL,
  `modify_date`         DATETIME NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`sequence_id`, `resource_id`),
  KEY `FK_apad_invoice_document_resource_routing_history_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_resource_routing_history_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_routing_history_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_routing_history_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

