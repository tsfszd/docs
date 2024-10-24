DELIMITER $$

CREATE OR REPLACE VIEW v_ResourcesByInvoiceDocument AS
	SELECT DISTINCT
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		id.model_def_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_invoice_document id
		INNER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
		INNER JOIN apad_po_resources por ON por.po_code = idd.io_number
												AND por.company_code = idd.company_code
		INNER JOIN apad_resources r ON r.resource_id = por.resource_id
										AND r.company_code = por.company_code
		INNER JOIN apam_position_category pc ON pc.position_category_code = por.position_category_code
												AND pc.company_code = por.company_code
	WHERE
		id.is_deleted = FALSE
		AND id.model_def_id = 1
	UNION
	SELECT DISTINCT
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		id.model_def_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_invoice_document id
		INNER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
		INNER JOIN apad_level2_resources l2r ON l2r.level2_key = idd.level2_key
												AND l2r.company_code = idd.company_code
		INNER JOIN apad_resources r ON r.resource_id = l2r.resource_id
										AND r.company_code = l2r.company_code
		INNER JOIN apam_position_category pc ON pc.position_category_code = l2r.position_category_code
												AND pc.company_code = l2r.company_code
	WHERE
		id.is_deleted = FALSE
		AND id.model_def_id = 2;
$$
DELIMITER ;

