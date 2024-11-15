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

CREATE TABLE IF NOT EXISTS `apad_cost_codes` (
  `company_code` INT NOT NULL,
  `cost_type` INT NOT NULL,
  `res_type` INT NOT NULL,
  `effective_date` DATETIME NOT NULL,
  `rtype_name` VARCHAR(32) NULL,
  `rtype_description` VARCHAR(64) NULL,
  PRIMARY KEY (`company_code`, `res_type`, `cost_type`, `effective_date`),
  INDEX `FK_apad_cost_codes_1_idx` (`company_code` ASC, `cost_type` ASC),
  CONSTRAINT `FK_apad_cost_codes_1`
    FOREIGN KEY (`company_code` , `cost_type`)
    REFERENCES `apam_cost_types` (`company_code` , `cost_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_document_manual_upload` (
  `document_manual_upload_record_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `document_manual_upload_file_location` varchar(1024) NOT NULL,
  `document_manual_upload_file_update_date` datetime NOT NULL,
  `scanned_flag` char(1) NOT NULL,
  `scanner_monitor_record_id` INT unsigned DEFAULT NULL,
  `document_model_request_id` INT unsigned DEFAULT NULL,
  `invoice_document_id` INT unsigned DEFAULT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`document_manual_upload_record_id`),
  KEY `FK_apad_document_manual_upload_1` (`company_code`,`resource_id`),
  KEY `FK_apad_document_manual_upload_2` (`scanner_monitor_record_id`),
  KEY `FK_apad_document_manual_upload_3` (`document_model_request_id`),
  KEY `FK_apad_document_manual_upload_4` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_document_manual_upload_5` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_document_manual_upload_1` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`),
  CONSTRAINT `FK_apad_document_manual_upload_2` FOREIGN KEY (`scanner_monitor_record_id`) REFERENCES `apad_invoice_scanner_monitor` (`scanner_monitor_record_id`),
  CONSTRAINT `FK_apad_document_manual_upload_3` FOREIGN KEY (`document_model_request_id`) REFERENCES `apam_document_model_request` (`document_model_request_id`),
  CONSTRAINT `FK_apad_document_manual_upload_4` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_document_manual_upload_5` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_email_log`
(
  `record_id`               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_code`            INT NOT NULL,
  `recipients`              VARCHAR(1024) NOT NULL,
  `subject`                 VARCHAR(256) NOT NULL,
  `body`                    VARCHAR(1024) NOT NULL,
  `date_time_sent`          DATETIME NOT NULL,
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `apad_invoice_document` (
  `company_code` INT NOT NULL,
  `invoice_document_id` INT UNSIGNED NOT NULL,
  `invoice_document_file_location` VARCHAR(1024) NULL DEFAULT NULL,
  `invoice_document_status_id` INT UNSIGNED NOT NULL,
  `invoice_document_status_attribute` CHAR(1) NULL DEFAULT NULL,
  `duplicate_invoice_flag` CHAR(1) NOT NULL,
  `master_document_model_id` INT UNSIGNED NULL DEFAULT NULL,
  `document_model_request_id` INT UNSIGNED NULL DEFAULT NULL,
  `vendor_code` VARCHAR(12) NULL DEFAULT NULL,
  `site_id` VARCHAR(32) NULL DEFAULT NULL,
  `invoice_number` VARCHAR(32) NULL DEFAULT NULL,
  `invoice_date` DATE NULL DEFAULT NULL,
  `due_date` DATE NULL DEFAULT NULL,
  `service_term_start_date` DATE NULL DEFAULT NULL,
  `service_term_end_date` DATE NULL DEFAULT NULL,
  `payment_term_code` VARCHAR(32) NULL DEFAULT NULL,
  `currency_code` VARCHAR(32) NULL DEFAULT NULL,
  `scanned_total` DOUBLE NOT NULL DEFAULT 0,
  `po_code` VARCHAR(32) NULL,
  `replaced_by_invoice_document_file_location` VARCHAR(1024) NULL DEFAULT NULL,
  `transaction_id` VARCHAR(32) NULL,
  `is_deleted` TINYINT NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  `create_id` VARCHAR(32) NOT NULL,
  `create_date` DATETIME NOT NULL,
  `modify_id` VARCHAR(32) NULL DEFAULT NULL,
  `modify_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`company_code`, `invoice_document_id`),
  KEY `FK_apad_invoice_document_1` (`invoice_document_status_id` ASC),
  KEY `FK_apad_invoice_document_2` (`master_document_model_id` ASC),
  KEY `FK_apad_invoice_document__apam_document_model_request` (`document_model_request_id` ASC),
  KEY `FK_apad_invoice_document_3` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_invoice_document_1` FOREIGN KEY (`invoice_document_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_status` (`invoice_document_status_id`),
  CONSTRAINT `FK_apad_invoice_document_2` FOREIGN KEY (`master_document_model_id`) REFERENCES {COMMON_DATABASE}.`apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apad_invoice_document__apam_document_model_request` FOREIGN KEY (`document_model_request_id`) REFERENCES `apam_document_model_request` (`document_model_request_id`),
  CONSTRAINT `FK_apad_invoice_document_3` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

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

CREATE TABLE IF NOT EXISTS `apad_invoice_document_resource_notification` (
  `company_code` INT NOT NULL,
  `invoice_document_id` INT unsigned NOT NULL,
  `resource_id` char(16) NOT NULL,
  `notification_date` datetime NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`resource_id`),
  KEY `FK_apad_invoice_document_resource_notification_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_resource_notification_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_notification_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_notification_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_invoice_document_resource_routing_history` (
  `company_code`        INT NOT NULL,
  `invoice_document_id` INT UNSIGNED NOT NULL,
  `sequence_id`         INT UNSIGNED NOT NULL,
  `resource_id`         CHAR(16) NOT NULL,
  `comments`            VARCHAR(1024) DEFAULT NULL,
  `suggestion_flag`     CHAR(1) DEFAULT 'N' NOT NULL,
  `create_id`           VARCHAR(32) NOT NULL,
  `create_date`         DATETIME NOT NULL,
  `modify_id`           VARCHAR(32) NULL,
  `modify_date`         DATETIME NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`sequence_id`, `resource_id`),
  KEY `FK_apad_invoice_document_resource_routing_history_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_resource_routing_history_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_routing_history_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_resource_routing_history_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_invoice_document_routing_history` (
  `company_code` INT NOT NULL,
  `invoice_document_id` INT unsigned NOT NULL,
  `sequence_id` INT unsigned NOT NULL,
  `approval_level` INT unsigned NOT NULL,
  `invoice_document_status_id` INT unsigned NOT NULL,
  `approval_rejection_comment` varchar(1024) DEFAULT NULL,
  `approval_rejection_update_date` datetime NOT NULL,
  `approval_rejection_user_id` varchar(32) NOT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`sequence_id`),
  KEY `FK_apad_invoice_document_routing_history_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_routing_history_2` (`invoice_document_status_id`),
  CONSTRAINT `FK_apad_invoice_document_routing_history_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_document_routing_history_2` FOREIGN KEY (`invoice_document_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_status` (`invoice_document_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_invoice_posting_monitor` (
  `posting_monitor_record_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `invoice_document_id` INT unsigned NOT NULL,
  `invoice_document_posting_status_id` INT unsigned NOT NULL,
  `invoice_document_posting_update_date` datetime NOT NULL,
  `invoice_document_posting_duration` INT unsigned DEFAULT NULL,
  `invoice_document_posting_error_message` varchar(1024) DEFAULT NULL,
  `invoice_document_posting_process_tag_string` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`posting_monitor_record_id`),
  KEY `FK_apad_invoice_posting_monitor_1` (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_posting_monitor_2` (`invoice_document_posting_status_id`),
  CONSTRAINT `FK_apad_invoice_posting_monitor_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`),
  CONSTRAINT `FK_apad_invoice_posting_monitor_2` FOREIGN KEY (`invoice_document_posting_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_posting_status` (`invoice_document_posting_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_invoice_scanner_monitor` (
  `scanner_monitor_record_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `invoice_document_file_location` varchar(1024) NOT NULL,
  `invoice_document_scan_status_id` INT unsigned NOT NULL,
  `manual_upload_flag` char(1) NOT NULL,
  `invoice_document_scan_update_date` datetime NOT NULL,
  `invoice_document_scan_duration` INT unsigned DEFAULT NULL,
  `invoice_document_scan_error_message` varchar(1024) DEFAULT NULL,
  `invoice_document_scanner_process_tag_string` varchar(1024) DEFAULT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`scanner_monitor_record_id`),
  KEY `FK_apad_invoice_scanner_monitor_1` (`invoice_document_scan_status_id`),
  KEY `FK_apad_invoice_scanner_monitor_2` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_invoice_scanner_monitor_1` FOREIGN KEY (`invoice_document_scan_status_id`) REFERENCES {COMMON_DATABASE}.`apai_invoice_document_scan_status` (`invoice_document_scan_status_id`),
  CONSTRAINT `FK_apad_invoice_scanner_monitor_2` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_level2` (
  `company_code` INT NOT NULL,
  `level2_key` VARCHAR(32) NOT NULL,
  `level2_description` VARCHAR(128) NULL,
  `level2_status_id` INT UNSIGNED NOT NULL,
  `open_date` DATETIME NULL,
  `customer_code` VARCHAR(16) NULL,
  `customer_name` VARCHAR(64) NULL,
  `customer_po_number` VARCHAR(16) NULL,
  `po_required_flag` CHAR(1) DEFAULT NULL,
  `tolerance_po_flag` CHAR(1) DEFAULT NULL,
  `tolerance_po_amount` DECIMAL(6, 2) DEFAULT 0,
  PRIMARY KEY (`company_code`, `level2_key`),
  INDEX `FK_apad_level2_1_idx` (`level2_status_id` ASC),
  CONSTRAINT `FK_apad_level2_1`
    FOREIGN KEY (`level2_status_id`)
    REFERENCES {COMMON_DATABASE}.`apai_level2_status` (`level2_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_level2_resources` (
  `company_code` INT NOT NULL,
  `level2_key` VARCHAR(32) NOT NULL,
  `resource_id` CHAR(16) NOT NULL,
  `position_category_code` INT NOT NULL,
  `effective_date` DATETIME NOT NULL,
  PRIMARY KEY (`company_code`, `level2_key`, `resource_id`, `position_category_code`, `effective_date`),
  INDEX `FK_apad_level2_resources_2_idx` (`company_code` ASC, `resource_id` ASC),
  CONSTRAINT `FK_apad_level2_resources_1`
    FOREIGN KEY (`company_code` , `level2_key`)
    REFERENCES `apad_level2` (`company_code` , `level2_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apad_level2_resources_2`
    FOREIGN KEY (`company_code` , `resource_id`)
    REFERENCES `apad_resources` (`company_code` , `resource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apad_level2_resources_3`
    FOREIGN KEY (`company_code`)
    REFERENCES `apam_position_category` (`company_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_level3` (
  `company_code` INT NOT NULL,
  `level2_key` VARCHAR(32) NOT NULL,
  `level3_key` VARCHAR(32) NOT NULL,
  `level3_description` VARCHAR(45) NULL,
  `level3_status_id` INT UNSIGNED NOT NULL,
  `open_date` DATETIME NULL,
  `cost_type` INT NULL,
  `customer_po_number` VARCHAR(16) NULL,
  `expense_flag` TINYINT NULL,
  PRIMARY KEY (`company_code`, `level2_key`, `level3_key`),
  INDEX `FK_apad_level3_2_idx` (`level3_status_id` ASC),
  CONSTRAINT `FK_apad_level3_1`
    FOREIGN KEY (`company_code` , `level2_key`)
    REFERENCES `apad_level2` (`company_code` , `level2_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apad_level3_2`
    FOREIGN KEY (`level3_status_id`)
    REFERENCES {COMMON_DATABASE}.`apai_level3_status` (`level3_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_level3_resources` (
  `company_code` INT NOT NULL,
  `level2_key` VARCHAR(32) NOT NULL,
  `level3_key` VARCHAR(32) NOT NULL,
  `resource_id` CHAR(16) NOT NULL,
  `position_category_code` INT NOT NULL,
  PRIMARY KEY (`company_code`, `level2_key`, `level3_key`, `resource_id`, `position_category_code`),
  INDEX `FK_apad_level3_resources_2_idx` (`company_code` ASC, `resource_id` ASC),
  INDEX `FK_apad_level3_resources_3_idx` (`company_code` ASC, `position_category_code` ASC),
  CONSTRAINT `FK_apad_level3_resources_1`
    FOREIGN KEY (`company_code` , `level2_key` , `level3_key`)
    REFERENCES `apad_level3` (`company_code` , `level2_key` , `level3_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apad_level3_resources_2`
    FOREIGN KEY (`company_code` , `resource_id`)
    REFERENCES `apad_resources` (`company_code` , `resource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apad_level3_resources_3`
    FOREIGN KEY (`company_code` , `position_category_code`)
    REFERENCES `apam_position_category` (`company_code` , `position_category_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_po_detail` (
  `company_code`        INT NOT NULL,
  `po_code`             VARCHAR(32) NOT NULL,
  `line_id`             INT NOT NULL,
  `level2_key`          VARCHAR(32) NULL,
  `level3_key`          VARCHAR(32) NULL,
  `cost_category`       INT NOT NULL,
  `due_date`            DATETIME NULL,
  `quantity`            DOUBLE NOT NULL,
  `net_cost`            DOUBLE NOT NULL,
  `match_to_date_net`   DOUBLE NOT NULL,
  `close_flag`          TINYINT NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `line_id`),
  CONSTRAINT `FK_apad_po_detail_1` FOREIGN KEY (`company_code` , `po_code`) REFERENCES `apad_po_header` (`company_code` , `po_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_po_header` (
  `company_code` INT NOT NULL,
  `po_code` VARCHAR(32) NOT NULL,
  `vendor_code` VARCHAR(12) NOT NULL,
  `site_id` VARCHAR(32) NOT NULL,
  `po_amount` DOUBLE NOT NULL,
  `consumed_amount` DOUBLE NOT NULL,
  `client_code` VARCHAR(32) NULL DEFAULT '',
  `client_name` VARCHAR(256) NULL DEFAULT '',
  `job_code` VARCHAR(32) NULL DEFAULT '',
  `campaign_name` VARCHAR(512) NULL DEFAULT '',
  `activity_code` VARCHAR(64) NULL DEFAULT '',
  `media_plan_name` VARCHAR(512) NULL DEFAULT '',
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  `active_flag` TINYINT NULL,
  `po_date` DATETIME NULL,
  `currency_code` VARCHAR(32),
  `payment_term_code` VARCHAR(32),
  `due_date` DATETIME NULL,
  PRIMARY KEY (`company_code`, `po_code`),
  KEY `FK_apad_po_header_1` (`model_def_id` ASC),
  CONSTRAINT `FK_apad_po_header_1` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_po_media_delivery` (
  `company_code` INT NOT NULL,
  `po_code` VARCHAR(32) NOT NULL,
  `delivery_date` DATETIME NOT NULL,
  `delivery_amount` DOUBLE NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `delivery_date`),
  CONSTRAINT `FK_apad_po_media_delivery_1`
    FOREIGN KEY (`company_code` , `po_code`)
    REFERENCES `apad_po_header` (`company_code` , `po_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apad_po_resources` (
  `company_code` INT NOT NULL,
  `po_code` VARCHAR(32) NOT NULL,
  `resource_id` CHAR(16) NOT NULL,
  `position_category_code` INT NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `resource_id`, `position_category_code`),
  KEY `FK_apad_po_resources_2` (`company_code` ASC, `resource_id` ASC),
  KEY `FK_apad_po_resources_1` (`company_code` ASC, `position_category_code` ASC),
  CONSTRAINT `FK_apad_po_resources_1`
    FOREIGN KEY (`company_code` , `position_category_code`)
    REFERENCES `apam_position_category` (`company_code` , `position_category_code`),
  CONSTRAINT `FK_apad_po_resources_2`
    FOREIGN KEY (`company_code` , `resource_id`)
    REFERENCES `apad_resources` (`company_code` , `resource_id`),
  CONSTRAINT `FK_apad_po_resources_3`
    FOREIGN KEY (`company_code` , `po_code`)
    REFERENCES `apad_po_header` (`company_code` , `po_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'imported as join query from pdd_po_dtl, pdd_level3_resource';

CREATE TABLE IF NOT EXISTS `apad_resources` (
  `company_code` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `name_last` varchar(32) NOT NULL,
  `name_first` varchar(32) NOT NULL,
  `name_init` varchar(1) DEFAULT NULL,
  `title` varchar(64) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `login_id` varchar(64) DEFAULT NULL,
  `res_password` varchar(256) DEFAULT NULL,
  `active_flag` TINYINT(1) NOT NULL,
  `password_reset_flag` char(1) DEFAULT 'N',
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdd_resources';

CREATE TABLE IF NOT EXISTS `apad_user_roles` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `user_role_name` varchar(64) DEFAULT NULL,
  `is_admin_role` char(1) NOT NULL,
  `allow_routing_setup` char(1) NOT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`),
  CONSTRAINT `FK_apad_user_roles_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_user_roles_invoice_rights` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `allow_non_mapped_invoices_request_processing` CHAR(1) NOT NULL,
  `allow_invoice_model_mapping` CHAR(1) NOT NULL,
  `allow_invoice_auto_routing` CHAR(1) NOT NULL,
  `allow_invoice_manual_processing` CHAR(1) NOT NULL,
  `allow_invoice_document_management` CHAR(1) NOT NULL,
  `allow_invoice_correction` CHAR(1) NOT NULL,
  `allow_invoice_level_1_approval` CHAR(1) NOT NULL,
  `allow_invoice_level_2_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_3_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_4_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_5_approval` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`model_def_id`),
  KEY `FK_apad_user_roles_invoice_rights_2_idx` (`model_def_id`),
  CONSTRAINT `FK_apad_user_roles_invoice_rights_1` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`),
  CONSTRAINT `FK_apad_user_roles_invoice_rights_2` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_user_roles_resource` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`resource_id`),
  KEY `FK_apad_resource_groups_resource_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_user_roles_resource_1` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`),
  CONSTRAINT `FK_apad_user_roles_resource_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_user_role_position_categories` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `position_category_code` INT NOT NULL DEFAULT '0',
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`position_category_code`),
  KEY `FK_apad_user_role_position_categories_1` (`company_code`,`position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_1` FOREIGN KEY (`company_code`, `position_category_code`) REFERENCES `apam_position_category` (`company_code`, `position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_2` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_vendors` (
  `company_code` INT NOT NULL,
  `vendor_code` varchar(12) NOT NULL,
  `site_id` varchar(32) NOT NULL DEFAULT '',
  `vendor_name` varchar(256) NOT NULL,
  `short_name` varchar(128) DEFAULT NULL,
  `addr1` varchar(64) DEFAULT NULL,
  `addr2` varchar(64) DEFAULT NULL,
  `addr3` varchar(64) DEFAULT NULL,
  `addr4` varchar(64) DEFAULT NULL,
  `addr5` varchar(64) DEFAULT NULL,
  `addr6` varchar(64) DEFAULT NULL,
  `attention_name` varchar(64) DEFAULT NULL,
  `attention_phone` varchar(32) DEFAULT NULL,
  `contact_name` varchar(64) DEFAULT NULL,
  `contact_phone` varchar(32) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `phone_1` varchar(32) DEFAULT NULL,
  `phone_2` varchar(32) DEFAULT NULL,
  `tax_code` varchar(16) DEFAULT NULL,
  `terms_code` varchar(64) DEFAULT NULL,
  `currency_code` char(8) DEFAULT NULL,
  `vendor_status_id` INT unsigned DEFAULT NULL,
  `no_po_flag` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`vendor_code`,`site_id`),
  KEY `FK_apad_vendors_1` (`company_code`),
  KEY `FK_apad_vendors_2` (`terms_code`),
  KEY `FK_apad_vendors_3` (`currency_code`),
  KEY `FK_apad_vendors_4` (`company_code`,`vendor_status_id`),
  CONSTRAINT `FK_apad_vendors_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`),
  CONSTRAINT `FK_apad_vendors_2` FOREIGN KEY (`terms_code`) REFERENCES `apam_payment_terms` (`terms_code`),
  CONSTRAINT `FK_apad_vendors_3` FOREIGN KEY (`currency_code`) REFERENCES `apam_currencies` (`currency_code`),
  CONSTRAINT `FK_apad_vendors_4` FOREIGN KEY (`company_code`, `vendor_status_id`) REFERENCES `apam_vendor_status` (`company_code`, `vendor_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apad_vendor_ext_fields` (
  `company_code` INT NOT NULL,
  `vendor_code` varchar(12) NOT NULL,
  `site_id` varchar(32) NOT NULL DEFAULT '',
  `ext_field_code` varchar(32) NOT NULL DEFAULT '',
  `ext_field_value` varchar(8000) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`vendor_code`,`site_id`,`ext_field_code`),
  KEY `FK_apad_vendor_ext_fields_1` (`company_code`,`vendor_code`,`site_id`),
  KEY `FK_apad_vendor_ext_fields_2` (`company_code`,`ext_field_code`),
  CONSTRAINT `FK_apad_vendor_ext_fields_1` FOREIGN KEY (`company_code`, `vendor_code`, `site_id`) REFERENCES `apad_vendors` (`company_code`, `vendor_code`, `site_id`),
  CONSTRAINT `FK_apad_vendor_ext_fields_2` FOREIGN KEY (`company_code`, `ext_field_code`) REFERENCES `apam_vendor_ext_field` (`company_code`, `ext_field_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_approval_stamp_configuration`
(
  `approval_stamp_configuration_id` INT UNSIGNED NOT NULL,
  `company_code`                    INT NOT NULL,
  `master_document_model_id`        INT UNSIGNED NULL,
  `html`                            VARCHAR(1024) NOT NULL,
  `top`                             INT UNSIGNED NOT NULL,
  `left`                            INT UNSIGNED NOT NULL,
  `width`                           INT UNSIGNED NOT NULL,
  `height`                          INT UNSIGNED NOT NULL,
  `text_format_settings`            VARCHAR(1024) NULL,
  `create_id`                       VARCHAR(32) NOT NULL,
  `create_date`                     DATETIME NOT NULL,
  PRIMARY KEY (`approval_stamp_configuration_id`),
  KEY `FK_apam_approval_stamp_configuration_1` (`company_code`),
  KEY `FK_apam_approval_stamp_configuration_2` (`company_code`, `master_document_model_id`),
  CONSTRAINT `FK_apam_approval_stamp_configuration_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apam_company` (
  `company_code` int NOT NULL,
  `co_short_name` varchar(16) NOT NULL,
  `co_name` varchar(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  `addr_street1` varchar(64) DEFAULT NULL,
  `addr_street2` varchar(64) DEFAULT NULL,
  `addr_street3` varchar(64) DEFAULT NULL,
  `addr_city` varchar(64) DEFAULT NULL,
  `addr_state_province` varchar(16) DEFAULT NULL,
  `addr_zip_postcode` varchar(16) DEFAULT NULL,
  `tel_area` varchar(64) DEFAULT NULL,
  `tel_number` varchar(64) DEFAULT NULL,
  `nexelus_s3_storage_connection_string` varchar(512) DEFAULT NULL,
  `client_ftp_site_connection_string` varchar(1024) NOT NULL,
  `nexelus_owned_storage_flag` char(1) NOT NULL,
  `client_owned_storage_flag` char(1) NOT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_company_approval_configuration` (
  `company_code` INT NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `routing_number_of_approval_levels` INT NULL DEFAULT NULL,
  `approval_level_1_short_name` VARCHAR(64) NOT NULL,
  `approval_level_1_name` VARCHAR(64) NOT NULL,
  `approval_level_1_status_name` VARCHAR(64) NOT NULL,
  `approval_level_1_accept_name` VARCHAR(64) NOT NULL,
  `approval_level_1_reject_name` VARCHAR(64) NOT NULL,
  `approval_level_1_allow_invoice_editing_flag` CHAR(1) NOT NULL,
  `approval_level_2_short_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_2_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_2_status_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_2_accept_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_2_reject_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_2_allow_invoice_editing_flag` CHAR(1) NULL DEFAULT NULL,
  `approval_level_3_short_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_3_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_3_status_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_3_accept_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_3_reject_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_3_allow_invoice_editing_flag` CHAR(1) NULL DEFAULT NULL,
  `approval_level_4_short_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_4_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_4_status_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_4_accept_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_4_reject_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_4_allow_invoice_editing_flag` CHAR(1) NULL DEFAULT NULL,
  `approval_level_5_short_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_5_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_5_status_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_5_accept_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_5_reject_name` VARCHAR(64) NULL DEFAULT NULL,
  `approval_level_5_allow_invoice_editing_flag` CHAR(1) NULL DEFAULT NULL,
  PRIMARY KEY (`company_code`, `model_def_id`),
  INDEX `FK_apam_company_approval_configuration_2_idx` (`model_def_id` ASC),
  CONSTRAINT `FK_apam_company_approval_configuration_1`
    FOREIGN KEY (`company_code`)
    REFERENCES `apam_company` (`company_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apam_company_approval_configuration_2`
    FOREIGN KEY (`model_def_id`)
    REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apam_company_invoice_configuration` (
  `company_code` INT NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL DEFAULT 1,
  `invoice_collection_email_string` VARCHAR(1024) NULL DEFAULT NULL,
  `invoice_collection_email_flag` CHAR(1) NOT NULL,
  `use_delivery_amount_for_matching` CHAR(1) NULL DEFAULT NULL,
  `auto_post_invoice` CHAR(1) NOT NULL DEFAULT '',
  `email_reminder_cron_expression` VARCHAR(64) NULL DEFAULT '* * * * * * *',
  `email_reminder_last_execution_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`company_code`, `model_def_id`),
  INDEX `FK_apam_company_invoice_configuration_2_idx` (`model_def_id` ASC),
  CONSTRAINT `FK_apam_company_invoice_configuration_1`
    FOREIGN KEY (`company_code`)
    REFERENCES `apam_company` (`company_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_apam_company_invoice_configuration_2`
    FOREIGN KEY (`model_def_id`)
    REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apam_cost_types` (
  `company_code` INT NOT NULL,
  `cost_type` INT NOT NULL,
  `cost_type_name` VARCHAR(16) NOT NULL,
  `cost_type_description` VARCHAR(64) NULL,
  `cost_type_status` TINYINT NOT NULL,
  `effective_date` DATETIME NOT NULL,
  `expiration_date` DATETIME NULL,
  PRIMARY KEY (`company_code`, `cost_type`))
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apam_currencies` (
  `currency_code` char(8) NOT NULL,
  `currency_name` varchar(16) NOT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_currencies';

CREATE TABLE IF NOT EXISTS `apam_currencies_map` (
  `apam_invoice_currency_code` char(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  PRIMARY KEY (`apam_invoice_currency_code`),
  KEY `FK_apam_currencies_map_1` (`currency_code`),
  CONSTRAINT `FK_apam_currencies_map_1` FOREIGN KEY (`currency_code`) REFERENCES `apam_currencies` (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_data_last_updated` (
  `company_code` INT NOT NULL,
  `table_name` VARCHAR(32) NOT NULL,
  `last_updated` DATETIME NOT NULL,
  PRIMARY KEY (`company_code`, `table_name`),
  CONSTRAINT `FK_apam_data_last_updated_1`
    FOREIGN KEY (`company_code`)
    REFERENCES `apam_company` (`company_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `apam_document_model` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `document_model_name` varchar(64) NOT NULL,
  `document_model_name_tag` varchar(32) DEFAULT NULL,
  `vendor_code` varchar(12) DEFAULT NULL,
  `site_id` varchar(32) DEFAULT NULL,
  `invoice_document_sample_file_location` varchar(1024) NOT NULL,
  `document_model_status_id` INT unsigned NOT NULL,
  `document_model_is_active` char(1) NOT NULL,
  `document_model_comments` varchar(512) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`),
  UNIQUE KEY `apam_document_model_I1` (`company_code`,`document_model_name`,`document_model_name_tag`),
  KEY `FK_apam_document_model_1` (`master_document_model_id`),
  KEY `FK_apam_document_model_2` (`document_model_status_id`),
  CONSTRAINT `FK_apam_document_model_1` FOREIGN KEY (`master_document_model_id`) REFERENCES {COMMON_DATABASE}.`apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apam_document_model_2` FOREIGN KEY (`document_model_status_id`) REFERENCES {COMMON_DATABASE}.`apai_document_model_status` (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_document_model_field` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `master_document_model_field_id` INT unsigned NOT NULL,
  `default_value` VARCHAR(32) NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`),
  CONSTRAINT `FK_apam_document_model_field_1` FOREIGN KEY (`company_code`, `master_document_model_id`) REFERENCES `apam_document_model` (`company_code`, `master_document_model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_document_model_field_detail` (
  `company_code` INT NOT NULL,
  `master_document_model_id` INT unsigned NOT NULL,
  `master_document_model_field_id` INT unsigned NOT NULL,
  `master_document_model_field_seq_id` INT unsigned NOT NULL,
  `field_sample_value` varchar(128) NOT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`,`master_document_model_field_seq_id`),
  CONSTRAINT `FK_apam_document_model_field_detail_1` FOREIGN KEY (`company_code`, `master_document_model_id`, `master_document_model_field_id`) REFERENCES `apam_document_model_field` (`company_code`, `master_document_model_id`, `master_document_model_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_document_model_request` (
  `document_model_request_id` INT unsigned NOT NULL,
  `company_code` INT NOT NULL,
  `scanner_monitor_record_id` INT unsigned DEFAULT NULL,
  `request_to_map` char(1) NOT NULL,
  `manual_processing` char(1) NOT NULL,
  `request_completed` char(1) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`document_model_request_id`),
  KEY `FK_apam_document_model_request__scanner_monitor_record_id` (`scanner_monitor_record_id`),
  CONSTRAINT `FK_apam_document_model_request__scanner_monitor_record_id` FOREIGN KEY (`scanner_monitor_record_id`) REFERENCES `apad_invoice_scanner_monitor` (`scanner_monitor_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_payment_terms` (
  `terms_code` varchar(64) NOT NULL,
  `terms_desc` varchar(64) NOT NULL,
  `days_due` INT NOT NULL,
  PRIMARY KEY (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdv_terms';

CREATE TABLE IF NOT EXISTS `apam_payment_terms_map` (
  `apam_invoice_terms_code` varchar(64) NOT NULL,
  `terms_code` varchar(64) NOT NULL,
  PRIMARY KEY (`apam_invoice_terms_code`),
  KEY `FK_apam_payment_terms_map_1` (`terms_code`),
  CONSTRAINT `FK_apam_payment_terms_map_1` FOREIGN KEY (`terms_code`) REFERENCES `apam_payment_terms` (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_position_category` (
  `company_code` INT NOT NULL,
  `position_category_code` INT NOT NULL,
  `position_category_name` varchar(64) NOT NULL,
  `protected_role_flag` INT NOT NULL,
  PRIMARY KEY (`company_code`,`position_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_position_category';

CREATE TABLE IF NOT EXISTS `apam_registration` (
  `registration_record_id` INT NOT NULL,
  `registration_business_name` varchar(128) NOT NULL,
  `registration_business_addr1` varchar(128) DEFAULT NULL,
  `registration_business_addr2` varchar(128) DEFAULT NULL,
  `registration_business_city` varchar(128) DEFAULT NULL,
  `registration_business_state` varchar(32) DEFAULT NULL,
  `registration_business_zip` varchar(128) DEFAULT NULL,
  `registration_business_phone` varchar(128) DEFAULT NULL,
  `registration_business_email` varchar(128) DEFAULT NULL,
  `admin_login` varchar(128) NOT NULL,
  `admin_password` varchar(128) DEFAULT NULL,
  `s3_storage_root_folder` varchar(1024) DEFAULT NULL,
  `is_trial_flag` char(1) NOT NULL,
  `trial_expiration_date` date DEFAULT NULL,
  `license_key` varchar(256) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`registration_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_vendor_ext_field` (
  `company_code` INT NOT NULL,
  `ext_field_code` varchar(32) NOT NULL,
  `ext_field_name` varchar(256) DEFAULT NULL,
  `ext_field_default_value` varchar(8000) DEFAULT NULL,
  `is_active` char(1) NOT NULL,
  PRIMARY KEY (`company_code`,`ext_field_code`),
  KEY `FK_apam_vendor_ext_field_1` (`company_code`),
  CONSTRAINT `FK_apam_vendor_ext_field_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `apam_vendor_status` (
  `company_code` INT NOT NULL,
  `vendor_status_id` INT unsigned NOT NULL,
  `vendor_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`company_code`,`vendor_status_id`),
  CONSTRAINT `FK_apam_vendor_status_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

