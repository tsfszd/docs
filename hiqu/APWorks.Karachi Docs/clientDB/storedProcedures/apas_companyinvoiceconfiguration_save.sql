DELIMITER $$
DROP PROCEDURE IF EXISTS apas_companyinvoiceconfiguration_save;$$

CREATE PROCEDURE apas_companyinvoiceconfiguration_save(
	IN company_code_param                                   INT,
	IN model_def_id_param                                   INT UNSIGNED,
	IN invoice_collection_email_flag_param                  CHAR(1), 
	IN invoice_collection_email_string_param                VARCHAR(128), 
	IN use_delivery_amount_for_matching_param               CHAR(1),
	IN auto_post_invoice_param                              CHAR(1),
	IN email_reminder_cron_expression_param                 VARCHAR(64)
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apam_company_invoice_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param) THEN
		INSERT INTO apam_company_invoice_configuration
		(
			company_code,
			model_def_id,
			invoice_collection_email_flag,
			invoice_collection_email_string,
			use_delivery_amount_for_matching,
			auto_post_invoice,
			email_reminder_cron_expression
		)
		SELECT
			company_code_param,
			model_def_id_param,
			invoice_collection_email_flag_param,
			invoice_collection_email_string_param,
			use_delivery_amount_for_matching_param,
			auto_post_invoice_param,
			email_reminder_cron_expression_param;
	ELSE
		UPDATE
			apam_company_invoice_configuration
		SET
			invoice_collection_email_flag		= invoice_collection_email_flag_param,
			invoice_collection_email_string		= invoice_collection_email_string_param,
			use_delivery_amount_for_matching    = use_delivery_amount_for_matching_param,
			auto_post_invoice					= auto_post_invoice_param,
			email_reminder_cron_expression		= email_reminder_cron_expression_param
		WHERE
			company_code = company_code_param
			AND model_def_id = model_def_id_param;
	END IF;
END$$
DELIMITER ;

