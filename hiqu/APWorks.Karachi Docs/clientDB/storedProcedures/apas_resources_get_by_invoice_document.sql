DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_get_by_invoice_document;$$

CREATE PROCEDURE apas_resources_get_by_invoice_document(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED,
	IN accept_reject_param          TINYINT
)
BEGIN
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;
	DECLARE invoice_document_status_id_param INT UNSIGNED;
	DECLARE next_status INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		resource_id             CHAR(16),
		name_last               VARCHAR(32),
		name_first              VARCHAR(32),
		name_init               VARCHAR(1),
		title                   VARCHAR(64),
		email                   VARCHAR(128),
		login_id                VARCHAR(64),
		res_password            VARCHAR(256),
		active_flag             TINYINT,
		create_id               VARCHAR(32),
		create_date             DATETIME,
		modify_id               VARCHAR(32),
		modify_date             DATETIME,
		position_category_code  INT,
		position_category_name  VARCHAR(64),
		protected_role_flag     INT
	);

	SET routing_number_of_approval_levels_param = (SELECT
														cac.routing_number_of_approval_levels
													FROM
														apam_company_approval_configuration cac
														INNER JOIN apad_invoice_document id ON id.company_code = cac.company_code
																								AND id.model_def_id = cac.model_def_id
																								AND id.invoice_document_id = invoice_document_id_param
													WHERE
														cac.company_code = company_code_param);

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	SET invoice_document_status_id_param = (SELECT invoice_document_status_id FROM apad_invoice_document WHERE invoice_document_id = invoice_document_id_param AND company_code = company_code_param);
	SET next_status = CASE WHEN accept_reject_param = TRUE THEN 20 WHEN accept_reject_param = FALSE THEN -30 ELSE 0 END;

	IF invoice_document_status_id_param = 50 AND next_status = 0 THEN
		SET next_status = 20;
	END IF;

	INSERT INTO _temp
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		res_password,
		active_flag,
		create_id,
		create_date,
		modify_date,
		modify_id,
		position_category_code,
		position_category_name,
		protected_role_flag
	)
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
		r.position_category_code,
		r.position_category_name,
		r.protected_role_flag
	FROM
		v_ResourcesByInvoiceDocument r
		INNER JOIN (
				SELECT
					urr.company_code,
					urr.resource_id,
					urir.model_def_id,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 35 ELSE NULL END AS allowed_missing_vendor_assignment,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 40 ELSE NULL END AS allowed_invoice_correction,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 60 ELSE NULL END AS allowed_vefified_invoice_error_correction,
					CASE WHEN urir.allow_invoice_level_1_approval = 'Y' THEN 70 ELSE NULL END AS allowed_level_1_status,
					CASE WHEN urir.allow_invoice_level_2_approval = 'Y' THEN 90 ELSE NULL END AS allowed_level_2_status,
					CASE WHEN urir.allow_invoice_level_3_approval = 'Y' THEN 110 ELSE NULL END AS allowed_level_3_status,
					CASE WHEN urir.allow_invoice_level_4_approval = 'Y' THEN 130 ELSE NULL END AS allowed_level_4_status,
					CASE WHEN urir.allow_invoice_level_5_approval = 'Y' THEN 150 ELSE NULL END AS allowed_level_5_status
				FROM
					apad_user_roles_invoice_rights urir
					INNER JOIN  apad_user_roles_resource urr ON urr.company_code = urir.company_code
														AND urr.user_role_id = urir.user_role_id
					INNER JOIN  apad_user_roles ur ON ur.company_code = urr.company_code
														AND ur.user_role_id = urr.user_role_id
					) AS dt_urir ON r.company_code = dt_urir.company_code
									AND r.resource_id = dt_urir.resource_id
									AND r.model_def_id = dt_urir.model_def_id
	WHERE
		r.invoice_document_id = invoice_document_id_param
		AND r.company_code = company_code_param
		AND r.active_flag = TRUE
		#AND IFNULL(r.email, '') <> ''
		AND ((r.invoice_document_status_id + next_status) IN (dt_urir.allowed_missing_vendor_assignment, dt_urir.allowed_invoice_correction, dt_urir.allowed_vefified_invoice_error_correction, dt_urir.allowed_level_1_status, dt_urir.allowed_level_2_status, dt_urir.allowed_level_3_status, dt_urir.allowed_level_4_status) OR r.invoice_document_status_id = max_possible_approved_status_id);

	IF EXISTS (SELECT 1 FROM _temp) THEN
		SELECT
			company_code,
			resource_id,
			name_last,
			name_first,
			name_init,
			title,
			email,
			login_id,
			res_password,
			#active_flag,
			create_id,
			create_date,
			modify_date,
			modify_id,
			position_category_code,
			position_category_name,
			protected_role_flag,
            NULL as is_admin_role
		FROM
			_temp;
	ELSE
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
			#r.active_flag,
			r.create_id,
			r.create_date,
			r.modify_date,
			r.modify_id,
			ur.is_admin_role
		FROM
			apad_resources r
			INNER JOIN apad_user_roles_resource urr ON r.resource_id = urr.resource_id
														AND r.company_code = urr.company_code
			INNER JOIN apad_user_roles ur ON urr.user_role_id = ur.user_role_id
														AND urr.company_code = ur.company_code
			LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.company_code = r.company_code
																AND dmu.invoice_document_id = invoice_document_id_param
		WHERE
			r.company_code = company_code_param
			AND r.active_flag = TRUE
			#AND IFNULL(r.email, '') <> ''
			AND (ur.is_admin_role = 'Y' OR dmu.resource_id = r.resource_id);
	END IF;

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

