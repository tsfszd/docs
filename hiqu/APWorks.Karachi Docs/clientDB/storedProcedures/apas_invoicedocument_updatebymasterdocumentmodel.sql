DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_updatebymasterdocumentmodel;$$

CREATE PROCEDURE apas_invoicedocument_updatebymasterdocumentmodel(
	IN company_code_param               INT,
	IN master_document_model_id_param   INT UNSIGNED,
	IN modify_id_param                  VARCHAR(32),
	IN modify_date_param                DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document id
	INNER JOIN apam_document_model dm ON dm.master_document_model_id = id.master_document_model_id
										AND dm.company_code = id.company_code
	INNER JOIN apam_document_model_request dmr ON dmr.document_model_request_id = id.document_model_request_id
												AND dmr.company_code = id.company_code
	SET
		dmr.request_completed           = 'Y',
		dmr.modify_id                   = modify_id_param,
		dmr.modify_date                 = modify_date_param,
		id.invoice_document_status_id   = 50,
		id.vendor_code                  = dm.vendor_code,
		id.site_id                      = dm.site_id,
		id.modify_id                    = modify_id_param,
		id.modify_date                  = modify_date_param
	WHERE
		id.company_code = company_code_param
		AND id.master_document_model_id = master_document_model_id_param
		AND invoice_document_status_id IN (30, 35);
END$$
DELIMITER ;

