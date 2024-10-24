DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level3withcostcodes_list;$$

CREATE PROCEDURE apas_level3withcostcodes_list(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	CALL apas_level3_list(company_code_param, level2_key_param, '');

	SELECT DISTINCT
		cc.company_code,
		cc.cost_type,
		cc.res_type,
		cc.effective_date,
		cc.rtype_name,
		cc.rtype_description
	FROM
		apad_cost_codes cc
		INNER JOIN apad_level3 l3 ON cc.cost_type = l3.cost_type
										AND cc.company_code = l3.company_code
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
		AND l3.level3_status_id = 1
		AND l3.expense_flag = TRUE
	ORDER BY
		cc.rtype_name;
END$$
DELIMITER ;

