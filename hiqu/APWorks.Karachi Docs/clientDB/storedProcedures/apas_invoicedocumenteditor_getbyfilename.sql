DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumenteditor_getbyfilename;$$

CREATE PROCEDURE apas_invoicedocumenteditor_getbyfilename(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024)
)
BEGIN
	DECLARE invoice_document_id_param INT UNSIGNED;

	SET invoice_document_id_param = (SELECT invoice_document_id FROM apad_invoice_document WHERE invoice_document_file_location = invoice_document_file_location_param AND company_code = company_code_param);

	CALL apas_invoicedocumenteditor_get(company_code_param, invoice_document_id_param);
END$$
DELIMITER ;

