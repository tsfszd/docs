CREATE TABLE IF NOT EXISTS `apam_approval_stamp_configuration`
(
  `approval_stamp_configuration_id` INT UNSIGNED NOT NULL,
  `company_code`                    INT NOT NULL,
  `master_document_model_id`        INT UNSIGNED NULL,
  `html`                            VARCHAR(1024) NOT NULL,
  `top`                             INT UNSIGNED NOT NULL,
  `left`                            INT UNSIGNED NOT NULL,
  `width`                           INT UNSIGNED NOT NULL,
  `height`                          INT UNSIGNED NOT NULL,
  `text_format_settings`            VARCHAR(1024) NULL,
  `create_id`                       VARCHAR(32) NOT NULL,
  `create_date`                     DATETIME NOT NULL,
  PRIMARY KEY (`approval_stamp_configuration_id`),
  KEY `FK_apam_approval_stamp_configuration_1` (`company_code`),
  KEY `FK_apam_approval_stamp_configuration_2` (`company_code`, `master_document_model_id`),
  CONSTRAINT `FK_apam_approval_stamp_configuration_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

