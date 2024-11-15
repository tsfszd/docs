DROP PROCEDURE IF EXISTS apas_po_header_get;

DELIMITER $$
CREATE PROCEDURE apas_po_header_get
(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id
	FROM
		apad_po_header
	WHERE
		company_code = company_code_param
		AND po_code = po_code_param;

	SELECT
		d.company_code,
		d.po_code,
		d.line_id,
		d.level2_key,
		d.level3_key,
		d.cost_category,
		d.due_date,
		d.quantity,
		d.net_cost,
		d.match_to_date_net,
		d.close_flag,
		IFNULL(l2.tolerance_po_flag, 'N') AS tolerance_po_flag,
		IFNULL(l2.tolerance_po_amount, 0) AS tolerance_po_amount
	FROM
		apad_po_detail d
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = d.level2_key
										AND l2.company_code = d.company_code
	WHERE
		d.company_code = company_code_param
		AND d.po_code = po_code_param;
END$$

DELIMITER ;

