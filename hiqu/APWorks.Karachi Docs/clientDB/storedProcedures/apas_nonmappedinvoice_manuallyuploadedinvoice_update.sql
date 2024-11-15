DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_manuallyuploadedinvoice_update;$$

CREATE PROCEDURE apas_nonmappedinvoice_manuallyuploadedinvoice_update(
	IN document_manual_upload_record_id_param           INT UNSIGNED, 
	IN company_code_param                               INT,
	IN resource_id_param                                CHAR(16),
	IN document_manual_upload_file_location_param       VARCHAR(1024),
	IN document_manual_upload_file_update_date_param    DATETIME,
	IN scanned_flag_param                               CHAR(1),
	IN scanner_monitor_record_id_param                  INT UNSIGNED,
	IN document_model_request_id_param                  INT UNSIGNED,
	IN invoice_document_id_param                        INT UNSIGNED,
	IN model_def_id_param                               INT UNSIGNED
)
BEGIN
	SET scanner_monitor_record_id_param = (SELECT MAX(scanner_monitor_record_id) + 1 FROM apad_invoice_scanner_monitor);

	IF ISNULL(scanner_monitor_record_id_param) THEN
			SET scanner_monitor_record_id_param = 1;
	END IF;

	INSERT INTO apad_invoice_scanner_monitor
	(
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
	)
	SELECT
		scanner_monitor_record_id_param,
		company_code_param,
		document_manual_upload_file_location_param,
		30,
		'Y',
		document_manual_upload_file_update_date_param,
		NULL,
		NULL,
		NULL,
		model_def_id_param;

	UPDATE
		apad_document_manual_upload
	SET
		scanner_monitor_record_id               = scanner_monitor_record_id_param
	WHERE
		company_code = company_code_param
		AND document_manual_upload_record_id = document_manual_upload_record_id_param;
END$$
DELIMITER ;

