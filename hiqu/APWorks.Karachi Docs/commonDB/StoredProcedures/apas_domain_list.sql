DELIMITER $$
DROP PROCEDURE IF EXISTS apas_domain_list;$$

CREATE PROCEDURE apas_domain_list(
)
BEGIN
	SELECT
		ent_domain_name,
		ent_record_id,
		active_flag,
		sso_type,
		sso_login_url,
		sso_logout_url,
		callback_url,
		signing_authority_certificate,
		client_logo,
		create_id,
		create_date,
		modify_id,
		modify_date 
	FROM
		ent_domain
	WHERE
		active_flag = 1;

	SELECT
		ent_record_id,
		ent_client_name,
		active_flag,
		db_schema_name,
		db_hostname,
		db_port,
		db_username,
		db_password,
		db_password_access_attributes,
		db_connection_attributes,
		saml_enabled_flag,
		saml_provider_name,
		saml_idp_id,
		saml_attributes,
		client_key,
		client_secret,
		erp_url,
		system_type,
		create_id,
		create_date, 
		modify_id,
		modify_date
	FROM
		ent_client
	WHERE
		active_flag = 1;
END$$
DELIMITER ;

