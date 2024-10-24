DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfield_add;$$

CREATE PROCEDURE apas_masterdocumentmodelfield_add(
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN model_def_field_id_param             INT UNSIGNED,
	IN model_def_field_parse_type_id_param  INT UNSIGNED
)
BEGIN
	INSERT INTO apam_master_document_model_field
	(
		master_document_model_id,
		master_document_model_field_id,
		model_def_id,
		model_def_field_id,
		model_def_field_parse_type_id
	)
	SELECT
		master_document_model_id_param,
		master_document_model_field_id_param,
		model_def_id_param,
		model_def_field_id_param,
		model_def_field_parse_type_id_param;
END$$
DELIMITER ;

