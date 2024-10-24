CREATE TABLE IF NOT EXISTS `apam_vendor_ext_field` (
  `company_code` INT NOT NULL,
  `ext_field_code` varchar(32) NOT NULL,
  `ext_field_name` varchar(256) DEFAULT NULL,
  `ext_field_default_value` varchar(8000) DEFAULT NULL,
  `is_active` char(1) NOT NULL,
  PRIMARY KEY (`company_code`,`ext_field_code`),
  KEY `FK_apam_vendor_ext_field_1` (`company_code`),
  CONSTRAINT `FK_apam_vendor_ext_field_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

