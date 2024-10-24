CREATE TABLE IF NOT EXISTS `apam_currencies_map` (
  `apam_invoice_currency_code` char(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  PRIMARY KEY (`apam_invoice_currency_code`),
  KEY `FK_apam_currencies_map_1` (`currency_code`),
  CONSTRAINT `FK_apam_currencies_map_1` FOREIGN KEY (`currency_code`) REFERENCES `apam_currencies` (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

