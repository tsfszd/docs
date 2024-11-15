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

