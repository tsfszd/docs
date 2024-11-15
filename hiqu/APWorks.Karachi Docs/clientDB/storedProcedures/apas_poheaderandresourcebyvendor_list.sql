DELIMITER $$
DROP PROCEDURE IF EXISTS apas_poheaderandresourcebyvendor_list;$$

CREATE PROCEDURE apas_poheaderandresourcebyvendor_list
(
	IN company_code_param           INT,
	IN vendor_code_param            CHAR(12),
	IN site_id_param                CHAR(32),
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	SELECT DISTINCT
		ph.company_code,
		ph.vendor_code,
		ph.site_id,
		ph.client_code,
		ph.client_name,
		ph.job_code,
		ph.campaign_name,
		ph.activity_code,
		ph.media_plan_name,
		ph.model_def_id,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.title,
		r.email,
		r.login_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_po_header ph
		INNER JOIN apad_po_resources pr ON pr.po_code = ph.po_code
											AND pr.company_code = ph.company_code
		INNER JOIN apad_resources r ON r.resource_id = pr.resource_id
											AND r.company_code = ph.company_code
											AND r.active_flag = TRUE
		INNER JOIN apam_position_category pc ON pc.position_category_code = pr.position_category_code
												AND pc.company_code = ph.company_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history rrh ON rrh.company_code = ph.company_code
																				AND rrh.invoice_document_id = IFNULL(invoice_document_id_param, 0)
																				AND rrh.resource_id = r.resource_id
																				AND rrh.suggestion_flag <> 'N'
	WHERE
		ph.company_code = company_code_param
		AND (IFNULL(vendor_code_param, '') = '' OR ph.vendor_code = vendor_code_param)
		AND (IFNULL(site_id_param, '') = '' OR ph.site_id = site_id_param)
		AND (IFNULL(invoice_document_id_param, 0) = 0 OR (IFNULL(invoice_document_id_param, 0) <> 0 AND rrh.resource_id IS NOT NULL))
	ORDER BY
		r.resource_id;
END$$
DELIMITER ;

