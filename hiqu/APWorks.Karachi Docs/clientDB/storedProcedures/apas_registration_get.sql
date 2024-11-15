DELIMITER $$
DROP PROCEDURE IF EXISTS apas_registration_get;$$

CREATE PROCEDURE apas_registration_get(
	IN registration_record_id_param INT
)
BEGIN
	SELECT
		registration_record_id,
		registration_business_name,
		registration_business_addr1,
		registration_business_addr2,
		registration_business_city,
		registration_business_state,
		registration_business_zip,
		registration_business_phone,
		registration_business_email,
		admin_login,
		admin_password,
		s3_storage_root_folder,
		is_trial_flag,
		trial_expiration_date,
		license_key,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_registration
	WHERE
		registration_record_id = registration_record_id_param
	ORDER BY
		registration_business_name;
END$$
DELIMITER ;

