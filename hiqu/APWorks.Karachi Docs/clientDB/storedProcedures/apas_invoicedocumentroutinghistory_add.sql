DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentroutinghistory_add;$$

CREATE PROCEDURE apas_invoicedocumentroutinghistory_add(
	IN company_code_param                      INT,
	IN invoice_document_id_param               INT UNSIGNED,
	IN sequence_id_param                       INT UNSIGNED,
    IN approval_level_param                    INT UNSIGNED,
	IN invoice_document_status_id_param        INT UNSIGNED,
	IN approval_rejection_comment_param        VARCHAR(1024),
	IN approval_rejection_update_date_param    DATETIME,
	IN approval_rejection_user_id_param        VARCHAR(32)
)
BEGIN
	SET sequence_id_param = (SELECT MAX(sequence_id) + 1 FROM apad_invoice_document_routing_history WHERE invoice_document_id = invoice_document_id_param AND company_code = company_code_param);

	IF ISNULL(sequence_id_param) THEN
			SET sequence_id_param = 1;
    END IF;

	INSERT INTO apad_invoice_document_routing_history
	(
		company_code,
		invoice_document_id,
        sequence_id,
		approval_level,
		invoice_document_status_id,
		approval_rejection_comment,
		approval_rejection_update_date,
		approval_rejection_user_id
	)
	SELECT
		company_code_param,
		invoice_document_id_param,
        sequence_id_param,
		approval_level_param,
		invoice_document_status_id_param,
		approval_rejection_comment_param,
		approval_rejection_update_date_param,
		approval_rejection_user_id_param;
END$$
DELIMITER ;

