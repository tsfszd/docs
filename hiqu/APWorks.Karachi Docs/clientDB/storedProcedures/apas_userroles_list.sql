DELIMITER $$
DROP PROCEDURE IF EXISTS apas_userroles_list;$$

CREATE PROCEDURE apas_userroles_list(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		user_role_id,
		user_role_name,
		is_admin_role,
		allow_routing_setup,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apad_user_roles
	WHERE
		company_code = company_code_param;

	SELECT
		company_code,
		user_role_id,
		position_category_code,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apad_user_role_position_categories
	WHERE
		company_code = company_code_param;

	SELECT
		dt_ur.company_code,
		dt_ur.user_role_id,
		dt_ur.model_def_id,
		IFNULL(urir.allow_non_mapped_invoices_request_processing, 'N') AS allow_non_mapped_invoices_request_processing,
		IFNULL(urir.allow_invoice_model_mapping, 'N') AS allow_invoice_model_mapping,
		IFNULL(urir.allow_invoice_auto_routing, 'N') AS allow_invoice_auto_routing,
		IFNULL(urir.allow_invoice_manual_processing, 'N') AS allow_invoice_manual_processing,
		IFNULL(urir.allow_invoice_document_management, 'N') AS allow_invoice_document_management,
		IFNULL(urir.allow_invoice_correction, 'N') AS allow_invoice_correction,
		IFNULL(urir.allow_invoice_level_1_approval, 'N') AS allow_invoice_level_1_approval,
		IFNULL(urir.allow_invoice_level_2_approval, 'N') AS allow_invoice_level_2_approval,
		IFNULL(urir.allow_invoice_level_3_approval, 'N') AS allow_invoice_level_3_approval,
		IFNULL(urir.allow_invoice_level_4_approval, 'N') AS allow_invoice_level_4_approval,
		IFNULL(urir.allow_invoice_level_5_approval, 'N') AS allow_invoice_level_5_approval
	FROM
		(
		SELECT
			ur.user_role_id,
			ur.company_code,
			md.model_def_id
		FROM
			{COMMON_DATABASE}.apai_model_def md
			CROSS JOIN apad_user_roles ur
		) dt_ur
		LEFT OUTER JOIN apad_user_roles_invoice_rights urir ON urir.user_role_id = dt_ur.user_role_id AND urir.model_def_id = dt_ur.model_def_id AND urir.company_code = dt_ur.company_code
	WHERE
		dt_ur.company_code = company_code_param;
END$$
DELIMITER ;

