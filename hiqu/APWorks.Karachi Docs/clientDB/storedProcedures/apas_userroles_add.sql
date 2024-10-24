DELIMITER $$
DROP PROCEDURE IF EXISTS apas_userroles_add;$$

CREATE PROCEDURE apas_userroles_add(
	IN company_code_param			INT,
	OUT user_role_id_param			INT,
	IN user_role_name_param			VARCHAR(64),
	IN is_admin_role_param			CHAR(1),
	IN allow_routing_setup_param	CHAR(1),
	IN create_id_param				VARCHAR(32),
	IN create_date_param			DATETIME
)
BEGIN
	SET user_role_id_param = (SELECT MAX(user_role_id) + 1 FROM apad_user_roles WHERE company_code = company_code_param);

	IF ISNULL(user_role_id_param) THEN
			SET user_role_id_param = 1;
	END IF;

	INSERT INTO apad_user_roles
	(
		company_code,
		user_role_id,
		user_role_name,
		is_admin_role,
		allow_routing_setup,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		user_role_id_param,
		user_role_name_param,
		is_admin_role_param,
		allow_routing_setup_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

