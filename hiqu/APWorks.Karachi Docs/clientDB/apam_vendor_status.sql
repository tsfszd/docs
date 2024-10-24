CREATE TABLE IF NOT EXISTS `apam_vendor_status` (
  `company_code` INT NOT NULL,
  `vendor_status_id` INT unsigned NOT NULL,
  `vendor_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`company_code`,`vendor_status_id`),
  CONSTRAINT `FK_apam_vendor_status_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

