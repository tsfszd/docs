CREATE TABLE IF NOT EXISTS `apai_model_def` (
  `model_def_id` INT UNSIGNED NOT NULL,
  `master_def_name` varchar(64) NOT NULL,
  `model_def_recognition_threshold` INT UNSIGNED NOT NULL DEFAULT '75',
  PRIMARY KEY (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

