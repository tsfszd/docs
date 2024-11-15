DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelfielddetail_delete;$$

CREATE PROCEDURE apas_documentmodelfielddetail_delete(
	IN master_document_model_id_param INT UNSIGNED
)
BEGIN
	DELETE FROM
		apam_document_model_field_detail
	WHERE
		master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

