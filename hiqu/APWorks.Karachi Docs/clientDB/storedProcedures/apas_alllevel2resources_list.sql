DELIMITER $$
DROP PROCEDURE IF EXISTS apas_alllevel2resources_list;$$

CREATE PROCEDURE apas_alllevel2resources_list(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	SELECT
		l2r.company_code,
		l2r.level2_key,
		l2r.resource_id,
		l2r.position_category_code,
		l2r.effective_date,
		r.name_first,
		r.name_last,
		pc.position_category_name
	FROM
		apad_level2_resources l2r
		INNER JOIN apad_resources r ON r.company_code = l2r.company_code
										AND r.resource_id = l2r.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = l2r.company_code
										AND pc.position_category_code = l2r.position_category_code
	WHERE
		l2r.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l2r.level2_key = level2_key_param);
END$$
DELIMITER ;

