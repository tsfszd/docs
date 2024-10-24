DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level3_list;$$

CREATE PROCEDURE apas_level3_list(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32),
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT DISTINCT
		l3.company_code,
		l3.level2_key,
		l3.level3_key,
		l3.level3_description,
		l3.level3_status_id,
		l3.open_date,
		l3.cost_type,
		l3.customer_po_number,
		l3.expense_flag,
		l2.po_required_flag,
		l2.tolerance_po_flag,
		l2.tolerance_po_amount
	FROM
		apad_level3 l3
		INNER JOIN apad_level2 l2 ON l2.level2_key = l3.level2_key
										AND l2.company_code = l3.company_code
										AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_po_detail pd ON pd.level2_key = l3.level2_key
											AND pd.level3_key = l3.level3_key
											AND pd.company_code = l3.company_code
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
		AND l3.level3_status_id = 1
		AND l3.expense_flag = TRUE
		AND (IFNULL(po_code_param, '') = '' OR pd.po_code = po_code_param)
	ORDER BY
		l3.level3_description;
END$$
DELIMITER ;

