DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodel_setactive;$$

CREATE PROCEDURE apas_documentmodel_setactive(
	IN company_code_param                            INT,
	IN master_document_model_id_param                INT UNSIGNED,
	IN document_model_is_active_param                CHAR(1),
	IN modify_id_param                               VARCHAR(32),
	IN modify_date_param                             DATETIME
)
BEGIN
	UPDATE
		apam_document_model
	SET
		company_code                            = company_code_param,
		master_document_model_id                = master_document_model_id_param,
		document_model_is_active                = document_model_is_active_param,
		modify_id                               = modify_id_param,
		modify_date                             = modify_date_param
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

