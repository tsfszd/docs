DELIMITER $$
DROP PROCEDURE IF EXISTS apas_currencies_list;$$

CREATE PROCEDURE apas_currencies_list(
)
BEGIN
	SELECT
		currency_code,
		currency_name
	FROM
		apam_currencies;
END$$
DELIMITER ;

