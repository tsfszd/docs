DELIMITER $$
DROP PROCEDURE IF EXISTS apas_user_roles_resource_delete;$$

CREATE PROCEDURE apas_user_roles_resource_delete(
	IN company_code_param   INT,
	IN resource_id_param    CHAR(16)
)
BEGIN
	DELETE
	FROM
		apad_user_roles_resource
	WHERE
		company_code = company_code_param
		AND resource_id = resource_id_param;
END$$
DELIMITER ;

