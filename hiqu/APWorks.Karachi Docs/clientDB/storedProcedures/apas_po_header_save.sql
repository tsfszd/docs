DROP PROCEDURE IF EXISTS apas_po_header_save;

DELIMITER $$
CREATE PROCEDURE apas_po_header_save
(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param  INT;
	DECLARE model_def_id_param  INT UNSIGNED;
	DECLARE table_name_param    VARCHAR(32);

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		po_code             VARCHAR(32),
		vendor_code         VARCHAR(12),
		site_id             VARCHAR(32),
		po_amount           DOUBLE,
		consumed_amount     DOUBLE,
		client_code         VARCHAR(32),
		client_name         VARCHAR(256),
		job_code            VARCHAR(32),
		campaign_name       VARCHAR(512),
		activity_code       VARCHAR(64),
		media_plan_name     VARCHAR(512),
		model_def_id        INT UNSIGNED,
		active_flag         TINYINT,
		po_date             DATETIME,
		currency_code       VARCHAR(32),
		payment_term_code   VARCHAR(32),
		due_date            DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_header po
	INNER JOIN _temp t ON t.po_code = po.po_code
						AND t.company_code = po.company_code
	SET
		po.po_amount            = t.po_amount,
		po.consumed_amount      = t.consumed_amount,
		po.client_code          = t.client_code,
		po.client_name          = t.client_name,
		po.job_code             = t.job_code,
		po.campaign_name        = t.campaign_name,
		po.activity_code        = t.activity_code,
		po.media_plan_name      = t.media_plan_name,
		po.model_def_id         = t.model_def_id,
		po.active_flag          = t.active_flag,
		po.po_date              = t.po_date,
		po.currency_code        = t.currency_code,
		po.payment_term_code    = t.payment_term_code,
		po.due_date             = t.due_date;

	INSERT INTO apad_po_header
	(
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	)
	SELECT
		t.company_code,
		t.po_code,
		t.vendor_code,
		t.site_id,
		t.po_amount,
		t.consumed_amount,
		t.client_code,
		t.client_name,
		t.job_code,
		t.campaign_name,
		t.activity_code,
		t.media_plan_name,
		t.model_def_id,
		t.active_flag,
		t.po_date,
		t.currency_code,
		t.payment_term_code,
		t.due_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_po_header po ON po.po_code = t.po_code
											AND po.company_code = t.company_code
	WHERE
		po.po_code IS NULL
	GROUP BY
		t.company_code,
		t.po_code;

	SELECT company_code, model_def_id INTO company_code_param, model_def_id_param FROM _temp LIMIT 1;
	SET table_name_param = CONCAT('apad_po_header', '_', model_def_id_param);

	CALL apas_datalastupdated_update(company_code_param, table_name_param, update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$

DELIMITER ;

