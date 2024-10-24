CREATE TABLE IF NOT EXISTS `apai_document_model_status` (
  `document_model_status_id` INT UNSIGNED NOT NULL,
  `document_model_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_invoice_document_posting_status` (
  `invoice_document_posting_status_id` INT UNSIGNED NOT NULL,
  `invoice_document_posting_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`invoice_document_posting_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_invoice_document_scan_status` (
  `invoice_document_scan_status_id` INT UNSIGNED NOT NULL,
  `invoice_document_scan_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`invoice_document_scan_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_invoice_document_status` (
  `invoice_document_status_id` INT UNSIGNED NOT NULL,
  `invoice_document_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`invoice_document_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS apai_level2_status (
  level2_status_id INT UNSIGNED NOT NULL,
  level2_status_name VARCHAR(64) NOT NULL,
  PRIMARY KEY (level2_status_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS apai_level3_status (
  level3_status_id INT UNSIGNED NOT NULL,
  level3_status_name VARCHAR(64) NOT NULL,
  PRIMARY KEY (level3_status_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_model_def` (
  `model_def_id` INT UNSIGNED NOT NULL,
  `master_def_name` varchar(64) NOT NULL,
  `model_def_recognition_threshold` INT UNSIGNED NOT NULL DEFAULT '75',
  PRIMARY KEY (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_model_def_field_alignment_type` (
  `model_def_field_alignment_type_id` INT UNSIGNED NOT NULL,
  `model_def_field_alignment_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_alignment_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_model_def_field_parse_type` (
  `model_def_field_parse_type_id` INT UNSIGNED NOT NULL,
  `model_def_field_parse_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_parse_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_model_def_field_source` (
  `model_def_field_source_id` INT UNSIGNED NOT NULL,
  `model_def_field_source_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apai_model_def_field_type` (
  `model_def_field_type_id` INT UNSIGNED NOT NULL,
  `model_def_field_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE IF NOT EXISTS `apam_master_document_model_field` (
  `master_document_model_id` INT UNSIGNED NOT NULL,
  `master_document_model_field_id` INT UNSIGNED NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `model_def_field_id` INT UNSIGNED NOT NULL,
  `model_def_field_parse_type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`master_document_model_id`,`master_document_model_field_id`),
  KEY `FK_apam_model_field__apai_model_def_field_parse_type` (`model_def_field_parse_type_id`),
  CONSTRAINT `FK_apam_master_document_model` FOREIGN KEY (`master_document_model_id`) REFERENCES `apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apam_model_field__apai_model_def_field_parse_type` FOREIGN KEY (`model_def_field_parse_type_id`) REFERENCES `apai_model_def_field_parse_type` (`model_def_field_parse_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_master_document_model_field_detail` (
  `master_document_model_id` INT UNSIGNED NOT NULL,
  `master_document_model_field_id` INT UNSIGNED NOT NULL,
  `master_document_model_field_seq_id` INT UNSIGNED NOT NULL,
  `model_def_field_source_id` INT UNSIGNED NOT NULL,
  `model_def_field_alignment_type_id` INT UNSIGNED NOT NULL,
  `model_def_field_parse_type_id` INT UNSIGNED NOT NULL DEFAULT '20',
  `block_id` varchar(38) NOT NULL DEFAULT '',
  `field_format` varchar(128) DEFAULT NULL,
  `classifier_text` varchar(128) DEFAULT NULL,
  `page_number` INT UNSIGNED DEFAULT NULL,
  `table_number` INT UNSIGNED DEFAULT NULL,
  `table_row_index` INT UNSIGNED DEFAULT NULL,
  `table_col_index` INT UNSIGNED DEFAULT NULL,
  `boundingbox_left` decimal(24,20) DEFAULT NULL,
  `boundingbox_top` decimal(24,20) DEFAULT NULL,
  `boundingbox_width` decimal(24,20) DEFAULT NULL,
  `boundingbox_height` decimal(24,20) DEFAULT NULL,
  `confidence_level` decimal(24,20) DEFAULT NULL,
  `internal_comment` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`master_document_model_id`,`master_document_model_field_id`,`master_document_model_field_seq_id`),
  KEY `FK_apam_master_document_model_field_detail_1` (`master_document_model_id`,`master_document_model_field_id`),
  KEY `FK_apam_master_document_model_field_detail_2` (`model_def_field_source_id`),
  KEY `FK_apam_master_document_model_field_detail_3` (`model_def_field_alignment_type_id`),
  KEY `FK_apam_master_document_model_field_detail_4_idx` (`model_def_field_parse_type_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_1` FOREIGN KEY (`master_document_model_id`, `master_document_model_field_id`) REFERENCES `apam_master_document_model_field` (`master_document_model_id`, `master_document_model_field_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_2` FOREIGN KEY (`model_def_field_source_id`) REFERENCES `apai_model_def_field_source` (`model_def_field_source_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_3` FOREIGN KEY (`model_def_field_alignment_type_id`) REFERENCES `apai_model_def_field_alignment_type` (`model_def_field_alignment_type_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_4` FOREIGN KEY (`model_def_field_parse_type_id`) REFERENCES `apai_model_def_field_parse_type` (`model_def_field_parse_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

