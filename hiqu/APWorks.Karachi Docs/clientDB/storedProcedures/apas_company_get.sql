DELIMITER $$
DROP PROCEDURE IF EXISTS apas_company_get;$$

CREATE PROCEDURE apas_company_get(
	IN company_code_param INT
)
BEGIN
	DECLARE u_one INT;
	SET u_one = 1;

	SELECT
		company_code,
		co_short_name, 
		co_name, 
		currency_code,
		addr_street1, 
		addr_street2, 
		addr_street3, 
		addr_city, 
		addr_state_province, 
		addr_zip_postcode, 
		tel_area, 
		tel_number, 
		nexelus_s3_storage_connection_string, 
		client_ftp_site_connection_string, 
		nexelus_owned_storage_flag,
		client_owned_storage_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_company
	WHERE
		company_code = company_code_param
	ORDER BY
		co_name;

	SELECT
		company_code_param AS company_code,
		md.model_def_id,
		md.master_def_name,
		IFNULL(c.routing_number_of_approval_levels, u_one) AS routing_number_of_approval_levels,
		IFNULL(c.approval_level_1_short_name, '') AS approval_level_1_short_name,
		IFNULL(c.approval_level_1_name, '') AS approval_level_1_name,
		IFNULL(c.approval_level_1_status_name, '') AS approval_level_1_status_name,
		IFNULL(c.approval_level_1_accept_name, '') AS approval_level_1_accept_name,
		IFNULL(c.approval_level_1_reject_name, '') AS approval_level_1_reject_name,
		IFNULL(c.approval_level_1_allow_invoice_editing_flag, 'N') AS approval_level_1_allow_invoice_editing_flag,
		c.approval_level_2_short_name,
		c.approval_level_2_name,
		c.approval_level_2_status_name,
		c.approval_level_2_accept_name,
		c.approval_level_2_reject_name,
		c.approval_level_2_allow_invoice_editing_flag,
		c.approval_level_3_short_name,
		c.approval_level_3_name,
		c.approval_level_3_status_name,
		c.approval_level_3_accept_name,
		c.approval_level_3_reject_name,
		c.approval_level_3_allow_invoice_editing_flag,
		c.approval_level_4_short_name,
		c.approval_level_4_name,
		c.approval_level_4_status_name,
		c.approval_level_4_accept_name,
		c.approval_level_4_reject_name,
		c.approval_level_4_allow_invoice_editing_flag,
		c.approval_level_5_short_name,
		c.approval_level_5_name,
		c.approval_level_5_status_name,
		c.approval_level_5_accept_name,
		c.approval_level_5_reject_name,
		c.approval_level_5_allow_invoice_editing_flag
	FROM
		{COMMON_DATABASE}.apai_model_def md
		LEFT OUTER JOIN apam_company_approval_configuration c ON md.model_def_id = c.model_def_id AND c.company_code = company_code_param;

	SELECT
		company_code_param AS company_code,
		md.model_def_id,
		md.master_def_name,
		c.invoice_collection_email_string,
		IFNULL(c.invoice_collection_email_flag, 'N') AS invoice_collection_email_flag,
		IFNULL(c.use_delivery_amount_for_matching, 'N') AS use_delivery_amount_for_matching,
		IFNULL(c.auto_post_invoice, 'N') AS auto_post_invoice,
		IFNULL(c.email_reminder_cron_expression, '* * * * * * *') AS email_reminder_cron_expression,
		c.email_reminder_last_execution_date
	FROM
		{COMMON_DATABASE}.apai_model_def md
		LEFT OUTER JOIN apam_company_invoice_configuration c ON md.model_def_id = c.model_def_id AND c.company_code = company_code_param;

	SELECT
		approval_stamp_configuration_id,
		company_code,
		master_document_model_id,
		html,
		top,
		`left`,
		width,
		height,
		text_format_settings,
		create_id,
		create_date
	FROM
		apam_approval_stamp_configuration
	WHERE
		company_code = company_code_param
		AND master_document_model_id IS NULL;
END$$
DELIMITER ;

