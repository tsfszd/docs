DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_manuallyuploadedinvoice_add;$$

CREATE PROCEDURE apas_nonmappedinvoice_manuallyuploadedinvoice_add(
	OUT document_manual_upload_record_id_param          INT UNSIGNED,
	IN company_code_param                               INT,
	IN resource_id_param                                CHAR(16),
	IN document_manual_upload_file_location_param       VARCHAR(1024),
	IN document_manual_upload_file_update_date_param    DATETIME,
	IN scanned_flag_param                               CHAR(1),
	IN scanner_monitor_record_id_param                  INT UNSIGNED,
	IN document_model_request_id_param                  INT UNSIGNED,
	IN invoice_document_id_param                        INT UNSIGNED,
	IN model_def_id_param                               INT UNSIGNED
)
BEGIN
	SET document_manual_upload_record_id_param = (SELECT MAX(document_manual_upload_record_id) + 1 FROM apad_document_manual_upload);

	IF ISNULL(document_manual_upload_record_id_param) THEN
			SET document_manual_upload_record_id_param = 1;
	END IF;

	INSERT INTO apad_document_manual_upload
	(
		document_manual_upload_record_id,
		company_code,
		resource_id,
		document_manual_upload_file_location,
		document_manual_upload_file_update_date,
		scanned_flag,
		scanner_monitor_record_id,
		document_model_request_id,
		invoice_document_id,
		model_def_id
	)
	SELECT
		document_manual_upload_record_id_param,
		company_code_param,
		resource_id_param,
		document_manual_upload_file_location_param,
		document_manual_upload_file_update_date_param,
		scanned_flag_param,
		scanner_monitor_record_id_param,
		document_model_request_id_param,
		invoice_document_id_param,
		model_def_id_param;
END$$
DELIMITER ;

