CREATE TABLE IF NOT EXISTS `apai_model_field_def` (
  `model_def_id` INT UNSIGNED NOT NULL,
  `model_def_field_id` INT UNSIGNED NOT NULL,
  `model_def_field_name` varchar(64) NOT NULL,
  `model_def_screen_label_name` varchar(64) NOT NULL,
  `model_def_field_order` INT UNSIGNED NOT NULL,
  `model_def_field_required` char(1) NOT NULL,
  `model_def_field_type_id` INT UNSIGNED NOT NULL,
  `model_def_field_weightage` INT UNSIGNED NOT NULL DEFAULT '0',
  `target_db_table_name` varchar(128) DEFAULT NULL,
  `target_db_field_name` varchar(128) DEFAULT NULL,
  `lookup_sql_view_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`model_def_id`,`model_def_field_id`),
  KEY `FK_apai_model_field_def__apai_model_def_field_type` (`model_def_field_type_id`),
  CONSTRAINT `FK_apai_model_field_def__apai_model_def` FOREIGN KEY (`model_def_id`) REFERENCES `apai_model_def` (`model_def_id`),
  CONSTRAINT `FK_apai_model_field_def__apai_model_def_field_type` FOREIGN KEY (`model_def_field_type_id`) REFERENCES `apai_model_def_field_type` (`model_def_field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

