DELIMITER $$
DROP PROCEDURE IF EXISTS apas_poheaderbypocodelist_list;$$

CREATE PROCEDURE apas_poheaderbypocodelist_list
(
	IN company_code_param               INT,
	IN po_code_list_param               VARCHAR(65535),
	IN service_term_start_date_param    DATE,
	IN service_term_end_date_param      DATE
)
BEGIN
	IF service_term_start_date_param IS NULL THEN
		SET @service_term_start_date = 'NULL';
	ELSE
		SET @service_term_start_date = CONCAT('''', service_term_start_date_param, '''');
	END IF;

	IF service_term_end_date_param IS NULL THEN
		SET @service_term_end_date = 'NULL';
	ELSE
		SET @service_term_end_date = CONCAT('''', service_term_end_date_param, '''');
	END IF;

	#SELECT @service_term_start_date, @service_term_end_date;

	SET @query = CONCAT('SELECT
		ph.company_code,
		ph.po_code,
		ph.vendor_code,
		ph.site_id,
		ph.po_amount,
		ph.consumed_amount,
		ph.client_code,
		ph.client_name,
		ph.job_code,
		ph.campaign_name,
		ph.activity_code,
		ph.media_plan_name,
		ph.model_def_id,
		IFNULL(SUM(pmd.delivery_amount), 0.00) AS delivery_amount
	FROM
		apad_po_header ph
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.po_code = ph.po_code
													AND pmd.company_code = ph.company_code
													AND pmd.delivery_date BETWEEN ', @service_term_start_date, ' AND ', @service_term_end_date, '
	WHERE
		ph.company_code = ', company_code_param, '
		AND ph.po_code IN (', po_code_list_param, ')
	GROUP BY
		ph.company_code,
		ph.po_code,
		ph.vendor_code,
		ph.site_id,
		ph.po_amount,
		ph.consumed_amount,
		ph.client_code,
		ph.client_name,
		ph.job_code,
		ph.campaign_name,
		ph.activity_code,
		ph.media_plan_name,
		ph.model_def_id
	ORDER BY
		ph.po_code;');

	PREPARE stmt1 FROM @query;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;
END$$
DELIMITER ;

