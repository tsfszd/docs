DELIMITER $$
DROP PROCEDURE IF EXISTS apas_company_add;$$

CREATE PROCEDURE apas_company_add(
	IN company_code_param                                   INT,
	IN co_short_name_param                                  VARCHAR(16),
	IN co_name_param                                        VARCHAR(64), 
	IN currency_code_param                                  CHAR(8),
	IN addr_street1_param                                   VARCHAR(64), 
	IN addr_street2_param                                   VARCHAR(64), 
	IN addr_street3_param                                   VARCHAR(64), 
	IN addr_city_param                                      VARCHAR(64), 
	IN addr_state_province_param                            VARCHAR(16), 
	IN addr_zip_postcode_param                              VARCHAR(16), 
	IN tel_area_param                                       VARCHAR(64), 
	IN tel_number_param                                     VARCHAR(64), 
	IN nexelus_s3_storage_connection_string_param           VARCHAR(512), 
	IN client_ftp_site_connection_string_param              VARCHAR(1024), 
	IN nexelus_owned_storage_flag_param                     CHAR(1),
	IN client_owned_storage_flag_param                      CHAR(1),
	IN create_id_param                                      VARCHAR(32),
	IN create_date_param                                    DATETIME,
	IN modify_id_param                                      VARCHAR(32),
	IN modify_date_param                                    DATETIME
)
BEGIN
	INSERT INTO apam_company
	(
		company_code,
		co_short_name,
		co_name,
		currency_code,
		addr_street1,
		addr_street2,
		addr_street3,
		addr_city,
		addr_state_province,
		addr_zip_postcode,
		tel_area,
		tel_number,
		nexelus_s3_storage_connection_string,
		client_ftp_site_connection_string,
		nexelus_owned_storage_flag,
		client_owned_storage_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	)
	SELECT
		company_code_param,
		co_short_name_param,
		co_name_param,
		currency_code_param,
		addr_street1_param,
		addr_street2_param,
		addr_street3_param,
		addr_city_param,
		addr_state_province_param,
		addr_zip_postcode_param,
		tel_area_param,
		tel_number_param,
		nexelus_s3_storage_connection_string_param,
		client_ftp_site_connection_string_param,
		nexelus_owned_storage_flag_param,
		client_owned_storage_flag_param,
		create_id_param,
		create_date_param,
		modify_id_param,
		modify_date_param;
END$$
DELIMITER ;

