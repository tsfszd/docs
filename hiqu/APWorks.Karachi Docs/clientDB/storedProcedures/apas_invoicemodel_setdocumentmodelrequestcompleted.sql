DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicemodel_setdocumentmodelrequestcompleted;$$

CREATE PROCEDURE apas_invoicemodel_setdocumentmodelrequestcompleted(
	IN company_code_param               INT,
	IN document_model_request_id_param  INT UNSIGNED,
	IN modify_id_param                  INT,
	IN modify_date_param                DATETIME
)
BEGIN
	UPDATE
		apam_document_model_request
	SET
		request_completed   = 'Y',
		modify_id           = modify_id_param,
		modify_date         = modify_date_param
	WHERE
		company_code = company_code_param
		AND document_model_request_id = document_model_request_id_param;
END$$
DELIMITER ;

