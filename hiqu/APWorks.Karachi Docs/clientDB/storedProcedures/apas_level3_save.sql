DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level3_save;$$

CREATE PROCEDURE apas_level3_save
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
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		level3_description  VARCHAR(128),
		level3_status_id    INT UNSIGNED,
		open_date           DATETIME,
		cost_type           INT,
		customer_po_number  VARCHAR(16),
		expense_flag        TINYINT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		level3_key,
		level3_description,
		level3_status_id,
		open_date,
		cost_type,
		customer_po_number,
		expense_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_level3 l
	INNER JOIN _temp t ON t.level2_key = l.level2_key
						AND t.level3_key = l.level3_key
						AND t.company_code = l.company_code
	SET
		l.level3_description    = t.level3_description,
		l.level3_status_id      = t.level3_status_id,
		l.open_date             = t.open_date,
		l.cost_type             = t.cost_type,
		l.customer_po_number    = t.customer_po_number,
		l.expense_flag          = t.expense_flag;

	INSERT INTO apad_level3
	(
		company_code,
		level2_key,
		level3_key,
		level3_description,
		level3_status_id,
		open_date,
		cost_type,
		customer_po_number,
		expense_flag
	)
	SELECT
		t.company_code,
		t.level2_key,
		t.level3_key,
		t.level3_description,
		t.level3_status_id,
		t.open_date,
		t.cost_type,
		t.customer_po_number,
		t.expense_flag
	FROM
		_temp t
		INNER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = t.level2_key
										AND l3.level3_key = t.level3_key
										AND l3.company_code = t.company_code
	WHERE
		l3.level2_key IS NULL
		OR l3.level3_key IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level3', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

