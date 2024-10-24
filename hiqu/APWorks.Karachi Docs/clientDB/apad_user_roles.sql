CREATE TABLE IF NOT EXISTS `apad_user_roles` (
  `company_code` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `user_role_name` varchar(64) DEFAULT NULL,
  `is_admin_role` char(1) NOT NULL,
  `allow_routing_setup` char(1) NOT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`),
  CONSTRAINT `FK_apad_user_roles_1` FOREIGN KEY (`company_code`) REFERENCES `apam_company` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

