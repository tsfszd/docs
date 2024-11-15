DELIMITER $$
DROP PROCEDURE IF EXISTS apas_documentmodelrequest_add;$$

CREATE PROCEDURE apas_documentmodelrequest_add(
	OUT document_model_request_id_param INT UNSIGNED,
	IN company_code_param               INT,
	IN scanner_monitor_record_id_param  INT UNSIGNED,
	IN request_to_map_param             CHAR(1),
	IN manual_processing_param          CHAR(1),
    IN request_completed_param          CHAR(1),
	IN create_id_param                  VARCHAR(32),
	IN create_date_param                DATETIME
)
BEGIN
	SET document_model_request_id_param = (SELECT MAX(document_model_request_id) + 1 FROM apam_document_model_request);

	IF ISNULL(document_model_request_id_param) THEN
			SET document_model_request_id_param = 1;
    END IF;

	INSERT INTO apam_document_model_request
	(
		document_model_request_id,
		company_code,
		scanner_monitor_record_id,
		request_to_map,
		manual_processing,
		request_completed,
		create_id,
		create_date
	)
	SELECT
		document_model_request_id_param,
		company_code_param,
		scanner_monitor_record_id_param,
		request_to_map_param,
		manual_processing_param,
		request_completed_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

