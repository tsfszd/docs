DROP PROCEDURE IF EXISTS apas_podetail_list;

DELIMITER $$
CREATE PROCEDURE apas_podetail_list
(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT
		pd.company_code,
		pd.po_code,
		pd.line_id,
		pd.level2_key,
        l2.level2_description,
		pd.level3_key,
		pd.cost_category,
		pd.due_date,
		pd.quantity,
		pd.net_cost,
		pd.match_to_date_net,
		pd.close_flag
	FROM
		apad_po_detail pd
	INNER JOIN apad_level2 l2 ON pd.company_code = l2.company_code 
								AND pd.level2_key = l2.level2_key 
	WHERE
		pd.company_code = company_code_param
        AND (IFNULL(po_code_param, '') = '' OR pd.po_code = po_code_param);
END$$

DELIMITER ;

