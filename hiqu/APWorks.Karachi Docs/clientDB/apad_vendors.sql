CREATE TABLE IF NOT EXISTS `apad_vendors` (
  `company_code` INT NOT NULL,
  `vendor_code` varchar(12) NOT NULL,
  `site_id` varchar(32) NOT NULL DEFAULT '',
  `vendor_name` varchar(256) NOT NULL,
  `short_name` varchar(128) DEFAULT NULL,
  `addr1` varchar(64) DEFAULT NULL,
  `addr2` varchar(64) DEFAULT NULL,
  `addr3` varchar(64) DEFAULT NULL,
  `addr4` varchar(64) DEFAULT NULL,
  `addr5` varchar(64) DEFAULT NULL,
  `addr6` varchar(64) DEFAULT NULL,
  `attention_name` varchar(64) DEFAULT NULL,
  `attention_phone` varchar(32) DEFAULT NULL,
  `contact_name` varchar(64) DEFAULT NULL,
  `contact_phone` varchar(32) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `phone_1` varchar(32) DEFAULT NULL,
  `phone_2` varchar(32) DEFAULT NULL,
  `tax_code` varchar(16) DEFAULT NULL,
  `terms_code` varchar(64) DEFAULT NULL,
  `currency_code` char(8) DEFAULT NULL,
  `vendor_status_id` INT unsigned DEFAULT NULL,
  `no_po_flag` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`vendor_code`,`site_id`),
  KEY `FK_apad_vendors_1` (`company_code`),
  KEY `FK_apad_vendors_2` (`terms_code`),
  KEY `FK_apad_vendors_3` (`currency_code`),
  KEY `FK_apad_vendors_4` (`company_code`,`vendor_status_id`),
  CONSTRAINT `FK_apad_vendors_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`),
  CONSTRAINT `FK_apad_vendors_2` FOREIGN KEY (`terms_code`) REFERENCES `apam_payment_terms` (`terms_code`),
  CONSTRAINT `FK_apad_vendors_3` FOREIGN KEY (`currency_code`) REFERENCES `apam_currencies` (`currency_code`),
  CONSTRAINT `FK_apad_vendors_4` FOREIGN KEY (`company_code`, `vendor_status_id`) REFERENCES `apam_vendor_status` (`company_code`, `vendor_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

