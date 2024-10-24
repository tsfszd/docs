DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_get;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_get(
	IN company_code_param               INT,
	IN model_def_id_param               INT UNSIGNED,
	IN scanner_monitor_record_id_param  INT UNSIGNED
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
		AND model_def_id =  model_def_id_param
		AND scanner_monitor_record_id = scanner_monitor_record_id_param
	ORDER BY
		company_code;
END$$
DELIMITER ;

