CREATE TABLE IF NOT EXISTS `apam_currencies` (
  `currency_code` char(8) NOT NULL,
  `currency_name` varchar(16) NOT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_currencies';

