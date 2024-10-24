DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicemodel_update;$$

CREATE PROCEDURE apas_invoicemodel_update(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT,
	IN document_model_name_param            VARCHAR(64),
	IN document_model_name_tag_param        VARCHAR(32),
	IN vendor_code_param                    VARCHAR(12),
	IN site_id_param                        VARCHAR(32),
	IN invoice_document_file_location_param VARCHAR(1024),
	IN document_model_status_id_param       INT,
	IN is_active_param                      CHAR(1)
)
BEGIN
	UPDATE
		apam_document_model
	SET
		document_model_name                   = document_model_name_param,
		document_model_name_tag               = document_model_name_tag_param,
		vendor_code                           = vendor_code_param,
		site_id                               = site_id_param,
		invoice_document_sample_file_location = invoice_document_file_location_param,
		document_model_status_id              = document_model_status_id_param,
		modify_id                             = 'system',
		modify_date                           = current_date()
	WHERE
		master_document_model_id = master_document_model_id_param
		AND company_code = company_code_param;
END$$
DELIMITER ;

