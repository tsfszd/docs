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

