DROP PROCEDURE IF EXISTS apas_email_log_write;

DELIMITER $$
CREATE PROCEDURE apas_email_log_write
(
	INOUT record_id_param   INT UNSIGNED,
	IN company_code_param   INT,
	IN recipients_param     VARCHAR(1024),
	IN subject_param        VARCHAR(256),
	IN body_param           VARCHAR(1024),
	IN date_time_sent_param DATETIME
)
BEGIN
	INSERT INTO apad_email_log
	(
		company_code,
		recipients,
		`subject`,
		body,
		date_time_sent
	)
	SELECT
		company_code_param,
		recipients_param,
		subject_param,
		body_param,
		date_time_sent_param;

	SELECT record_id_param = LAST_INSERT_ID();
END$$

DELIMITER ;

