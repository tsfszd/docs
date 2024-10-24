CREATE TABLE IF NOT EXISTS `apad_resources` (
  `company_code` INT NOT NULL,
  `resource_id` char(16) NOT NULL,
  `name_last` varchar(32) NOT NULL,
  `name_first` varchar(32) NOT NULL,
  `name_init` varchar(1) DEFAULT NULL,
  `title` varchar(64) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `login_id` varchar(64) DEFAULT NULL,
  `res_password` varchar(256) DEFAULT NULL,
  `active_flag` TINYINT(1) NOT NULL,
  `password_reset_flag` char(1) DEFAULT 'N',
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdd_resources';

