DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level2_save;$$

CREATE PROCEDURE apas_level2_save
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
		level2_description  VARCHAR(128),
		level2_status_id    INT UNSIGNED,
		open_date           DATETIME,
		customer_code       VARCHAR(16),
		customer_name       VARCHAR(64),
		customer_po_number  VARCHAR(16),
		po_required_flag    CHAR(1),
		tolerance_po_flag   CHAR(1),
		tolerance_po_amount DECIMAL(6, 2)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		level2_description,
		level2_status_id,
		open_date,
		customer_code,
		customer_name,
		customer_po_number,
		po_required_flag,
		tolerance_po_flag,
		tolerance_po_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_level2 l
	INNER JOIN _temp t ON t.level2_key = l.level2_key
						AND t.company_code = l.company_code
	SET
		l.level2_description    = t.level2_description,
		l.level2_status_id      = t.level2_status_id,
		l.open_date             = t.open_date,
		l.customer_code         = t.customer_code,
		l.customer_name         = t.customer_name,
		l.customer_po_number    = t.customer_po_number,
		l.po_required_flag      = t.po_required_flag,
		l.tolerance_po_flag     = t.tolerance_po_flag,
		l.tolerance_po_amount   = t.tolerance_po_amount;

	INSERT INTO apad_level2
	(
		company_code,
		level2_key,
		level2_description,
		level2_status_id,
		open_date,
		customer_code,
		customer_name,
		customer_po_number,
		po_required_flag,
		tolerance_po_flag,
		tolerance_po_amount
	)
	SELECT
		t.company_code,
		t.level2_key,
		t.level2_description,
		t.level2_status_id,
		t.open_date,
		t.customer_code,
		t.customer_name,
		t.customer_po_number,
		t.po_required_flag,
		t.tolerance_po_flag,
		t.tolerance_po_amount
	FROM
		_temp t
		LEFT OUTER JOIN apad_level2 l ON l.level2_key = t.level2_key
										AND l.company_code = t.company_code
	WHERE
		l.level2_key IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level2', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

