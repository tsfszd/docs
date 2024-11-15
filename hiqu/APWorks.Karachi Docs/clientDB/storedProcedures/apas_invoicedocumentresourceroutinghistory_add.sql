DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentresourceroutinghistory_add;$$

CREATE PROCEDURE apas_invoicedocumentresourceroutinghistory_add
(
	IN company_code_param           INT,
	IN invoice_document_id_param	INT UNSIGNED,
	INOUT sequence_id_param         INT UNSIGNED,
	IN resource_id_param            CHAR(16),
	IN suggestion_flag_param        CHAR(1),
	IN comments_param               VARCHAR(1024),
	IN create_id_param              VARCHAR(32),
	IN create_date_param            DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apad_invoice_document_resource_routing_history WHERE company_code = company_code_param AND invoice_document_id = invoice_document_id_param AND resource_id = resource_id_param AND sequence_id = sequence_id_param) THEN
		SET sequence_id_param = 0;
	END IF;

	IF (IFNULL(sequence_id_param, 0) = 0) THEN
		SET sequence_id_param = (SELECT MAX(sequence_id) + 1 FROM apad_invoice_document_resource_routing_history WHERE company_code = company_code_param AND invoice_document_id = invoice_document_id_param);

		IF ISNULL(sequence_id_param) THEN
				SET sequence_id_param = 1;
		END IF;
	END IF;

	INSERT INTO apad_invoice_document_resource_routing_history
	(
		company_code,
		invoice_document_id,
        sequence_id,
		resource_id,
		suggestion_flag,
		comments,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		invoice_document_id_param,
        sequence_id_param,
		resource_id_param,
		suggestion_flag_param,
		comments_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

