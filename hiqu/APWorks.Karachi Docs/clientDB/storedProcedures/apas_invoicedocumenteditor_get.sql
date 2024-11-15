DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumenteditor_get;$$

CREATE PROCEDURE apas_invoicedocumenteditor_get(
	IN company_code_param        INT,
	IN invoice_document_id_param INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		IFNULL(id.master_document_model_id, zero) AS master_document_model_id,
		id.document_model_request_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		IFNULL(id.payment_term_code, '') AS payment_term_code,
		IFNULL(id.currency_code, '') AS currency_code,
		id.scanned_total,
		id.po_code,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		dm.document_model_name,
		dm.document_model_name_tag,
		mr.request_to_map,
		mr.manual_processing,
		IFNULL(sm.invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		sm.manual_upload_flag,
		v.vendor_code,
		v.vendor_name,
		v.short_name,
		v.site_id,
		no_po_flag,
		idrrh.routed_to_resource_id,
		CASE WHEN dt_ph.po_code IS NULL THEN 'N' ELSE 'Y' END AS is_po_code_valid
	FROM
		apad_invoice_document id
		LEFT OUTER JOIN apam_document_model dm ON dm.master_document_model_id = id.master_document_model_id
													AND dm.company_code = id.company_code
		LEFT OUTER JOIN apam_document_model_request mr ON mr.document_model_request_id = id.document_model_request_id
		LEFT OUTER JOIN apad_invoice_scanner_monitor sm ON sm.scanner_monitor_record_id = mr.scanner_monitor_record_id
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.site_id = id.site_id
										AND v.company_code = id.company_code
		LEFT OUTER JOIN (SELECT
							resource_id AS routed_to_resource_id
						FROM
							apad_invoice_document_resource_routing_history
						WHERE
							company_code = company_code_param
							AND invoice_document_id = invoice_document_id_param
						ORDER BY
							sequence_id DESC
						LIMIT 1
						) AS idrrh ON 1 = 1
		LEFT OUTER JOIN (SELECT DISTINCT
							ph.po_code,
							ph.vendor_code,
							ph.site_id,
							ph.company_code
						FROM
							apad_po_header ph
							INNER JOIN apad_po_detail pd ON ph.company_code = pd.company_code
												AND ph.po_code = pd.po_code
												AND ph.model_def_id = 2
												AND ph.active_flag = TRUE
												AND pd.close_flag = FALSE
						) dt_ph ON dt_ph.company_code = id.company_code
									AND dt_ph.po_code = id.po_code
									AND dt_ph.vendor_code = id.vendor_code
									AND dt_ph.site_id = id.site_id
	WHERE
		id.company_code = company_code_param
		AND id.invoice_document_id = invoice_document_id_param
		AND id.is_deleted = FALSE;

	SELECT
		idd.company_code,
		idd.invoice_document_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, 0) AS io_invoice_amount,
		ph.po_code,
		IFNULL(ph.po_amount, zero) AS po_amount,
		IFNULL(ph.consumed_amount, zero) + IFNULL(SUM(idd2.io_invoice_amount), 0.00) AS consumed_amount,
		SUM(pmd.delivery_amount) AS delivery_amount,
		ph.campaign_name,
		ph.media_plan_name,
		cc.rtype_name,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount,0) AS remaining_amount,
		l2.level2_description,
		l2.po_required_flag,
		IFNULL(l2.tolerance_po_amount,0) AS tolerance_po_amount,
		l2.tolerance_po_flag,
		CASE WHEN ph.po_code IS NULL THEN 'N' ELSE 'Y' END AS is_io_number_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND l2.level2_key IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.level2_key IS NULL)) THEN 'N' ELSE 'Y' END AS is_level2_key_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND l3.level3_key IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.level3_key IS NULL)) THEN 'N' ELSE 'Y' END AS is_level3_key_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND cc.res_type IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.cost_category IS NULL)) THEN 'N' ELSE 'Y' END AS is_cost_codes_valid
	FROM
		apad_invoice_document_detail idd
		INNER JOIN apad_invoice_document id ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
														AND id.is_deleted = FALSE
		LEFT OUTER JOIN apad_po_header ph ON ph.po_code = idd.io_number
												AND ph.vendor_code = id.vendor_code
												AND ph.site_id = id.site_id
												AND ph.company_code = idd.company_code
												AND ph.active_flag = TRUE
		LEFT OUTER JOIN apad_invoice_document id2 ON id2.company_code = ph.company_code
                                                        AND id2.vendor_code = ph.vendor_code
                                                        AND id2.is_deleted = 0
                                                        AND id2.invoice_document_id <> invoice_document_id_param
                                                        AND id2.invoice_document_status_id <> 170
			LEFT OUTER JOIN apad_invoice_document_detail idd2 ON idd2.io_number = ph.po_code
														AND idd2.company_code = id2.company_code
                                                        AND idd2.invoice_document_id = id2.invoice_document_id
		LEFT OUTER JOIN (
						SELECT DISTINCT
							pd.po_code,
							pd.company_code,
							pd.level2_key,
							pd.level3_key,
							pd.cost_category,
							pd.quantity,
							pd.net_cost,
							pd.match_to_date_net,
							pd.remaining_amount
						FROM
							v_PODetail pd
						) dt_pd ON dt_pd.po_code = id.po_code
									AND dt_pd.company_code = id.company_code
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = idd.level2_key
												AND l2.company_code = idd.company_code
												AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = idd.level2_key
												AND l3.level3_key = idd.level3_key
												AND l3.company_code = idd.company_code
												AND l3.level3_status_id = 1
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.po_code = ph.po_code
												AND pmd.company_code = idd.company_code
												AND pmd.delivery_date BETWEEN id.service_term_start_date AND id.service_term_end_date
		LEFT OUTER JOIN apad_cost_codes cc ON idd.cost_type = cc.cost_type
														AND idd.res_type = cc.res_type
														AND idd.company_code = id.company_code
	WHERE
		idd.company_code = company_code_param
		AND idd.invoice_document_id = invoice_document_id_param
	GROUP BY
		idd.company_code,
		idd.invoice_document_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		idd.io_invoice_amount,
		ph.po_code,
		po_amount,
		consumed_amount,
		ph.campaign_name,
		ph.media_plan_name,
		cc.rtype_name,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		dt_pd.remaining_amount,
		l2.level2_description,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag,
		is_io_number_valid,
		is_level2_key_valid,
		is_level3_key_valid,
		is_cost_codes_valid;

	SELECT
		terms_code,
		terms_desc,
		days_due
	FROM
		apam_payment_terms;

	SELECT
		currency_code,
		currency_name
	FROM
		apam_currencies;
END$$
DELIMITER ;

