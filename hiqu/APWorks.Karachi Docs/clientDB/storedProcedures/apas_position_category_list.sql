DELIMITER $$
DROP PROCEDURE IF EXISTS apas_position_category_list;$$

CREATE PROCEDURE apas_position_category_list(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		position_category_code,
		position_category_name,
		protected_role_flag
	FROM
		apam_position_category
	WHERE
		company_code = company_code_param;
END$$
DELIMITER ;

