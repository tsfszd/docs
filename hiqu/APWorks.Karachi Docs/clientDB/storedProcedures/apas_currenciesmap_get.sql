DELIMITER $$
DROP PROCEDURE IF EXISTS apas_currenciesmap_get;$$

CREATE PROCEDURE apas_currenciesmap_get(
)
BEGIN
	SELECT
		apam_invoice_currency_code,
		currency_code
	FROM
		apam_currencies_map;
END$$
DELIMITER ;

