CREATE TABLE IF NOT EXISTS `apad_po_resources` (
  `company_code` INT NOT NULL,
  `po_code` VARCHAR(32) NOT NULL,
  `resource_id` CHAR(16) NOT NULL,
  `position_category_code` INT NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `resource_id`, `position_category_code`),
  KEY `FK_apad_po_resources_2` (`company_code` ASC, `resource_id` ASC),
  KEY `FK_apad_po_resources_1` (`company_code` ASC, `position_category_code` ASC),
  CONSTRAINT `FK_apad_po_resources_1`
    FOREIGN KEY (`company_code` , `position_category_code`)
    REFERENCES `apam_position_category` (`company_code` , `position_category_code`),
  CONSTRAINT `FK_apad_po_resources_2`
    FOREIGN KEY (`company_code` , `resource_id`)
    REFERENCES `apad_resources` (`company_code` , `resource_id`),
  CONSTRAINT `FK_apad_po_resources_3`
    FOREIGN KEY (`company_code` , `po_code`)
    REFERENCES `apad_po_header` (`company_code` , `po_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'imported as join query from pdd_po_dtl, pdd_level3_resource';

