DELIMITER $$
DROP PROCEDURE IF EXISTS apas_costtypes_save;$$

CREATE PROCEDURE apas_costtypes_save
(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		cost_type               INT,
		cost_type_name          VARCHAR(16),
		cost_type_description	VARCHAR(64),
		cost_type_status        TINYINT,
		effective_date          DATETIME,
		expiration_date	        DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apam_cost_types ct
	INNER JOIN _temp t ON t.cost_type = ct.cost_type
						AND t.company_code = ct.company_code
	SET
		ct.cost_type_name           = t.cost_type_name,
		ct.cost_type_description    = t.cost_type_description,
		ct.cost_type_status         = t.cost_type_status,
		ct.effective_date           = t.effective_date,
		ct.expiration_date          = t.expiration_date;

	INSERT INTO apam_cost_types
	(
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	)
	SELECT
		t.company_code,
		t.cost_type,
		t.cost_type_name,
		t.cost_type_description,
		t.cost_type_status,
		t.effective_date,
		t.expiration_date
	FROM
		_temp t
		LEFT OUTER JOIN apam_cost_types ct ON ct.cost_type = t.cost_type
												AND ct.company_code = t.company_code
	WHERE
		ct.cost_type IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apam_cost_types', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

