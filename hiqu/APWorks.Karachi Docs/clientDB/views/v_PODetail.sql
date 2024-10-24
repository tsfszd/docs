DELIMITER $$

CREATE OR REPLACE VIEW v_PODetail AS
	SELECT
		pd.company_code,
		pd.po_code,
		pd.level2_key,
		pd.level3_key,
		pd.cost_category,
		SUM(pd.quantity) AS quantity,
		SUM(pd.net_cost) AS net_cost,
		SUM(pd.match_to_date_net) AS match_to_date_net,
		SUM(pd.net_cost) - SUM(pd.match_to_date_net) AS remaining_amount,
		l2.customer_name,
		l2.level2_description,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag
	FROM
		apad_po_detail pd
		INNER JOIN apad_level2 l2 ON l2.company_code = pd.company_code
									AND l2.level2_key = pd.level2_key
									AND l2.level2_status_id = 1
		INNER JOIN apad_level3 l3 ON l3.company_code = pd.company_code
									AND l3.level2_key = pd.level2_key
									AND l3.level3_key = pd.level3_key
									AND l3.level3_status_id = 1
	WHERE
		pd.close_flag = FALSE
	GROUP BY
		pd.company_code,
		pd.po_code,
		pd.level2_key,
		pd.level3_key,
		pd.cost_category,
		l2.customer_name,
		l2.level2_description,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag;
$$
DELIMITER ;

