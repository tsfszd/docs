DELIMITER $$
DROP PROCEDURE IF EXISTS apas_poheaderbyvendor_list;$$

CREATE PROCEDURE apas_poheaderbyvendor_list
(
	IN company_code_param               INT,
	IN vendor_code_param                CHAR(12),
	IN site_id_param                    CHAR(32),
	IN service_term_start_date_param    DATE,
	IN service_term_end_date_param      DATE,
	IN model_def_id_param               INT UNSIGNED,
	IN invoice_document_id_param        INT UNSIGNED
)
BEGIN
	IF model_def_id_param = 1 THEN
		SELECT
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			ph.po_amount,
			ph.consumed_amount + IFNULL(dt_io.io_invoice_amount, 0.00) AS consumed_amount,
			ph.client_code,
			ph.client_name,
			ph.job_code,
			ph.campaign_name,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id,
			IFNULL(SUM(pmd.delivery_amount), 0.00) AS delivery_amount
		FROM
			apad_po_header ph
			LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.po_code = ph.po_code
														AND pmd.company_code = ph.company_code
														AND pmd.delivery_date BETWEEN service_term_start_date_param AND service_term_end_date_param
			LEFT OUTER JOIN (SELECT
								id.company_code,
								idd.io_number,
								SUM(idd.io_invoice_amount) AS io_invoice_amount
							FROM
								apad_invoice_document id
								LEFT OUTER JOIN apad_invoice_document_detail idd ON idd.company_code = id.company_code
																					AND idd.invoice_document_id = id.invoice_document_id
							WHERE
								id.company_code = company_code_param
								AND id.vendor_code = vendor_code_param
								AND id.site_id = site_id_param
								AND id.invoice_document_id <> invoice_document_id_param
								AND id.is_deleted = 0
								AND id.invoice_document_status_id <> 170
								AND idd.io_number IS NOT NULL
							GROUP BY
								id.company_code,
								idd.io_number) dt_io ON dt_io.company_code = ph.company_code
														AND dt_io.io_number = ph.po_code
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param
			AND ph.model_def_id = model_def_id_param
		GROUP BY
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			ph.po_amount,
			ph.consumed_amount,
			ph.client_code,
			ph.client_name,
			ph.job_code,
			ph.campaign_name,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id
		ORDER BY
			ph.po_code;
	ELSE
		SELECT DISTINCT
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			SUM(pd.net_cost) AS po_amount,
			SUM(pd.match_to_date_net) + IFNULL(dt_io.io_invoice_amount, 0.00) AS consumed_amount,
			ph.client_code,
			pd.customer_name AS client_name,
			pd.level2_key AS job_code,
			pd.level2_description AS campaign_name,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id
		FROM
			apad_po_header ph
			INNER JOIN v_PODetail pd ON pd.company_code = ph.company_code
											AND pd.po_code = ph.po_code
			LEFT OUTER JOIN (SELECT
								id.company_code,
								id.po_code,
								SUM(idd.io_invoice_amount) AS io_invoice_amount
							FROM
								apad_invoice_document id
								LEFT OUTER JOIN apad_invoice_document_detail idd ON idd.company_code = id.company_code
																					AND idd.invoice_document_id = id.invoice_document_id
							WHERE
								id.company_code = company_code_param
								AND id.vendor_code = vendor_code_param
								AND id.site_id = site_id_param
								AND id.invoice_document_id <> invoice_document_id_param
								AND id.is_deleted = 0
								AND id.invoice_document_status_id <> 170
								AND idd.io_number IS NOT NULL
							GROUP BY
								id.company_code,
								id.po_code) dt_io ON dt_io.company_code = ph.company_code
														AND dt_io.po_code = ph.po_code
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param
			AND ph.active_flag = TRUE
		GROUP BY
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			ph.client_code,
			pd.customer_name,
			pd.level2_key,
			pd.level2_description,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id
		ORDER BY
			ph.po_code;

		SELECT
			pd.company_code,
			pd.po_code,
			pd.line_id,
			pd.level2_key,
			pd.level3_key,
			pd.cost_category,
			pd.due_date,
			pd.quantity,
			pd.net_cost,
			pd.match_to_date_net,
			pd.close_flag,
			IFNULL(l2.tolerance_po_flag, 'N') AS tolerance_po_flag,
			IFNULL(l2.tolerance_po_amount, 0) AS tolerance_po_amount
		FROM
			apad_po_header ph
			INNER JOIN apad_po_detail pd ON pd.company_code = ph.company_code
											AND pd.po_code = ph.po_code
											AND pd.close_flag = FALSE
			INNER JOIN apad_level2 l2 ON l2.company_code = pd.company_code
										AND l2.level2_key = pd.level2_key
										AND l2.level2_status_id = 1
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param;
	END IF;
END$$
DELIMITER ;

