DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_manuallyuploadedinvoice_get;$$

CREATE PROCEDURE apas_nonmappedinvoice_manuallyuploadedinvoice_get(
	IN company_code_param                       INT,
	IN document_manual_upload_record_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		dmu.document_manual_upload_record_id,
		dmu.company_code,
		dmu.resource_id,
		dmu.document_manual_upload_file_location,
		dmu.document_manual_upload_file_update_date,
		dmu.scanned_flag,
		dmu.scanner_monitor_record_id,
		dmu.document_model_request_id,
		dmu.model_def_id,
		ism.invoice_document_scan_status_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		dmr.request_to_map,
		dmr.manual_processing,
		dmr.request_completed
	FROM
		apad_document_manual_upload dmu
		LEFT OUTER JOIN apad_invoice_scanner_monitor ism ON ism.scanner_monitor_record_id = dmu.scanner_monitor_record_id
															AND ism.company_code = dmu.company_code
															AND ism.model_def_id = dmu.model_def_id
		LEFT OUTER JOIN apam_document_model_request dmr ON dmr.scanner_monitor_record_id = ism.scanner_monitor_record_id
															AND dmr.company_code = dmu.company_code
		LEFT OUTER JOIN apad_invoice_document id ON (id.invoice_document_id = dmu.invoice_document_id OR id.invoice_document_file_location = ism.invoice_document_file_location)
															AND id.company_code = dmu.company_code
															AND id.model_def_id = dmu.model_def_id
	WHERE
		dmu.company_code = company_code_param
		AND IFNULL(id.is_deleted, FALSE) = FALSE
		AND document_manual_upload_record_id = document_manual_upload_record_id_param;
END$$
DELIMITER ;

