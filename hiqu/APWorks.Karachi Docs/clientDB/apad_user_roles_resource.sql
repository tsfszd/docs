CREATE TABLE IF NOT EXISTS `apad_user_roles_resource` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`resource_id`),
  KEY `FK_apad_resource_groups_resource_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_user_roles_resource_1` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`),
  CONSTRAINT `FK_apad_user_roles_resource_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

