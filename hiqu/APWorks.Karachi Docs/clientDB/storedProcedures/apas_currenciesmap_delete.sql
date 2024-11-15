DELIMITER $$
DROP PROCEDURE IF EXISTS apas_currenciesmap_delete;$$

CREATE PROCEDURE apas_currenciesmap_delete
(
	IN currency_code_param CHAR(8)
)
BEGIN
	DELETE FROM apam_currencies_map
	WHERE
		currency_code = currency_code_param;
END$$
DELIMITER ;

