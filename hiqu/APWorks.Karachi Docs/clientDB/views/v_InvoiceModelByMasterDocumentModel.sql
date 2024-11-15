DELIMITER $$

CREATE OR REPLACE VIEW v_InvoiceModelByMasterDocumentModel AS
	SELECT
		dmr.company_code,
		dmr.document_model_request_id,
		sm.invoice_document_file_location,
		sm.manual_upload_flag,
		mdm.master_document_model_id,
		dm.document_model_name,
		dm.document_model_name_tag,
		dm.document_model_status_id,
		mdm.is_active,
		dm.invoice_document_sample_file_location,
		id.invoice_document_id,
		v.vendor_code,
		v.vendor_name,
		v.short_name,
		v.site_id
	FROM
		apam_document_model_request dmr
		INNER JOIN apad_invoice_scanner_monitor sm ON sm.scanner_monitor_record_id = dmr.scanner_monitor_record_id
														AND sm.company_code = dmr.company_code
		INNER JOIN apad_invoice_document id ON id.document_model_request_id = dmr.document_model_request_id
													AND id.company_code = dmr.company_code
		INNER JOIN {COMMON_DATABASE}.apam_master_document_model mdm ON mdm.master_document_model_id = id.master_document_model_id
		LEFT OUTER JOIN apam_document_model dm ON dm.master_document_model_id = mdm.master_document_model_id
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.site_id = id.site_id
										AND v.company_code = dmr.company_code
	WHERE
		dmr.request_to_map = 'Y'
		AND dmr.request_completed = 'N'
		AND dm.invoice_document_sample_file_location <> id.invoice_document_file_location;
$$
DELIMITER ;

