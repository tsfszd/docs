DROP procedure IF EXISTS apas_po_resource_save;

DELIMITER $$
CREATE PROCEDURE apas_po_resource_save
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
		po_code                 VARCHAR(32),
		resource_id             CHAR(16),
		position_category_code	INT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		resource_id,
		position_category_code
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	INSERT INTO apad_po_resources
	(
		company_code,
		po_code,
		resource_id,
		position_category_code
	)
	SELECT DISTINCT
		t.company_code,
		t.po_code,
		t.resource_id,
		t.position_category_code
	FROM
		_temp t
		INNER JOIN apad_po_header po ON po.company_code = t.company_code
												AND po.po_code = t.po_code
		INNER JOIN apad_resources r ON r.company_code = t.company_code
										AND r.resource_id = t.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = t.company_code
										AND pc.position_category_code = t.position_category_code
		LEFT OUTER JOIN apad_po_resources pr ON pr.company_code = t.company_code
												AND pr.po_code = t.po_code
												AND pr.resource_id = t.resource_id
												AND pr.position_category_code = t.position_category_code
	WHERE
		pr.po_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$

DELIMITER ;

