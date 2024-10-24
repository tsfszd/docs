CREATE TABLE IF NOT EXISTS `apad_email_log`
(
  `record_id`               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_code`            INT NOT NULL,
  `recipients`              VARCHAR(1024) NOT NULL,
  `subject`                 VARCHAR(256) NOT NULL,
  `body`                    VARCHAR(1024) NOT NULL,
  `date_time_sent`          DATETIME NOT NULL,
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
