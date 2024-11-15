DELIMITER $$
DROP PROCEDURE IF EXISTS apas_approvalstampconfiguration_get;$$

CREATE PROCEDURE apas_approvalstampconfiguration_get
(
	IN company_code_param               INT,
	IN master_document_model_id_param   VARCHAR(12)
)
BEGIN
	DECLARE approval_stamp_configuration_id_param INT UNSIGNED;
	SET approval_stamp_configuration_id_param = (SELECT approval_stamp_configuration_id FROM apam_approval_stamp_configuration WHERE company_code = company_code_param AND master_document_model_id = master_document_model_id_param);

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
		approval_stamp_configuration_id = approval_stamp_configuration_id_param
		OR (approval_stamp_configuration_id_param IS NULL AND company_code = company_code_param AND master_document_model_id IS NULL);
END$$
DELIMITER ;

