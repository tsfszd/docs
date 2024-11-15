DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_update;$$

CREATE PROCEDURE apas_resources_update(
	IN company_code_param INT,
	IN resource_id_param  CHAR(16),
	IN name_last_param    VARCHAR(32),
	IN name_first_param   VARCHAR(32),
	IN name_init_param    VARCHAR(1),
	IN title_param        VARCHAR(64),
	IN email_param        VARCHAR(128),
	IN login_id_param     VARCHAR(64),
	IN active_flag_param  TINYINT,
	IN modify_id_param    VARCHAR(32),
	IN modify_date_param  DATETIME
)
BEGIN
	UPDATE
		apad_resources
	SET
		name_last       = name_last_param,
		name_first      = name_first_param,
		name_init       = name_init_param,
		title           = title_param,
		email           = email_param,
		login_id        = login_id_param,
		active_flag     = active_flag_param,
		modify_date     = modify_date_param,
		modify_id       = modify_id_param
	WHERE
		company_code = company_code_param
		AND resource_id = resource_id_param;
END$$
DELIMITER ;

