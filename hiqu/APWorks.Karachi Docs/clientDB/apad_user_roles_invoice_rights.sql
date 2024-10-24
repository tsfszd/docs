CREATE TABLE IF NOT EXISTS `apad_user_roles_invoice_rights` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `model_def_id` INT UNSIGNED NOT NULL,
  `allow_non_mapped_invoices_request_processing` CHAR(1) NOT NULL,
  `allow_invoice_model_mapping` CHAR(1) NOT NULL,
  `allow_invoice_auto_routing` CHAR(1) NOT NULL,
  `allow_invoice_manual_processing` CHAR(1) NOT NULL,
  `allow_invoice_document_management` CHAR(1) NOT NULL,
  `allow_invoice_correction` CHAR(1) NOT NULL,
  `allow_invoice_level_1_approval` CHAR(1) NOT NULL,
  `allow_invoice_level_2_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_3_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_4_approval` CHAR(1) DEFAULT NULL,
  `allow_invoice_level_5_approval` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`model_def_id`),
  KEY `FK_apad_user_roles_invoice_rights_2_idx` (`model_def_id`),
  CONSTRAINT `FK_apad_user_roles_invoice_rights_1` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`),
  CONSTRAINT `FK_apad_user_roles_invoice_rights_2` FOREIGN KEY (`model_def_id`) REFERENCES {COMMON_DATABASE}.`apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

