DELIMITER $$
DROP PROCEDURE IF EXISTS apas_company_updateemailreminderlastexecutiondate;$$

CREATE PROCEDURE apas_company_updateemailreminderlastexecutiondate(
	IN company_code_param                       INT,
	IN model_def_id_param                       INT UNSIGNED,
	IN email_reminder_last_execution_date_param DATETIME,
	IN modify_id_param                          VARCHAR(32),
	IN modify_date_param                        DATETIME
)
BEGIN
	UPDATE
		apam_company_invoice_configuration
	SET
		email_reminder_last_execution_date	= email_reminder_last_execution_date_param
	WHERE
		company_code = company_code_param
		AND model_def_id = model_def_id_param;
END$$
DELIMITER ;

