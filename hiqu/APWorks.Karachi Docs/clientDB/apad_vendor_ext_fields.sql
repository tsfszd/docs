CREATE TABLE IF NOT EXISTS `apad_vendor_ext_fields` (
  `company_code` INT NOT NULL,
  `vendor_code` varchar(12) NOT NULL,
  `site_id` varchar(32) NOT NULL DEFAULT '',
  `ext_field_code` varchar(32) NOT NULL DEFAULT '',
  `ext_field_value` varchar(8000) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`vendor_code`,`site_id`,`ext_field_code`),
  KEY `FK_apad_vendor_ext_fields_1` (`company_code`,`vendor_code`,`site_id`),
  KEY `FK_apad_vendor_ext_fields_2` (`company_code`,`ext_field_code`),
  CONSTRAINT `FK_apad_vendor_ext_fields_1` FOREIGN KEY (`company_code`, `vendor_code`, `site_id`) REFERENCES `apad_vendors` (`company_code`, `vendor_code`, `site_id`),
  CONSTRAINT `FK_apad_vendor_ext_fields_2` FOREIGN KEY (`company_code`, `ext_field_code`) REFERENCES `apam_vendor_ext_field` (`company_code`, `ext_field_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

