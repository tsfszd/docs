DELIMITER $$
DROP PROCEDURE IF EXISTS apas_paymenttermsmap_get;$$

CREATE PROCEDURE apas_paymenttermsmap_get(
)
BEGIN
	SELECT
		apam_invoice_terms_code,
		terms_code
	FROM
		apam_payment_terms_map;
END$$
DELIMITER ;

