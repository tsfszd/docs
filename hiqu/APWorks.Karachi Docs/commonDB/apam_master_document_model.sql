CREATE TABLE IF NOT EXISTS `apam_master_document_model` (
  `master_document_model_id` INT UNSIGNED NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `master_document_model_comments` varchar(512) DEFAULT NULL,
  `is_active` char(1) NOT NULL DEFAULT 'N',
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`master_document_model_id`),
  KEY `FK_apam_master_document_model__apai_model_def` (`model_def_id`),
  CONSTRAINT `FK_apam_master_document_model__apai_model_def` FOREIGN KEY (`model_def_id`) REFERENCES `apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

