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

