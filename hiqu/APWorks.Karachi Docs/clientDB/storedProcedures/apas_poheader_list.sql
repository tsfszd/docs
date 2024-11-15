DROP PROCEDURE IF EXISTS apas_poheader_list;

DELIMITER $$
CREATE PROCEDURE apas_poheader_list
(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
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
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	FROM
		apad_po_header
	WHERE
		company_code = company_code_param
		AND model_def_id = model_def_id_param;
END$$

DELIMITER ;

