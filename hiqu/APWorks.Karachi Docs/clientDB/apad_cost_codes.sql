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

