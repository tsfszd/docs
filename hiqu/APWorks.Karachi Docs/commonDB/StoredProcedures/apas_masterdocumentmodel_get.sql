DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_get;$$

CREATE PROCEDURE apas_masterdocumentmodel_get(
	IN master_document_model_id_param INT
)
BEGIN
	SELECT
		master_document_model_id,
		model_def_id,
		master_document_model_comments,
		is_active,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_master_document_model
	WHERE
		master_document_model_id = master_document_model_id_param;

	SELECT
		master_document_model_id,
		master_document_model_field_id,
		model_def_id,
		model_def_field_id,
		model_def_field_parse_type_id
	FROM
		apam_master_document_model_field
	WHERE
		master_document_model_id = master_document_model_id_param;

	SELECT
		master_document_model_id,
		master_document_model_field_id,
		master_document_model_field_seq_id,
		model_def_field_source_id,
		model_def_field_alignment_type_id,
        model_def_field_parse_type_id,
        block_id,
		field_format,
		classifier_text,
		page_number,
		table_number,
		table_row_index,
		table_col_index,
		boundingbox_left,
		boundingbox_top,
		boundingbox_width,
		boundingbox_height,
		confidence_level,
		internal_comment
	FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

