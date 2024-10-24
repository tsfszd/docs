DELIMITER $$
DROP PROCEDURE IF EXISTS apas_currency_save;$$

CREATE PROCEDURE apas_currency_save
(
	currencyCode        VARCHAR(8),
	currencyName        VARCHAR(16),
	company_code_param  INT,
	update_date_param   DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_currencies WHERE currency_code = currencyCode)
	THEN
		UPDATE
			apam_currencies
		SET
			currency_name = currencyName
		WHERE
			currency_code = currencyCode; 
	ELSE
		INSERT INTO apam_currencies(currency_code, currency_name)
		VALUES (currencyCode, currencyName);
	END IF;

	CALL apas_datalastupdated_update(company_code_param, 'apam_currencies', update_date_param);
END$$
DELIMITER ;

