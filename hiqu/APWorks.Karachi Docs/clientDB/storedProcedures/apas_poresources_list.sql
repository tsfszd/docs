DELIMITER $$
DROP PROCEDURE IF EXISTS apas_poresources_list;$$

CREATE PROCEDURE apas_poresources_list(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN resource_id_param    CHAR(16)
)
BEGIN
	SELECT
		por.company_code,
		por.po_code,
		por.resource_id,
		por.position_category_code,
		r.name_first,
		r.name_last,
		pc.position_category_name
	FROM
		apad_po_resources por
		INNER JOIN apad_resources r ON r.company_code = por.company_code
										AND r.resource_id = por.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = por.company_code
										AND pc.position_category_code = por.position_category_code
	WHERE
		por.company_code = company_code_param
		AND (IFNULL(po_code_param, '') = '' OR por.po_code = po_code_param)
		AND (IFNULL(resource_id_param, '') = '' OR por.resource_id = resource_id_param)
	ORDER BY
		por.po_code;
END$$
DELIMITER ;

