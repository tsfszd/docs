DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_get_by_po_header;$$

CREATE PROCEDURE apas_resources_get_by_po_header
(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN po_code_param                        VARCHAR(32),
	IN client_code_param                    VARCHAR(32),
	IN client_name_param                    VARCHAR(256),
	IN campaign_name_param                  VARCHAR(512),
	IN media_plan_name_param	            VARCHAR(512)
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
		CASE WHEN model_def_id_param = 1 THEN por.resource_id WHEN model_def_id_param = 2 THEN dt_l2r.resource_id ELSE  '' END AS resource_id,
		CASE WHEN model_def_id_param = 1 THEN por.position_category_code WHEN model_def_id_param = 2 THEN dt_l2r.position_category_code ELSE  '' END AS position_category_code
	FROM
		apad_po_header ph
		LEFT OUTER JOIN apad_po_resources por ON por.po_code = ph.po_code
												AND por.company_code = ph.company_code
												AND ph.model_def_id = model_def_id_param
		LEFT OUTER JOIN
		(
			SELECT
				pd.company_code,
				pd.po_code,
				l2r.level2_key,
				l2r.resource_id,
				l2r.position_category_code
			FROM
				apad_po_detail pd
				INNER JOIN apad_level2_resources l2r ON l2r.level2_key = pd.level2_key
														AND l2r.company_code = pd.company_code
		) dt_l2r ON dt_l2r.po_code = ph.po_code
					AND dt_l2r.company_code = ph.company_code
					AND ph.model_def_id = model_def_id_param
	WHERE
		ph.company_code = company_code_param
		AND ((IFNULL(po_code_param, '') <> '' AND ph.po_code = po_code_param)
		OR (IFNULL(client_code_param, '') <> '' AND ph.client_code = client_code_param)
		OR (IFNULL(client_name_param, '') <> '' AND ph.client_name = client_name_param)
		OR (IFNULL(campaign_name_param, '') <> '' AND ph.campaign_name = campaign_name_param)
		OR (IFNULL(media_plan_name_param, '') <> '' AND ph.media_plan_name = media_plan_name_param));

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

	DROP TEMPORARY TABLE IF EXISTS _temp;
END$$
DELIMITER ;

