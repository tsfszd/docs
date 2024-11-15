DELIMITER $$
DROP PROCEDURE IF EXISTS apas_alllevel2_list;$$

CREATE PROCEDURE apas_alllevel2_list
(
	IN company_code_param   INT
)
BEGIN
	SELECT
		l2.company_code,
		l2.level2_key,
		l2.level2_description,
		l2.level2_status_id,
		l2.open_date,
		l2.customer_code,
		l2.customer_name,
		l2.customer_po_number,
		l2.po_required_flag,
		l2.tolerance_po_flag,
		l2.tolerance_po_amount,
		l2s.level2_status_name
	FROM
		apad_level2 l2
		INNER JOIN {COMMON_DATABASE}.apai_level2_status l2s ON l2.level2_status_id = l2s.level2_status_id
	WHERE
		l2.company_code = company_code_param
	ORDER BY
		l2.level2_description;
END$$
DELIMITER ;

