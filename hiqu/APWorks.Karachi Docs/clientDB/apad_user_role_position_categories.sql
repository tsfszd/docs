CREATE TABLE IF NOT EXISTS `apad_user_role_position_categories` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `position_category_code` INT NOT NULL DEFAULT '0',
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`position_category_code`),
  KEY `FK_apad_user_role_position_categories_1` (`company_code`,`position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_1` FOREIGN KEY (`company_code`, `position_category_code`) REFERENCES `apam_position_category` (`company_code`, `position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_2` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

