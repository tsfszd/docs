CREATE TABLE IF NOT EXISTS `apam_payment_terms` (
  `terms_code` varchar(64) NOT NULL,
  `terms_desc` varchar(64) NOT NULL,
  `days_due` INT NOT NULL,
  PRIMARY KEY (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdv_terms';

