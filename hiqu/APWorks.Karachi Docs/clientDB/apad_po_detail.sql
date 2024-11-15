CREATE TABLE IF NOT EXISTS `apad_po_detail` (
  `company_code`        INT NOT NULL,
  `po_code`             VARCHAR(32) NOT NULL,
  `line_id`             INT NOT NULL,
  `level2_key`          VARCHAR(32) NULL,
  `level3_key`          VARCHAR(32) NULL,
  `cost_category`       INT NOT NULL,
  `due_date`            DATETIME NULL,
  `quantity`            DOUBLE NOT NULL,
  `net_cost`            DOUBLE NOT NULL,
  `match_to_date_net`   DOUBLE NOT NULL,
  `close_flag`          TINYINT NOT NULL,
  PRIMARY KEY (`company_code`, `po_code`, `line_id`),
  CONSTRAINT `FK_apad_po_detail_1` FOREIGN KEY (`company_code` , `po_code`) REFERENCES `apad_po_header` (`company_code` , `po_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

