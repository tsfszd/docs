DELIMITER $$
DROP PROCEDURE IF EXISTS apas_paymentdashboard_list;$$

CREATE PROCEDURE apas_paymentdashboard_list
(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED,
	IN user_role_id_param   INT,
	IN resource_id_param    CHAR(16)
)
BEGIN
	SELECT DISTINCT
		id.company_code,
		id.invoice_number,
		id.invoice_date,
		id.transaction_id,
		idd.amount,
		v.vendor_code,
		v.vendor_name,
		poh.po_code AS io_number,
		poh.campaign_name,
		poh.media_plan_name,
		pod.level2_key,
		pod.level2_key AS job_code,
		pod.level3_key,
		pod.level3_key AS activity_code,
		p.check_number,
		p.document_date,
		CASE WHEN IFNULL(d_p.payment_amount, 0.0) = 0.0 THEN 1 WHEN IFNULL(d_p.payment_amount, 0.0) >= idd.amount THEN 3 ELSE 2 END AS payment_status_id,
		CASE WHEN IFNULL(d_p.payment_amount, 0.0) = 0.0 THEN 'Unpaid' WHEN IFNULL(d_p.payment_amount, 0.0) >= idd.amount THEN 'Fully Paid' ELSE 'Partially Paid' END AS payment_status,
		IFNULL(d_p.payment_amount, 0.0) AS payment_amount,
		d_p.payment_info,
		pm.invoice_document_posting_update_date AS posted_date,
		iah.approval_rejection_user_id,
		CONCAT(rr.name_last,', ', rr.name_first) AS approved_by
	FROM
		apad_invoice_document id
	INNER JOIN (
				SELECT
					company_code,
					invoice_document_id,
					CAST(SUM(io_invoice_amount) AS DECIMAL(19, 2)) AS amount
				FROM
					apad_invoice_document_detail
				WHERE
					company_code = company_code_param
				GROUP BY
					company_code,
					invoice_document_id
				) AS idd ON idd.company_code = id.company_code
							AND idd.invoice_document_id = id.invoice_document_id
	INNER JOIN apad_vendors v ON v.company_code = id.company_code
								AND v.vendor_code = id.vendor_code
	INNER JOIN apad_po_header poh ON poh.company_code = id.company_code
									AND poh.po_code = id.po_code
	INNER JOIN apad_invoice_posting_monitor pm ON pm.company_code = id.company_code
													AND pm.invoice_document_id = id.invoice_document_id
													AND pm.invoice_document_posting_status_id = 20
	INNER JOIN v_ResourcesByInvoiceDocument rbid ON rbid.company_code = id.company_code
													AND rbid.invoice_document_id = id.invoice_document_id
	INNER JOIN (
				SELECT
					company_code,
					invoice_document_id,
					approval_rejection_user_id,
					MAX(sequence_id)
				FROM
					apad_invoice_document_routing_history
				GROUP BY
					invoice_document_id
				) iah ON iah.company_code = id.company_code 
					AND iah.invoice_document_id = id.invoice_document_id
	INNER JOIN apad_user_role_position_categories urpc ON urpc.position_category_code = rbid.position_category_code
															AND urpc.company_code = rbid.company_code
															AND (urpc.user_role_id = user_role_id_param OR IFNULL(resource_id_param, '') = '')
	LEFT OUTER JOIN apad_ap_payment p ON p.company_code = id.company_code
										AND p.invoice_number = id.invoice_number
	LEFT OUTER JOIN (
					SELECT
						company_code,
						invoice_number,
						SUM(payment_amount) AS payment_amount,
						GROUP_CONCAT(DISTINCT CONCAT(check_number, ' (', payment_amount, ')') ORDER BY check_number SEPARATOR ', ') AS payment_info
					FROM
						apad_ap_payment
					GROUP BY
						company_code,
						invoice_number
					) AS d_p ON d_p.company_code = id.company_code
								AND d_p.invoice_number = id.invoice_number
	LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = id.company_code
																			AND idrrh.invoice_document_id = id.invoice_document_id
	LEFT OUTER JOIN apad_resources r ON r.resource_id = idrrh.resource_id
										AND r.company_code = p.company_code
										AND r.active_flag = TRUE
	LEFT OUTER JOIN apad_resources rr ON rr.resource_id = iah.approval_rejection_user_id
										AND rr.company_code = iah.company_code
										AND rr.active_flag = TRUE
	LEFT OUTER JOIN apad_po_detail pod ON pod.company_code = poh.company_code
										AND pod.po_code = poh.po_code
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
	ORDER BY
		document_date DESC;
END$$
DELIMITER ;

