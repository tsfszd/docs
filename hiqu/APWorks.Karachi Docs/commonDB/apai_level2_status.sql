CREATE TABLE IF NOT EXISTS apai_level2_status (
  level2_status_id INT UNSIGNED NOT NULL,
  level2_status_name VARCHAR(64) NOT NULL,
  PRIMARY KEY (level2_status_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

