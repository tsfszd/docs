DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_list;$$

CREATE PROCEDURE apas_invoicedocument_list(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	DROP TEMPORARY TABLE IF EXISTS temp_invoice_document;
	DROP TEMPORARY TABLE IF EXISTS temp_client;

	CREATE TEMPORARY TABLE temp_invoice_document
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
		replaced_by_invoice_document_file_location VARCHAR(1024) DEFAULT NULL,
		transaction_id                          VARCHAR(32) DEFAULT NULL,
		model_def_id                            INT UNSIGNED DEFAULT 1 NOT NULL,
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
		date_updated                            DATETIME
	);

	CREATE TEMPORARY TABLE temp_client
	(
		company_code        INT NOT NULL,
		invoice_document_id INT UNSIGNED NOT NULL,
		client_code         VARCHAR(32),
		client_name         VARCHAR(256)
	);

	INSERT INTO temp_invoice_document
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
		replaced_by_invoice_document_file_location,
		transaction_id,
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
		date_updated
	)
	SELECT
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		IFNULL(master_document_model_id, zero) AS master_document_model_id,
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
		replaced_by_invoice_document_file_location,
		transaction_id,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		TotalAmount,
		request_to_map,
		manual_processing,
		IFNULL(invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		IFNULL(modify_date, create_date) AS date_updated
	FROM
		v_InvoiceDocument
	WHERE
		company_code = company_code_param
		AND model_def_id = model_def_id_param;

	INSERT INTO temp_client
	(
		company_code,
		invoice_document_id,
		client_code,
		client_name
	)
	SELECT DISTINCT
		t1.company_code,
		t1.invoice_document_id,
		t2.client_code,
		t2.client_name
	FROM
		temp_invoice_document t1
	LEFT OUTER JOIN (SELECT DISTINCT
						idd.company_code,
						idd.invoice_document_id,
						ph.po_code,
						ph.vendor_code,
						ph.site_id,
						ph.client_code,
						ph.client_name
					FROM
						apad_invoice_document_detail idd
						INNER JOIN apad_po_header ph ON ph.po_code = idd.io_number
														AND ph.company_code = idd.company_code
														AND ph.model_def_id = model_def_id_param
					) t2 ON t2.invoice_document_id = t1.invoice_document_id
							AND t2.company_code = t1.company_code
							AND t2.vendor_code = t1.vendor_code
							AND t2.site_id = t1.site_id;
	SELECT
		t.company_code,
		t.invoice_document_id,
		t.invoice_document_file_location,
		t.invoice_document_status_id,
		t.invoice_document_status_attribute,
		t.duplicate_invoice_flag,
		t.master_document_model_id,
		t.document_model_request_id,
		t.vendor_code,
		t.site_id,
		t.invoice_number,
		t.invoice_date,
		t.due_date,
		t.service_term_start_date,
		t.service_term_end_date,
		t.payment_term_code,
		t.currency_code,
		t.po_code,
		t.replaced_by_invoice_document_file_location,
		t.transaction_id,
		t.model_def_id,
		t.create_id,
		t.create_date,
		t.modify_id,
		t.modify_date,
		t.total_amount,
		t.request_to_map,
		t.manual_processing,
		t.invoice_document_scan_status_id,
		t.manual_upload_flag,
		t.invoice_document_posting_status_id,
		t.invoice_document_posting_error_message,
		t.vendor_name,
		t.short_name,
		t.routing_history_count,
		t.date_updated,
		c.client_code,
		c.client_name
	FROM
		temp_invoice_document t
		LEFT OUTER JOIN temp_client c ON t.invoice_document_id = c.invoice_document_id
										AND t.company_code = c.company_code
	ORDER BY
		t.date_updated DESC,
		t.invoice_document_id;

	DROP TEMPORARY TABLE IF EXISTS temp_invoice_document;
	DROP TEMPORARY TABLE IF EXISTS temp_client;
END$$
DELIMITER ;

