DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_authenticate;$$

CREATE PROCEDURE apas_resources_authenticate(
	IN login_id_param       	VARCHAR(64),
	IN res_password_param   	VARCHAR(256),
	IN email_param          	VARCHAR(128),
	IN ignore_password_param    CHAR(1)
)
BEGIN
	SELECT
		u.company_code,
		u.resource_id,
		u.name_last,
		u.name_first,
		u.name_init,
		u.title,
		u.email,
		u.login_id,
		u.res_password,
		u.active_flag,
		u.password_reset_flag,
		u.create_id,
		u.create_date,
		u.modify_date,
		u.modify_id,
		c.co_name,
		c.co_short_name
	FROM
		apad_resources u
		INNER JOIN apam_company c ON c.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param = 'Y'))
		)
		AND active_flag = TRUE;

	SELECT
		u.resource_id,
		ur.company_code,
		ur.user_role_id,
		ur.user_role_name,
		ur.is_admin_role,
		ur.allow_routing_setup,
		ur.create_id,
		ur.create_date,
		ur.modify_id,
		ur.modify_date
	FROM
		apad_resources u
		INNER JOIN apad_user_roles_resource urr ON urr.resource_id = u.resource_id
												AND urr.company_code = u.company_code
		INNER JOIN apad_user_roles ur ON ur.user_role_id = urr.user_role_id
										AND ur.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(u.login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param  = 'Y'))
		)
		AND u.active_flag = TRUE;

	SELECT
		u.resource_id,
		urir.company_code,
		urir.user_role_id,
		urir.model_def_id,
		urir.allow_non_mapped_invoices_request_processing,
		urir.allow_invoice_model_mapping,
		urir.allow_invoice_manual_processing,
		urir.allow_invoice_document_management,
		urir.allow_invoice_correction,
		urir.allow_invoice_level_1_approval,
		urir.allow_invoice_level_2_approval,
		urir.allow_invoice_level_3_approval,
		urir.allow_invoice_level_4_approval,
		urir.allow_invoice_level_5_approval
	FROM
		apad_resources u
		INNER JOIN apad_user_roles_resource urr ON urr.resource_id = u.resource_id
												AND urr.company_code = u.company_code
		INNER JOIN apad_user_roles ur ON ur.user_role_id = urr.user_role_id
										AND ur.company_code = u.company_code
		INNER JOIN apad_user_roles_invoice_rights urir ON urir.user_role_id = ur.user_role_id
										AND urir.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(u.login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param  = 'Y'))
		)
		AND u.active_flag = TRUE;
END$$
DELIMITER ;

