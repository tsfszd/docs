CREATE TABLE IF NOT EXISTS `apam_company` (
  `company_code` int NOT NULL,
  `co_short_name` varchar(16) NOT NULL,
  `co_name` varchar(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  `addr_street1` varchar(64) DEFAULT NULL,
  `addr_street2` varchar(64) DEFAULT NULL,
  `addr_street3` varchar(64) DEFAULT NULL,
  `addr_city` varchar(64) DEFAULT NULL,
  `addr_state_province` varchar(16) DEFAULT NULL,
  `addr_zip_postcode` varchar(16) DEFAULT NULL,
  `tel_area` varchar(64) DEFAULT NULL,
  `tel_number` varchar(64) DEFAULT NULL,
  `nexelus_s3_storage_connection_string` varchar(512) DEFAULT NULL,
  `client_ftp_site_connection_string` varchar(1024) NOT NULL,
  `nexelus_owned_storage_flag` char(1) NOT NULL,
  `client_owned_storage_flag` char(1) NOT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

