DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelfield_add;$$

CREATE PROCEDURE apas_documentmodelfield_add(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN default_value_param                  VARCHAR(32)
)
BEGIN
	INSERT INTO  apam_document_model_field
	(
		company_code,
		master_document_model_id,
		master_document_model_field_id,
		default_value
	)
	SELECT
		company_code_param,
		master_document_model_id_param,
		master_document_model_field_id_param,
		default_value_param;
END$$
DELIMITER ;

