DROP PROCEDURE IF EXISTS apas_paymentTerm_save;

DELIMITER $$
CREATE PROCEDURE apas_paymentTerm_save
(
	termsCode           VARCHAR(64),
	termsDesc           VARCHAR(64),
	daysDue             INT,
	company_code_param  INT,
	update_date_param   DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_payment_terms WHERE terms_code = termsCode) THEN
		UPDATE
			apam_payment_terms
		SET
			terms_desc  = termsDesc,
			days_due    = daysDue
		WHERE
			terms_code = termsCode;
	ELSE
		INSERT INTO apam_payment_terms
		(
			terms_code,
			terms_desc,
			days_due
		)
		VALUES
		(
			termsCode,
			termsDesc,
			daysDue
		);
	END IF;

	CALL apas_datalastupdated_update(company_code_param, 'apam_payment_terms', update_date_param);
END$$

DELIMITER ;

