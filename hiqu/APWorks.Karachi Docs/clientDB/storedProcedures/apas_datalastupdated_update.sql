DELIMITER $$
DROP PROCEDURE IF EXISTS apas_datalastupdated_update;$$

CREATE PROCEDURE apas_datalastupdated_update(
	IN company_code_param   INT,
	IN table_name_param     VARCHAR(32),
	IN last_updated_param   DATETIME
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apam_data_last_updated WHERE company_code = company_code_param AND table_name = table_name_param) THEN
		INSERT INTO apam_data_last_updated
		(
			company_code,
			table_name,
			last_updated
		)
		VALUES
		(
			company_code_param,
			table_name_param,
			last_updated_param
		);
	ELSE
		UPDATE
			apam_data_last_updated
		SET
			last_updated = last_updated_param
		WHERE
			company_code = company_code_param
			AND table_name = table_name_param;
	END IF;
END$$
DELIMITER ;

