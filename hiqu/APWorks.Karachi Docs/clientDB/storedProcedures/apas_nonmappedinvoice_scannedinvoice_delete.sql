DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_delete;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_delete(
	IN company_code_param               INT,
	IN scanner_monitor_record_id_param  INT UNSIGNED
)
BEGIN
	DELETE FROM
		apad_document_manual_upload
	WHERE
		company_code = company_code_param
		AND scanner_monitor_record_id = scanner_monitor_record_id_param;

	DELETE FROM
		apad_invoice_scanner_monitor
	WHERE
		company_code = company_code_param
		AND scanner_monitor_record_id = scanner_monitor_record_id_param;
END$$
DELIMITER ;

