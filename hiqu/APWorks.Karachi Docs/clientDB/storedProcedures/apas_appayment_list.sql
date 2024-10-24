DELIMITER $$
DROP PROCEDURE IF EXISTS apas_appayment_list;$$

CREATE PROCEDURE apas_appayment_list(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	FROM
		apad_ap_payment
	WHERE
		company_code = company_code_param
	ORDER BY
		invoice_number;
END$$
DELIMITER ;

