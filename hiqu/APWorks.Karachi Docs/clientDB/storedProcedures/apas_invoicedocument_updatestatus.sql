DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_updatestatus;$$

CREATE PROCEDURE apas_invoicedocument_updatestatus(
	IN company_code_param                           INT,
	IN invoice_document_id_param                    INT,
	IN invoice_document_status_id_param             INT UNSIGNED,
	IN transaction_id_param							VARCHAR(32),
	IN invoice_document_posting_error_message_param	VARCHAR(1024),
	IN modify_id_param                              VARCHAR(32),
	IN modify_date_param                            DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		invoice_document_status_id = invoice_document_status_id_param,
		transaction_id 			   = transaction_id_param,
		modify_id                  = modify_id_param,
		modify_date                = modify_date_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;

	UPDATE
		apad_invoice_posting_monitor
	SET
		invoice_document_posting_status_id      =
												CASE
													WHEN invoice_document_status_id_param = 170 THEN 10
													WHEN invoice_document_status_id_param = 180 THEN 20
													ELSE invoice_document_posting_status_id
												END,
		invoice_document_posting_update_date    = modify_date_param,
		invoice_document_posting_error_message  = invoice_document_posting_error_message_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;
END$$
DELIMITER ;

