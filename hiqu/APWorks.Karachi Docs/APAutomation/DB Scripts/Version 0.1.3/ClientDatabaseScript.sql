DELIMITER $$
DROP PROCEDURE IF EXISTS apas_dashboard_pendingapprovalorapprovedinvoice_list;$$

CREATE PROCEDURE apas_dashboard_pendingapprovalorapprovedinvoice_list(
	IN company_code_param       INT,
	IN user_role_id_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT,
	IN ready_to_post_param      TINYINT(1)
)
BEGIN
	DECLARE zero INT UNSIGNED;
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;

	SET zero = 0;
	SET routing_number_of_approval_levels_param = (SELECT routing_number_of_approval_levels FROM apam_company WHERE company_code = company_code_param);

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	IF resource_id_param IS NOT NULL THEN
		SELECT
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 70 ELSE 50 END ELSE NULL END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 90 ELSE 70 END ELSE NULL END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 110 ELSE 90 END ELSE NULL END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 130 ELSE 110 END ELSE NULL END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 150 ELSE 130 END ELSE NULL END
		INTO
			@allowed_level_1_status,
			@allowed_level_2_status,
			@allowed_level_3_status,
			@allowed_level_4_status,
			@allowed_level_5_status
		FROM
			apad_user_roles
		WHERE
			user_role_id = user_role_id_param AND company_code = company_code_param;
	END IF;

	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		id.TotalAmount,
		id.request_to_map,
		id.manual_processing,
		IFNULL(invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		id.manual_upload_flag,
		id.invoice_document_posting_status_id,
		id.invoice_document_posting_error_message,
		id.vendor_name,
		id.short_name,
		routing_history_count,
		IFNULL(id.approval_rejection_update_date, id.modify_date) AS approval_rejection_update_date,
		r.resource_id,
		r.name_first,
		r.name_last
	FROM
		v_InvoiceDocument id
		INNER JOIN (
					SELECT DISTINCT
						rbid.company_code,
						rbid.invoice_document_id
					FROM
						v_ResourcesByInvoiceDocument rbid
						INNER JOIN apad_user_role_position_categories urpc ON rbid.position_category_code = rbid.position_category_code
														AND urpc.company_code = rbid.company_code
														AND urpc.user_role_id = user_role_id_param
					WHERE
						IFNULL(resource_id_param, '') = '' OR rbid.resource_id = resource_id_param
					) dt_rbid ON dt_rbid.invoice_document_id = id.invoice_document_id
									AND dt_rbid.company_code = id.company_code
		LEFT OUTER JOIN apad_resources r ON r.resource_id = id.approval_rejection_user_id
											AND r.company_code = id.company_code
	WHERE
		id.company_code = company_code_param
		AND id.invoice_document_status_id NOT IN (80, 100, 120, 140, 160)
		AND (IFNULL(resource_id_param, '') = '' OR id.invoice_document_status_id IN (@allowed_level_1_status, @allowed_level_2_status, @allowed_level_3_status, @allowed_level_4_status, @allowed_level_5_status))
		AND ((ready_to_post_param = FALSE AND id.invoice_document_status_id >= 50 AND id.invoice_document_status_id < max_possible_approved_status_id)
			OR (ready_to_post_param = TRUE AND (id.invoice_document_status_id IN (170, 180) OR id.invoice_document_status_id >= max_possible_approved_status_id)))
		AND (DATE(approval_rejection_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	ORDER BY
		approval_rejection_update_date DESC,
		id.modify_date DESC,
		id.invoice_document_id;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_dashboard_scannedinvoice_list;$$

CREATE PROCEDURE apas_dashboard_scannedinvoice_list(
	IN company_code_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT
)
BEGIN
	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT
		i.scanner_monitor_record_id,
		i.company_code,
		i.invoice_document_file_location,
		i.invoice_document_scan_status_id,
		i.manual_upload_flag,
		i.invoice_document_scan_update_date,
		i.invoice_document_scan_duration,
		i.invoice_document_scan_error_message,
		i.invoice_document_scanner_process_tag_string,
		i.invoice_document_id,
		i.invoice_document_status_id,
		i.vendor_code,
		i.vendor_name,
		i.short_name,
		i.site_id,
		i.routed_to_resource_id,
		r.name_last,
		r.name_first
	FROM
	(
		SELECT
			m.scanner_monitor_record_id,
			m.company_code,
			m.invoice_document_file_location,
			m.invoice_document_scan_status_id,
			m.manual_upload_flag,
			m.invoice_document_scan_update_date,
			m.invoice_document_scan_duration,
			m.invoice_document_scan_error_message,
			m.invoice_document_scanner_process_tag_string,
			id.invoice_document_id,
			id.invoice_document_status_id,
			v.vendor_code,
			v.vendor_name,
			v.short_name,
			v.site_id,
			(SELECT
				resource_id AS routed_to_resource_id
			FROM
				apad_invoice_document_resource_routing_history
			WHERE
				company_code = company_code_param
				AND invoice_document_id = id.invoice_document_id
			ORDER BY
				sequence_id DESC
			LIMIT 1) AS routed_to_resource_id
		FROM
			apad_invoice_scanner_monitor m
			LEFT OUTER JOIN apam_document_model_request r ON m.scanner_monitor_record_id = r.scanner_monitor_record_id
			LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location
														AND id.company_code = m.company_code
			LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
											AND v.site_id = id.site_id
											AND v.company_code = id.company_code
		WHERE
			m.company_code = company_code_param
			AND (r.document_model_request_id IS NULL OR (r.document_model_request_id IS NOT NULL AND id.invoice_document_status_id = 20))
			AND (id.invoice_document_status_id IN (10, 20, 30, 35, 40, 60) AND m.invoice_document_scan_status_id = 10)
			AND (DATE(m.invoice_document_scan_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	) AS i
	LEFT OUTER JOIN apad_resources r ON r.resource_id = i.routed_to_resource_id
										AND r.company_code = i.company_code
	WHERE
		IFNULL(resource_id_param, '') = '' OR i.routed_to_resource_id = resource_id_param
	ORDER BY
		invoice_document_scan_update_date DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_manuallyuploadedinvoice_list;$$

CREATE PROCEDURE apas_nonmappedinvoice_manuallyuploadedinvoice_list(
	IN company_code_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT
)
BEGIN
	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT
		dmu.document_manual_upload_record_id,
		dmu.company_code,
		dmu.resource_id,
		dmu.document_manual_upload_file_location,
		dmu.document_manual_upload_file_update_date,
		dmu.scanned_flag,
		dmu.scanner_monitor_record_id,
		dmu.document_model_request_id,
		ism.invoice_document_scan_status_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		dmr.request_to_map,
		dmr.manual_processing,
		dmr.request_completed
	FROM
		apad_document_manual_upload dmu
		LEFT OUTER JOIN apad_invoice_scanner_monitor ism ON ism.scanner_monitor_record_id = dmu.scanner_monitor_record_id
															AND ism.company_code = dmu.company_code
		LEFT OUTER JOIN apam_document_model_request dmr ON dmr.scanner_monitor_record_id = ism.scanner_monitor_record_id
															AND dmr.company_code = dmu.company_code
		LEFT OUTER JOIN apad_invoice_document id ON (id.invoice_document_id = dmu.invoice_document_id OR id.invoice_document_file_location = ism.invoice_document_file_location)
															AND id.company_code = dmu.company_code
	WHERE
		dmu.company_code = company_code_param
		AND (id.invoice_document_id IS NULL OR id.invoice_document_status_id <> 170)
		AND (IFNULL(resource_id_param, '') = '' OR (dmu.resource_id = resource_id_param))
		AND (DATE(dmu.document_manual_upload_file_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	ORDER BY
		dmu.document_manual_upload_file_update_date DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_nonmappedinvoice_scannedinvoice_list;$$

CREATE PROCEDURE apas_nonmappedinvoice_scannedinvoice_list(
	IN company_code_param                       INT,
	IN resource_id_param                        CHAR(16),
	IN invoice_document_scan_status_id_param    INT UNSIGNED
)
BEGIN
	SELECT
		m.scanner_monitor_record_id,
		m.company_code,
		m.invoice_document_file_location,
		m.invoice_document_scan_status_id,
		m.manual_upload_flag,
		m.invoice_document_scan_update_date,
		m.invoice_document_scan_duration,
		m.invoice_document_scan_error_message,
		m.invoice_document_scanner_process_tag_string
	FROM
		apad_invoice_scanner_monitor m
		LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.scanner_monitor_record_id = m.scanner_monitor_record_id
															AND dmu.company_code = m.company_code
		LEFT OUTER JOIN apam_document_model_request r ON m.scanner_monitor_record_id = r.scanner_monitor_record_id
		LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location
													AND id.company_code = m.company_code
	WHERE
		m.company_code = company_code_param
		AND r.document_model_request_id IS NULL
		AND (IFNULL(resource_id_param, '') = '' OR (dmu.resource_id = resource_id_param))
		AND ((id.invoice_document_status_id IN (10, 35, 40) AND m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 10) OR (m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 20))
	ORDER BY
		m.invoice_document_scan_update_date DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_poheaderandresourcebyvendor_list;$$

CREATE PROCEDURE apas_poheaderandresourcebyvendor_list(
	IN company_code_param   INT(11),
	IN vendor_code_param    CHAR(12),
	IN site_id_param        CHAR(32)
)
BEGIN
	SELECT DISTINCT
		ph.company_code,
		ph.vendor_code,
		ph.site_id,
		ph.client_code,
		ph.client_name,
		ph.job_code,
		ph.campaign_name,
		ph.activity_code,
		ph.media_plan_name,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.title,
		r.email,
		r.login_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_po_header ph
		INNER JOIN apad_po_resources pr ON pr.po_code = ph.po_code
											AND pr.company_code = ph.company_code
		INNER JOIN apad_resources r ON r.resource_id = pr.resource_id
											AND r.company_code = ph.company_code
											AND r.active_flag = TRUE
		INNER JOIN apam_position_category pc ON pc.position_category_code = pr.position_category_code
												AND pc.company_code = ph.company_code
	WHERE
		ph.company_code = company_code_param
		AND ph.vendor_code = vendor_code_param
		AND ph.site_id = site_id_param
	ORDER BY
		ph.po_code;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS apas_po_header_save;

DELIMITER $$
CREATE PROCEDURE apas_po_header_save
(
    companyCode     INT(11),
    poCode          VARCHAR(32),
    vendorCode      VARCHAR(12),
    siteId          VARCHAR(32),
    poAmount        DOUBLE,
    consumedAmount  DOUBLE,
    clientCode 	varchar(32),
	clientName varchar(256),
	jobCode varchar(32),
	campaignName varchar(512),
	activityCode varchar(64),
	mediaPlanName varchar(512)
)
BEGIN
    IF EXISTS (SELECT 1 FROM apad_po_header WHERE company_code = companyCode AND po_code = poCode) THEN
        UPDATE
           apad_po_header
        SET
            po_amount       = poAmount,
            consumed_amount = consumedAmount,
            client_code = clientCode,
			client_name = clientName,
			job_code = jobCode,
			campaign_name = campaignName,
			activity_code = activityCode,
			media_plan_name = mediaPlanName
        WHERE
            company_code = companyCode
            AND po_code = poCode
            AND vendor_code = vendorCode
            AND site_id = siteId;
    ELSE
        INSERT INTO apad_po_header
        (
            company_code,
            po_code,
            vendor_code,
            site_id,
            po_amount,
            consumed_amount,
            client_code,
			client_name,
			job_code,
			campaign_name,
			activity_code,
			media_plan_name
        )
        VALUES
        (
            companyCode,
            poCode,
            vendorCode,
            siteId,
            poAmount,
            consumedAmount,
            clientCode,
			clientName,
			jobCode,
			campaignName,
			activityCode,
			mediaPlanName
        );
    END IF;

    SELECT 200 code, "INSERTED" message;
END$$

DELIMITER ;

