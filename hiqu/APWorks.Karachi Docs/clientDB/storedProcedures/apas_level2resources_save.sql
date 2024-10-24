DELIMITER $$
DROP PROCEDURE IF EXISTS apas_level2resources_save;$$

CREATE PROCEDURE apas_level2resources_save
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
		level2_key              VARCHAR(32),
		resource_id             CHAR(16),
		position_category_code  INT,
		effective_date          DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		resource_id,
		position_category_code,
		effective_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	INSERT INTO apad_level2_resources
	(
		company_code,
		level2_key,
		resource_id,
		position_category_code,
		effective_date
	)
	SELECT DISTINCT
		t.company_code,
		t.level2_key,
		t.resource_id,
		t.position_category_code,
		t.effective_date
	FROM
		_temp t
		INNER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
		INNER JOIN apad_resources r ON r.resource_id = t.resource_id
										AND r.company_code = t.company_code
		INNER JOIN apam_position_category pc ON pc.position_category_code = t.position_category_code
										AND pc.company_code = t.company_code
		LEFT OUTER JOIN apad_level2_resources l2r ON l2r.level2_key = t.level2_key
											AND l2r.resource_id = t.resource_id
											AND l2r.position_category_code = t.position_category_code
											AND l2r.effective_date = t.effective_date
											AND l2r.company_code = t.company_code
	WHERE
		l2r.level2_key IS NULL
		OR l2r.resource_id IS NULL
		OR l2r.position_category_code IS NULL
		OR l2r.effective_date IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level2_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

