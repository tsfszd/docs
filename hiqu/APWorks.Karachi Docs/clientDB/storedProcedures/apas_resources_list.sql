DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_list;$$

CREATE PROCEDURE apas_resources_list(
	IN company_code_param   INT
)
BEGIN
	SELECT
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
		create_date,
		modify_date,
		modify_id
	FROM
		apad_resources
	WHERE
		company_code = company_code_param;

	SELECT
		company_code,
		user_role_id,
		resource_id,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apad_user_roles_resource
	WHERE
		company_code = company_code_param;
END$$
DELIMITER ;

