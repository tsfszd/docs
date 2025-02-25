DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelfielddetail_add;$$

CREATE PROCEDURE apas_documentmodelfielddetail_add(
	IN company_code_param                       INT,
	IN master_document_model_id_param           INT UNSIGNED,
	IN master_document_model_field_id_param     INT UNSIGNED,
	IN master_document_model_field_seq_id_param INT UNSIGNED,
	IN field_sample_value_param                 VARCHAR(128)
)
BEGIN
	INSERT INTO  apam_document_model_field_detail
	(
		company_code,
		master_document_model_id,
		master_document_model_field_id,
		master_document_model_field_seq_id,
		field_sample_value
	)
	SELECT
		company_code_param,
		master_document_model_id_param,
		master_document_model_field_id_param,
		master_document_model_field_seq_id_param,
		field_sample_value_param;
END$$
DELIMITER ;

