DELIMITER $$
DROP PROCEDURE IF EXISTS apas_datasearchservice_get;$$

CREATE PROCEDURE apas_datasearchservice_get(
	IN company_code_param       INT,
	valuesCSV           VARCHAR(65535)
)
BEGIN

DROP TEMPORARY TABLE IF EXISTS _tempDataSearch;
CREATE TEMPORARY TABLE IF NOT EXISTS _tempDataSearch

	(
		block_id        varchar(64),
		word            varchar(1024)
);

SET @query = CONCAT('INSERT INTO _tempDataSearch(block_id, word) VALUES ',valuesCSV,';');

PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

-- ________________________________Invoice document__________________________________
SELECT DISTINCT
    id.vendor_code,
    id.site_id,
    id.invoice_number,
    id.po_code,
    id.create_id,
	CONCAT('%', t.word, '%') AS WORD
    
FROM
    apad_invoice_document id
        INNER JOIN
    apad_vendors v ON v.vendor_code = id.vendor_code
        AND v.site_id = id.site_id
        INNER JOIN
    _tempDataSearch t ON id.vendor_code LIKE WORD
        OR id.site_id LIKE WORD
        OR id.invoice_number LIKE WORD
        OR id.po_code LIKE WORD
        OR id.create_id LIKE WORD
WHERE
    v.vendor_status_id = 1
        AND id.company_code = company_code_param
        AND (
        ((ifnull(id.vendor_code, '') <> '') AND id.vendor_code LIKE WORD)
        OR ((ifnull(id.site_id, '') <> '') AND id.site_id LIKE WORD)
        OR ((ifnull(id.invoice_number, '') <> '') AND id.invoice_number LIKE WORD)
        OR ((ifnull(id.po_code, '') <> '') AND id.po_code LIKE WORD)
        OR ((ifnull(id.create_id, '') <> '') AND id.create_id LIKE WORD)
		);

-- ________________________________Invoice document detail__________________________________
SELECT DISTINCT
    idd.io_number, idd.level2_key, idd.level3_key, CONCAT('%', t.word, '%') AS WORD
FROM
    apad_invoice_document_detail idd
	INNER JOIN apad_level2 l2 ON l2.level2_key = idd.level2_key
							AND l2.company_code = idd.company_code
	INNER JOIN apad_level3 l3 ON l3.level3_key = idd.level3_key
							AND l3.company_code = idd.company_code
	INNER JOIN _tempDataSearch t ON idd.io_number LIKE WORD
							OR idd.level2_key LIKE WORD
							OR idd.level3_key LIKE WORD
	WHERE
    l2.level2_status_id = 1
	AND l3.level3_status_id = 1
	AND idd.company_code = company_code_param
    AND (
    ((ifnull(idd.io_number, '') <> '') AND idd.io_number LIKE WORD)
	OR ((ifnull(idd.level2_key, '') <> '') AND idd.level2_key LIKE WORD)
	OR ((ifnull(idd.level3_key, '') <> '') AND idd.level3_key LIKE WORD)
	);

-- ________________________________Invoice document routing history__________________________________
SELECT DISTINCT
    idrh.approval_rejection_user_id, CONCAT('%', t.word, '%') AS WORD
FROM
    apad_invoice_document_routing_history idrh
	INNER JOIN apad_invoice_document id ON id.invoice_document_id = idrh.invoice_document_id
							AND id.company_code = idrh.company_code
	INNER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
							AND v.company_code = idrh.company_code
	INNER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = idrh.invoice_document_id
							AND idd.company_code = idrh.company_code
	INNER JOIN apad_level2 l2 ON l2.level2_key = idd.level2_key
							AND l2.company_code = idrh.company_code
	INNER JOIN apad_level3 l3 ON l3.level3_key = idd.level3_key
							AND l3.company_code = idrh.company_code
	INNER JOIN _tempDataSearch t ON idrh.approval_rejection_user_id LIKE WORD
WHERE
    v.vendor_status_id = 1
	AND l2.level2_status_id = 1
	AND l3.level3_status_id = 1
	AND idrh.company_code = company_code_param
    AND (
    ((ifnull(idrh.approval_rejection_user_id, '') <> '') AND idrh.approval_rejection_user_id LIKE WORD)
	);
    
-- ________________________________Level2__________________________________
SELECT DISTINCT
    l2.level2_key,
    l2.level2_description,
    l2.customer_code,
    l2.customer_name,
    l2.customer_po_number,
	CONCAT('%', t.word, '%') AS WORD
FROM
    apad_level2 l2
    INNER JOIN _tempDataSearch t ON l2.level2_key LIKE WORD
							OR l2.level2_description LIKE WORD
							OR l2.customer_code LIKE WORD
							OR l2.customer_name LIKE WORD
							OR l2.customer_po_number LIKE WORD
                            
WHERE
    l2.level2_status_id = 1
	AND l2.company_code = company_code_param
    AND (
			((ifnull(l2.level2_key, '') <> '') AND l2.level2_key LIKE WORD)
			OR ((ifnull(l2.level2_description, '') <> '') AND l2.level2_description LIKE WORD)
			OR ((ifnull(l2.customer_code, '') <> '') AND l2.customer_code LIKE WORD)
			OR ((ifnull(l2.customer_name, '') <> '') AND l2.customer_name LIKE WORD)
			OR ((ifnull(l2.customer_po_number, '') <> '') AND l2.customer_po_number LIKE WORD)
    );
	
-- ________________________________Level2 resources__________________________________	
SELECT DISTINCT
    l2r.level2_key, l2r.resource_id, CONCAT('%', t.word, '%') AS WORD
FROM
    apad_level2_resources l2r
	INNER JOIN apad_level2 l2 ON l2.level2_key = l2r.level2_key
							AND l2.company_code = l2r.company_code
	INNER JOIN apad_resources r ON r.resource_id = l2r.resource_id
							AND r.company_code = l2r.company_code
	INNER JOIN _tempDataSearch t ON l2r.level2_key LIKE WORD
							OR l2r.resource_id LIKE WORD
WHERE
    l2.level2_status_id = 1
	AND r.active_flag = 1
	AND l2r.company_code = company_code_param
    AND (
    ((ifnull(l2r.level2_key, '') <> '') AND l2r.level2_key LIKE WORD)
	OR ((ifnull(l2r.resource_id, '') <> '') AND l2r.resource_id LIKE WORD)
	);
	
-- ________________________________Level3___________________________________
SELECT DISTINCT
    l3.level3_key, 
    l3.level3_description, 
    l3.customer_po_number,
	CONCAT('%', t.word, '%') AS WORD
FROM
    apad_level3 l3
	INNER JOIN apad_level2 l2 ON l2.level2_key = l3.level2_key
							AND l2.company_code = l3.company_code
	INNER JOIN _tempDataSearch t ON  l3.level3_key LIKE WORD
							OR l3.level3_description LIKE WORD
							OR l3.customer_po_number LIKE WORD
WHERE
    l3.level3_status_id = 1
    AND l2.level2_status_id = 1
	AND l2.company_code = company_code_param
    AND(
    ((ifnull(l3.level3_key, '') <> '') AND l3.level3_key LIKE WORD) 
	OR ((ifnull(l3.level3_description, '') <> '') AND l3.level3_description LIKE WORD)
    OR ((ifnull(l3.customer_po_number, '') <> '') AND l3.customer_po_number LIKE WORD)
    );
	
-- ________________________________PO detail__________________________________
SELECT DISTINCT
    pod.po_code, pod.level2_key, pod.level3_key, CONCAT('%', t.word, '%') as WORD
FROM
    apad_po_detail pod
	INNER JOIN apad_level2 l2 ON l2.level2_key = pod.level2_key
                            AND l2.company_code = pod.company_code
	INNER JOIN apad_level3 l3 ON l3.level3_key = pod.level3_key
							AND l3.company_code = pod.company_code
                            AND l3.level2_key = l2.level2_key
	INNER JOIN _tempDataSearch t ON pod.po_code LIKE WORD
							OR pod.level2_key LIKE WORD
							OR pod.level3_key LIKE WORD
WHERE
    pod.close_flag = 0
	AND l2.level2_status_id = 1
	AND l3.level3_status_id = 1
	AND pod.company_code = company_code_param
    AND (
    (pod.po_code LIKE (ifnull(pod.po_code, '') <> '') AND WORD)
	OR ((ifnull(pod.level2_key, '') <> '') AND pod.level2_key LIKE WORD)
	OR ((ifnull(pod.level3_key, '') <> '') AND pod.level3_key LIKE WORD)
	);
	
-- ________________________________PO header__________________________________    	
SELECT DISTINCT
    poh.po_code,
    poh.vendor_code,
    poh.site_id,
    poh.client_code,
    poh.client_name,
    poh.job_code,
    poh.campaign_name,
    poh.activity_code,
    poh.media_plan_name,
	CONCAT('%', t.word, '%') as WORD
FROM
    apad_po_header poh
	INNER JOIN apad_vendors v ON v.vendor_code = poh.vendor_code
							AND v.company_code = poh.company_code
	INNER JOIN _tempDataSearch t ON 
							poh.po_code LIKE WORD
							OR poh.vendor_code LIKE WORD
							OR poh.site_id LIKE WORD
                            OR poh.client_code LIKE WORD
							OR poh.job_code LIKE WORD
                            OR poh.campaign_name LIKE WORD
							OR poh.activity_code LIKE WORD
							OR poh.media_plan_name LIKE WORD
WHERE
    poh.active_flag = 1
	AND v.vendor_status_id = 1
	AND poh.company_code = company_code_param
    AND
    (
    ((ifnull(poh.po_code, '') <> '') AND poh.po_code LIKE WORD)
	OR ((ifnull(poh.vendor_code, '') <> '') AND poh.vendor_code LIKE WORD)
	OR ((ifnull(poh.site_id, '') <> '') AND poh.site_id LIKE WORD)
    OR ((ifnull(poh.client_code, '') <> '') AND poh.client_code LIKE WORD)
	OR ((ifnull(poh.job_code, '') <> '') AND poh.job_code LIKE WORD)
    OR ((ifnull(poh.campaign_name, '') <> '') AND poh.campaign_name LIKE WORD)
	OR ((ifnull(poh.activity_code, '') <> '') AND poh.activity_code LIKE WORD)
	OR ((ifnull(poh.media_plan_name, '') <> '') AND poh.media_plan_name LIKE WORD)
    );

-- ________________________________PO resources__________________________________    
SELECT DISTINCT
    por.po_code, por.resource_id, CONCAT('%', t.word, '%') as WORD
FROM
    apad_po_resources por
	INNER JOIN apad_resources r ON r.resource_id = por.resource_id
							AND por.company_code = r.company_code
	INNER JOIN _tempDataSearch t ON t.word >= 5
							AND por.po_code like WORD
WHERE
    r.active_flag = 1
	AND por.company_code = company_code_param
    AND t.word >= 5
    AND (
    ifnull(por.po_code, '') <> ''
		AND por.po_code like WORD
    );

-- ________________________________Resources__________________________________
SELECT DISTINCT
    r.resource_id,
    r.name_first,
    r.name_last,
    r.email,
    r.login_id,
    r.create_id,
    r.modify_id,
	CONCAT('%', t.word, '%') as WORD
FROM
    apad_resources r
    INNER JOIN _tempDataSearch t ON 
							r.resource_id LIKE WORD
							OR r.name_first LIKE WORD
                            OR r.name_last LIKE WORD
                            OR r.email LIKE WORD
                            OR r.login_id LIKE WORD
                            OR r.create_id LIKE WORD
                            OR r.modify_id LIKE WORD
WHERE
    r.active_flag = 1
	AND r.company_code = company_code_param
    AND (
    ((ifnull(r.resource_id, '') <> '') AND r.resource_id LIKE WORD)
	OR ((ifnull(r.name_first, '') <> '') AND r.name_first LIKE WORD)
    OR ((ifnull(r.name_last, '') <> '') AND r.name_last LIKE WORD)
    OR ((ifnull(r.email, '') <> '') AND r.email LIKE WORD)
    OR ((ifnull(r.login_id, '') <> '') AND r.login_id LIKE WORD)
    OR ((ifnull(r.create_id, '') <> '') AND r.create_id LIKE WORD)
    OR ((ifnull(r.modify_id, '') <> '') AND r.modify_id LIKE WORD)
    );
    
-- ________________________________Vendors__________________________________
SELECT DISTINCT
    v.vendor_code,
    v.site_id,
    v.vendor_name,
    v.short_name,
    v.addr1,
    v.addr2,
    v.addr3,
    v.addr4,
    v.addr5,
    v.addr6,
    v.attention_name,
    v.attention_phone,
    v.contact_name,
    v.contact_phone,
    v.email,
    v.phone_1,
    v.phone_2,
    v.tax_code,
	CONCAT('%', t.word, '%') as WORD
FROM
    apad_vendors v
    INNER JOIN _tempDataSearch t ON v.vendor_code LIKE WORD
							OR v.site_id LIKE WORD
                            OR v.vendor_name LIKE WORD
                            OR v.short_name LIKE WORD
                            OR v.addr1 LIKE WORD
                            OR v.addr2 LIKE WORD
                            OR v.addr3 LIKE WORD
                            OR v.addr4 LIKE WORD
                            OR v.addr5 LIKE WORD
                            OR v.addr6 LIKE WORD
                            OR v.attention_name LIKE WORD
                            OR v.attention_phone LIKE WORD
                            OR v.contact_name LIKE WORD
                            OR v.contact_phone LIKE WORD
                            OR v.email LIKE WORD
                            OR v.phone_1 LIKE WORD
                            OR v.phone_2 LIKE WORD
                            OR v.tax_code LIKE WORD
WHERE
    v.vendor_status_id = 1
	AND v.company_code = company_code_param
    AND (
    ((ifnull(v.vendor_code, '') <> '') AND v.vendor_code LIKE WORD)
	OR ((ifnull(v.site_id, '') <> '') AND v.site_id LIKE WORD)
	OR ((ifnull(v.vendor_name, '') <> '') AND v.vendor_name LIKE WORD)
	OR ((ifnull(v.short_name, '') <> '') AND v.short_name LIKE WORD)
	OR ((ifnull(v.addr1, '') <> '') AND v.addr1 LIKE WORD)
	OR ((ifnull(v.addr2, '') <> '') AND v.addr2 LIKE WORD)
	OR ((ifnull(v.addr3, '') <> '') AND v.addr3 LIKE WORD)
	OR ((ifnull(v.addr4, '') <> '') AND v.addr4 LIKE WORD)
	OR ((ifnull(v.addr5, '') <> '') AND v.addr5 LIKE WORD)
	OR ((ifnull(v.addr6, '') <> '') AND v.addr6 LIKE WORD)
	OR ((ifnull(v.attention_name, '') <> '') AND v.attention_name LIKE WORD)
	OR ((ifnull(v.attention_phone, '') <> '') AND v.attention_phone LIKE WORD)
	OR ((ifnull(v.contact_name, '') <> '') AND v.contact_name LIKE WORD)
	OR ((ifnull(v.contact_phone, '') <> '') AND v.contact_phone LIKE WORD)
	OR ((ifnull(v.email, '') <> '') AND v.email LIKE WORD)
	OR ((ifnull(v.phone_1, '') <> '') AND v.phone_1 LIKE WORD)
	OR ((ifnull(v.phone_2, '') <> '') AND v.phone_2 LIKE WORD)
	OR ((ifnull(v.tax_code, '') <> '') AND v.tax_code LIKE WORD)
	);

DROP TEMPORARY TABLE IF EXISTS _tempDataSearch;

END$$
DELIMITER ;