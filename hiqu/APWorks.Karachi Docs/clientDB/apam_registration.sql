CREATE TABLE IF NOT EXISTS `apam_registration` (
  `registration_record_id` INT NOT NULL,
  `registration_business_name` varchar(128) NOT NULL,
  `registration_business_addr1` varchar(128) DEFAULT NULL,
  `registration_business_addr2` varchar(128) DEFAULT NULL,
  `registration_business_city` varchar(128) DEFAULT NULL,
  `registration_business_state` varchar(32) DEFAULT NULL,
  `registration_business_zip` varchar(128) DEFAULT NULL,
  `registration_business_phone` varchar(128) DEFAULT NULL,
  `registration_business_email` varchar(128) DEFAULT NULL,
  `admin_login` varchar(128) NOT NULL,
  `admin_password` varchar(128) DEFAULT NULL,
  `s3_storage_root_folder` varchar(1024) DEFAULT NULL,
  `is_trial_flag` char(1) NOT NULL,
  `trial_expiration_date` date DEFAULT NULL,
  `license_key` varchar(256) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`registration_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

