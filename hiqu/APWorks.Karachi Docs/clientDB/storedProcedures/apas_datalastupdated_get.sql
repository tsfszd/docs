DROP PROCEDURE IF EXISTS apas_datalastupdated_get;

DELIMITER $$
CREATE PROCEDURE apas_datalastupdated_get
(
	IN company_code_param  INT,
	IN table_name_param    VARCHAR(32)
)
BEGIN
	SELECT company_code, table_name, last_updated FROM apam_data_last_updated WHERE company_code = company_code_param AND table_name = table_name_param;
END$$

DELIMITER ;

