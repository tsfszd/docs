DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_updateinvoicedocumentid;$$

CREATE PROCEDURE apas_nonmappedinvoice_updateinvoicedocumentid(
	IN company_code_param                           INT,
	IN document_manual_upload_file_location_param   VARCHAR(1024),
	IN invoice_document_id_param                    INT UNSIGNED
)
BEGIN
	UPDATE
		apad_document_manual_upload
	SET
		invoice_document_id = invoice_document_id_param
	WHERE
		company_code = company_code_param
		AND document_manual_upload_file_location = document_manual_upload_file_location_param;
END$$
DELIMITER ;

