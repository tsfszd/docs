DROP PROCEDURE IF EXISTS apas_position_category_save;

DELIMITER $$
CREATE PROCEDURE apas_position_category_save
(
	companyCode                 INT,
	positionCategoryCode        INT,
	positionCategoryName        VARCHAR(64),
	protected_role_flag_param   INT,
	update_date_param           DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_position_category WHERE company_code = companyCode AND position_category_code = positionCategoryCode)
	THEN
		UPDATE
			apam_position_category
		SET
			position_category_name  = positionCategoryName,
			protected_role_flag     = protected_role_flag_param
		WHERE
			company_code = companyCode
			AND position_category_code = positionCategoryCode;
	ELSE
		INSERT INTO apam_position_category
		(
			company_code,
			position_category_code,
			position_category_name,
			protected_role_flag
		)
		VALUES
		(
			companyCode,
			positionCategoryCode,
			positionCategoryName,
			protected_role_flag_param
		);
	END IF;

	CALL apas_datalastupdated_update(companyCode, 'apam_position_category', update_date_param);
END$$

DELIMITER ;

