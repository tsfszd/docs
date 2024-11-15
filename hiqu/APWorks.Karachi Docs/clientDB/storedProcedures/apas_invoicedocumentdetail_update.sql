DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentdetail_update;$$

CREATE PROCEDURE apas_invoicedocumentdetail_update(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED,
	IN seq_id_param                 INT UNSIGNED,
	IN io_number_param              VARCHAR(64),
	IN level2_key_param             VARCHAR(32),
	IN level3_key_param             VARCHAR(32),
	IN cost_type_param              INT,
	IN res_type_param               INT,
	IN io_description_param         VARCHAR(128),
	IN quantity_param               INT,
	IN io_invoice_amount_param      DOUBLE
)
BEGIN
	UPDATE apad_invoice_document_detail
	SET
		io_number           = io_number_param,
		level2_key          = level2_key_param,
		level3_key          = level3_key_param,
		cost_type           = cost_type_param,
		res_type            = res_type_param,
		io_description      = io_description_param,
		quantity            = quantity_param,
		io_invoice_amount	= io_invoice_amount_param
	WHERE
		company_code = company_code_param
		AND invoice_document_id = invoice_document_id_param
		AND seq_id = seq_id_param;
END$$
DELIMITER ;

