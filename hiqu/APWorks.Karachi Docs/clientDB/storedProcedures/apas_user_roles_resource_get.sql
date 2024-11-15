DELIMITER $$
DROP PROCEDURE IF EXISTS apas_user_roles_resource_get;$$

CREATE PROCEDURE apas_user_roles_resource_get(
	IN resource_id_param  CHAR(16)
)
BEGIN
	SELECT
		urr.company_code,
		urr.user_role_id,
		urr.resource_id,
		urr.create_id,
		urr.create_date,
		urr.modify_id,
		urr.modify_date,
        ur.user_role_name,
		ur.is_admin_role, 
		ur.allow_routing_setup,
		ur.allow_non_mapped_invoices_request_processing,
		ur.allow_invoice_model_mapping,
		ur.allow_invoice_manual_processing,
		ur.allow_invoice_correction,
		ur.allow_invoice_level_1_approval,
		ur.allow_invoice_level_2_approval,
		ur.allow_invoice_level_3_approval,
		ur.allow_invoice_level_4_approval,
		ur.allow_invoice_level_5_approval,
        urpc.position_category_code,
        pc.position_category_name
	FROM
		apad_user_roles_resource urr
		INNER JOIN apad_user_roles ur ON ur.user_role_id = urr.user_role_id
        LEFT JOIN apad_user_role_position_categories urpc ON ur.user_role_id = urpc.user_role_id
        LEFT JOIN apam_position_category pc ON urpc.position_category_code = pc.position_category_code
	WHERE
		resource_id = resource_id_param;
END$$
DELIMITER ;

