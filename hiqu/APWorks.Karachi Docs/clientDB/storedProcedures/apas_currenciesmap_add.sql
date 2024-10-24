DELIMITER $$
DROP PROCEDURE IF EXISTS apas_currenciesmap_add;$$

CREATE PROCEDURE apas_currenciesmap_add
(
	IN apam_invoice_currency_code_param CHAR(64),
	IN currency_code_param              CHAR(8)
)
BEGIN
	INSERT INTO apam_currencies_map (apam_invoice_currency_code, currency_code)
	VALUES (apam_invoice_currency_code_param, currency_code_param);
END$$
DELIMITER ;

