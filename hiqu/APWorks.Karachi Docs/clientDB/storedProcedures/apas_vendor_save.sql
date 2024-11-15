DELIMITER $$
DROP PROCEDURE IF EXISTS apas_vendor_save;$$

CREATE PROCEDURE apas_vendor_save
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
		vendor_code         VARCHAR(12),
		site_id             VARCHAR(32),
		vendor_name         VARCHAR(256),
		addr1               VARCHAR(64),
		addr2               VARCHAR(64),
		addr3               VARCHAR(64),
		addr4               VARCHAR(64),
		addr5               VARCHAR(64),
		addr6               VARCHAR(64),
		short_name          VARCHAR(128),
		attention_name      VARCHAR(64),
		attention_phone	    VARCHAR(32),
		contact_name        VARCHAR(64),
		contact_phone       VARCHAR(32),
		email               VARCHAR(128),
		phone_1             VARCHAR(32),
		phone_2             VARCHAR(32),
		tax_code            VARCHAR(16),
		terms_code          VARCHAR(64),
		currency_code       CHAR(8),
		vendor_status_id    INT,
		no_po_flag          CHAR(1)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		vendor_code,
		site_id,
		vendor_name,
		short_name,
		addr1,
		addr2,
		addr3,
		addr4,
		addr5,
		addr6,
		attention_name,
		attention_phone,
		contact_name,
		contact_phone,
		email,
		phone_1,
		phone_2,
		tax_code,
		terms_code,
		currency_code,
		vendor_status_id,
		no_po_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_vendors v
	INNER JOIN _temp t ON t.vendor_code = v.vendor_code
						AND t.site_id = v.site_id
						AND t.company_code = v.company_code
	SET
		v.vendor_name       = t.vendor_name,
		v.short_name        = t.short_name,
		v.addr1             = t.addr1,
		v.addr2             = t.addr2,
		v.addr3             = t.addr3,
		v.addr4             = t.addr4,
		v.addr5             = t.addr5,
		v.addr6             = t.addr6,
		v.attention_name    = t.attention_name,
		v.attention_phone   = t.attention_phone,
		v.contact_name      = t.contact_name,
		v.contact_phone     = t.contact_phone,
		v.email             = t.email,
		v.phone_1           = t.phone_1,
		v.phone_2           = t.phone_2,
		v.tax_code          = t.tax_code,
		v.terms_code        = t.terms_code,
		v.currency_code     = t.currency_code,
		v.vendor_status_id  = t.vendor_status_id,
		v.no_po_flag        = t.no_po_flag;

	INSERT INTO apad_vendors
	(
		company_code,
		vendor_code,
		site_id,
		vendor_name,
		short_name,
		addr1,
		addr2,
		addr3,
		addr4,
		addr5,
		addr6,
		attention_name,
		attention_phone,
		contact_name,
		contact_phone,
		email,
		phone_1,
		phone_2,
		tax_code,
		terms_code,
		currency_code,
		vendor_status_id,
		no_po_flag
	)
	SELECT
		t.company_code,
		t.vendor_code,
		t.site_id,
		t.vendor_name,
		t.short_name,
		t.addr1,
		t.addr2,
		t.addr3,
		t.addr4,
		t.addr5,
		t.addr6,
		t.attention_name,
		t.attention_phone,
		t.contact_name,
		t.contact_phone,
		t.email,
		t.phone_1,
		t.phone_2,
		t.tax_code,
		t.terms_code,
		t.currency_code,
		t.vendor_status_id,
		t.no_po_flag
	FROM
		_temp t
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = t.vendor_code
											AND v.site_id = t.site_id
											AND v.company_code = t.company_code
	WHERE
		v.vendor_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_vendors', update_date_param);

	DROP TEMPORARY TABLE _temp;
END$$
DELIMITER ;

