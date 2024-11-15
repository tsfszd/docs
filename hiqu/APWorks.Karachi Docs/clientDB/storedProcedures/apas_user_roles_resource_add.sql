DELIMITER $$
DROP PROCEDURE IF EXISTS apas_user_roles_resource_add;$$

CREATE PROCEDURE apas_user_roles_resource_add(
	IN company_code_param   INT,
	IN user_role_id_param	INT,
	IN resource_id_param    CHAR(16),
	IN create_id_param      VARCHAR(32),
	IN create_date_param    DATETIME
)
BEGIN
	INSERT INTO apad_user_roles_resource
	(
		company_code,
		user_role_id,
		resource_id,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		user_role_id_param,
		resource_id_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

