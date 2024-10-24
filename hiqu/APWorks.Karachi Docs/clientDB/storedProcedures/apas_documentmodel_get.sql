DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodel_get;$$

CREATE PROCEDURE apas_documentmodel_get
(
	IN company_code_param               INT,
	IN master_document_model_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		company_code,
		master_document_model_id,
		document_model_name,
		document_model_name_tag,
		vendor_code,
		site_id,
		invoice_document_sample_file_location,
		document_model_status_id,
		document_model_is_active,
		document_model_comments,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_document_model
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;

	SELECT
		company_code,
		master_document_model_id,
		master_document_model_field_id,
		default_value
	FROM
		apam_document_model_field
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;

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
		AND master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

