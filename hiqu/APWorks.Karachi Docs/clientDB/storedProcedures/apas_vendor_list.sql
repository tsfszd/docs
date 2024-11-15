DELIMITER $$
DROP PROCEDURE IF EXISTS apas_vendor_list;$$

CREATE PROCEDURE apas_vendor_list(
	IN company_code_param INT
)
BEGIN
	SELECT
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
	FROM
		apad_vendors
	WHERE
		company_code = company_code_param
	ORDER BY
		vendor_name;
END$$
DELIMITER ;

