DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelfield_update;$$

CREATE PROCEDURE apas_documentmodelfield_update(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN default_value_param                  VARCHAR(32)
)
BEGIN
	UPDATE
		apam_document_model_field
	SET
		default_value   = default_value_param
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param
		AND company_code                    = company_code_param;
END$$
DELIMITER ;

