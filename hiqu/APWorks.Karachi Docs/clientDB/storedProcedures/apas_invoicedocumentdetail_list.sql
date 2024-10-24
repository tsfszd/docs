DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentdetail_list;$$

CREATE PROCEDURE apas_invoicedocumentdetail_list
(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_status_id,
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
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, zero) AS io_invoice_amount,
		IFNULL(ph.po_amount, zero) AS po_amount,
		IFNULL(ph.consumed_amount, zero) AS consumed_amount,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount, zero) AS remaining_amount,
		SUM(pmd.delivery_amount) AS delivery_amount,
		cc.rtype_name,
        CASE WHEN model_def_id_param = 1 THEN ph.client_code ELSE l2.customer_code END as client_code,
        CASE WHEN model_def_id_param = 1 THEN ph.client_name ELSE l2.customer_name END as client_name,
        v.vendor_name
	FROM
		apad_invoice_document id
		INNER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
		LEFT OUTER JOIN apad_po_header ph ON ph.company_code = id.company_code
												AND ph.vendor_code = id.vendor_code
												AND ph.site_id = id.site_id
												AND ph.active_flag = TRUE
												AND ((ph.po_code = idd.io_number AND model_def_id_param = 1) OR (ph.po_code = id.po_code AND model_def_id_param = 2))
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
						) dt_pd ON dt_pd.company_code = id.company_code
									AND dt_pd.po_code = id.po_code
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.company_code = idd.company_code
												AND pmd.po_code = ph.po_code
												AND pmd.delivery_date BETWEEN id.service_term_start_date AND id.service_term_end_date
		LEFT OUTER JOIN apad_cost_codes cc ON idd.cost_type = cc.cost_type
														AND idd.res_type = cc.res_type
														AND idd.company_code = cc.company_code
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = dt_pd.level2_key
										AND dt_pd.company_code = cc.company_code
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.company_code = id.company_code
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND id.is_deleted = FALSE
	GROUP BY
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_status_id,
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
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, zero),
		IFNULL(ph.po_amount, zero),
		IFNULL(ph.consumed_amount, zero),
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount, zero),
		cc.rtype_name,
        client_code,
        client_name,
        v.vendor_name;
END$$
DELIMITER ;

