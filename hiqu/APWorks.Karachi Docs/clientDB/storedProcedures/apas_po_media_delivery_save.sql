DROP PROCEDURE IF EXISTS apas_po_media_delivery_save;

DELIMITER $$
CREATE PROCEDURE apas_po_media_delivery_save
(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code    INT,
		po_code         VARCHAR(32),
		delivery_date   DATETIME,
		delivery_amount DOUBLE
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		delivery_date,
		delivery_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_media_delivery pmd
	INNER JOIN _temp t ON t.company_code = pmd.company_code
						AND t.po_code = pmd.po_code
						AND t.delivery_date = pmd.delivery_date
	SET
		pmd.delivery_amount = t.delivery_amount;

	INSERT INTO apad_po_media_delivery
	(
		company_code,
		po_code,
		delivery_date,
		delivery_amount
	)
	SELECT
		t.company_code,
		t.po_code,
		t.delivery_date,
		t.delivery_amount
	FROM
		_temp t
		INNER JOIN apad_po_header po ON po.company_code = t.company_code
												AND po.po_code = t.po_code
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.company_code = t.company_code
													AND pmd.po_code = t.po_code
													AND pmd.delivery_date = t.delivery_date
	WHERE
		pmd.po_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_media_delivery', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$

DELIMITER ;

