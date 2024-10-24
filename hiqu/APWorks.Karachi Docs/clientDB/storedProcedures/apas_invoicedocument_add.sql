DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_add;$$

CREATE PROCEDURE apas_invoicedocument_add(
	IN company_code_param                      INT,
	OUT invoice_document_id_param              INT UNSIGNED,
	IN invoice_document_file_location_param    VARCHAR(1024),
	IN invoice_document_status_id_param        INT UNSIGNED,
	IN invoice_document_status_attribute_param CHAR(1),
	IN duplicate_invoice_flag_param            CHAR(1),
	IN master_document_model_id_param          INT UNSIGNED,
	IN document_model_request_id_param         INT UNSIGNED,
	IN vendor_code_param                       VARCHAR(12),
	IN site_id_param                           VARCHAR(32),
	IN invoice_number_param                    VARCHAR(32),
	IN invoice_date_param                      DATE,
	IN due_date_param                          DATE,
	IN service_term_start_date_param           DATE,
	IN service_term_end_date_param             DATE,
	IN payment_term_code_param                 VARCHAR(32),
	IN currency_code_param                     VARCHAR(32),
	IN scanned_total_param                     DOUBLE,
	IN po_code_param                           VARCHAR(32),
	IN model_def_id_param                      INT UNSIGNED,
	IN create_id_param                         VARCHAR(32),
	IN create_date_param                       DATETIME
)
BEGIN
	SET invoice_document_id_param = (SELECT invoice_document_id FROM apad_invoice_document WHERE invoice_document_file_location = invoice_document_file_location_param AND company_code = company_code_param);
    
    IF ISNULL(invoice_document_id_param) THEN
		SET invoice_document_id_param = (SELECT MAX(invoice_document_id) + 1 FROM apad_invoice_document);

		IF ISNULL(invoice_document_id_param) THEN
			SET invoice_document_id_param = 1;
		END IF;

		IF EXISTS (SELECT
					1
				FROM
					apad_invoice_document
				WHERE
					invoice_number = invoice_number_param
					AND vendor_code = vendor_code_param
					AND site_id = site_id_param
					AND company_code = company_code_param
					AND is_deleted = FALSE) THEN
			SET duplicate_invoice_flag_param = 'Y';
		END IF;
 
		INSERT INTO apad_invoice_document
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
			scanned_total,
			po_code,
			model_def_id,
			create_id,
			create_date
		)
		SELECT
			company_code_param,
			invoice_document_id_param,
			invoice_document_file_location_param,
			CASE WHEN duplicate_invoice_flag_param = 'Y' THEN 40 ELSE invoice_document_status_id_param END,
			invoice_document_status_attribute_param,
			duplicate_invoice_flag_param,
			master_document_model_id_param,
			document_model_request_id_param,
			vendor_code_param,
			site_id_param,
			invoice_number_param,
			invoice_date_param,
			due_date_param,
			service_term_start_date_param,
			service_term_end_date_param,
			payment_term_code_param,
			currency_code_param,
			scanned_total_param,
			po_code_param,
			model_def_id_param,
			create_id_param,
			create_date_param;
	END IF;
END$$
DELIMITER ;

