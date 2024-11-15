DELIMITER $$
DROP PROCEDURE IF EXISTS apas_paymenttermsmap_delete;$$

CREATE PROCEDURE apas_paymenttermsmap_delete
(
	IN terms_code_param CHAR(64)
)
BEGIN
	DELETE FROM apam_payment_terms_map
	WHERE
		terms_code = terms_code_param;
END$$
DELIMITER ;

