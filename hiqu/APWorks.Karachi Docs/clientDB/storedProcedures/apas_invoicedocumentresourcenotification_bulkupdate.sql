DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentresourcenotification_bulkupdate;$$

CREATE PROCEDURE apas_invoicedocumentresourcenotification_bulkupdate(
	valuesCSV   VARCHAR(65535)
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		invoice_document_id VARCHAR(32),
		resource_id         CHAR(16),
		notification_date   DATETIME,
		create_id           VARCHAR(32),
		create_date         DATETIME,
		modify_id           VARCHAR(32),
		modify_date         DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		invoice_document_id,
		resource_id,
		notification_date,
		create_id,
		create_date,
		modify_id,
		modify_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_invoice_document_resource_notification n
	INNER JOIN _temp t ON n.invoice_document_id = t.invoice_document_id
							AND n.resource_id = t.resource_id
							AND n.company_code = t.company_code
	SET
		n.notification_date = t.notification_date,
		n.modify_id         = t.modify_id,
		n.modify_date       = t.modify_date;

	INSERT INTO apad_invoice_document_resource_notification
	(
		company_code,
		invoice_document_id,
		resource_id,
		notification_date,
		create_id,
		create_date
	)
	SELECT
		t.company_code,
		t.invoice_document_id,
		t.resource_id,
		t.notification_date,
		t.create_id,
		t.create_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_invoice_document_resource_notification n ON n.invoice_document_id = t.invoice_document_id
																		AND n.resource_id = t.resource_id
																		AND n.company_code = t.company_code
	WHERE
		n.invoice_document_id IS NULL;

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

