CREATE TABLE IF NOT EXISTS `apad_po_media_delivery` (
  `company_code` INT NOT NULL,
  `po_code` VARCHAR(32) NOT NULL,
  `delivery_date` DATETIME NOT NULL,
  `delivery_amount` DOUBLE NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `delivery_date`),
  CONSTRAINT `FK_apad_po_media_delivery_1`
    FOREIGN KEY (`company_code` , `po_code`)
    REFERENCES `apad_po_header` (`company_code` , `po_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

