DELIMITER $$
DROP PROCEDURE IF EXISTS apas_company_delete;$$

CREATE PROCEDURE apas_company_delete(
	IN company_code_param INT
)
BEGIN
	DELETE FROM
		apam_company_invoice_configuration
	WHERE
		company_code = company_code_param;

	DELETE FROM
		apam_company_approval_configuration
	WHERE
		company_code = company_code_param;

	DELETE FROM
		apam_company
	WHERE
		company_code = company_code_param;
END$$
DELIMITER ;

