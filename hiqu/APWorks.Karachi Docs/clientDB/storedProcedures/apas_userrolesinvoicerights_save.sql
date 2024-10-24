DELIMITER $$
DROP PROCEDURE IF EXISTS apas_userrolesinvoicerights_save;$$

CREATE PROCEDURE apas_userrolesinvoicerights_save(
	IN company_code_param									INT,
	IN user_role_id_param									INT,
	IN model_def_id_param									INT UNSIGNED,
	IN allow_non_mapped_invoices_request_processing_param	CHAR(1),
	IN allow_invoice_model_mapping_param					CHAR(1),
	IN allow_invoice_auto_routing_param						CHAR(1),
	IN allow_invoice_manual_processing_param				CHAR(1),
	IN allow_invoice_document_management_param				CHAR(1),
	IN allow_invoice_correction_param						CHAR(1),
	IN allow_invoice_level_1_approval_param					CHAR(1),
	IN allow_invoice_level_2_approval_param					CHAR(1),
	IN allow_invoice_level_3_approval_param					CHAR(1),
	IN allow_invoice_level_4_approval_param					CHAR(1),
	IN allow_invoice_level_5_approval_param					CHAR(1)
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apad_user_roles_invoice_rights WHERE company_code = company_code_param AND user_role_id = user_role_id_param AND model_def_id = model_def_id_param) THEN
		INSERT INTO apad_user_roles_invoice_rights
		(
			company_code,
			user_role_id,
			model_def_id,
			allow_non_mapped_invoices_request_processing,
			allow_invoice_model_mapping,
			allow_invoice_auto_routing,
			allow_invoice_manual_processing,
			allow_invoice_document_management,
			allow_invoice_correction,
			allow_invoice_level_1_approval,
			allow_invoice_level_2_approval,
			allow_invoice_level_3_approval,
			allow_invoice_level_4_approval,
			allow_invoice_level_5_approval
		)
		SELECT
			company_code_param,
			user_role_id_param,
			model_def_id_param,
			allow_non_mapped_invoices_request_processing_param,
			allow_invoice_model_mapping_param,
			allow_invoice_auto_routing_param,
			allow_invoice_manual_processing_param,
			allow_invoice_document_management_param,
			allow_invoice_correction_param,
			allow_invoice_level_1_approval_param,
			allow_invoice_level_2_approval_param,
			allow_invoice_level_3_approval_param,
			allow_invoice_level_4_approval_param,
			allow_invoice_level_5_approval_param;
	ELSE
		UPDATE
			apad_user_roles_invoice_rights
		SET
			allow_non_mapped_invoices_request_processing	= allow_non_mapped_invoices_request_processing_param,
			allow_invoice_model_mapping						= allow_invoice_model_mapping_param,
			allow_invoice_auto_routing					    = allow_invoice_auto_routing_param,
			allow_invoice_manual_processing					= allow_invoice_manual_processing_param,
			allow_invoice_document_management				= allow_invoice_document_management_param,
			allow_invoice_correction						= allow_invoice_correction_param,
			allow_invoice_level_1_approval					= allow_invoice_level_1_approval_param,
			allow_invoice_level_2_approval					= allow_invoice_level_2_approval_param,
			allow_invoice_level_3_approval					= allow_invoice_level_3_approval_param,
			allow_invoice_level_4_approval					= allow_invoice_level_4_approval_param,
			allow_invoice_level_5_approval					= allow_invoice_level_5_approval_param
		WHERE
			company_code = company_code_param
			AND user_role_id = user_role_id_param
			AND model_def_id = model_def_id_param;
	END IF;
END$$
DELIMITER ;

