DELIMITER $$
DROP PROCEDURE IF EXISTS apas_costcodes_save;$$

CREATE PROCEDURE apas_costcodes_save
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
		cost_type           INT,
		res_type            INT,
		effective_date      DATETIME,
		rtype_name          VARCHAR(32),
		rtype_description   VARCHAR(64)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		cost_type,
		res_type,
		effective_date,
		rtype_name,
		rtype_description
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_cost_codes cc
	INNER JOIN _temp t ON t.cost_type = cc.cost_type
						AND t.res_type = cc.res_type
						AND t.effective_date = cc.effective_date
						AND t.company_code = cc.company_code
	SET
		cc.rtype_name           = t.rtype_name,
		cc.rtype_description    = t.rtype_description;

	INSERT INTO apad_cost_codes
	(
		company_code,
		cost_type,
		res_type,
		effective_date,
		rtype_name,
		rtype_description
	)
	SELECT
		t.company_code,
		t.cost_type,
		t.res_type,
		t.effective_date,
		t.rtype_name,
		t.rtype_description
	FROM
		_temp t
		INNER JOIN apam_cost_types ct ON ct.cost_type = t.cost_type
										AND ct.company_code = t.company_code
		LEFT OUTER JOIN apad_cost_codes cc ON cc.cost_type = t.cost_type
											AND cc.res_type = t.res_type
											AND cc.effective_date = t.effective_date
											AND cc.company_code = t.company_code
	WHERE
		cc.cost_type IS NULL
		OR cc.res_type IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_cost_codes', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

