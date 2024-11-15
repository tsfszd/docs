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

