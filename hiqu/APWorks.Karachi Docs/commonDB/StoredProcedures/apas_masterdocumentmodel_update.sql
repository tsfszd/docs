DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_update;$$

CREATE PROCEDURE apas_masterdocumentmodel_update(
	IN master_document_model_id_param         INT UNSIGNED,
	IN model_def_id_param                     INT UNSIGNED,
	IN master_document_model_comments_param   VARCHAR(512),
	IN is_active_param                        CHAR(1),
	IN modify_id_param                        VARCHAR(32),
	IN modify_date_param                      DATETIME
)
BEGIN
	UPDATE
		apam_master_document_model
	SET
		master_document_model_comments  = master_document_model_comments_param,
		is_active                       = CASE WHEN is_active = 'Y' THEN 'Y' ELSE is_active_param END,
		modify_id                       = modify_id_param,
		modify_date                     = modify_date_param
	WHERE
		master_document_model_id    = master_document_model_id_param
		AND model_def_id            = model_def_id_param;
END$$
DELIMITER ;

