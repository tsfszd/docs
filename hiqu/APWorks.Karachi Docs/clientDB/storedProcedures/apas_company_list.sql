DELIMITER $$
DROP PROCEDURE IF EXISTS apas_company_list;$$

CREATE PROCEDURE apas_company_list()
BEGIN
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
	ORDER BY
		co_name;

	SELECT
		c.company_code,
		c.model_def_id,
		md.master_def_name,
		c.routing_number_of_approval_levels,
		c.approval_level_1_short_name,
		c.approval_level_1_name,
		c.approval_level_1_status_name,
		c.approval_level_1_accept_name,
		c.approval_level_1_reject_name,
		c.approval_level_1_allow_invoice_editing_flag,
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
		apam_company_approval_configuration c
		INNER JOIN {COMMON_DATABASE}.apai_model_def md ON md.model_def_id = c.model_def_id;

	SELECT
		c.company_code,
		c.model_def_id,
		md.master_def_name,
		c.invoice_collection_email_string,
		c.invoice_collection_email_flag,
		c.use_delivery_amount_for_matching,
		c.auto_post_invoice,
		c.email_reminder_cron_expression,
		c.email_reminder_last_execution_date
	FROM
		apam_company_invoice_configuration c
		INNER JOIN {COMMON_DATABASE}.apai_model_def md ON md.model_def_id = c.model_def_id;
END$$
DELIMITER ;

