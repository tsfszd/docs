DELIMITER $$
DROP PROCEDURE IF EXISTS apas_paymenttermsmap_add;$$

CREATE PROCEDURE apas_paymenttermsmap_add
(
	IN apam_invoice_terms_code_param    CHAR(64),
	IN terms_code_param                 CHAR(64)
)
BEGIN
	INSERT INTO apam_payment_terms_map (apam_invoice_terms_code, terms_code)
	VALUES (apam_invoice_terms_code_param, terms_code_param);
END$$
DELIMITER ;

