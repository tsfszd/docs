DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resources_get_by_resources;$$

CREATE PROCEDURE apas_resources_get_by_resources
(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN resource_id_param                    CHAR(16),
	IN name_last_param                      VARCHAR(128),
	IN name_first_param                     VARCHAR(16),
	IN email_param                          VARCHAR(64),
	IN login_id_param                       VARCHAR(64)
)
BEGIN
	DECLARE invoice_document_id_param   INT UNSIGNED;
	DECLARE model_def_id_param          INT UNSIGNED;

	SELECT invoice_document_id, model_def_id INTO invoice_document_id_param, model_def_id_param FROM apad_invoice_document WHERE invoice_document_file_location LIKE (CONCAT(invoice_document_file_location_param, '%')) AND company_code = company_code_param;

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
		apad_resources r
	WHERE
		r.company_code = company_code_param
		AND r.active_flag = TRUE
		AND ((IFNULL(resource_id_param, '') <> '' AND r.resource_id = resource_id_param)
		OR (IFNULL(name_last_param, '') <> '' AND r.name_last = name_last_param)
		OR (IFNULL(name_first_param, '') <> '' AND r.name_first = name_first_param)
		OR (IFNULL(email_param, '') <> '' AND r.email = email_param)
		OR (IFNULL(login_id_param, '') <> '' AND r.login_id = login_id_param));
END$$
DELIMITER ;

