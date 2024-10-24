DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocuments_postinprogress;$$

CREATE PROCEDURE apas_invoicedocuments_postinprogress
(
	IN company_code_param                           INT,
	IN invoice_document_id_csv_param                VARCHAR(1000),
	IN invoice_document_posting_update_date_param   DATETIME
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS t, temp;
	CREATE TEMPORARY TABLE t (txt TEXT);
	INSERT INTO t VALUES(invoice_document_id_csv_param);

	CREATE TEMPORARY TABLE temp (invoice_document_id INT UNSIGNED);
	SET @SQL = CONCAT("insert into temp (invoice_document_id) values ('", REPLACE(( SELECT GROUP_CONCAT(DISTINCT txt) AS DATA FROM t), ",", "'),('"),"');");
	PREPARE stmt1 FROM @SQL;
	EXECUTE stmt1;

	SET @posting_monitor_record_id = (SELECT MAX(posting_monitor_record_id) + 1 FROM apad_invoice_posting_monitor);

	IF ISNULL(@posting_monitor_record_id) THEN
		SET @posting_monitor_record_id = 0;
	END IF;

	UPDATE
		apad_invoice_posting_monitor pm
		INNER JOIN temp t ON t.invoice_document_id = pm.invoice_document_id
							AND pm.company_code = company_code_param
	SET
		pm.invoice_document_posting_status_id   = 30,
		pm.invoice_document_posting_update_date = invoice_document_posting_update_date_param,
		pm.invoice_document_posting_duration = NULL,
		pm.invoice_document_posting_error_message = NULL,
		pm.invoice_document_posting_process_tag_string = NULL;

	INSERT INTO apad_invoice_posting_monitor
	(
		posting_monitor_record_id,
		company_code,
		invoice_document_id,
		invoice_document_posting_status_id,
		invoice_document_posting_update_date,
		invoice_document_posting_duration,
		invoice_document_posting_error_message,
		invoice_document_posting_process_tag_string
	)
	SELECT 
		(@posting_monitor_record_id := @posting_monitor_record_id + 1) AS posting_monitor_record_id,
		company_code_param,
		t.invoice_document_id,
		30,
		invoice_document_posting_update_date_param,
		NULL,
		NULL,
		NULL
	FROM
		temp t
		LEFT OUTER JOIN apad_invoice_posting_monitor pm ON pm.invoice_document_id = t.invoice_document_id
															AND pm.company_code = company_code_param
	WHERE
		pm.invoice_document_id IS NULL;

	DROP TEMPORARY TABLE t, temp;
END$$
DELIMITER ;

