DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_manuallyuploadedinvoice_delete;$$

CREATE PROCEDURE apas_nonmappedinvoice_manuallyuploadedinvoice_delete(
	IN company_code_param                       INT,
	IN document_manual_upload_record_id_param   INT UNSIGNED
)
BEGIN
	DELETE FROM
		apad_document_manual_upload
	WHERE
		company_code = company_code_param
		AND document_manual_upload_record_id = document_manual_upload_record_id_param;
END$$
DELIMITER ;

