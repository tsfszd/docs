CREATE TABLE IF NOT EXISTS `apai_invoice_document_scan_status` (
  `invoice_document_scan_status_id` INT UNSIGNED NOT NULL,
  `invoice_document_scan_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`invoice_document_scan_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

