DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicescannermonitor_getbyfilename;$$

CREATE PROCEDURE apas_invoicescannermonitor_getbyfilename(
	IN company_code_param                   INT,
    IN invoice_document_file_location_param	VARCHAR(1024)
)
BEGIN
	SELECT
		scanner_monitor_record_id,
		company_code,
		invoice_document_file_location,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_scan_update_date,
		invoice_document_scan_duration,
		invoice_document_scan_error_message,
		invoice_document_scanner_process_tag_string,
		model_def_id
	FROM
		apad_invoice_scanner_monitor
	WHERE
		company_code = company_code_param
		AND invoice_document_file_location LIKE(CONCAT(invoice_document_file_location_param, '%'));
END$$
DELIMITER ;

