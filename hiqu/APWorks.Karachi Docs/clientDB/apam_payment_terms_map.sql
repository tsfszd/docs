CREATE TABLE IF NOT EXISTS `apam_payment_terms_map` (
  `apam_invoice_terms_code` varchar(64) NOT NULL,
  `terms_code` varchar(64) NOT NULL,
  PRIMARY KEY (`apam_invoice_terms_code`),
  KEY `FK_apam_payment_terms_map_1` (`terms_code`),
  CONSTRAINT `FK_apam_payment_terms_map_1` FOREIGN KEY (`terms_code`) REFERENCES `apam_payment_terms` (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

