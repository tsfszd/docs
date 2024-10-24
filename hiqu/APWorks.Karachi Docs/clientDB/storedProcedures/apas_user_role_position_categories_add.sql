DELIMITER $$
DROP PROCEDURE IF EXISTS apas_user_role_position_categories_add;$$

CREATE PROCEDURE apas_user_role_position_categories_add(
	IN company_code_param   INT,
	IN user_role_id_param	INT,
	IN position_category_code_param    INT,
	IN create_id_param      VARCHAR(32),
	IN create_date_param    DATETIME
)
BEGIN
	INSERT INTO apad_user_role_position_categories
	(
		company_code,
		user_role_id,
		position_category_code,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		user_role_id_param,
		position_category_code_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

