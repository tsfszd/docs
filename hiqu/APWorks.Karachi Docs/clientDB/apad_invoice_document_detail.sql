CREATE TABLE IF NOT EXISTS `apad_invoice_document_detail` (
   `company_code` INT NOT NULL,
  `invoice_document_id` INT UNSIGNED NOT NULL,
  `seq_id` INT UNSIGNED NOT NULL,
  `io_number` VARCHAR(64) DEFAULT NULL,
  `level2_key` VARCHAR(32) DEFAULT NULL,
  `level3_key` VARCHAR(32) DEFAULT NULL,
  `cost_type` INT DEFAULT NULL,
  `res_type` INT DEFAULT NULL,
  `io_description` VARCHAR(128) DEFAULT NULL,
  `quantity` DOUBLE DEFAULT NULL,
  `io_invoice_amount` DOUBLE DEFAULT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`seq_id`),
  CONSTRAINT `FK_apad_invoice_document_detail_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

