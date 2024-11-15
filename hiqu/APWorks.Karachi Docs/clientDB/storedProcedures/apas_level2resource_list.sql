DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level2resource_list;$$

CREATE PROCEDURE apas_level2resource_list
(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	SELECT DISTINCT
		l2.company_code,
		l2.level2_key,
		l2.level2_description,
		l2.level2_status_id,
		l2.open_date,
		l2.customer_code,
		l2.customer_name,
		l2.customer_po_number,
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
		apad_level2 l2
		INNER JOIN apad_level2_resources l2r ON l2r.company_code = l2.company_code
												AND l2r.level2_key = l2.level2_key
		INNER JOIN apad_resources r ON r.company_code = l2.company_code
										AND r.resource_id = l2r.resource_id
										AND r.active_flag = TRUE
		INNER JOIN apam_position_category pc ON pc.company_code = l2.company_code
												AND pc.position_category_code = l2r.position_category_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history rrh ON rrh.company_code = l2.company_code
																				AND rrh.invoice_document_id = IFNULL(invoice_document_id_param, 0)
																				AND rrh.resource_id = r.resource_id
																				AND rrh.suggestion_flag <> 'N'
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND (IFNULL(invoice_document_id_param, 0) = 0 OR (IFNULL(invoice_document_id_param, 0) <> 0 AND rrh.resource_id IS NOT NULL))
	ORDER BY
		r.resource_id;
END$$
DELIMITER ;

