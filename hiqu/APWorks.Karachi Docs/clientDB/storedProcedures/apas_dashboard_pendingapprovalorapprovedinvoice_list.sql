DELIMITER $$
DROP PROCEDURE IF EXISTS apas_dashboard_pendingapprovalorapprovedinvoice_list;$$

CREATE PROCEDURE apas_dashboard_pendingapprovalorapprovedinvoice_list(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN user_role_id_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT,
	IN ready_to_post_param      TINYINT
)
BEGIN
	DECLARE zero INT UNSIGNED;
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;

	CREATE TEMPORARY TABLE _temp
	(
		company_code                            INT NOT NULL,
		invoice_document_id                     INT UNSIGNED NOT NULL,
		invoice_document_file_location          VARCHAR(1024) DEFAULT NULL,
		invoice_document_status_id              INT UNSIGNED NOT NULL,
		invoice_document_status_attribute       CHAR(1) DEFAULT NULL,
		duplicate_invoice_flag                  CHAR(1) NOT NULL,
		master_document_model_id                INT UNSIGNED DEFAULT NULL,
		document_model_request_id               INT UNSIGNED DEFAULT NULL,
		vendor_code                             VARCHAR(12) DEFAULT NULL,
		site_id                                 VARCHAR(32) DEFAULT NULL,
		invoice_number                          VARCHAR(32) DEFAULT NULL,
		invoice_date                            DATE DEFAULT NULL,
		due_date                                DATE DEFAULT NULL,
		service_term_start_date                 DATE DEFAULT NULL,
		service_term_end_date                   DATE DEFAULT NULL,
		payment_term_code                       VARCHAR(32) DEFAULT NULL,
		currency_code                           VARCHAR(32) DEFAULT NULL,
		po_code                                 VARCHAR(32) DEFAULT NULL,
		model_def_id                            INT UNSIGNED NOT NULL,
		create_id                               VARCHAR(32) NOT NULL,
		create_date                             DATETIME NOT NULL,
		modify_id                               VARCHAR(32) DEFAULT NULL,
		modify_date                             DATETIME DEFAULT NULL,
		total_amount                            DOUBLE,
		request_to_map                          CHAR(1),
		manual_processing                       CHAR(1),
		invoice_document_scan_status_id         INT UNSIGNED,
		manual_upload_flag                      CHAR(1),
		invoice_document_posting_status_id      INT UNSIGNED,
		invoice_document_posting_error_message  VARCHAR(1024),
		vendor_name                             VARCHAR(256),
		short_name                              VARCHAR(128),
		routing_history_count                   BIGINT,
		approval_rejection_update_date          DATETIME,
		resource_id                             CHAR(16),
		name_last                               VARCHAR(32),
		name_first                              VARCHAR(32)
	);

	CREATE TEMPORARY TABLE _temp_dt_rbid (
		company_code INT,
		invoice_document_id INT
	);

	CREATE TEMPORARY TABLE _temp_dt_h (
		company_code INT,
		invoice_document_id INT,
		approval_rejection_update_date DATETIME,
		approval_rejection_user_id VARCHAR(64)
	);

	SET zero = 0;
	SELECT routing_number_of_approval_levels INTO routing_number_of_approval_levels_param FROM apam_company_approval_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param;

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	IF resource_id_param IS NOT NULL THEN
		SELECT
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 70 ELSE 50 END ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 90 ELSE 70 END ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 110 ELSE 90 END ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 130 ELSE 110 END ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 150 ELSE 130 END ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 50 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 150 ELSE 0 END
		INTO
			@allowed_level_1_status,
			@allowed_level_2_status,
			@allowed_level_3_status,
			@allowed_level_4_status,
			@allowed_level_5_status,
			@allowed_pending_level_1_status,
			@allowed_pending_level_2_status,
			@allowed_pending_level_3_status,
			@allowed_pending_level_4_status,
			@allowed_pending_level_5_status,
			@allowed_approved_level_1_status,
			@allowed_approved_level_2_status,
			@allowed_approved_level_3_status,
			@allowed_approved_level_4_status,
			@allowed_approved_level_5_status
		FROM
			apad_user_roles_invoice_rights
		WHERE
			user_role_id = user_role_id_param
			AND model_def_id = model_def_id_param
			AND company_code = company_code_param;
	END IF;

	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	/*TL20210708 Created two temp tables _temp_dt_rbid AND _temp_dt_h to reduce the subquery in the SELECT statement down below
	This will help in troubleshooting issues.*/

	INSERT INTO _temp_dt_rbid
	SELECT DISTINCT
		0 AS company_code,
		0 AS invoice_document_id
	UNION
	SELECT DISTINCT
		rbid.company_code,
		rbid.invoice_document_id
	FROM
		v_ResourcesByInvoiceDocument rbid
		INNER JOIN apad_invoice_document id ON id.invoice_document_id = rbid.invoice_document_id
												AND id.company_code = rbid.company_code
		INNER JOIN apad_user_role_position_categories urpc ON rbid.position_category_code = rbid.position_category_code
															AND urpc.company_code = rbid.company_code
															AND (urpc.user_role_id = user_role_id_param OR IFNULL(resource_id_param, '') = '')
	WHERE
		rbid.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND rbid.resource_id = resource_id_param;
	

	INSERT INTO _temp_dt_h
	SELECT
		h.company_code,
		h.invoice_document_id,
		h.approval_rejection_update_date,
		h.approval_rejection_user_id
	FROM
		(
			SELECT
				h.company_code,
				h.invoice_document_id,
				MAX(h.sequence_id) AS sequence_id
			FROM
				apad_invoice_document_routing_history h
				INNER JOIN apad_invoice_document id ON id.invoice_document_id = h.invoice_document_id
														AND id.company_code = h.company_code
			WHERE
				id.model_def_id = model_def_id_param
			GROUP BY
				h.company_code,
				h.invoice_document_id
		) t
		INNER JOIN apad_invoice_document_routing_history h ON h.invoice_document_id = t.invoice_document_id
																AND h.company_code = t.company_code
																AND h.sequence_id = t.sequence_id;

	INSERT INTO _temp
	(
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	)
	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.document_model_request_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		id.TotalAmount,
		id.request_to_map,
		id.manual_processing,
		IFNULL(id.invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		id.manual_upload_flag,
		id.invoice_document_posting_status_id,
		id.invoice_document_posting_error_message,
		id.vendor_name,
		id.short_name,
		id.routing_history_count,
		IFNULL(dt_h.approval_rejection_update_date, id.modify_date) AS approval_rejection_update_date,
		r.resource_id,
		r.name_first,
		r.name_last
	FROM
		v_InvoiceDocument id
		INNER JOIN _temp_dt_rbid dt_rbid ON dt_rbid.invoice_document_id = id.invoice_document_id OR IFNULL(resource_id_param, '') = ''
		LEFT OUTER JOIN _temp_dt_h dt_h ON dt_h.invoice_document_id = id.invoice_document_id
								AND dt_h.company_code = id.company_code
		LEFT OUTER JOIN apad_resources r ON r.resource_id = dt_h.approval_rejection_user_id
											AND r.company_code = id.company_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.invoice_document_id = id.invoice_document_id
																				AND idrrh.resource_id = r.resource_id
																				AND idrrh.company_code = id.company_code
																				AND idrrh.suggestion_flag = 'N'
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND id.invoice_document_status_id NOT IN (60, 80, 100, 120, 140, 160)
		AND (DATE(approval_rejection_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
		AND (
				(
					ready_to_post_param = FALSE
					AND id.invoice_document_status_id >= 50
					AND id.invoice_document_status_id < max_possible_approved_status_id
					AND (IFNULL(resource_id_param, '') = '' OR id.invoice_document_status_id IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status))
				)
				OR (
					ready_to_post_param = TRUE
					AND id.invoice_document_status_id >= 70
					AND (
						id.invoice_document_status_id IN (170)
						OR id.invoice_document_status_id >= max_possible_approved_status_id
						OR id.invoice_document_status_id NOT IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status)
					)
					AND (
						@allowed_approved_level_1_status <> 0
						OR @allowed_approved_level_2_status <> 0
						OR @allowed_approved_level_3_status <> 0
						OR @allowed_approved_level_4_status <> 0
						OR @allowed_approved_level_5_status <> 0
						OR idrrh.invoice_document_id IS NOT NULL
					)
				)
			);

	SELECT
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	FROM
		_temp
	ORDER BY
		approval_rejection_update_date DESC,
		modify_date DESC,
		invoice_document_id;


	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;
END$$
DELIMITER ;

