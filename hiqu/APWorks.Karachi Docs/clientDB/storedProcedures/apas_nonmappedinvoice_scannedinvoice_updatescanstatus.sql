DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_updatescanstatus;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_updatescanstatus(
	IN company_code_param                       INT,
	IN invoice_document_file_location_param     VARCHAR(1024),
	IN invoice_document_scan_status_id_param    INT UNSIGNED,
	IN invoice_document_scan_update_date_param  DATETIME,
	IN model_def_id_param                       INT UNSIGNED
)
BEGIN
	DECLARE scanner_monitor_record_id_param INT UNSIGNED;

	IF NOT EXISTS (SELECT 1 FROM apad_invoice_scanner_monitor WHERE company_code = company_code_param AND invoice_document_file_location = invoice_document_file_location_param) THEN
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
			invoice_document_file_location_param,
			invoice_document_scan_status_id_param,
			'N',
			invoice_document_scan_update_date_param,
			NULL,
			NULL,
			NULL,
			model_def_id_param;
	ELSE
		UPDATE
			apad_invoice_scanner_monitor
		SET
			invoice_document_scan_status_id = invoice_document_scan_status_id_param,
			invoice_document_scan_update_date = invoice_document_scan_update_date_param
		WHERE
			company_code = company_code_param
			AND invoice_document_file_location = invoice_document_file_location_param;
	END IF;
END$$
DELIMITER ;

