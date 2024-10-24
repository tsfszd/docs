DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_reset_password;$$

CREATE PROCEDURE apas_resources_reset_password(
	IN resource_id_param  			   CHAR(16),
	IN res_password_param			   VARCHAR(256),
    IN password_reset_flag_param	   CHAR(1),
	IN modify_id_param    			   VARCHAR(32),
	IN modify_date_param  			   DATETIME
)
BEGIN
	UPDATE
		apad_resources
	SET
		res_password        = res_password_param,
        password_reset_flag = password_reset_flag_param,
		modify_date         = modify_date_param,
		modify_id           = modify_id_param
	WHERE
		resource_id = resource_id_param;
END$$
DELIMITER ;

