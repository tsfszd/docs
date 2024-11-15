DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelfielddetail_update;$$

CREATE PROCEDURE apas_documentmodelfielddetail_update(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN master_document_model_field_seq_id_param INT UNSIGNED
)
BEGIN
	UPDATE
		apam_document_model_field_detail
	SET
		master_document_model_field_id     = master_document_model_field_id_param,
		master_document_model_field_seq_id = master_document_model_field_seq_id_param
	WHERE
		master_document_model_id    = master_document_model_id_param
		AND company_code            = company_code_param;
END$$
DELIMITER ;

