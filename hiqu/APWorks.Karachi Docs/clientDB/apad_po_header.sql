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

