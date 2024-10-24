DELIMITER $$
DROP PROCEDURE IF EXISTS apas_costcodes_list;$$

CREATE PROCEDURE apas_costcodes_list
(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32),
	IN level3_key_param     VARCHAR(32),
	IN po_code_param        VARCHAR(32)
)
BEGIN
	IF IFNULL(po_code_param, '') = '' THEN
		SELECT DISTINCT
			cc.company_code,
			cc.res_type,
			cc.effective_date,
			cc.rtype_name,
			cc.rtype_description
		FROM
			apad_level3 l3
			INNER JOIN apad_cost_codes cc ON l3.cost_type = cc.cost_type
										AND l3.company_code = cc.company_code
		WHERE
			l3.company_code = company_code_param
			AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
			AND (IFNULL(level3_key_param, '') = '' OR l3.level3_key = level3_key_param)
		ORDER BY
			cc.rtype_name;
	ELSE
		SELECT DISTINCT
				cc.company_code,
				cc.res_type,
				cc.effective_date,
				cc.rtype_name,
				cc.rtype_description,
				pd.net_cost,
				pd.match_to_date_net,
				pd.remaining_amount
			FROM
				apad_cost_codes cc
				INNER JOIN v_PODetail pd ON pd.po_code = po_code_param
											AND pd.level2_key = level2_key_param
											AND pd.level3_key = level3_key_param
											AND pd.cost_category = cc.res_type
											AND pd.company_code = cc.company_code
				INNER JOIN apad_level3 l3 ON l3.company_code = cc.company_code
											AND l3.cost_type = cc.cost_type
											AND l3.level2_key = pd.level2_key
											AND l3.level3_key = pd.level3_key
			WHERE
				cc.company_code = company_code_param
			ORDER BY
				cc.rtype_name;
	END IF;
END$$
DELIMITER ;

