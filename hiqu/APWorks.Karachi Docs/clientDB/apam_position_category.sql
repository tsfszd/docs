CREATE TABLE IF NOT EXISTS `apam_position_category` (
  `company_code` INT NOT NULL,
  `position_category_code` INT NOT NULL,
  `position_category_name` varchar(64) NOT NULL,
  `protected_role_flag` INT NOT NULL,
  PRIMARY KEY (`company_code`,`position_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_position_category';

