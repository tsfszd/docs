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

