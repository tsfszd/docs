DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_update;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_update(
	IN master_document_model_id_param             INT UNSIGNED,
	IN master_document_model_field_id_param       INT UNSIGNED,
	IN master_document_model_field_seq_id_param   INT UNSIGNED,
	IN model_def_field_source_id_param            INT UNSIGNED,
	IN model_def_field_alignment_type_id_param    INT UNSIGNED,
	IN model_def_field_parse_type_id_param        INT UNSIGNED,
	IN block_id_param                             VARCHAR(38),
	IN field_format_param                         VARCHAR(128),
	IN classifier_text_param                      VARCHAR(128),
	IN page_number_param                          INT UNSIGNED,
	IN table_number_param                         INT UNSIGNED,
	IN table_row_index_param                      INT UNSIGNED,
	IN table_col_index_param                      INT UNSIGNED,
	IN boundingbox_left_param                     DECIMAL(24,20),
	IN boundingbox_top_param                      DECIMAL(24,20),
	IN boundingbox_width_param                    DECIMAL(24,20),
	IN boundingbox_height_param                   DECIMAL(24,20),
	IN confidence_level_param                     DECIMAL(24,20),
	IN internal_comment_param                     VARCHAR(1024)
)
BEGIN
	DELETE
	FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param;

	CALL apas_masterdocumentmodelfielddetail_add
	(
		master_document_model_id_param,
		master_document_model_field_id_param,
		master_document_model_field_seq_id_param,
		model_def_field_source_id_param,
		model_def_field_alignment_type_id_param,
		model_def_field_parse_type_id_param,
		block_id_param,
		field_format_param,
		classifier_text_param,
		page_number_param,
		table_number_param,
		table_row_index_param,
		table_col_index_param,
		boundingbox_left_param,
		boundingbox_top_param,
		boundingbox_width_param,
		boundingbox_height_param,
		confidence_level_param,
		internal_comment_param
	);
END$$
DELIMITER ;

