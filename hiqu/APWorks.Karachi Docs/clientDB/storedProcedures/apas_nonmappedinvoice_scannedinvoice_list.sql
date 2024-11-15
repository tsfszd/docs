DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_list;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_list(
	IN company_code_param                       INT,
	IN resource_id_param                        CHAR(16),
	IN model_def_id_param                       INT UNSIGNED,
	IN invoice_document_scan_status_id_param    INT UNSIGNED
)
BEGIN
	SELECT
		m.scanner_monitor_record_id,
		m.company_code,
		m.invoice_document_file_location,
		m.invoice_document_scan_status_id,
		m.manual_upload_flag,
		m.invoice_document_scan_update_date,
		m.invoice_document_scan_duration,
		m.invoice_document_scan_error_message,
		m.invoice_document_scanner_process_tag_string,
		m.model_def_id
	FROM
		apad_invoice_scanner_monitor m
		LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.scanner_monitor_record_id = m.scanner_monitor_record_id
															AND dmu.company_code = m.company_code
		LEFT OUTER JOIN apam_document_model_request r ON m.scanner_monitor_record_id = r.scanner_monitor_record_id
		LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location
													AND id.company_code = m.company_code
													AND id.model_def_id =  model_def_id_param
	WHERE
		m.company_code = company_code_param
		AND m.model_def_id =  model_def_id_param
		AND IFNULL(id.is_deleted, FALSE) = FALSE
		AND r.document_model_request_id IS NULL
		AND (IFNULL(resource_id_param, '') = '' OR (dmu.resource_id = resource_id_param))
		AND ((id.invoice_document_status_id IN (10, 35, 40) AND m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 10) OR (m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 20))
	ORDER BY
		m.invoice_document_scan_update_date DESC;
END$$
DELIMITER ;

