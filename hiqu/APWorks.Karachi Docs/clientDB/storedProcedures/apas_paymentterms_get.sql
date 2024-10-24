DELIMITER $$
DROP PROCEDURE IF EXISTS apas_paymentterms_get;$$

CREATE PROCEDURE apas_paymentterms_get(
)
BEGIN
	SELECT
		terms_code,
		terms_desc,
		days_due
	FROM
		apam_payment_terms;
END$$
DELIMITER ;

