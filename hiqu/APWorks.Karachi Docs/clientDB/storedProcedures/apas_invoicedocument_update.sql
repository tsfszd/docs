DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_update;$$

CREATE PROCEDURE apas_invoicedocument_update(
	IN company_code_param                      INT,
	IN invoice_document_id_param               INT UNSIGNED,
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
	IN po_code_param                           VARCHAR(32),
	IN modify_id_param                         VARCHAR(32),
	IN modify_date_param                       DATETIME
)
BEGIN
	IF EXISTS (SELECT
					1
				FROM
					apad_invoice_document
				WHERE
					invoice_number = invoice_number_param
					AND vendor_code = vendor_code_param
					AND site_id = site_id_param
					AND company_code = company_code_param
					AND is_deleted = FALSE
					AND invoice_document_id <> invoice_document_id_param) THEN
		SET duplicate_invoice_flag_param = 'Y';
	ELSE
		SET duplicate_invoice_flag_param = 'N';
	END IF;
 
	UPDATE
		apad_invoice_document
	SET
		invoice_document_status_id			= invoice_document_status_id_param,
		invoice_document_status_attribute	= invoice_document_status_attribute_param,
		invoice_document_file_location		= invoice_document_file_location_param,
		duplicate_invoice_flag				= duplicate_invoice_flag_param,
		master_document_model_id			= master_document_model_id_param,
		document_model_request_id			= document_model_request_id_param,
		vendor_code							= vendor_code_param,
		site_id								= site_id_param,
		invoice_number						= invoice_number_param,
		invoice_date						= invoice_date_param,
		due_date							= due_date_param,
		service_term_start_date				= service_term_start_date_param,
		service_term_end_date				= service_term_end_date_param,
		payment_term_code					= payment_term_code_param,
		currency_code						= currency_code_param,
		po_code                             = po_code_param,
		modify_id							= modify_id_param,
		modify_date							= modify_date_param
	WHERE
		company_code = company_code_param
		AND invoice_document_id = invoice_document_id_param;
END$$
DELIMITER ;

