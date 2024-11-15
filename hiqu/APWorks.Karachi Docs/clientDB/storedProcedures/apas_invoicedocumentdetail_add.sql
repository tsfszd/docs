DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentdetail_add;$$

CREATE PROCEDURE apas_invoicedocumentdetail_add(
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
	IF seq_id_param = 0 THEN
		SET seq_id_param = (SELECT MAX(seq_id) + 1 FROM apad_invoice_document_detail);

		IF ISNULL(seq_id_param) THEN
			SET seq_id_param = 1;
		END IF;
	END IF;

	INSERT INTO apad_invoice_document_detail
	(
		company_code,
		invoice_document_id,
		seq_id,
		io_number,
		level2_key,
		level3_key,
		cost_type,
		res_type,
		io_description,
		quantity,
		io_invoice_amount
	)
	SELECT
		company_code_param,
		invoice_document_id_param,
		seq_id_param,
		io_number_param,
		level2_key_param,
		level3_key_param,
		cost_type_param,
		res_type_param,
		io_description_param,
		quantity_param,
		io_invoice_amount_param;
END$$
DELIMITER ;

