DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_list;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_list(
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		d.master_document_model_id,
		d.master_document_model_field_id,
		d.master_document_model_field_seq_id,
		d.model_def_field_source_id,
		d.model_def_field_alignment_type_id,
		d.model_def_field_parse_type_id,
		d.block_id,
		d.field_format,
		d.classifier_text,
		d.page_number,
		d.table_number,
		d.table_row_index,
		d.table_col_index,
		d.boundingbox_left,
		d.boundingbox_top,
		d.boundingbox_width,
		d.boundingbox_height,
		d.confidence_level,
		d.internal_comment,
		f.model_def_field_id,
		mfd.model_def_field_weightage,
		md.model_def_recognition_threshold
	FROM
		apam_master_document_model_field_detail d
		INNER JOIN apam_master_document_model_field f ON f.master_document_model_id = d.master_document_model_id
													AND d.master_document_model_field_id = f.master_document_model_field_id
		INNER JOIN apam_master_document_model m ON m.master_document_model_id = f.master_document_model_id
													AND m.model_def_id = f.model_def_id
		INNER JOIN apai_model_field_def mfd ON mfd.model_def_field_id = f.model_def_field_id
												AND mfd.model_def_id = f.model_def_id
		INNER JOIN apai_model_def md ON md.model_def_id = f.model_def_id
	WHERE
		f.model_def_id = model_def_id_param
		AND m.is_active = 'Y';
END$$
DELIMITER ;

