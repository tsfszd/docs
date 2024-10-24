DELIMITER $$
DROP PROCEDURE IF EXISTS apas_resource_save;$$

CREATE PROCEDURE apas_resource_save
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
		resource_id     CHAR(16),
		name_last       VARCHAR(32),
		name_first      VARCHAR(32),
		name_init       VARCHAR(1),
		title           VARCHAR(64),
		email           VARCHAR(128),
		login_id        VARCHAR(64),
		active_flag     TINYINT,
		create_id       VARCHAR(32),
		create_date     DATETIME,
		modify_id       VARCHAR(32),
		modify_date     DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		active_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_resources r
	INNER JOIN _temp t ON t.resource_id = r.resource_id
						AND t.company_code = r.company_code
	SET
		r.name_last       = t.name_last,
		r.name_first      = t.name_first,
		r.name_init       = t.name_init,
		r.title           = t.title,
		#r.email           = t.email,
		r.login_id        = t.login_id,
		r.modify_date     = t.modify_date,
		r.modify_id       = t.modify_id;

	INSERT INTO apad_resources
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		active_flag,
		create_id,
		create_date
	)
	SELECT
		t.company_code,
		t.resource_id,
		t.name_last,
		t.name_first,
		t.name_init,
		t.title,
		'',#t.email,
		t.login_id,
		FALSE,
		t.create_id,
		t.create_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_resources r ON r.resource_id = t.resource_id
											AND r.company_code = t.company_code
	WHERE
		r.resource_id IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

