DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_add;$$

CREATE PROCEDURE apas_resources_add(
	IN company_code_param INT,
	IN resource_id_param  CHAR(16),
	IN name_last_param    VARCHAR(32),
	IN name_first_param   VARCHAR(32),
	IN name_init_param    VARCHAR(1),
	IN title_param        VARCHAR(64),
	IN email_param        VARCHAR(128),
	IN login_id_param     VARCHAR(64),
	IN res_password_param VARCHAR(256),
	IN active_flag_param  TINYINT,
	IN create_id_param    VARCHAR(32),
	IN create_date_param  DATETIME
)
BEGIN
	INSERT INTO apad_resources
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		res_password,
		active_flag,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		resource_id_param,
		name_last_param,
		name_first_param,
		name_init_param,
		title_param,
		email_param,
		login_id_param,
		res_password_param,
		active_flag_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

