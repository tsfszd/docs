DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodel_update;$$

CREATE PROCEDURE apas_documentmodel_update(
	IN company_code_param                            INT,
	IN master_document_model_id_param                INT UNSIGNED,
	IN document_model_name_param                     VARCHAR(64),
	IN document_model_name_tag_param                 VARCHAR(32),
	IN vendor_code_param                             VARCHAR(12),
	IN site_id_param                                 VARCHAR(32),
	IN invoice_document_sample_file_location_param   VARCHAR(1024),
	IN document_model_status_id_param                INT UNSIGNED,
	IN document_model_is_active_param                CHAR(1),
	IN document_model_comments_param                 VARCHAR(512),
	IN create_id_param                               VARCHAR(32),
	IN create_date_param                             DATETIME,
	IN modify_id_param                               VARCHAR(32),
	IN modify_date_param                             DATETIME
)
BEGIN
	UPDATE
		apam_document_model
	SET
		document_model_name                     = document_model_name_param,
		document_model_name_tag                 = document_model_name_tag_param,
		vendor_code                             = vendor_code_param,
		site_id                                 = site_id_param,
		invoice_document_sample_file_location   = invoice_document_sample_file_location_param,
		document_model_status_id                = document_model_status_id_param,
		document_model_is_active                = document_model_is_active_param,
		document_model_comments                 = document_model_comments_param,
		modify_id                               = modify_id_param,
		modify_date                             = modify_date_param
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

