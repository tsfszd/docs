DELIMITER $$
DROP PROCEDURE IF EXISTS apas_userroles_update;$$

CREATE PROCEDURE apas_userroles_update(
	IN company_code_param			INT,
	IN user_role_id_param			INT,
	IN user_role_name_param			VARCHAR(64),
	IN is_admin_role_param			CHAR(1),
	IN allow_routing_setup_param	CHAR(1),
	IN modify_id_param				VARCHAR(32),
	IN modify_date_param			DATETIME
)
BEGIN
	UPDATE
		apad_user_roles
	SET
		user_role_name		= user_role_name_param,
		is_admin_role		= is_admin_role_param,
		allow_routing_setup = allow_routing_setup_param,
		modify_id			= modify_id_param,
		modify_date			= modify_date
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;
END$$
DELIMITER ;

