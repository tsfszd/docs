DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentdetail_delete;$$

CREATE PROCEDURE apas_invoicedocumentdetail_delete(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	DELETE FROM apad_invoice_document_detail
	WHERE
		company_code = company_code_param
		AND invoice_document_id = invoice_document_id_param;
END$$
DELIMITER ;

