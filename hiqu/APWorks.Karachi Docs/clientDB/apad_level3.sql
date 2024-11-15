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

