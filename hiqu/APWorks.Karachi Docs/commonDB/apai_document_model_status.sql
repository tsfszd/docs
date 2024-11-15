CREATE TABLE IF NOT EXISTS `apai_document_model_status` (
  `document_model_status_id` INT UNSIGNED NOT NULL,
  `document_model_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

