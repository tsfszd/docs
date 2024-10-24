DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_setactive;$$

CREATE PROCEDURE apas_masterdocumentmodel_setactive(
	IN master_document_model_id_param         INT UNSIGNED,
	IN model_def_id_param                     INT UNSIGNED,
	IN is_active_param                        CHAR(1),
	IN modify_id_param                        VARCHAR(32),
	IN modify_date_param                      DATETIME
)
BEGIN
	UPDATE
		apam_master_document_model
	SET
		is_active                       = is_active_param,
		modify_id                       = modify_id_param,
		modify_date                     = modify_date_param
	WHERE
		master_document_model_id    = master_document_model_id_param
		AND model_def_id            = model_def_id_param
		AND is_active <> 'Y';
END$$
DELIMITER ;

