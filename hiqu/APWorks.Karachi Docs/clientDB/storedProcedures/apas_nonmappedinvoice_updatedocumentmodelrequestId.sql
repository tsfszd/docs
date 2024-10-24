DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_updatedocumentmodelrequestId;$$

CREATE PROCEDURE apas_nonmappedinvoice_updatedocumentmodelrequestId(
	IN document_model_request_id_param              INT UNSIGNED,
	IN company_code_param                           INT,
    IN document_manual_upload_file_location_param   VARCHAR(1024)
)
BEGIN
	UPDATE
		apad_document_manual_upload
	SET
		document_model_request_id = document_model_request_id_param
	WHERE
		company_code = company_code_param
		AND document_manual_upload_file_location = document_manual_upload_file_location_param;
END$$
DELIMITER ;

