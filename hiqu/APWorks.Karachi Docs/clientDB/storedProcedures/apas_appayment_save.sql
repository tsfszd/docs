DELIMITER $$
DROP PROCEDURE IF EXISTS apas_appayment_save;$$

CREATE PROCEDURE apas_appayment_save
(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code    INT NOT NULL,
		vendor_code     VARCHAR(12) NULL,
		check_number    VARCHAR(64) NOT NULL,
		invoice_number  VARCHAR(64) NOT NULL,
		document_date   DATETIME NOT NULL,
		payment_amount  DECIMAL(19, 2) NOT NULL
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_ap_payment p
	INNER JOIN _temp t ON t.company_code = p.company_code
						AND t.vendor_code = p.vendor_code
						AND t.check_number = p.check_number
						AND t.invoice_number = p.invoice_number
						AND t.document_date = p.document_date
	SET
		p.company_code      = t.company_code,
		p.vendor_code       = t.vendor_code,
		p.check_number      = t.check_number,
		p.invoice_number    = t.invoice_number,
		p.document_date     = t.document_date,
		p.payment_amount    = t.payment_amount;

	INSERT INTO apad_ap_payment
	(
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	)
	SELECT
		t.company_code,
		t.vendor_code,
		t.check_number,
		t.invoice_number,
		t.document_date,
		t.payment_amount
	FROM
		_temp t
		INNER JOIN apad_vendors v ON v.vendor_code = t.vendor_code
										AND v.company_code = t.company_code
		LEFT OUTER JOIN apad_ap_payment p ON p.company_code = t.company_code
											AND p.vendor_code = t.vendor_code
											AND p.check_number = t.check_number
											AND p.invoice_number = t.invoice_number
											AND p.document_date = t.document_date
	WHERE
		p.vendor_code IS NULL
	GROUP BY t.company_code,t.vendor_code, t.check_number, t.invoice_number, t.document_date;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_ap_payment', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

