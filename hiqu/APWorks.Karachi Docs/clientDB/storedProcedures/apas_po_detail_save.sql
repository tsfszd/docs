DROP PROCEDURE IF EXISTS apas_podetail_save;

DELIMITER $$
CREATE PROCEDURE apas_podetail_save
(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		po_code             VARCHAR(32),
		line_id             INT,
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		cost_category       INT,
		due_date            DATETIME,
		quantity            FLOAT,
		net_cost            FLOAT,
		match_to_date_net   FLOAT,
		close_flag          TINYINT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		line_id,
		level2_key,
		level3_key,
		cost_category,
		due_date,
		quantity,
		net_cost,
		match_to_date_net,
		close_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_detail pd
	INNER JOIN _temp t ON t.po_code = pd.po_code
						AND t.line_id = pd.line_id
						AND t.company_code = pd.company_code
	SET
		pd.level2_key           = t.level2_key,
		pd.level3_key           = t.level3_key,
		pd.cost_category        = t.cost_category,
		pd.due_date             = t.due_date,
		pd.quantity             = t.quantity,
		pd.net_cost             = t.net_cost,
		pd.match_to_date_net    = t.match_to_date_net,
		pd.close_flag           = t.close_flag;

	INSERT INTO apad_po_detail
	(
		company_code,
		po_code,
		line_id,
		level2_key,
		level3_key,
		cost_category,
		due_date,
		quantity,
		net_cost,
		match_to_date_net,
		close_flag
	)
	SELECT
		t.company_code,
		t.po_code,
		t.line_id,
		t.level2_key,
		t.level3_key,
		t.cost_category,
		t.due_date,
		t.quantity,
		t.net_cost,
		t.match_to_date_net,
		t.close_flag
	FROM
		_temp t
		INNER JOIN apad_po_header ph ON ph.po_code = t.po_code
										AND ph.company_code = t.company_code
		LEFT OUTER JOIN apad_po_detail pd ON pd.po_code = t.po_code
											AND pd.line_id = t.line_id
											AND pd.company_code = t.company_code
	WHERE
		pd.po_code IS NULL
	GROUP BY
		t.company_code,
		t.po_code,
		t.line_id;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_detail', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$

DELIMITER ;

