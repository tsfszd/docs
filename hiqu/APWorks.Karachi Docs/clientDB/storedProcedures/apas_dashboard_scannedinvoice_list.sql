DELIMITER $$
DROP PROCEDURE IF EXISTS apas_dashboard_scannedinvoice_list;$$

CREATE PROCEDURE apas_dashboard_scannedinvoice_list(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT
)
BEGIN
	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT DISTINCT
		i.scanner_monitor_record_id,
		i.company_code,
		i.invoice_document_file_location,
		i.invoice_document_scan_status_id,
		i.manual_upload_flag,
		i.invoice_document_scan_update_date,
		i.invoice_document_scan_duration,
		i.invoice_document_scan_error_message,
		i.invoice_document_scanner_process_tag_string,
		i.model_def_id,
		i.invoice_document_id,
		i.invoice_document_status_id,
		i.duplicate_invoice_flag,
		i.invoice_document_posting_status_id,
		i.invoice_document_posting_error_message,
		i.vendor_code,
		i.vendor_name,
		i.short_name,
		i.site_id,
		i.routed_to_csv,
		CASE WHEN idrrh.suggestion_flag <> 'N' THEN NULL ELSE idrrh.resource_id END AS routed_to_resource_id,
		idrrh.create_id,
		idrrh.create_date,
		idrrh.modify_id,
		idrrh.modify_date,
		idrrh.suggestion_flag,
		idrrh.comments,
		r.name_last,
		r.name_first
	FROM
	(
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
			m.model_def_id,
			id.invoice_document_id,
			id.invoice_document_status_id,
			id.duplicate_invoice_flag,
			pm.invoice_document_posting_status_id,
			pm.invoice_document_posting_error_message,
			v.vendor_code,
			v.vendor_name,
			v.short_name,
			v.site_id,
			dt_idrrh.sequence_id,
			dt_idrrh.resource_id,
			dt_idrrh.routed_to_csv
		FROM
			apad_invoice_scanner_monitor m
			LEFT OUTER JOIN apam_document_model_request r ON r.scanner_monitor_record_id = m.scanner_monitor_record_id
														AND r.company_code = m.company_code
			LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location
														AND id.company_code = m.company_code
														AND id.model_def_id = m.model_def_id
			LEFT OUTER JOIN apad_invoice_posting_monitor pm ON pm.invoice_document_id = id.invoice_document_id
															AND pm.company_code = id.company_code
			LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
											AND v.site_id = id.site_id
											AND v.company_code = id.company_code
			LEFT OUTER JOIN (SELECT
								idrrh.company_code,
								idrrh.invoice_document_id,
								idrrh.sequence_id,
								idrrh.resource_id,
								GROUP_CONCAT(DISTINCT CONCAT(r.name_last, ', ', r.name_first) ORDER BY idrrh.sequence_id DESC SEPARATOR ' | ') AS routed_to_csv
							FROM
							(
								SELECT
									company_code,
									invoice_document_id,
									MAX(sequence_id) AS sequence_id
								FROM
									apad_invoice_document_resource_routing_history
								GROUP BY
									company_code,
									invoice_document_id
							) dt_h
							INNER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = dt_h.company_code
																								AND idrrh.invoice_document_id = dt_h.invoice_document_id
																								AND idrrh.sequence_id = dt_h.sequence_id
							INNER JOIN apad_resources r ON r.company_code = idrrh.company_code
															AND r.resource_id = idrrh.resource_id
															AND r.active_flag = TRUE
							GROUP BY
								idrrh.company_code,
								idrrh.invoice_document_id
							) dt_idrrh ON dt_idrrh.invoice_document_id = id.invoice_document_id
										AND dt_idrrh.company_code = m.company_code
		WHERE
			m.company_code = company_code_param
			AND m.model_def_id = model_def_id_param
			AND IFNULL(id.is_deleted, FALSE) = FALSE
			AND (r.document_model_request_id IS NULL OR (r.document_model_request_id IS NOT NULL AND id.invoice_document_status_id = 20))
			AND (id.invoice_document_status_id IN (10, 20, 30, 35, 40, 60, 80, 100, 120, 140, 160) AND m.invoice_document_scan_status_id = 10)
			AND (DATE(m.invoice_document_scan_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	) AS i
	LEFT OUTER JOIN v_ResourcesByInvoiceDocument rid ON rid.invoice_document_id = i.invoice_document_id
														AND rid.company_code = i.company_code
														AND ACTIVE_FLAG = 1
	LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = i.company_code
																AND idrrh.invoice_document_id = i.invoice_document_id
																AND idrrh.sequence_id = i.sequence_id
																AND idrrh.resource_id = i.resource_id
	LEFT OUTER JOIN apad_resources r ON r.resource_id = idrrh.resource_id
										AND r.company_code = i.company_code
										AND r.active_flag = TRUE
	LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.company_code = i.company_code
														AND dmu.invoice_document_id = i.invoice_document_id
														AND dmu.model_def_id = i.model_def_id
	WHERE
		IFNULL(resource_id_param, '') = '' OR idrrh.resource_id = resource_id_param OR rid.resource_id = resource_id_param OR dmu.resource_id = resource_id_param
	ORDER BY
		invoice_document_scan_update_date DESC;
END$$
DELIMITER ;

