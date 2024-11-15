DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfield_update;$$

CREATE PROCEDURE apas_masterdocumentmodelfield_update(
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN model_def_field_id_param             INT UNSIGNED,
	IN model_def_field_parse_type_id_param  INT UNSIGNED
)
BEGIN
	UPDATE
		apam_master_document_model_field
	SET
		model_def_id                     = model_def_id_param,
		model_def_field_id               = model_def_field_id_param,
		model_def_field_parse_type_id    = model_def_field_parse_type_id_param
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param;
END$$
DELIMITER ;

