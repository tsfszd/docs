DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodel_add;$$

CREATE PROCEDURE apas_documentmodel_add(
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
	INSERT INTO apam_document_model
	(
		company_code,
		master_document_model_id,
		document_model_name,
		document_model_name_tag,
		vendor_code,
		site_id,
		invoice_document_sample_file_location,
		document_model_status_id,
		document_model_is_active,
		document_model_comments,
		create_id,
		create_date,
		modify_id,
		modify_date
	)
	SELECT
		company_code_param,
		master_document_model_id_param,
		document_model_name_param,
		document_model_name_tag_param,
		vendor_code_param,
		site_id_param,
		invoice_document_sample_file_location_param,
		document_model_status_id_param,
		document_model_is_active_param,
		document_model_comments_param,
		create_id_param,
		create_date_param,
		modify_id_param,
		modify_date_param;
END$$
DELIMITER ;

