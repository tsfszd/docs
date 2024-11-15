DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_updatestatus;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_updatestatus(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN document_model_request_id_param      INT UNSIGNED,
	IN invoice_document_status_id_param     INT UNSIGNED,
	IN modify_id_param                      VARCHAR(32),
	IN modify_date_param                    DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		document_model_request_id   = document_model_request_id_param,
		invoice_document_status_id  = invoice_document_status_id_param,
		modify_id                   = modify_id_param,
		modify_date                 = modify_date_param
	WHERE
		invoice_document_file_location = invoice_document_file_location_param
		AND company_code = company_code_param;
END$$
DELIMITER ;

