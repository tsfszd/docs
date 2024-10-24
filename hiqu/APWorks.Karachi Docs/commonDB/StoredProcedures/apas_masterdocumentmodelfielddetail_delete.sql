DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_delete;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_delete(
	IN master_document_model_id_param INT UNSIGNED
)
BEGIN
	DELETE FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

