DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_setdeleted;$$

CREATE PROCEDURE apas_invoicedocument_setdeleted(
	IN company_code_param                               INT,
	IN invoice_document_id_param                        INT,
	IN replaced_by_invoice_document_file_location_param VARCHAR(1024),
	IN modify_id_param                                  VARCHAR(32),
	IN modify_date_param                                DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		is_deleted                                  = TRUE,
		replaced_by_invoice_document_file_location  = CASE WHEN IFNULL(replaced_by_invoice_document_file_location_param, '') <> '' THEN replaced_by_invoice_document_file_location_param ELSE replaced_by_invoice_document_file_location END,
		modify_id                                   = modify_id_param,
		modify_date                                 = modify_date_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;
END$$
DELIMITER ;

