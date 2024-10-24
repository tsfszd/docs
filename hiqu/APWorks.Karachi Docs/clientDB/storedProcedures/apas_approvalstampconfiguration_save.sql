DELIMITER $$
DROP PROCEDURE IF EXISTS apas_approvalstampconfiguration_save;$$

CREATE PROCEDURE apas_approvalstampconfiguration_save
(
	IN company_code_param               INT,
	IN master_document_model_id_param   INT UNSIGNED,
	IN html_param                       VARCHAR(1024),
	IN top_param                        INT UNSIGNED,
	IN left_param                       INT UNSIGNED,
	IN width_param                      INT UNSIGNED,
	IN height_param                     INT UNSIGNED,
	IN text_format_settings_param       VARCHAR(1024),
	IN create_id_param                  VARCHAR(32),
	IN create_date_param                DATETIME
)
BEGIN
	DECLARE approval_stamp_configuration_id_param INT UNSIGNED;
	SELECT approval_stamp_configuration_id INTO approval_stamp_configuration_id_param FROM apam_approval_stamp_configuration WHERE company_code = company_code_param AND IFNULL(master_document_model_id, '') = IFNULL(master_document_model_id_param, '');

	IF ISNULL(approval_stamp_configuration_id_param) THEN
		SELECT (MAX(approval_stamp_configuration_id) + 1) AS approval_stamp_configuration_id INTO approval_stamp_configuration_id_param FROM apam_approval_stamp_configuration;

		IF ISNULL(approval_stamp_configuration_id_param) THEN
			SET approval_stamp_configuration_id_param = 1;
		END IF;

		INSERT INTO apam_approval_stamp_configuration
		(
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
		)
		SELECT
			approval_stamp_configuration_id_param,
			company_code_param,
			master_document_model_id_param,
			html_param,
			top_param,
			left_param,
			width_param,
			height_param,
			text_format_settings_param,
			create_id_param,
			create_date_param;
	ELSE
		UPDATE
			apam_approval_stamp_configuration
		SET
			html					 =  html_param,
			top						 =  top_param,
			`left`					 =  left_param,
			width					 =  width_param,
			height					 =  height_param,
			text_format_settings	 =  text_format_settings_param
		WHERE
			approval_stamp_configuration_id = approval_stamp_configuration_id_param;
	END IF;
END$$
DELIMITER ;

