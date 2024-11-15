DELIMITER $$
DROP PROCEDURE IF EXISTS apas_allcostcodes_list;$$

CREATE PROCEDURE apas_allcostcodes_list
(
	IN company_code_param   INT,
	IN cost_type_param      INT
)
BEGIN
	SELECT
		cc.company_code,
		cc.cost_type,
		cc.res_type,
		cc.effective_date,
		cc.rtype_name,
		cc.rtype_description
	FROM
		apad_cost_codes cc
	WHERE
		cc.company_code = company_code_param
		AND (NULLIF(cost_type_param, 0) IS NULL OR cc.cost_type = cost_type_param)
	ORDER BY
		cc.rtype_name;
END$$
DELIMITER ;

