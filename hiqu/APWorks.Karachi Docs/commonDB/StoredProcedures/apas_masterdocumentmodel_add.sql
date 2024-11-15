DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_add;$$

CREATE PROCEDURE apas_masterdocumentmodel_add(
	INOUT master_document_model_id_param    INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN master_document_model_comments_param	VARCHAR(512),
	IN is_active_param                      CHAR(1),
	IN create_id_param                      VARCHAR(32),
	IN create_date_param                    DATETIME
)
BEGIN
	SET master_document_model_id_param = (SELECT MAX(master_document_model_id) + 1 FROM apam_master_document_model);

	IF ISNULL(master_document_model_id_param) THEN
		SET master_document_model_id_param = 1;
    END IF;
    
	INSERT INTO apam_master_document_model
	(
		master_document_model_id,
		model_def_id,
		master_document_model_comments,
		is_active,
		create_id,
		create_date
	)
	SELECT
		master_document_model_id_param,
		model_def_id_param,
		master_document_model_comments_param,
		is_active_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

