DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level2_list;$$

CREATE PROCEDURE apas_level2_list
(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN no_po_flag_param     CHAR(1)
)
BEGIN
	SELECT DISTINCT
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
		l2.tolerance_po_amount
	FROM
		apad_level2 l2
		LEFT OUTER JOIN v_PODetail pd ON pd.level2_key = l2.level2_key
											AND pd.company_code = l2.company_code
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND ((IFNULL(po_code_param, '') = '' AND (IFNULL(no_po_flag_param, 'N') = 'Y' OR IFNULL(l2.po_required_flag, 'N') = 'N')) OR pd.po_code = po_code_param)
	ORDER BY
		l2.level2_description;
END$$
DELIMITER ;

