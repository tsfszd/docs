DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicemodel_list;$$

CREATE PROCEDURE apas_invoicemodel_list(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		dm.company_code,
		zero AS document_model_request_id,
		dm.invoice_document_sample_file_location AS invoice_document_file_location,
		'N' AS manual_upload_flag,
		mdm.master_document_model_id,
		mdm.model_def_id,
		dm.document_model_name,
		dm.document_model_name_tag,
		dm.document_model_status_id,
		mdm.is_active,
		dm.document_model_is_active,
		dm.invoice_document_sample_file_location,
		zero AS invoice_document_id,
		v.vendor_code,
		v.vendor_name,
		v.short_name,
		v.site_id
	FROM
		{COMMON_DATABASE}.apam_master_document_model mdm
		INNER JOIN apam_document_model dm ON dm.master_document_model_id = mdm.master_document_model_id
													AND dm.company_code = company_code_param
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = dm.vendor_code
										AND v.site_id = dm.site_id
										AND v.company_code = dm.company_code
	WHERE
		mdm.model_def_id = model_def_id_param
	UNION
	SELECT
		dmr.company_code,
		dmr.document_model_request_id,
		id.invoice_document_file_location,
		sm.manual_upload_flag,
		IFNULL(mdm.master_document_model_id, zero) AS master_document_model_id,
		model_def_id_param AS model_def_id,
		dm.document_model_name,
		dm.document_model_name_tag,
		IFNULL(dm.document_model_status_id, zero) AS document_model_status_id,
		IFNULL(mdm.is_active, 'N') AS is_active,
		'N' AS document_model_is_active,
		id.invoice_document_file_location AS invoice_document_sample_file_location,
		id.invoice_document_id,
		NULL AS vendor_code,
		NULL AS vendor_name,
		NULL AS short_name,
		NULL AS site_id
	FROM
		apam_document_model_request dmr
		INNER JOIN apad_invoice_scanner_monitor sm ON sm.scanner_monitor_record_id = dmr.scanner_monitor_record_id
														AND sm.company_code = dmr.company_code
														AND sm.model_def_id = model_def_id_param
		INNER JOIN apad_invoice_document id ON id.document_model_request_id = dmr.document_model_request_id
													AND id.company_code = dmr.company_code
													AND id.model_def_id = model_def_id_param
		LEFT OUTER JOIN {COMMON_DATABASE}.apam_master_document_model mdm ON mdm.master_document_model_id = id.master_document_model_id
																				AND id.model_def_id = model_def_id_param
		LEFT OUTER JOIN apam_document_model dm ON dm.master_document_model_id = mdm.master_document_model_id
	WHERE
		dmr.company_code = company_code_param
		AND dmr.request_to_map = 'Y'
		AND dmr.request_completed = 'N'
		AND dm.master_document_model_id IS NULL
	ORDER BY
		invoice_document_id;
END$$
DELIMITER ;

