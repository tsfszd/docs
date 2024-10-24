DELIMITER $$
DROP PROCEDURE IF EXISTS apas_userroles_delete;$$

CREATE PROCEDURE apas_userroles_delete(
	IN company_code_param   INT,
	IN user_role_id_param   INT
)
BEGIN
	DELETE FROM
		apad_user_roles_invoice_rights
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;

	DELETE FROM
		apad_user_role_position_categories
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;

	DELETE FROM
		apad_user_roles
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;
END$$
DELIMITER ;

