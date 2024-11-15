DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_get_by_level2;$$

CREATE PROCEDURE apas_resources_get_by_level2
(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN level2_key_param                     VARCHAR(32),
	IN level2_description_param             VARCHAR(128),
	IN customer_code_param                  VARCHAR(16),
	IN customer_name_param                  VARCHAR(64)
)
BEGIN
	DECLARE invoice_document_id_param   INT UNSIGNED;
	DECLARE model_def_id_param          INT UNSIGNED;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		resource_id             CHAR(16),
		position_category_code  INT
	);

	SELECT invoice_document_id, model_def_id INTO invoice_document_id_param, model_def_id_param FROM apad_invoice_document WHERE invoice_document_file_location LIKE (CONCAT(invoice_document_file_location_param, '%')) AND company_code = company_code_param;

	INSERT INTO _temp
	(
		resource_id,
		position_category_code
	)
	SELECT
		l2r.resource_id,
		l2r.position_category_code
	FROM
		apad_level2 l2
		LEFT OUTER JOIN apad_level2_resources l2r ON l2r.company_code = l2.company_code
												AND l2r.level2_key = l2.level2_key
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND ((IFNULL(level2_key_param, '') <> '' AND l2.level2_key = level2_key_param)
		OR (IFNULL(level2_description_param, '') <> '' AND l2.level2_description = level2_description_param)
		OR (IFNULL(customer_code_param, '') <> '' AND l2.customer_code = customer_code_param)
		OR (IFNULL(customer_name_param, '') <> '' AND l2.customer_name = customer_name_param));

	SELECT DISTINCT
		invoice_document_id_param AS invoice_document_id,
		model_def_id_param AS model_def_id,
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
		r.modify_id
	FROM
	(
		SELECT
			t.resource_id,
			t.user_role_id
		FROM
		(
			SELECT DISTINCT
				t.resource_id,
				IFNULL(urpc.user_role_id, urr.user_role_id) AS user_role_id
			FROM
				_temp t
			LEFT OUTER JOIN apad_user_role_position_categories urpc ON urpc.company_code = company_code_param
																	AND urpc.position_category_code = t.position_category_code
			LEFT OUTER JOIN apad_user_roles_resource urr ON urr.company_code = company_code_param
															AND urr.resource_id = t.resource_id
			WHERE
				urpc.user_role_id IS NOT NULL OR urr.user_role_id IS NOT NULL
		) t
		INNER JOIN apad_user_roles_invoice_rights urir ON urir.company_code = company_code_param
															AND urir.user_role_id = t.user_role_id
															AND urir.model_def_id = model_def_id_param
															AND urir.allow_invoice_auto_routing = 'Y'
	) dt_r
	INNER JOIN apad_resources r ON r.resource_id = dt_r.resource_id
									AND r.company_code = company_code_param
									AND r.active_flag = TRUE;
END$$
DELIMITER ;

