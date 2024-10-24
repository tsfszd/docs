DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentdetail_verify;$$

CREATE PROCEDURE apas_invoicedocumentdetail_verify
(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN valuesCSV            VARCHAR(65535)
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		cost_type           INT,
		res_type            INT,
		rtype_name          VARCHAR(32),
		quantity            DOUBLE,
		net_cost            DOUBLE,
		match_to_date_net   DOUBLE,
		remaining_amount    DOUBLE
	);

	IF IFNULL(po_code_param, '') = '' THEN
		SET @query = CONCAT('INSERT INTO _temp
		(
			company_code,
			level2_key,
			level3_key,
			cost_type,
			res_type,
			rtype_name
		) VALUES', valuesCSV, ';');

		PREPARE stmt1 FROM @query; 
		EXECUTE stmt1; 
		DEALLOCATE PREPARE stmt1;
	ELSE
		INSERT INTO _temp
		(
			company_code,
			level2_key,
			level3_key,
			cost_type,
			res_type,
			rtype_name,
			quantity,
			net_cost,
			match_to_date_net,
			remaining_amount
		)
		SELECT
			pd.company_code,
			pd.level2_key,
			pd.level3_key,
			l3.cost_type,
			pd.cost_category,
			cc.rtype_name,
			pd.quantity,
			pd.net_cost,
			pd.match_to_date_net,
			pd.remaining_amount
		FROM
			v_PODetail pd
			LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = pd.level2_key
											AND l3.level3_key = pd.level3_key
											AND l3.company_code = pd.company_code
			LEFT OUTER JOIN apad_cost_codes cc ON cc.company_code = l3.company_code
											AND cc.cost_type = l3.cost_type
											AND cc.res_type = pd.cost_category
		WHERE
			(pd.po_code = po_code_param OR (IFNULL(po_code_param, '') = '' AND pd.po_required_flag = 'N'))
			AND pd.company_code = company_code_param;
	END IF;

	SELECT
		t.company_code,
		t.level2_key,
		t.level3_key,
		t.cost_type,
		t.res_type,
		t.rtype_name,
		t.quantity,
		t.net_cost,
		t.match_to_date_net,
		t.remaining_amount,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag,
		CASE WHEN l2.level2_key IS NULL THEN 'N' ELSE 'Y' END AS is_level2_key_valid,
		CASE WHEN l3.level3_key IS NULL THEN 'N' ELSE 'Y' END AS is_level3_key_valid,
		CASE WHEN cc.res_type IS NULL THEN 'N' ELSE 'Y' END AS is_cost_codes_valid
	FROM
		_temp t
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
										AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = l2.level2_key
										AND l3.level3_key = t.level3_key
										AND l3.company_code = t.company_code
										AND l3.level3_status_id = 1
		LEFT OUTER JOIN apad_cost_codes cc ON cc.cost_type = l3.cost_type
										AND cc.res_type = t.res_type
										AND l3.company_code = t.company_code;

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

