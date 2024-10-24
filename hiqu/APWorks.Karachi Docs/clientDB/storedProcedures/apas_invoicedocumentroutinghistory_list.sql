DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentroutinghistory_list;$$

CREATE PROCEDURE apas_invoicedocumentroutinghistory_list(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	SELECT
		h.company_code,
		h.invoice_document_id,
		h.sequence_id,
		h.approval_level,
		h.invoice_document_status_id,
		h.approval_rejection_comment,
		h.approval_rejection_update_date,
		h.approval_rejection_user_id,
		r.name_last,
		r.name_first,
		id.model_def_id
	FROM
		apad_invoice_document_routing_history h
		INNER JOIN apad_invoice_document id ON id.invoice_document_id = h.invoice_document_id
												AND id.company_code = h.company_code
		INNER JOIN apad_resources r ON h.approval_rejection_user_id = r.resource_id
										AND h.company_code = r.company_code
	WHERE
		h.company_code = company_code_param
		AND h.invoice_document_id = invoice_document_id_param
	ORDER BY
		h.sequence_id DESC;
END$$
DELIMITER ;

