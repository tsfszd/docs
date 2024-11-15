DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocument_verifyduplication;$$

CREATE PROCEDURE apas_invoicedocument_verifyduplication(
	IN company_code_param                      INT,
	IN invoice_document_id_param               INT UNSIGNED,
	IN vendor_code_param                       VARCHAR(12),
	IN site_id_param                           VARCHAR(32),
	IN invoice_number_param                    VARCHAR(32),
	OUT duplicate_invoice_flag_param 		   CHAR(1)
)
BEGIN
	DECLARE duplicate_invoice_flag_param CHAR(1);
	IF EXISTS (SELECT
					1
				FROM
					apad_invoice_document
				WHERE
					invoice_number = invoice_number_param
					AND vendor_code = vendor_code_param
					AND company_code = company_code_param
					AND is_deleted = FALSE
					AND invoice_document_id <> invoice_document_id_param) THEN
		SET duplicate_invoice_flag_param = 'Y';
	ELSE
		SET duplicate_invoice_flag_param = 'N';
	END IF;
 
	SELECT duplicate_invoice_flag_param as IsDuplicate;
END$$
DELIMITER ;

