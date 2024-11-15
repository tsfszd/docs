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

