DELIMITER $$
DROP PROCEDURE IF EXISTS apas_invoicedocumentresourcenotification_getbynumberofdays;$$

CREATE PROCEDURE apas_invoicedocumentresourcenotification_getbynumberofdays(
	IN company_code_param   INT,
	IN number_of_days_param INT
)
BEGIN
	DECLARE expiry_date DATETIME;
	SET expiry_date = DATE_SUB(UTC_DATE(), INTERVAL number_of_days_param DAY);

	SELECT DISTINCT
		dt_id.company_code,
		dt_id.invoice_document_id,
		r.resource_id,
		n.notification_date,
		n.create_id,
		n.create_date,
		n.modify_id,
		n.modify_date,
		dt_id.invoice_number,
		dt_id.invoice_document_status_id,
		dt_id.vendor_code,
		dt_id.site_id,
		dt_id.short_name,
		h.comments,
		r2.login_id AS routed_by,
		r.name_first,
		r.name_last,
		r.email
	FROM
		(
			SELECT
				id.company_code,
				id.invoice_document_id,
				id.invoice_number,
				id.invoice_document_status_id,
				id.vendor_code,
				id.site_id,
				IFNULL(id.modify_date, id.create_date) AS modify_date,
				v.short_name
			FROM
				apad_invoice_document id
				LEFT OUTER JOIN apad_vendors v ON  id.company_code = v.company_code
												AND id.vendor_code = v.vendor_code
												AND id.site_id = v.site_id
			WHERE
				id.company_code = company_code_param
				AND id.invoice_document_status_id <> 180
				AND id.is_deleted = FALSE
				AND DATE(IFNULL(id.modify_date, id.create_date)) <= expiry_date
		) dt_id
		INNER JOIN apad_invoice_document_resource_routing_history h ON dt_id.invoice_document_id = h.invoice_document_id
																		AND dt_id.company_code = h.company_code
		INNER JOIN apad_resources r ON h.resource_id = r.resource_id
										AND h.resource_id = r.resource_id
										AND r.active_flag = TRUE
		INNER JOIN apad_resources r2 ON r2.resource_id = h.create_id
										AND r2.company_code = h.company_code
										AND r2.active_flag = TRUE
		LEFT OUTER JOIN apad_invoice_document_resource_notification n ON h.invoice_document_id = n.invoice_document_id
																		AND h.resource_id = n.resource_id
																		AND h.company_code = n.company_code
	WHERE
		dt_id.company_code = company_code_param
		AND ((n.notification_date IS NOT NULL AND DATE(n.notification_date) <= expiry_date) OR (n.notification_date IS NULL AND DATE(h.create_date) <= expiry_date));
END$$
DELIMITER ;

