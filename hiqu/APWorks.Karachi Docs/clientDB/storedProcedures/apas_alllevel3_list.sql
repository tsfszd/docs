DELIMITER $$
DROP PROCEDURE IF EXISTS apas_alllevel3_list;$$

CREATE PROCEDURE apas_alllevel3_list(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	SELECT
		l3.company_code,
		l3.level2_key,
		l3.level3_key,
		l3.level3_description,
		l3.level3_status_id,
		l3.open_date,
		l3.cost_type,
		l3.customer_po_number,
		l3.expense_flag,
		l3s.level3_status_name
	FROM
		apad_level3 l3
		INNER JOIN {COMMON_DATABASE}.apai_level3_status l3s ON l3.level3_status_id = l3s.level3_status_id
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
	ORDER BY
		l3.level3_description;
END$$
DELIMITER ;

