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

