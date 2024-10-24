CREATE TABLE IF NOT EXISTS `apad_ap_payment`
(
  `company_code`    INT NOT NULL,
  `vendor_code`     VARCHAR(12) NOT NULL,
  `check_number`    VARCHAR(64) NOT NULL,
  `invoice_number`  VARCHAR(64) NOT NULL,
  `document_date`   DATETIME NOT NULL,
  `payment_amount`  DECIMAL(19, 2) NOT NULL,
  PRIMARY KEY (`company_code`, `vendor_code`, `check_number`, `invoice_number`, `document_date`),
  KEY `FK_apad_ap_payment_1` (`company_code`),
  KEY `FK_apad_ap_payment_2` (`company_code`, `vendor_code`),
  CONSTRAINT `FK_apad_ap_payment_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`),
  CONSTRAINT `FK_apad_ap_payment_2` FOREIGN KEY (`company_code`, `vendor_code`) REFERENCES `apad_vendors` (`company_code`, `vendor_code`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

