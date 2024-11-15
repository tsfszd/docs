DELIMITER $$

CREATE OR REPLACE VIEW v_InvoiceDocument AS
	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.document_model_request_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.replaced_by_invoice_document_file_location,
		id.transaction_id,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		SUM(idd.io_invoice_amount) AS TotalAmount,
		mr.request_to_map,
		mr.manual_processing,
		sm.invoice_document_scan_status_id,
		sm.manual_upload_flag,
		pm.invoice_document_posting_status_id,
		pm.invoice_document_posting_error_message,
		v.vendor_name,
		v.short_name,
		(SELECT
			COUNT(sequence_id) AS routing_history_count
		FROM
			apad_invoice_document_routing_history
		WHERE
			invoice_document_id = id.invoice_document_id
			AND company_code = id.company_code) AS routing_history_count
	FROM
		apad_invoice_document id
		LEFT OUTER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
		LEFT OUTER JOIN apam_document_model_request mr ON mr.document_model_request_id = id.document_model_request_id
															AND mr.company_code = id.company_code
															AND mr.manual_processing = 'Y'
															AND mr.request_completed = 'N'
		LEFT OUTER JOIN apad_invoice_scanner_monitor sm ON sm.invoice_document_file_location = id.invoice_document_file_location
															AND sm.company_code = id.company_code
		LEFT OUTER JOIN apad_invoice_posting_monitor pm ON pm.invoice_document_id = id.invoice_document_id
															AND pm.company_code = id.company_code
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.site_id = id.site_id
										AND v.company_code = id.company_code
	WHERE
		id.is_deleted = FALSE
	GROUP BY
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.document_model_request_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		mr.request_to_map,
		mr.manual_processing,
		sm.invoice_document_scan_status_id,
		sm.manual_upload_flag,
		pm.invoice_document_posting_status_id,
		pm.invoice_document_posting_error_message,
		v.vendor_name,
		v.short_name
$$
DELIMITER ;

