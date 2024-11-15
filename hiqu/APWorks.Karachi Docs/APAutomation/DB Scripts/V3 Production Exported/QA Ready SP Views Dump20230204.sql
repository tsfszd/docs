-- MySQL dump 10.13  Distrib 5.6.10, for Win64 (x86_64)
--
-- Host: auroraprod.cluster-caridxswhlir.us-east-1.rds.amazonaws.com    Database: qa_apautomation_dentsux
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;*/
/*SET @@SESSION.SQL_LOG_BIN= 0;*/

--
-- GTID state at the beginning of the backup 
--

/*SET @@GLOBAL.GTID_PURGED='';*/

--
-- Dumping routines for database 'qa_apautomation_dentsux'
--
/*!50003 DROP PROCEDURE IF EXISTS `apas_allcostcodes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_allcostcodes_list`(
	IN company_code_param   INT,
	IN cost_type_param      INT
)
BEGIN
	SELECT
		cc.company_code,
		cc.cost_type,
		cc.res_type,
		cc.effective_date,
		cc.rtype_name,
		cc.rtype_description
	FROM
		apad_cost_codes cc
	WHERE
		cc.company_code = company_code_param
		AND (NULLIF(cost_type_param, 0) IS NULL OR cc.cost_type = cost_type_param)
	ORDER BY
		cc.rtype_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_alllevel2resources_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_alllevel2resources_list`(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	SELECT
		l2r.company_code,
		l2r.level2_key,
		l2r.resource_id,
		l2r.position_category_code,
		l2r.effective_date,
		r.name_first,
		r.name_last,
        pc.position_category_name
	FROM
		apad_level2_resources l2r
		INNER JOIN apad_resources r ON r.company_code = l2r.company_code
										AND r.resource_id = l2r.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = l2r.company_code
										AND pc.position_category_code = l2r.position_category_code
	WHERE
		l2r.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l2r.level2_key = level2_key_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_alllevel2_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_alllevel2_list`(
	IN company_code_param   INT
)
BEGIN
	SELECT
		l2.company_code,
		l2.level2_key,
		l2.level2_description,
		l2.level2_status_id,
		l2.open_date,
		l2.customer_code,
		l2.customer_name,
		l2.customer_po_number,
		l2.po_required_flag,
		l2.tolerance_po_flag,
		l2.tolerance_po_amount,
        l2s.level2_status_name
	FROM
		apad_level2 l2
		INNER JOIN qa_apautomation_common.apai_level2_status l2s ON l2.level2_status_id = l2s.level2_status_id
	WHERE
		l2.company_code = company_code_param
	ORDER BY
		l2.level2_description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_alllevel3_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_alllevel3_list`(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	SELECT
		l3.company_code,
		l3.level2_key,
		l3.level3_key,
		l3.level3_description,
		l3.level3_status_id,
		l3.open_date,
		l3.cost_type,
		l3.customer_po_number,
		l3.expense_flag,
		l3s.level3_status_name
	FROM
		apad_level3 l3
		INNER JOIN qa_apautomation_common.apai_level3_status l3s ON l3.level3_status_id = l3s.level3_status_id
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
	ORDER BY
		l3.level3_description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_appayment_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_appayment_list`(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	FROM
		apad_ap_payment
	WHERE
		company_code = company_code_param
	ORDER BY
		invoice_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_appayment_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_appayment_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code    INT NOT NULL,
		vendor_code     VARCHAR(12) NULL,
		check_number    VARCHAR(64) NOT NULL,
		invoice_number  VARCHAR(64) NOT NULL,
		document_date   DATETIME NOT NULL,
		payment_amount  DECIMAL(19, 2) NOT NULL
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_ap_payment p
	INNER JOIN _temp t ON t.company_code = p.company_code
						AND t.vendor_code = p.vendor_code
						AND t.check_number = p.check_number
						AND t.invoice_number = p.invoice_number
						AND t.document_date = p.document_date
	SET
		p.company_code      = t.company_code,
		p.vendor_code       = t.vendor_code,
		p.check_number      = t.check_number,
		p.invoice_number    = t.invoice_number,
		p.document_date     = t.document_date,
		p.payment_amount    = t.payment_amount;

	INSERT INTO apad_ap_payment
	(
		company_code,
		vendor_code,
		check_number,
		invoice_number,
		document_date,
		payment_amount
	)
	SELECT
		t.company_code,
		t.vendor_code,
		t.check_number,
		t.invoice_number,
		t.document_date,
		t.payment_amount
	FROM
		_temp t
		INNER JOIN apad_vendors v ON v.vendor_code = t.vendor_code
										AND v.company_code = t.company_code
		LEFT OUTER JOIN apad_ap_payment p ON p.company_code = t.company_code
											AND p.vendor_code = t.vendor_code
											AND p.check_number = t.check_number
											AND p.invoice_number = t.invoice_number
											AND p.document_date = t.document_date
	WHERE
		p.vendor_code IS NULL
	GROUP BY t.company_code,t.vendor_code, t.check_number, t.invoice_number, t.document_date;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_ap_payment', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_approvalstampconfiguration_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_approvalstampconfiguration_get`(
	IN company_code_param               INT,
	IN master_document_model_id_param   VARCHAR(12)
)
BEGIN
	DECLARE approval_stamp_configuration_id_param INT UNSIGNED;
	SET approval_stamp_configuration_id_param = (SELECT approval_stamp_configuration_id FROM apam_approval_stamp_configuration WHERE company_code = company_code_param AND master_document_model_id = master_document_model_id_param);

	SELECT
		approval_stamp_configuration_id,
		company_code,
		master_document_model_id,
		html,
		top,
		`left`,
		width,
		height,
		text_format_settings,
		create_id,
		create_date
	FROM
		apam_approval_stamp_configuration
	WHERE
		approval_stamp_configuration_id = approval_stamp_configuration_id_param
		OR (approval_stamp_configuration_id_param IS NULL AND company_code = company_code_param AND master_document_model_id IS NULL);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_approvalstampconfiguration_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_approvalstampconfiguration_save`(
	IN company_code_param               INT,
	IN master_document_model_id_param   INT UNSIGNED,
	IN html_param                       VARCHAR(1024),
	IN top_param                        INT UNSIGNED,
	IN left_param                       INT UNSIGNED,
	IN width_param                      INT UNSIGNED,
	IN height_param                     INT UNSIGNED,
	IN text_format_settings_param       VARCHAR(1024),
	IN create_id_param                  VARCHAR(32),
	IN create_date_param                DATETIME
)
BEGIN
	DECLARE approval_stamp_configuration_id_param INT UNSIGNED;
	SELECT approval_stamp_configuration_id INTO approval_stamp_configuration_id_param FROM apam_approval_stamp_configuration WHERE company_code = company_code_param AND IFNULL(master_document_model_id, '') = IFNULL(master_document_model_id_param, '');

	IF ISNULL(approval_stamp_configuration_id_param) THEN
		SELECT (MAX(approval_stamp_configuration_id) + 1) AS approval_stamp_configuration_id INTO approval_stamp_configuration_id_param FROM apam_approval_stamp_configuration;

		IF ISNULL(approval_stamp_configuration_id_param) THEN
			SET approval_stamp_configuration_id_param = 1;
		END IF;

		INSERT INTO apam_approval_stamp_configuration
		(
			approval_stamp_configuration_id,
			company_code,
			master_document_model_id,
			html,
			top,
			`left`,
			width,
			height,
			text_format_settings,
			create_id,
			create_date
		)
		SELECT
			approval_stamp_configuration_id_param,
			company_code_param,
			master_document_model_id_param,
			html_param,
			top_param,
			left_param,
			width_param,
			height_param,
			text_format_settings_param,
			create_id_param,
			create_date_param;
	ELSE
		UPDATE
			apam_approval_stamp_configuration
		SET
			html					 =  html_param,
			top						 =  top_param,
			`left`					 =  left_param,
			width					 =  width_param,
			height					 =  height_param,
			text_format_settings	 =  text_format_settings_param
		WHERE
			approval_stamp_configuration_id = approval_stamp_configuration_id_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_companyapprovalconfiguration_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_companyapprovalconfiguration_save`(
	IN company_code_param                                   INT,
	IN model_def_id_param                                   INT UNSIGNED,
	IN routing_number_of_approval_levels_param              INT,
	IN approval_level_1_short_name_param                    VARCHAR(64), 
	IN approval_level_1_name_param                          VARCHAR(64), 
	IN approval_level_1_status_name_param                   VARCHAR(64), 
	IN approval_level_1_accept_name_param                   VARCHAR(64), 
	IN approval_level_1_reject_name_param                   VARCHAR(64), 
	IN approval_level_1_allow_invoice_editing_flag_param    CHAR(1),
	IN approval_level_2_short_name_param                    VARCHAR(64), 
	IN approval_level_2_name_param                          VARCHAR(64), 
	IN approval_level_2_status_name_param                   VARCHAR(64), 
	IN approval_level_2_accept_name_param                   VARCHAR(64), 
	IN approval_level_2_reject_name_param                   VARCHAR(64), 
	IN approval_level_2_allow_invoice_editing_flag_param    CHAR(1),
	IN approval_level_3_short_name_param                    VARCHAR(64), 
	IN approval_level_3_name_param                          VARCHAR(64), 
	IN approval_level_3_status_name_param                   VARCHAR(64), 
	IN approval_level_3_accept_name_param                   VARCHAR(64), 
	IN approval_level_3_reject_name_param                   VARCHAR(64), 
	IN approval_level_3_allow_invoice_editing_flag_param    CHAR(1),
	IN approval_level_4_short_name_param                    VARCHAR(64), 
	IN approval_level_4_name_param                          VARCHAR(64), 
	IN approval_level_4_status_name_param                   VARCHAR(64), 
	IN approval_level_4_accept_name_param                   VARCHAR(64), 
	IN approval_level_4_reject_name_param                   VARCHAR(64), 
	IN approval_level_4_allow_invoice_editing_flag_param    CHAR(1),
	IN approval_level_5_short_name_param                    VARCHAR(64), 
	IN approval_level_5_name_param                          VARCHAR(64), 
	IN approval_level_5_status_name_param                   VARCHAR(64), 
	IN approval_level_5_accept_name_param                   VARCHAR(64), 
	IN approval_level_5_reject_name_param                   VARCHAR(64), 
	IN approval_level_5_allow_invoice_editing_flag_param    CHAR(1)
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apam_company_approval_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param) THEN
		INSERT INTO apam_company_approval_configuration
		(
			company_code,
			model_def_id,
			routing_number_of_approval_levels,
			approval_level_1_short_name,
			approval_level_1_name,
			approval_level_1_status_name,
			approval_level_1_accept_name,
			approval_level_1_reject_name,
			approval_level_1_allow_invoice_editing_flag,
			approval_level_2_short_name,
			approval_level_2_name,
			approval_level_2_status_name,
			approval_level_2_accept_name,
			approval_level_2_reject_name,
			approval_level_2_allow_invoice_editing_flag,
			approval_level_3_short_name,
			approval_level_3_name,
			approval_level_3_status_name,
			approval_level_3_accept_name,
			approval_level_3_reject_name,
			approval_level_3_allow_invoice_editing_flag,
			approval_level_4_short_name,
			approval_level_4_name,
			approval_level_4_status_name,
			approval_level_4_accept_name,
			approval_level_4_reject_name,
			approval_level_4_allow_invoice_editing_flag,
			approval_level_5_short_name,
			approval_level_5_name,
			approval_level_5_status_name,
			approval_level_5_accept_name,
			approval_level_5_reject_name,
			approval_level_5_allow_invoice_editing_flag
		)
		SELECT
			company_code_param,
			model_def_id_param,
			routing_number_of_approval_levels_param,
			approval_level_1_short_name_param,
			approval_level_1_name_param,
			approval_level_1_status_name_param,
			approval_level_1_accept_name_param,
			approval_level_1_reject_name_param,
			approval_level_1_allow_invoice_editing_flag_param,
			approval_level_2_short_name_param,
			approval_level_2_name_param,
			approval_level_2_status_name_param,
			approval_level_2_accept_name_param,
			approval_level_2_reject_name_param,
			approval_level_2_allow_invoice_editing_flag_param,
			approval_level_3_short_name_param,
			approval_level_3_name_param,
			approval_level_3_status_name_param,
			approval_level_3_accept_name_param,
			approval_level_3_reject_name_param,
			approval_level_3_allow_invoice_editing_flag_param,
			approval_level_4_short_name_param,
			approval_level_4_name_param,
			approval_level_4_status_name_param,
			approval_level_4_accept_name_param,
			approval_level_4_reject_name_param,
			approval_level_4_allow_invoice_editing_flag_param,
			approval_level_5_short_name_param,
			approval_level_5_name_param,
			approval_level_5_status_name_param,
			approval_level_5_accept_name_param,
			approval_level_5_reject_name_param,
			approval_level_5_allow_invoice_editing_flag_param;
	ELSE
		UPDATE
			apam_company_approval_configuration
		SET
			routing_number_of_approval_levels			 = routing_number_of_approval_levels_param,
			approval_level_1_short_name					 = approval_level_1_short_name_param,
			approval_level_1_name						 = approval_level_1_name_param,
			approval_level_1_status_name				 = approval_level_1_status_name_param,
			approval_level_1_accept_name				 = approval_level_1_accept_name_param,
			approval_level_1_reject_name				 = approval_level_1_reject_name_param,
			approval_level_1_allow_invoice_editing_flag	 = approval_level_1_allow_invoice_editing_flag_param,
			approval_level_2_short_name					 = approval_level_2_short_name_param,
			approval_level_2_name						 = approval_level_2_name_param,
			approval_level_2_status_name				 = approval_level_2_status_name_param,
			approval_level_2_accept_name				 = approval_level_2_accept_name_param,
			approval_level_2_reject_name				 = approval_level_2_reject_name_param,
			approval_level_2_allow_invoice_editing_flag	 = approval_level_2_allow_invoice_editing_flag_param,
			approval_level_3_short_name					 = approval_level_3_short_name_param,
			approval_level_3_name						 = approval_level_3_name_param,
			approval_level_3_status_name				 = approval_level_3_status_name_param,
			approval_level_3_accept_name				 = approval_level_3_accept_name_param,
			approval_level_3_reject_name				 = approval_level_3_reject_name_param,
			approval_level_3_allow_invoice_editing_flag	 = approval_level_3_allow_invoice_editing_flag_param,
			approval_level_4_short_name					 = approval_level_4_short_name_param,
			approval_level_4_name						 = approval_level_4_name_param,
			approval_level_4_status_name				 = approval_level_4_status_name_param,
			approval_level_4_accept_name				 = approval_level_4_accept_name_param,
			approval_level_4_reject_name				 = approval_level_4_reject_name_param,
			approval_level_4_allow_invoice_editing_flag	 = approval_level_4_allow_invoice_editing_flag_param,
			approval_level_5_short_name					 = approval_level_5_short_name_param,
			approval_level_5_name						 = approval_level_5_name_param,
			approval_level_5_status_name				 = approval_level_5_status_name_param,
			approval_level_5_accept_name				 = approval_level_5_accept_name_param,
			approval_level_5_reject_name				 = approval_level_5_reject_name_param,
			approval_level_5_allow_invoice_editing_flag	 = approval_level_5_allow_invoice_editing_flag_param
		WHERE
			company_code = company_code_param
			AND model_def_id = model_def_id_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_companyinvoiceconfiguration_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_companyinvoiceconfiguration_save`(
	IN company_code_param                                   INT,
	IN model_def_id_param                                   INT UNSIGNED,
	IN invoice_collection_email_flag_param                  CHAR(1), 
	IN invoice_collection_email_string_param                VARCHAR(128), 
	IN use_delivery_amount_for_matching_param               CHAR(1),
	IN auto_post_invoice_param                              CHAR(1),
	IN email_reminder_cron_expression_param                 VARCHAR(64)
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apam_company_invoice_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param) THEN
		INSERT INTO apam_company_invoice_configuration
		(
			company_code,
			model_def_id,
			invoice_collection_email_flag,
			invoice_collection_email_string,
			use_delivery_amount_for_matching,
			auto_post_invoice,
			email_reminder_cron_expression
		)
		SELECT
			company_code_param,
			model_def_id_param,
			invoice_collection_email_flag_param,
			invoice_collection_email_string_param,
			use_delivery_amount_for_matching_param,
			auto_post_invoice_param,
			email_reminder_cron_expression_param;
	ELSE
		UPDATE
			apam_company_invoice_configuration
		SET
			invoice_collection_email_flag		= invoice_collection_email_flag_param,
			invoice_collection_email_string		= invoice_collection_email_string_param,
			use_delivery_amount_for_matching    = use_delivery_amount_for_matching_param,
			auto_post_invoice					= auto_post_invoice_param,
			email_reminder_cron_expression		= email_reminder_cron_expression_param
		WHERE
			company_code = company_code_param
			AND model_def_id = model_def_id_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_add`(
	IN company_code_param                                   INT,
	IN co_short_name_param                                  VARCHAR(16),
	IN co_name_param                                        VARCHAR(64), 
	IN currency_code_param                                  CHAR(8),
	IN addr_street1_param                                   VARCHAR(64), 
	IN addr_street2_param                                   VARCHAR(64), 
	IN addr_street3_param                                   VARCHAR(64), 
	IN addr_city_param                                      VARCHAR(64), 
	IN addr_state_province_param                            VARCHAR(16), 
	IN addr_zip_postcode_param                              VARCHAR(16), 
	IN tel_area_param                                       VARCHAR(64), 
	IN tel_number_param                                     VARCHAR(64), 
	IN nexelus_s3_storage_connection_string_param           VARCHAR(512), 
	IN client_ftp_site_connection_string_param              VARCHAR(1024), 
	IN nexelus_owned_storage_flag_param                     CHAR(1),
	IN client_owned_storage_flag_param                      CHAR(1),
	IN create_id_param                                      VARCHAR(32),
	IN create_date_param                                    DATETIME,
	IN modify_id_param                                      VARCHAR(32),
	IN modify_date_param                                    DATETIME
)
BEGIN
	INSERT INTO apam_company
	(
		company_code,
		co_short_name,
		co_name,
		currency_code,
		addr_street1,
		addr_street2,
		addr_street3,
		addr_city,
		addr_state_province,
		addr_zip_postcode,
		tel_area,
		tel_number,
		nexelus_s3_storage_connection_string,
		client_ftp_site_connection_string,
		nexelus_owned_storage_flag,
		client_owned_storage_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	)
	SELECT
		company_code_param,
		co_short_name_param,
		co_name_param,
		currency_code_param,
		addr_street1_param,
		addr_street2_param,
		addr_street3_param,
		addr_city_param,
		addr_state_province_param,
		addr_zip_postcode_param,
		tel_area_param,
		tel_number_param,
		nexelus_s3_storage_connection_string_param,
		client_ftp_site_connection_string_param,
		nexelus_owned_storage_flag_param,
		client_owned_storage_flag_param,
		create_id_param,
		create_date_param,
		modify_id_param,
		modify_date_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_delete`(
	IN company_code_param INT
)
BEGIN
	DELETE FROM
		apam_company_invoice_configuration
	WHERE
		company_code = company_code_param;

	DELETE FROM
		apam_company_approval_configuration
	WHERE
		company_code = company_code_param;

	DELETE FROM
		apam_company
	WHERE
		company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_get`(
	IN company_code_param INT
)
BEGIN
	DECLARE u_one INT;
	SET u_one = 1;

	SELECT
		company_code,
		co_short_name, 
		co_name, 
		currency_code,
		addr_street1, 
		addr_street2, 
		addr_street3, 
		addr_city, 
		addr_state_province, 
		addr_zip_postcode, 
		tel_area, 
		tel_number, 
		nexelus_s3_storage_connection_string, 
		client_ftp_site_connection_string, 
		nexelus_owned_storage_flag,
		client_owned_storage_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_company
	WHERE
		company_code = company_code_param
	ORDER BY
		co_name;

	SELECT
		company_code_param AS company_code,
		md.model_def_id,
		md.master_def_name,
		IFNULL(c.routing_number_of_approval_levels, u_one) AS routing_number_of_approval_levels,
		IFNULL(c.approval_level_1_short_name, '') AS approval_level_1_short_name,
		IFNULL(c.approval_level_1_name, '') AS approval_level_1_name,
		IFNULL(c.approval_level_1_status_name, '') AS approval_level_1_status_name,
		IFNULL(c.approval_level_1_accept_name, '') AS approval_level_1_accept_name,
		IFNULL(c.approval_level_1_reject_name, '') AS approval_level_1_reject_name,
		IFNULL(c.approval_level_1_allow_invoice_editing_flag, 'N') AS approval_level_1_allow_invoice_editing_flag,
		c.approval_level_2_short_name,
		c.approval_level_2_name,
		c.approval_level_2_status_name,
		c.approval_level_2_accept_name,
		c.approval_level_2_reject_name,
		c.approval_level_2_allow_invoice_editing_flag,
		c.approval_level_3_short_name,
		c.approval_level_3_name,
		c.approval_level_3_status_name,
		c.approval_level_3_accept_name,
		c.approval_level_3_reject_name,
		c.approval_level_3_allow_invoice_editing_flag,
		c.approval_level_4_short_name,
		c.approval_level_4_name,
		c.approval_level_4_status_name,
		c.approval_level_4_accept_name,
		c.approval_level_4_reject_name,
		c.approval_level_4_allow_invoice_editing_flag,
		c.approval_level_5_short_name,
		c.approval_level_5_name,
		c.approval_level_5_status_name,
		c.approval_level_5_accept_name,
		c.approval_level_5_reject_name,
		c.approval_level_5_allow_invoice_editing_flag
	FROM
		qa_apautomation_common.apai_model_def md
		LEFT OUTER JOIN apam_company_approval_configuration c ON md.model_def_id = c.model_def_id AND c.company_code = company_code_param;

	SELECT
		company_code_param AS company_code,
		md.model_def_id,
		md.master_def_name,
		c.invoice_collection_email_string,
		IFNULL(c.invoice_collection_email_flag, 'N') AS invoice_collection_email_flag,
		IFNULL(c.use_delivery_amount_for_matching, 'N') AS use_delivery_amount_for_matching,
		IFNULL(c.auto_post_invoice, 'N') AS auto_post_invoice,
		IFNULL(c.email_reminder_cron_expression, '* * * * * * *') AS email_reminder_cron_expression,
		c.email_reminder_last_execution_date
	FROM
		qa_apautomation_common.apai_model_def md
		LEFT OUTER JOIN apam_company_invoice_configuration c ON md.model_def_id = c.model_def_id AND c.company_code = company_code_param;

	SELECT
		approval_stamp_configuration_id,
		company_code,
		master_document_model_id,
		html,
		top,
		`left`,
		width,
		height,
		text_format_settings,
		create_id,
		create_date
	FROM
		apam_approval_stamp_configuration
	WHERE
		company_code = company_code_param
		AND master_document_model_id IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_list`()
BEGIN
	SELECT
		company_code,
		co_short_name, 
		co_name, 
		currency_code,
		addr_street1, 
		addr_street2, 
		addr_street3, 
		addr_city, 
		addr_state_province, 
		addr_zip_postcode, 
		tel_area, 
		tel_number, 
		nexelus_s3_storage_connection_string, 
		client_ftp_site_connection_string, 
		nexelus_owned_storage_flag,
		client_owned_storage_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_company
	ORDER BY
		co_name;

	SELECT
		c.company_code,
		c.model_def_id,
		md.master_def_name,
		c.routing_number_of_approval_levels,
		c.approval_level_1_short_name,
		c.approval_level_1_name,
		c.approval_level_1_status_name,
		c.approval_level_1_accept_name,
		c.approval_level_1_reject_name,
		c.approval_level_1_allow_invoice_editing_flag,
		c.approval_level_2_short_name,
		c.approval_level_2_name,
		c.approval_level_2_status_name,
		c.approval_level_2_accept_name,
		c.approval_level_2_reject_name,
		c.approval_level_2_allow_invoice_editing_flag,
		c.approval_level_3_short_name,
		c.approval_level_3_name,
		c.approval_level_3_status_name,
		c.approval_level_3_accept_name,
		c.approval_level_3_reject_name,
		c.approval_level_3_allow_invoice_editing_flag,
		c.approval_level_4_short_name,
		c.approval_level_4_name,
		c.approval_level_4_status_name,
		c.approval_level_4_accept_name,
		c.approval_level_4_reject_name,
		c.approval_level_4_allow_invoice_editing_flag,
		c.approval_level_5_short_name,
		c.approval_level_5_name,
		c.approval_level_5_status_name,
		c.approval_level_5_accept_name,
		c.approval_level_5_reject_name,
		c.approval_level_5_allow_invoice_editing_flag
	FROM
		apam_company_approval_configuration c
		INNER JOIN qa_apautomation_common.apai_model_def md ON md.model_def_id = c.model_def_id;

	SELECT
		c.company_code,
		c.model_def_id,
		md.master_def_name,
		c.invoice_collection_email_string,
		c.invoice_collection_email_flag,
		c.use_delivery_amount_for_matching,
		c.auto_post_invoice,
		c.email_reminder_cron_expression,
		c.email_reminder_last_execution_date
	FROM
		apam_company_invoice_configuration c
		INNER JOIN qa_apautomation_common.apai_model_def md ON md.model_def_id = c.model_def_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_update`(
	IN company_code_param                                   INT,
	IN co_short_name_param                                  VARCHAR(16),
	IN co_name_param                                        VARCHAR(64), 
	IN currency_code_param                                  CHAR(8),
	IN addr_street1_param                                   VARCHAR(64), 
	IN addr_street2_param                                   VARCHAR(64), 
	IN addr_street3_param                                   VARCHAR(64), 
	IN addr_city_param                                      VARCHAR(64), 
	IN addr_state_province_param                            VARCHAR(16), 
	IN addr_zip_postcode_param                              VARCHAR(16), 
	IN tel_area_param                                       VARCHAR(64), 
	IN tel_number_param                                     VARCHAR(64), 
	IN nexelus_s3_storage_connection_string_param           VARCHAR(512), 
	IN client_ftp_site_connection_string_param              VARCHAR(1024), 
	IN nexelus_owned_storage_flag_param                     CHAR(1),
	IN client_owned_storage_flag_param                      CHAR(1),
	IN create_id_param                                      VARCHAR(32),
	IN create_date_param                                    DATETIME,
	IN modify_id_param                                      VARCHAR(32),
	IN modify_date_param                                    DATETIME
)
BEGIN
	UPDATE
		apam_company
	SET
		co_short_name							= co_short_name_param,
		co_name									= co_name_param,
		currency_code							= currency_code_param,
		addr_street1							= addr_street1_param,
		addr_street2							= addr_street2_param,
		addr_street3							= addr_street3_param,
		addr_city								= addr_city_param,
		addr_state_province						= addr_state_province_param,
		addr_zip_postcode						= addr_zip_postcode_param,
		tel_area								= tel_area_param,
		tel_number								= tel_number_param,
		nexelus_s3_storage_connection_string    = nexelus_s3_storage_connection_string_param,
		client_ftp_site_connection_string		= client_ftp_site_connection_string_param,
		nexelus_owned_storage_flag				= nexelus_owned_storage_flag_param,
		client_owned_storage_flag				= client_owned_storage_flag_param,
		create_id								= create_id_param,
		create_date								= create_date_param,
		modify_id								= modify_id_param,
		modify_date								= modify_date_param
	WHERE
		company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_company_updateemailreminderlastexecutiondate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_company_updateemailreminderlastexecutiondate`(

	IN company_code_param                       INT,

	IN model_def_id_param                       INT UNSIGNED,

	IN email_reminder_last_execution_date_param DATETIME,

	IN modify_id_param                          VARCHAR(32),

	IN modify_date_param                        DATETIME

)
BEGIN

	UPDATE

		apam_company_invoice_configuration

	SET

		email_reminder_last_execution_date	= email_reminder_last_execution_date_param

	WHERE

		company_code = company_code_param

		AND model_def_id = model_def_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_costcodes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_costcodes_list`(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32),
	IN level3_key_param     VARCHAR(32),
	IN po_code_param        VARCHAR(32)
)
BEGIN
	IF IFNULL(po_code_param, '') = '' THEN
		SELECT DISTINCT
			cc.company_code,
			cc.res_type,
			cc.effective_date,
			cc.rtype_name,
			cc.rtype_description
		FROM
			apad_level3 l3
			INNER JOIN apad_cost_codes cc ON l3.cost_type = cc.cost_type
										AND l3.company_code = cc.company_code
		WHERE
			l3.company_code = company_code_param
			AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
			AND (IFNULL(level3_key_param, '') = '' OR l3.level3_key = level3_key_param)
		ORDER BY
			cc.rtype_name;
	ELSE
		SELECT DISTINCT
				cc.company_code,
				cc.res_type,
				cc.effective_date,
				cc.rtype_name,
				cc.rtype_description,
				pd.net_cost,
				pd.match_to_date_net,
				pd.remaining_amount
			FROM
				apad_cost_codes cc
				INNER JOIN v_PODetail pd ON pd.po_code = po_code_param
											AND pd.level2_key = level2_key_param
											AND pd.level3_key = level3_key_param
											AND pd.cost_category = cc.res_type
											AND pd.company_code = cc.company_code
				INNER JOIN apad_level3 l3 ON l3.company_code = cc.company_code
											AND l3.cost_type = cc.cost_type
											AND l3.level2_key = pd.level2_key
											AND l3.level3_key = pd.level3_key
			WHERE
				cc.company_code = company_code_param
			ORDER BY
				cc.rtype_name;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_costcodes_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_costcodes_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		cost_type           INT,
		res_type            INT,
		effective_date      DATETIME,
		rtype_name          VARCHAR(32),
		rtype_description   VARCHAR(64)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		cost_type,
		res_type,
		effective_date,
		rtype_name,
		rtype_description
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_cost_codes cc
	INNER JOIN _temp t ON t.cost_type = cc.cost_type
						AND t.res_type = cc.res_type
						AND t.effective_date = cc.effective_date
						AND t.company_code = cc.company_code
	SET
		cc.rtype_name           = t.rtype_name,
		cc.rtype_description    = t.rtype_description;

	INSERT INTO apad_cost_codes
	(
		company_code,
		cost_type,
		res_type,
		effective_date,
		rtype_name,
		rtype_description
	)
	SELECT
		t.company_code,
		t.cost_type,
		t.res_type,
		t.effective_date,
		t.rtype_name,
		t.rtype_description
	FROM
		_temp t
		INNER JOIN apam_cost_types ct ON ct.cost_type = t.cost_type
										AND ct.company_code = t.company_code
		LEFT OUTER JOIN apad_cost_codes cc ON cc.cost_type = t.cost_type
											AND cc.res_type = t.res_type
											AND cc.effective_date = t.effective_date
											AND cc.company_code = t.company_code
	WHERE
		cc.cost_type IS NULL
		OR cc.res_type IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_cost_codes', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_costtypes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_costtypes_list`(
	IN company_code_param   INT
)
BEGIN
	SELECT
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	FROM
		apam_cost_types ct
	WHERE
		ct.company_code = company_code_param
	ORDER BY
		ct.cost_type_description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_costtypes_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_costtypes_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		cost_type               INT,
		cost_type_name          VARCHAR(16),
		cost_type_description	VARCHAR(64),
		cost_type_status        TINYINT,
		effective_date          DATETIME,
		expiration_date	        DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apam_cost_types ct
	INNER JOIN _temp t ON t.cost_type = ct.cost_type
						AND t.company_code = ct.company_code
	SET
		ct.cost_type_name           = t.cost_type_name,
		ct.cost_type_description    = t.cost_type_description,
		ct.cost_type_status         = t.cost_type_status,
		ct.effective_date           = t.effective_date,
		ct.expiration_date          = t.expiration_date;

	INSERT INTO apam_cost_types
	(
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	)
	SELECT
		t.company_code,
		t.cost_type,
		t.cost_type_name,
		t.cost_type_description,
		t.cost_type_status,
		t.effective_date,
		t.expiration_date
	FROM
		_temp t
		LEFT OUTER JOIN apam_cost_types ct ON ct.cost_type = t.cost_type
												AND ct.company_code = t.company_code
	WHERE
		ct.cost_type IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apam_cost_types', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_currenciesmap_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_currenciesmap_add`(
	IN apam_invoice_currency_code_param CHAR(64),
	IN currency_code_param              CHAR(8)
)
BEGIN
	INSERT INTO apam_currencies_map (apam_invoice_currency_code, currency_code)
	VALUES (apam_invoice_currency_code_param, currency_code_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_currenciesmap_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_currenciesmap_delete`(
	IN currency_code_param CHAR(8)
)
BEGIN
	DELETE FROM apam_currencies_map
	WHERE
		currency_code = currency_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_currenciesmap_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_currenciesmap_get`(

)
BEGIN

	SELECT

		apam_invoice_currency_code,

		currency_code

	FROM

		apam_currencies_map;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_currencies_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_currencies_list`(
)
BEGIN
	SELECT
		currency_code,
		currency_name
	FROM
		apam_currencies;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_currency_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_currency_save`(
	currencyCode        VARCHAR(8), 
	currencyName        VARCHAR(16),
	company_code_param  INT,
	update_date_param   DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_currencies WHERE currency_code = currencyCode)
	THEN
		UPDATE
			apam_currencies
		SET
			currency_name = currencyName
		WHERE
			currency_code = currencyCode; 
	ELSE
		INSERT INTO apam_currencies(currency_code, currency_name)
		VALUES (currencyCode, currencyName);
	END IF;

	CALL apas_datalastupdated_update(company_code_param, 'apam_currencies', update_date_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_dashboard_pendingapprovalorapprovedinvoice_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_dashboard_pendingapprovalorapprovedinvoice_list`(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN user_role_id_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT,
	IN ready_to_post_param      TINYINT
)
BEGIN
	DECLARE zero INT UNSIGNED;
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;

	CREATE TEMPORARY TABLE _temp
	(
		company_code                            INT NOT NULL,
		invoice_document_id                     INT UNSIGNED NOT NULL,
		invoice_document_file_location          VARCHAR(1024) DEFAULT NULL,
		invoice_document_status_id              INT UNSIGNED NOT NULL,
		invoice_document_status_attribute       CHAR(1) DEFAULT NULL,
		duplicate_invoice_flag                  CHAR(1) NOT NULL,
		master_document_model_id                INT UNSIGNED DEFAULT NULL,
		document_model_request_id               INT UNSIGNED DEFAULT NULL,
		vendor_code                             VARCHAR(12) DEFAULT NULL,
		site_id                                 VARCHAR(32) DEFAULT NULL,
		invoice_number                          VARCHAR(32) DEFAULT NULL,
		invoice_date                            DATE DEFAULT NULL,
		due_date                                DATE DEFAULT NULL,
		service_term_start_date                 DATE DEFAULT NULL,
		service_term_end_date                   DATE DEFAULT NULL,
		payment_term_code                       VARCHAR(32) DEFAULT NULL,
		currency_code                           VARCHAR(32) DEFAULT NULL,
		po_code                                 VARCHAR(32) DEFAULT NULL,
		model_def_id                            INT UNSIGNED NOT NULL,
		create_id                               VARCHAR(32) NOT NULL,
		create_date                             DATETIME NOT NULL,
		modify_id                               VARCHAR(32) DEFAULT NULL,
		modify_date                             DATETIME DEFAULT NULL,
		total_amount                            DOUBLE,
		request_to_map                          CHAR(1),
		manual_processing                       CHAR(1),
		invoice_document_scan_status_id         INT UNSIGNED,
		manual_upload_flag                      CHAR(1),
		invoice_document_posting_status_id      INT UNSIGNED,
		invoice_document_posting_error_message  VARCHAR(1024),
		vendor_name                             VARCHAR(256),
		short_name                              VARCHAR(128),
		routing_history_count                   BIGINT,
		approval_rejection_update_date          DATETIME,
		resource_id                             CHAR(16),
		name_last                               VARCHAR(32),
		name_first                              VARCHAR(32)
	);

	CREATE TEMPORARY TABLE _temp_dt_rbid (
		company_code INT,
		invoice_document_id INT
	);

	CREATE TEMPORARY TABLE _temp_dt_h (
		company_code INT,
		invoice_document_id INT,
		approval_rejection_update_date DATETIME,
		approval_rejection_user_id VARCHAR(64)
	);

	SET zero = 0;
	SET routing_number_of_approval_levels_param = (SELECT routing_number_of_approval_levels FROM apam_company_approval_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param);

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	IF resource_id_param IS NOT NULL THEN
		SELECT
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 70 ELSE 50 END ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 90 ELSE 70 END ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 110 ELSE 90 END ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 130 ELSE 110 END ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 150 ELSE 130 END ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 50 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 150 ELSE 0 END
		INTO
			@allowed_level_1_status,
			@allowed_level_2_status,
			@allowed_level_3_status,
			@allowed_level_4_status,
			@allowed_level_5_status,
			@allowed_pending_level_1_status,
			@allowed_pending_level_2_status,
			@allowed_pending_level_3_status,
			@allowed_pending_level_4_status,
			@allowed_pending_level_5_status,
			@allowed_approved_level_1_status,
			@allowed_approved_level_2_status,
			@allowed_approved_level_3_status,
			@allowed_approved_level_4_status,
			@allowed_approved_level_5_status
		FROM
			apad_user_roles_invoice_rights
		WHERE
			user_role_id = user_role_id_param
			AND model_def_id = model_def_id_param
			AND company_code = company_code_param;
	END IF;

	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	/*TL20210708 Created two temp tables _temp_dt_rbid AND _temp_dt_h to reduce the subquery in the SELECT statement down below
	This will help in troubleshooting issues.*/

	INSERT INTO _temp_dt_rbid
	SELECT DISTINCT
		0 AS company_code,
		0 AS invoice_document_id
	UNION
	SELECT DISTINCT
		rbid.company_code,
		rbid.invoice_document_id
	FROM
		v_ResourcesByInvoiceDocument rbid
		INNER JOIN apad_invoice_document id ON id.invoice_document_id = rbid.invoice_document_id
												AND id.company_code = rbid.company_code
		INNER JOIN apad_user_role_position_categories urpc ON rbid.position_category_code = rbid.position_category_code
															AND urpc.company_code = rbid.company_code
															AND (urpc.user_role_id = user_role_id_param OR IFNULL(resource_id_param, '') = '')
	WHERE
		rbid.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND rbid.resource_id = resource_id_param;
	

	INSERT INTO _temp_dt_h
	SELECT
		h.company_code,
		h.invoice_document_id,
		h.approval_rejection_update_date,
		h.approval_rejection_user_id
	FROM
		(
			SELECT
				h.company_code,
				h.invoice_document_id,
				MAX(h.sequence_id) AS sequence_id
			FROM
				apad_invoice_document_routing_history h
				INNER JOIN apad_invoice_document id ON id.invoice_document_id = h.invoice_document_id
														AND id.company_code = h.company_code
			WHERE
				id.model_def_id = model_def_id_param
			GROUP BY
				h.company_code,
				h.invoice_document_id
		) t
		INNER JOIN apad_invoice_document_routing_history h ON h.invoice_document_id = t.invoice_document_id
																AND h.company_code = t.company_code
																AND h.sequence_id = t.sequence_id;

	INSERT INTO _temp
	(
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	)
	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.document_model_request_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		id.TotalAmount,
		id.request_to_map,
		id.manual_processing,
		IFNULL(id.invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		id.manual_upload_flag,
		id.invoice_document_posting_status_id,
		id.invoice_document_posting_error_message,
		id.vendor_name,
		id.short_name,
		id.routing_history_count,
		IFNULL(dt_h.approval_rejection_update_date, id.modify_date) AS approval_rejection_update_date,
		r.resource_id,
		r.name_first,
		r.name_last
	FROM
		v_InvoiceDocument id
		INNER JOIN _temp_dt_rbid dt_rbid ON dt_rbid.invoice_document_id = id.invoice_document_id OR IFNULL(resource_id_param, '') = ''
		LEFT OUTER JOIN _temp_dt_h dt_h ON dt_h.invoice_document_id = id.invoice_document_id
								AND dt_h.company_code = id.company_code
		LEFT OUTER JOIN apad_resources r ON r.resource_id = dt_h.approval_rejection_user_id
											AND r.company_code = id.company_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.invoice_document_id = id.invoice_document_id
																				AND idrrh.resource_id = r.resource_id
																				AND idrrh.company_code = id.company_code
																				AND idrrh.suggestion_flag = 'N'
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND id.invoice_document_status_id NOT IN (60, 80, 100, 120, 140, 160)
		AND (DATE(approval_rejection_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
		AND (
				(
					ready_to_post_param = FALSE
					AND id.invoice_document_status_id >= 50
					AND id.invoice_document_status_id < max_possible_approved_status_id
					AND (IFNULL(resource_id_param, '') = '' OR id.invoice_document_status_id IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status))
				)
				OR (
					ready_to_post_param = TRUE
					AND id.invoice_document_status_id >= 70
					AND (
						id.invoice_document_status_id IN (170)
						OR id.invoice_document_status_id >= max_possible_approved_status_id
						OR id.invoice_document_status_id NOT IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status)
					)
					AND (
						@allowed_approved_level_1_status <> 0
						OR @allowed_approved_level_2_status <> 0
						OR @allowed_approved_level_3_status <> 0
						OR @allowed_approved_level_4_status <> 0
						OR @allowed_approved_level_5_status <> 0
						OR idrrh.invoice_document_id IS NOT NULL
					)
				)
			);

	SELECT
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	FROM
		_temp
	ORDER BY
		approval_rejection_update_date DESC,
		modify_date DESC,
		invoice_document_id;


	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_dashboard_pendingapprovalorapprovedinvoice_list_tl` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_dashboard_pendingapprovalorapprovedinvoice_list_tl`(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN user_role_id_param       INT,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT,
	IN ready_to_post_param      TINYINT
)
BEGIN
	DECLARE zero INT UNSIGNED;
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;

	CREATE TEMPORARY TABLE _temp
	(
		company_code                            INT NOT NULL,
		invoice_document_id                     INT UNSIGNED NOT NULL,
		invoice_document_file_location          VARCHAR(1024) DEFAULT NULL,
		invoice_document_status_id              INT UNSIGNED NOT NULL,
		invoice_document_status_attribute       CHAR(1) DEFAULT NULL,
		duplicate_invoice_flag                  CHAR(1) NOT NULL,
		master_document_model_id                INT UNSIGNED DEFAULT NULL,
		document_model_request_id               INT UNSIGNED DEFAULT NULL,
		vendor_code                             VARCHAR(12) DEFAULT NULL,
		site_id                                 VARCHAR(32) DEFAULT NULL,
		invoice_number                          VARCHAR(32) DEFAULT NULL,
		invoice_date                            DATE DEFAULT NULL,
		due_date                                DATE DEFAULT NULL,
		service_term_start_date                 DATE DEFAULT NULL,
		service_term_end_date                   DATE DEFAULT NULL,
		payment_term_code                       VARCHAR(32) DEFAULT NULL,
		currency_code                           VARCHAR(32) DEFAULT NULL,
		po_code                                 VARCHAR(32) DEFAULT NULL,
		model_def_id                            INT UNSIGNED NOT NULL,
		create_id                               VARCHAR(32) NOT NULL,
		create_date                             DATETIME NOT NULL,
		modify_id                               VARCHAR(32) DEFAULT NULL,
		modify_date                             DATETIME DEFAULT NULL,
		total_amount                            DOUBLE,
		request_to_map                          CHAR(1),
		manual_processing                       CHAR(1),
		invoice_document_scan_status_id         INT UNSIGNED,
		manual_upload_flag                      CHAR(1),
		invoice_document_posting_status_id      INT UNSIGNED,
		invoice_document_posting_error_message  VARCHAR(1024),
		vendor_name                             VARCHAR(256),
		short_name                              VARCHAR(128),
		routing_history_count                   BIGINT,
		approval_rejection_update_date          DATETIME,
		resource_id                             CHAR(16),
		name_last                               VARCHAR(32),
		name_first                              VARCHAR(32)
	);

	CREATE TEMPORARY TABLE _temp_dt_rbid (
		company_code INT,
		invoice_document_id INT
	);

	CREATE TEMPORARY TABLE _temp_dt_h (
		company_code INT,
		invoice_document_id INT,
		approval_rejection_update_date DATETIME,
		approval_rejection_user_id VARCHAR(64)
	);

	SET zero = 0;
	SET routing_number_of_approval_levels_param = (SELECT routing_number_of_approval_levels FROM apam_company_approval_configuration WHERE company_code = company_code_param AND model_def_id = model_def_id_param);

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	IF resource_id_param IS NOT NULL THEN
		SELECT
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 70 ELSE 50 END ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 90 ELSE 70 END ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 110 ELSE 90 END ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 130 ELSE 110 END ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN CASE WHEN ready_to_post_param = TRUE THEN 150 ELSE 130 END ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 50 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_1_approval = 'Y' THEN 70 ELSE 0 END,
			CASE WHEN allow_invoice_level_2_approval = 'Y' THEN 90 ELSE 0 END,
			CASE WHEN allow_invoice_level_3_approval = 'Y' THEN 110 ELSE 0 END,
			CASE WHEN allow_invoice_level_4_approval = 'Y' THEN 130 ELSE 0 END,
			CASE WHEN allow_invoice_level_5_approval = 'Y' THEN 150 ELSE 0 END
		INTO
			@allowed_level_1_status,
			@allowed_level_2_status,
			@allowed_level_3_status,
			@allowed_level_4_status,
			@allowed_level_5_status,
			@allowed_pending_level_1_status,
			@allowed_pending_level_2_status,
			@allowed_pending_level_3_status,
			@allowed_pending_level_4_status,
			@allowed_pending_level_5_status,
			@allowed_approved_level_1_status,
			@allowed_approved_level_2_status,
			@allowed_approved_level_3_status,
			@allowed_approved_level_4_status,
			@allowed_approved_level_5_status
		FROM
			apad_user_roles_invoice_rights
		WHERE
			user_role_id = user_role_id_param
			AND model_def_id = model_def_id_param
			AND company_code = company_code_param;
	END IF;

	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	/*TL20210708 Created two temp tables _temp_dt_rbid AND _temp_dt_h to reduce the subquery in the SELECT statement down below
	This will help in troubleshooting issues.*/

select 1;/*
	INSERT INTO _temp_dt_rbid
	SELECT DISTINCT
		0 AS company_code,
		0 AS invoice_document_id
	UNION
	SELECT DISTINCT
		rbid.company_code,
		rbid.invoice_document_id
	FROM
		v_ResourcesByInvoiceDocument rbid
		INNER JOIN apad_invoice_document id ON id.invoice_document_id = rbid.invoice_document_id
												AND id.company_code = rbid.company_code
		INNER JOIN apad_user_role_position_categories urpc ON rbid.position_category_code = rbid.position_category_code
															AND urpc.company_code = rbid.company_code
															AND (urpc.user_role_id = user_role_id_param OR IFNULL(resource_id_param, '') = '')
	WHERE
		rbid.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND rbid.resource_id = resource_id_param;
	

	INSERT INTO _temp_dt_h
	SELECT
		h.company_code,
		h.invoice_document_id,
		h.approval_rejection_update_date,
		h.approval_rejection_user_id
	FROM
		(
			SELECT
				h.company_code,
				h.invoice_document_id,
				MAX(h.sequence_id) AS sequence_id
			FROM
				apad_invoice_document_routing_history h
				INNER JOIN apad_invoice_document id ON id.invoice_document_id = h.invoice_document_id
														AND id.company_code = h.company_code
			WHERE
				id.model_def_id = model_def_id_param
			GROUP BY
				h.company_code,
				h.invoice_document_id
		) t
		INNER JOIN apad_invoice_document_routing_history h ON h.invoice_document_id = t.invoice_document_id
																AND h.company_code = t.company_code
																AND h.sequence_id = t.sequence_id;

	INSERT INTO _temp
	(
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	)
	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		id.master_document_model_id,
		id.document_model_request_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		id.TotalAmount,
		id.request_to_map,
		id.manual_processing,
		IFNULL(id.invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		id.manual_upload_flag,
		id.invoice_document_posting_status_id,
		id.invoice_document_posting_error_message,
		id.vendor_name,
		id.short_name,
		id.routing_history_count,
		IFNULL(dt_h.approval_rejection_update_date, id.modify_date) AS approval_rejection_update_date,
		r.resource_id,
		r.name_first,
		r.name_last
	FROM
		v_InvoiceDocument id
		INNER JOIN _temp_dt_rbid dt_rbid ON dt_rbid.invoice_document_id = id.invoice_document_id OR IFNULL(resource_id_param, '') = ''
		LEFT OUTER JOIN _temp_dt_h dt_h ON dt_h.invoice_document_id = id.invoice_document_id
								AND dt_h.company_code = id.company_code
		LEFT OUTER JOIN apad_resources r ON r.resource_id = dt_h.approval_rejection_user_id
											AND r.company_code = id.company_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.invoice_document_id = id.invoice_document_id
																				AND idrrh.resource_id = r.resource_id
																				AND idrrh.company_code = id.company_code
																				AND idrrh.suggestion_flag = 'N'
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND id.invoice_document_status_id NOT IN (60, 80, 100, 120, 140, 160)
		AND (DATE(approval_rejection_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
		AND (
				(
					ready_to_post_param = FALSE
					AND id.invoice_document_status_id >= 50
					AND id.invoice_document_status_id < max_possible_approved_status_id
					AND (IFNULL(resource_id_param, '') = '' OR id.invoice_document_status_id IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status))
				)
				OR (
					ready_to_post_param = TRUE
					AND id.invoice_document_status_id >= 70
					AND (
						id.invoice_document_status_id IN (170)
						OR id.invoice_document_status_id >= max_possible_approved_status_id
						OR id.invoice_document_status_id NOT IN (@allowed_pending_level_1_status, @allowed_pending_level_2_status, @allowed_pending_level_3_status, @allowed_pending_level_4_status, @allowed_pending_level_5_status)
					)
					AND (
						@allowed_approved_level_1_status <> 0
						OR @allowed_approved_level_2_status <> 0
						OR @allowed_approved_level_3_status <> 0
						OR @allowed_approved_level_4_status <> 0
						OR @allowed_approved_level_5_status <> 0
						OR idrrh.invoice_document_id IS NOT NULL
					)
				)
			);

	SELECT
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		approval_rejection_update_date,
		resource_id,
		name_last,
		name_first
	FROM
		_temp
	ORDER BY
		approval_rejection_update_date DESC,
		modify_date DESC,
		invoice_document_id;
*/

	DROP TEMPORARY TABLE IF EXISTS _temp;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_rbid;
	DROP TEMPORARY TABLE IF EXISTS _temp_dt_h;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_dashboard_scannedinvoice_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_dashboard_scannedinvoice_list`(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT
)
BEGIN
	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT DISTINCT
		i.scanner_monitor_record_id,
		i.company_code,
		i.invoice_document_file_location,
		i.invoice_document_scan_status_id,
		i.manual_upload_flag,
		i.invoice_document_scan_update_date,
		i.invoice_document_scan_duration,
		i.invoice_document_scan_error_message,
		i.invoice_document_scanner_process_tag_string,
		i.model_def_id,
		i.invoice_document_id,
		i.invoice_document_status_id,
		i.duplicate_invoice_flag,
		i.invoice_document_posting_status_id,
		i.invoice_document_posting_error_message,
		i.vendor_code,
		i.vendor_name,
		i.short_name,
		i.site_id,
		i.routed_to_csv,
		CASE WHEN idrrh.suggestion_flag <> 'N' THEN NULL ELSE idrrh.resource_id END AS routed_to_resource_id,
		idrrh.create_id,
		idrrh.create_date,
		idrrh.modify_id,
		idrrh.modify_date,
		idrrh.suggestion_flag,
		idrrh.comments,
		r.name_last,
		r.name_first
	FROM
	(
		SELECT
			m.scanner_monitor_record_id,
			m.company_code,
			m.invoice_document_file_location,
			m.invoice_document_scan_status_id,
			m.manual_upload_flag,
			m.invoice_document_scan_update_date,
			m.invoice_document_scan_duration,
			m.invoice_document_scan_error_message,
			m.invoice_document_scanner_process_tag_string,
			m.model_def_id,
			id.invoice_document_id,
			id.invoice_document_status_id,
			id.duplicate_invoice_flag,
			pm.invoice_document_posting_status_id,
			pm.invoice_document_posting_error_message,
			v.vendor_code,
			v.vendor_name,
			v.short_name,
			v.site_id,
			dt_idrrh.sequence_id,
			dt_idrrh.resource_id,
			dt_idrrh.routed_to_csv
		FROM
			apad_invoice_scanner_monitor m
			LEFT OUTER JOIN apam_document_model_request r ON r.scanner_monitor_record_id = m.scanner_monitor_record_id
														AND r.company_code = m.company_code
			LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location
														AND id.company_code = m.company_code
														AND id.model_def_id = m.model_def_id
			LEFT OUTER JOIN apad_invoice_posting_monitor pm ON pm.invoice_document_id = id.invoice_document_id
															AND pm.company_code = id.company_code
			LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
											AND v.site_id = id.site_id
											AND v.company_code = id.company_code
			LEFT OUTER JOIN (SELECT
								idrrh.company_code,
								idrrh.invoice_document_id,
								idrrh.sequence_id,
								idrrh.resource_id,
								GROUP_CONCAT(DISTINCT CONCAT(r.name_last, ', ', r.name_first) ORDER BY idrrh.sequence_id DESC SEPARATOR ' | ') AS routed_to_csv
							FROM
							(
								SELECT
									company_code,
									invoice_document_id,
									MAX(sequence_id) AS sequence_id
								FROM
									apad_invoice_document_resource_routing_history
								GROUP BY
									company_code,
									invoice_document_id
							) dt_h
							INNER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = dt_h.company_code
																								AND idrrh.invoice_document_id = dt_h.invoice_document_id
																								AND idrrh.sequence_id = dt_h.sequence_id
							INNER JOIN apad_resources r ON r.company_code = idrrh.company_code
															AND r.resource_id = idrrh.resource_id
															AND r.active_flag = TRUE
							GROUP BY
								idrrh.company_code,
								idrrh.invoice_document_id
							) dt_idrrh ON dt_idrrh.invoice_document_id = id.invoice_document_id
										AND dt_idrrh.company_code = m.company_code
		WHERE
			m.company_code = company_code_param
			AND m.model_def_id = model_def_id_param
			AND IFNULL(id.is_deleted, FALSE) = FALSE
			AND (r.document_model_request_id IS NULL OR (r.document_model_request_id IS NOT NULL AND id.invoice_document_status_id = 20))
			AND (id.invoice_document_status_id IN (10, 20, 30, 35, 40, 60, 80, 100, 120, 140, 160) AND m.invoice_document_scan_status_id = 10)
			AND (DATE(m.invoice_document_scan_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	) AS i
	LEFT OUTER JOIN v_ResourcesByInvoiceDocument rid ON rid.invoice_document_id = i.invoice_document_id
														AND rid.company_code = i.company_code
														AND ACTIVE_FLAG = 1
	LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = i.company_code
																AND idrrh.invoice_document_id = i.invoice_document_id
																AND idrrh.sequence_id = i.sequence_id
																AND idrrh.resource_id = i.resource_id
	LEFT OUTER JOIN apad_resources r ON r.resource_id = idrrh.resource_id
										AND r.company_code = i.company_code
										AND r.active_flag = TRUE
	LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.company_code = i.company_code
														AND dmu.invoice_document_id = i.invoice_document_id
														AND dmu.model_def_id = i.model_def_id
	WHERE
		IFNULL(resource_id_param, '') = '' OR idrrh.resource_id = resource_id_param OR rid.resource_id = resource_id_param OR dmu.resource_id = resource_id_param
	ORDER BY
		invoice_document_scan_update_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_datalastupdated_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_datalastupdated_get`(
	IN company_code_param  INT,
	IN table_name_param    VARCHAR(32)
)
BEGIN
	SELECT company_code, table_name, last_updated FROM apam_data_last_updated WHERE company_code = company_code_param AND table_name = table_name_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_datalastupdated_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_datalastupdated_update`(
	IN company_code_param   INT,
	IN table_name_param     VARCHAR(32),
	IN last_updated_param   DATETIME
)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM apam_data_last_updated WHERE company_code = company_code_param AND table_name = table_name_param) THEN
		INSERT INTO apam_data_last_updated
		(
			company_code,
			table_name,
			last_updated
		)
		VALUES
		(
			company_code_param,
			table_name_param,
			last_updated_param
		);
	ELSE
		UPDATE
			apam_data_last_updated
		SET
			last_updated = last_updated_param
		WHERE
			company_code = company_code_param
			AND table_name = table_name_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_datasearchservice_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_datasearchservice_get`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelfielddetail_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelfielddetail_add`(

	IN company_code_param                       INT,

	IN master_document_model_id_param           INT UNSIGNED,

	IN master_document_model_field_id_param     INT UNSIGNED,

	IN master_document_model_field_seq_id_param INT UNSIGNED,

	IN field_sample_value_param                 VARCHAR(128)

)
BEGIN

	INSERT INTO  apam_document_model_field_detail

	(

		company_code,

		master_document_model_id,

		master_document_model_field_id,

		master_document_model_field_seq_id,

		field_sample_value

	)

	SELECT

		company_code_param,

		master_document_model_id_param,

		master_document_model_field_id_param,

		master_document_model_field_seq_id_param,

		field_sample_value_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelfielddetail_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelfielddetail_delete`(

	IN master_document_model_id_param INT UNSIGNED

)
BEGIN

	DELETE FROM

		apam_document_model_field_detail

	WHERE

		master_document_model_id = master_document_model_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelfielddetail_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelfielddetail_update`(

	IN company_code_param                   INT,

	IN master_document_model_id_param       INT UNSIGNED,

	IN master_document_model_field_id_param INT UNSIGNED,

	IN master_document_model_field_seq_id_param INT UNSIGNED

)
BEGIN

	UPDATE

		apam_document_model_field_detail

	SET

		master_document_model_field_id     = master_document_model_field_id_param,

		master_document_model_field_seq_id = master_document_model_field_seq_id_param

	WHERE

		master_document_model_id    = master_document_model_id_param

		AND company_code            = company_code_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelfield_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelfield_add`(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN default_value_param                  VARCHAR(32)
)
BEGIN
	INSERT INTO  apam_document_model_field
	(
		company_code,
		master_document_model_id,
		master_document_model_field_id,
		default_value
	)
	SELECT
		company_code_param,
		master_document_model_id_param,
		master_document_model_field_id_param,
		default_value_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelfield_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelfield_update`(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN default_value_param                  VARCHAR(32)
)
BEGIN
	UPDATE
		apam_document_model_field
	SET
		default_value   = default_value_param
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param
		AND company_code                    = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodelrequest_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodelrequest_add`(

	OUT document_model_request_id_param INT UNSIGNED,

	IN company_code_param               INT,

	IN scanner_monitor_record_id_param  INT UNSIGNED,

	IN request_to_map_param             CHAR(1),

	IN manual_processing_param          CHAR(1),

    IN request_completed_param          CHAR(1),

	IN create_id_param                  VARCHAR(32),

	IN create_date_param                DATETIME

)
BEGIN

	SET document_model_request_id_param = (SELECT MAX(document_model_request_id) + 1 FROM apam_document_model_request);



	IF ISNULL(document_model_request_id_param) THEN

			SET document_model_request_id_param = 1;

    END IF;



	INSERT INTO apam_document_model_request

	(

		document_model_request_id,

		company_code,

		scanner_monitor_record_id,

		request_to_map,

		manual_processing,

		request_completed,

		create_id,

		create_date

	)

	SELECT

		document_model_request_id_param,

		company_code_param,

		scanner_monitor_record_id_param,

		request_to_map_param,

		manual_processing_param,

		request_completed_param,

		create_id_param,

		create_date_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodel_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodel_add`(

	IN company_code_param                            INT,

	IN master_document_model_id_param                INT UNSIGNED,

	IN document_model_name_param                     VARCHAR(64),

	IN document_model_name_tag_param                 VARCHAR(32),

	IN vendor_code_param                             VARCHAR(12),

	IN site_id_param                                 VARCHAR(32),

	IN invoice_document_sample_file_location_param   VARCHAR(1024),

	IN document_model_status_id_param                INT UNSIGNED,

	IN document_model_is_active_param                CHAR(1),

	IN document_model_comments_param                 VARCHAR(512),

	IN create_id_param                               VARCHAR(32),

	IN create_date_param                             DATETIME,

	IN modify_id_param                               VARCHAR(32),

	IN modify_date_param                             DATETIME

)
BEGIN

	INSERT INTO apam_document_model

	(

		company_code,

		master_document_model_id,

		document_model_name,

		document_model_name_tag,

		vendor_code,

		site_id,

		invoice_document_sample_file_location,

		document_model_status_id,

		document_model_is_active,

		document_model_comments,

		create_id,

		create_date,

		modify_id,

		modify_date

	)

	SELECT

		company_code_param,

		master_document_model_id_param,

		document_model_name_param,

		document_model_name_tag_param,

		vendor_code_param,

		site_id_param,

		invoice_document_sample_file_location_param,

		document_model_status_id_param,

		document_model_is_active_param,

		document_model_comments_param,

		create_id_param,

		create_date_param,

		modify_id_param,

		modify_date_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodel_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodel_get`(
	IN company_code_param               INT,
	IN master_document_model_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		company_code,
		master_document_model_id,
		document_model_name,
		document_model_name_tag,
		vendor_code,
		site_id,
		invoice_document_sample_file_location,
		document_model_status_id,
		document_model_is_active,
		document_model_comments,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_document_model
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;

	SELECT
		company_code,
		master_document_model_id,
		master_document_model_field_id,
		default_value
	FROM
		apam_document_model_field
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;

	SELECT
		approval_stamp_configuration_id,
		company_code,
		master_document_model_id,
		html,
		top,
		`left`,
		width,
		height,
		text_format_settings,
		create_id,
		create_date
	FROM
		apam_approval_stamp_configuration
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodel_setactive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodel_setactive`(
	IN company_code_param                            INT,
	IN master_document_model_id_param                INT UNSIGNED,
	IN document_model_is_active_param                CHAR(1),
	IN modify_id_param                               VARCHAR(32),
	IN modify_date_param                             DATETIME
)
BEGIN
	UPDATE
		apam_document_model
	SET
		company_code                            = company_code_param,
		master_document_model_id                = master_document_model_id_param,
		document_model_is_active                = document_model_is_active_param,
		modify_id                               = modify_id_param,
		modify_date                             = modify_date_param
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_documentmodel_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_documentmodel_update`(
	IN company_code_param                            INT,
	IN master_document_model_id_param                INT UNSIGNED,
	IN document_model_name_param                     VARCHAR(64),
	IN document_model_name_tag_param                 VARCHAR(32),
	IN vendor_code_param                             VARCHAR(12),
	IN site_id_param                                 VARCHAR(32),
	IN invoice_document_sample_file_location_param   VARCHAR(1024),
	IN document_model_status_id_param                INT UNSIGNED,
	IN document_model_is_active_param                CHAR(1),
	IN document_model_comments_param                 VARCHAR(512),
	IN create_id_param                               VARCHAR(32),
	IN create_date_param                             DATETIME,
	IN modify_id_param                               VARCHAR(32),
	IN modify_date_param                             DATETIME
)
BEGIN
	UPDATE
		apam_document_model
	SET
		document_model_name                     = document_model_name_param,
		document_model_name_tag                 = document_model_name_tag_param,
		vendor_code                             = vendor_code_param,
		site_id                                 = site_id_param,
		invoice_document_sample_file_location   = invoice_document_sample_file_location_param,
		document_model_status_id                = document_model_status_id_param,
		document_model_is_active                = document_model_is_active_param,
		document_model_comments                 = document_model_comments_param,
		modify_id                               = modify_id_param,
		modify_date                             = modify_date_param
	WHERE
		company_code = company_code_param
		AND master_document_model_id = master_document_model_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_email_log_write` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_email_log_write`(
	INOUT record_id_param   INT UNSIGNED,
	IN company_code_param   INT,
	IN recipients_param     VARCHAR(1024),
	IN subject_param        VARCHAR(256),
	IN body_param           VARCHAR(1024),
	IN date_time_sent_param DATETIME
)
BEGIN
	INSERT INTO apad_email_log
	(
		company_code,
		recipients,
		`subject`,
		body,
		date_time_sent
	)
	SELECT
		company_code_param,
		recipients_param,
		subject_param,
		body_param,
		date_time_sent_param;

	SELECT record_id_param = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentdetail_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentdetail_add`(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED,
	IN seq_id_param                 INT UNSIGNED,
	IN io_number_param              VARCHAR(64),
	IN level2_key_param             VARCHAR(32),
	IN level3_key_param             VARCHAR(32),
	IN cost_type_param              INT,
	IN res_type_param               INT,
	IN io_description_param         VARCHAR(128),
	IN quantity_param               INT,
	IN io_invoice_amount_param      DOUBLE
)
BEGIN
	IF seq_id_param = 0 THEN
		SET seq_id_param = (SELECT MAX(seq_id) + 1 FROM apad_invoice_document_detail);

		IF ISNULL(seq_id_param) THEN
			SET seq_id_param = 1;
		END IF;
	END IF;

	INSERT INTO apad_invoice_document_detail
	(
		company_code,
		invoice_document_id,
		seq_id,
		io_number,
		level2_key,
		level3_key,
		cost_type,
		res_type,
		io_description,
		quantity,
		io_invoice_amount
	)
	SELECT
		company_code_param,
		invoice_document_id_param,
		seq_id_param,
		io_number_param,
		level2_key_param,
		level3_key_param,
		cost_type_param,
		res_type_param,
		io_description_param,
		quantity_param,
		io_invoice_amount_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentdetail_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentdetail_delete`(

	IN company_code_param           INT,

	IN invoice_document_id_param    INT UNSIGNED

)
BEGIN

	DELETE FROM apad_invoice_document_detail

	WHERE

		company_code = company_code_param

		AND invoice_document_id = invoice_document_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentdetail_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentdetail_list`(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_status_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.replaced_by_invoice_document_file_location,
		id.transaction_id,
		id.model_def_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, zero) AS io_invoice_amount,
		IFNULL(ph.po_amount, zero) AS po_amount,
		IFNULL(ph.consumed_amount, zero) AS consumed_amount,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount, zero) AS remaining_amount,
		SUM(pmd.delivery_amount) AS delivery_amount,
		cc.rtype_name,
        CASE WHEN model_def_id_param = 1 THEN ph.client_code ELSE l2.customer_code END as client_code,
        CASE WHEN model_def_id_param = 1 THEN ph.client_name ELSE l2.customer_name END as client_name,
        v.vendor_name
	FROM
		apad_invoice_document id
		INNER JOIN apad_invoice_document_detail idd ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
		LEFT OUTER JOIN apad_po_header ph ON ph.company_code = id.company_code
												AND ph.vendor_code = id.vendor_code
												AND ph.site_id = id.site_id
												AND ph.active_flag = TRUE
												AND ((ph.po_code = idd.io_number AND model_def_id_param = 1) OR (ph.po_code = id.po_code AND model_def_id_param = 2))
		LEFT OUTER JOIN (
						SELECT DISTINCT
							pd.po_code,
							pd.company_code,
							pd.level2_key,
							pd.level3_key,
							pd.cost_category,
							pd.quantity,
							pd.net_cost,
							pd.match_to_date_net,
							pd.remaining_amount
						FROM
							v_PODetail pd
						) dt_pd ON dt_pd.company_code = id.company_code
									AND dt_pd.po_code = id.po_code
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.company_code = idd.company_code
												AND pmd.po_code = ph.po_code
												AND pmd.delivery_date BETWEEN id.service_term_start_date AND id.service_term_end_date
		LEFT OUTER JOIN apad_cost_codes cc ON idd.cost_type = cc.cost_type
														AND idd.res_type = cc.res_type
														AND idd.company_code = cc.company_code
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = dt_pd.level2_key
										AND dt_pd.company_code = cc.company_code
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.company_code = id.company_code
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
		AND id.is_deleted = FALSE
	GROUP BY
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_status_id,
		id.vendor_code,
		id.site_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		id.payment_term_code,
		id.currency_code,
		id.po_code,
		id.replaced_by_invoice_document_file_location,
		id.transaction_id,
		id.model_def_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, zero),
		IFNULL(ph.po_amount, zero),
		IFNULL(ph.consumed_amount, zero),
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount, zero),
		cc.rtype_name,
        client_code,
        client_name,
        v.vendor_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentdetail_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentdetail_update`(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED,
	IN seq_id_param                 INT UNSIGNED,
	IN io_number_param              VARCHAR(64),
	IN level2_key_param             VARCHAR(32),
	IN level3_key_param             VARCHAR(32),
	IN cost_type_param              INT,
	IN res_type_param               INT,
	IN io_description_param         VARCHAR(128),
	IN quantity_param               INT,
	IN io_invoice_amount_param      DOUBLE
)
BEGIN
	UPDATE apad_invoice_document_detail
	SET
		io_number           = io_number_param,
		level2_key          = level2_key_param,
		level3_key          = level3_key_param,
		cost_type           = cost_type_param,
		res_type            = res_type_param,
		io_description      = io_description_param,
		quantity            = quantity_param,
		io_invoice_amount	= io_invoice_amount_param
	WHERE
		company_code = company_code_param
		AND invoice_document_id = invoice_document_id_param
		AND seq_id = seq_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentdetail_verify` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentdetail_verify`(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN valuesCSV            VARCHAR(65535)
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		cost_type           INT,
		res_type            INT,
		rtype_name          VARCHAR(32),
		quantity            DOUBLE,
		net_cost            DOUBLE,
		match_to_date_net   DOUBLE,
		remaining_amount    DOUBLE
	);

	IF IFNULL(po_code_param, '') = '' THEN
		SET @query = CONCAT('INSERT INTO _temp
		(
			company_code,
			level2_key,
			level3_key,
			cost_type,
			res_type,
			rtype_name
		) VALUES', valuesCSV, ';');

		PREPARE stmt1 FROM @query; 
		EXECUTE stmt1; 
		DEALLOCATE PREPARE stmt1;
	ELSE
		INSERT INTO _temp
		(
			company_code,
			level2_key,
			level3_key,
			cost_type,
			res_type,
			rtype_name,
			quantity,
			net_cost,
			match_to_date_net,
			remaining_amount
		)
		SELECT
			pd.company_code,
			pd.level2_key,
			pd.level3_key,
			l3.cost_type,
			pd.cost_category,
			cc.rtype_name,
			pd.quantity,
			pd.net_cost,
			pd.match_to_date_net,
			pd.remaining_amount
		FROM
			v_PODetail pd
			LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = pd.level2_key
											AND l3.level3_key = pd.level3_key
											AND l3.company_code = pd.company_code
			LEFT OUTER JOIN apad_cost_codes cc ON cc.company_code = l3.company_code
											AND cc.cost_type = l3.cost_type
											AND cc.res_type = pd.cost_category
		WHERE
			(pd.po_code = po_code_param OR (IFNULL(po_code_param, '') = '' AND pd.po_required_flag = 'N'))
			AND pd.company_code = company_code_param;
	END IF;

	SELECT
		t.company_code,
		t.level2_key,
		t.level3_key,
		t.cost_type,
		t.res_type,
		t.rtype_name,
		t.quantity,
		t.net_cost,
		t.match_to_date_net,
		t.remaining_amount,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag,
		CASE WHEN l2.level2_key IS NULL THEN 'N' ELSE 'Y' END AS is_level2_key_valid,
		CASE WHEN l3.level3_key IS NULL THEN 'N' ELSE 'Y' END AS is_level3_key_valid,
		CASE WHEN cc.res_type IS NULL THEN 'N' ELSE 'Y' END AS is_cost_codes_valid
	FROM
		_temp t
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
										AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = l2.level2_key
										AND l3.level3_key = t.level3_key
										AND l3.company_code = t.company_code
										AND l3.level3_status_id = 1
		LEFT OUTER JOIN apad_cost_codes cc ON cc.cost_type = l3.cost_type
										AND cc.res_type = t.res_type
										AND l3.company_code = t.company_code;

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumenteditor_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumenteditor_get`(
	IN company_code_param        INT,
	IN invoice_document_id_param INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		id.company_code,
		id.invoice_document_id,
		id.invoice_document_file_location,
		id.invoice_document_status_id,
		id.invoice_document_status_attribute,
		id.duplicate_invoice_flag,
		IFNULL(id.master_document_model_id, zero) AS master_document_model_id,
		id.document_model_request_id,
		id.invoice_number,
		id.invoice_date,
		id.due_date,
		id.service_term_start_date,
		id.service_term_end_date,
		IFNULL(id.payment_term_code, '') AS payment_term_code,
		IFNULL(id.currency_code, '') AS currency_code,
		id.scanned_total,
		id.po_code,
		id.model_def_id,
		id.create_id,
		id.create_date,
		id.modify_id,
		id.modify_date,
		dm.document_model_name,
		dm.document_model_name_tag,
		mr.request_to_map,
		mr.manual_processing,
		IFNULL(sm.invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		sm.manual_upload_flag,
		v.vendor_code,
		v.vendor_name,
		v.short_name,
		v.site_id,
		no_po_flag,
		idrrh.routed_to_resource_id,
		CASE WHEN dt_ph.po_code IS NULL THEN 'N' ELSE 'Y' END AS is_po_code_valid
	FROM
		apad_invoice_document id
		LEFT OUTER JOIN apam_document_model dm ON dm.master_document_model_id = id.master_document_model_id
													AND dm.company_code = id.company_code
		LEFT OUTER JOIN apam_document_model_request mr ON mr.document_model_request_id = id.document_model_request_id
		LEFT OUTER JOIN apad_invoice_scanner_monitor sm ON sm.scanner_monitor_record_id = mr.scanner_monitor_record_id
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = id.vendor_code
										AND v.site_id = id.site_id
										AND v.company_code = id.company_code
		LEFT OUTER JOIN (SELECT
							resource_id AS routed_to_resource_id
						FROM
							apad_invoice_document_resource_routing_history
						WHERE
							company_code = company_code_param
							AND invoice_document_id = invoice_document_id_param
						ORDER BY
							sequence_id DESC
						LIMIT 1
						) AS idrrh ON 1 = 1
		LEFT OUTER JOIN (SELECT DISTINCT
							ph.po_code,
							ph.vendor_code,
							ph.site_id,
							ph.company_code
						FROM
							apad_po_header ph
							INNER JOIN apad_po_detail pd ON ph.company_code = pd.company_code
												AND ph.po_code = pd.po_code
												AND ph.model_def_id = 2
												AND ph.active_flag = TRUE
												AND pd.close_flag = FALSE
						) dt_ph ON dt_ph.company_code = id.company_code
									AND dt_ph.po_code = id.po_code
									AND dt_ph.vendor_code = id.vendor_code
									AND dt_ph.site_id = id.site_id
	WHERE
		id.company_code = company_code_param
		AND id.invoice_document_id = invoice_document_id_param
		AND id.is_deleted = FALSE;

	SELECT
		idd.company_code,
		idd.invoice_document_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		IFNULL(idd.io_invoice_amount, 0) AS io_invoice_amount,
		ph.po_code,
		IFNULL(ph.po_amount, zero) AS po_amount,
		IFNULL(ph.consumed_amount, zero) + IFNULL(SUM(idd2.io_invoice_amount), 0.00) AS consumed_amount,
		SUM(pmd.delivery_amount) AS delivery_amount,
		ph.campaign_name,
		ph.media_plan_name,
		cc.rtype_name,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		IFNULL(dt_pd.remaining_amount,0) AS remaining_amount,
		l2.level2_description,
		l2.po_required_flag,
		IFNULL(l2.tolerance_po_amount,0) AS tolerance_po_amount,
		l2.tolerance_po_flag,
		CASE WHEN ph.po_code IS NULL THEN 'N' ELSE 'Y' END AS is_io_number_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND l2.level2_key IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.level2_key IS NULL)) THEN 'N' ELSE 'Y' END AS is_level2_key_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND l3.level3_key IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.level3_key IS NULL)) THEN 'N' ELSE 'Y' END AS is_level3_key_valid,
		CASE WHEN ((IFNULL(id.po_code, '') = '' AND cc.res_type IS NULL) OR (IFNULL(id.po_code, '') <> '' AND dt_pd.cost_category IS NULL)) THEN 'N' ELSE 'Y' END AS is_cost_codes_valid
	FROM
		apad_invoice_document_detail idd
		INNER JOIN apad_invoice_document id ON idd.invoice_document_id = id.invoice_document_id
														AND idd.company_code = id.company_code
														AND id.is_deleted = FALSE
		LEFT OUTER JOIN apad_po_header ph ON ph.po_code = idd.io_number
												AND ph.vendor_code = id.vendor_code
												AND ph.site_id = id.site_id
												AND ph.company_code = idd.company_code
												AND ph.active_flag = TRUE
		LEFT OUTER JOIN apad_invoice_document id2 ON id2.company_code = ph.company_code
                                                        AND id2.vendor_code = ph.vendor_code
                                                        AND id2.is_deleted = 0
                                                        AND id2.invoice_document_id <> invoice_document_id_param
                                                        AND id2.invoice_document_status_id <> 170
			LEFT OUTER JOIN apad_invoice_document_detail idd2 ON idd2.io_number = ph.po_code
														AND idd2.company_code = id2.company_code
                                                        AND idd2.invoice_document_id = id2.invoice_document_id
		LEFT OUTER JOIN (
						SELECT DISTINCT
							pd.po_code,
							pd.company_code,
							pd.level2_key,
							pd.level3_key,
							pd.cost_category,
							pd.quantity,
							pd.net_cost,
							pd.match_to_date_net,
							pd.remaining_amount
						FROM
							v_PODetail pd
						) dt_pd ON dt_pd.po_code = id.po_code
									AND dt_pd.company_code = id.company_code
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = idd.level2_key
												AND l2.company_code = idd.company_code
												AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = idd.level2_key
												AND l3.level3_key = idd.level3_key
												AND l3.company_code = idd.company_code
												AND l3.level3_status_id = 1
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.po_code = ph.po_code
												AND pmd.company_code = idd.company_code
												AND pmd.delivery_date BETWEEN id.service_term_start_date AND id.service_term_end_date
		LEFT OUTER JOIN apad_cost_codes cc ON idd.cost_type = cc.cost_type
														AND idd.res_type = cc.res_type
														AND idd.company_code = id.company_code
	WHERE
		idd.company_code = company_code_param
		AND idd.invoice_document_id = invoice_document_id_param
	GROUP BY
		idd.company_code,
		idd.invoice_document_id,
		idd.seq_id,
		idd.io_number,
		idd.level2_key,
		idd.level3_key,
		idd.cost_type,
		idd.res_type,
		idd.io_description,
		idd.quantity,
		idd.io_invoice_amount,
		ph.po_code,
		po_amount,
		consumed_amount,
		ph.campaign_name,
		ph.media_plan_name,
		cc.rtype_name,
		dt_pd.net_cost,
		dt_pd.match_to_date_net,
		dt_pd.remaining_amount,
		l2.level2_description,
		l2.po_required_flag,
		l2.tolerance_po_amount,
		l2.tolerance_po_flag,
		is_io_number_valid,
		is_level2_key_valid,
		is_level3_key_valid,
		is_cost_codes_valid;

	SELECT
		terms_code,
		terms_desc,
		days_due
	FROM
		apam_payment_terms;

	SELECT
		currency_code,
		currency_name
	FROM
		apam_currencies;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumenteditor_getbyfilename` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumenteditor_getbyfilename`(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024)
)
BEGIN
	DECLARE invoice_document_id_param INT UNSIGNED;

	SET invoice_document_id_param = (SELECT invoice_document_id FROM apad_invoice_document WHERE invoice_document_file_location = invoice_document_file_location_param AND company_code = company_code_param);

	CALL apas_invoicedocumenteditor_get(company_code_param, invoice_document_id_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentresourcenotification_bulkupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentresourcenotification_bulkupdate`(
	valuesCSV   VARCHAR(65535)
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		invoice_document_id VARCHAR(32),
		resource_id         CHAR(16),
		notification_date   DATETIME,
		create_id           VARCHAR(32),
		create_date         DATETIME,
		modify_id           VARCHAR(32),
		modify_date         DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		invoice_document_id,
		resource_id,
		notification_date,
		create_id,
		create_date,
		modify_id,
		modify_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_invoice_document_resource_notification n
	INNER JOIN _temp t ON n.invoice_document_id = t.invoice_document_id
							AND n.resource_id = t.resource_id
							AND n.company_code = t.company_code
	SET
		n.notification_date = t.notification_date,
		n.modify_id         = t.modify_id,
		n.modify_date       = t.modify_date;

	INSERT INTO apad_invoice_document_resource_notification
	(
		company_code,
		invoice_document_id,
		resource_id,
		notification_date,
		create_id,
		create_date
	)
	SELECT
		t.company_code,
		t.invoice_document_id,
		t.resource_id,
		t.notification_date,
		t.create_id,
		t.create_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_invoice_document_resource_notification n ON n.invoice_document_id = t.invoice_document_id
																		AND n.resource_id = t.resource_id
																		AND n.company_code = t.company_code
	WHERE
		n.invoice_document_id IS NULL;

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentresourcenotification_getbynumberofdays` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentresourcenotification_getbynumberofdays`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentresourceroutinghistory_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentresourceroutinghistory_add`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentroutinghistory_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentroutinghistory_add`(

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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocumentroutinghistory_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocumentroutinghistory_list`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocuments_postinprogress` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocuments_postinprogress`(
	IN company_code_param                           INT,
	IN invoice_document_id_csv_param                VARCHAR(1000),
	IN invoice_document_posting_update_date_param   DATETIME
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS t, temp;
	CREATE TEMPORARY TABLE t (txt TEXT);
	INSERT INTO t VALUES(invoice_document_id_csv_param);

	CREATE TEMPORARY TABLE temp (invoice_document_id INT UNSIGNED);
	SET @SQL = CONCAT("insert into temp (invoice_document_id) values ('", REPLACE(( SELECT GROUP_CONCAT(DISTINCT txt) AS DATA FROM t), ",", "'),('"),"');");
	PREPARE stmt1 FROM @SQL;
	EXECUTE stmt1;

	SET @posting_monitor_record_id = (SELECT MAX(posting_monitor_record_id) + 1 FROM apad_invoice_posting_monitor);

	IF ISNULL(@posting_monitor_record_id) THEN
		SET @posting_monitor_record_id = 0;
	END IF;

	UPDATE
		apad_invoice_posting_monitor pm
		INNER JOIN temp t ON t.invoice_document_id = pm.invoice_document_id
							AND pm.company_code = company_code_param
	SET
		pm.invoice_document_posting_status_id   = 30,
		pm.invoice_document_posting_update_date = invoice_document_posting_update_date_param,
		pm.invoice_document_posting_duration = NULL,
		pm.invoice_document_posting_error_message = NULL,
		pm.invoice_document_posting_process_tag_string = NULL;

	INSERT INTO apad_invoice_posting_monitor
	(
		posting_monitor_record_id,
		company_code,
		invoice_document_id,
		invoice_document_posting_status_id,
		invoice_document_posting_update_date,
		invoice_document_posting_duration,
		invoice_document_posting_error_message,
		invoice_document_posting_process_tag_string
	)
	SELECT 
		(@posting_monitor_record_id := @posting_monitor_record_id + 1) AS posting_monitor_record_id,
		company_code_param,
		t.invoice_document_id,
		30,
		invoice_document_posting_update_date_param,
		NULL,
		NULL,
		NULL
	FROM
		temp t
		LEFT OUTER JOIN apad_invoice_posting_monitor pm ON pm.invoice_document_id = t.invoice_document_id
															AND pm.company_code = company_code_param
	WHERE
		pm.invoice_document_id IS NULL;

	DROP TEMPORARY TABLE t, temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_add`(
	IN company_code_param                      INT,
	OUT invoice_document_id_param              INT UNSIGNED,
	IN invoice_document_file_location_param    VARCHAR(1024),
	IN invoice_document_status_id_param        INT UNSIGNED,
	IN invoice_document_status_attribute_param CHAR(1),
	IN duplicate_invoice_flag_param            CHAR(1),
	IN master_document_model_id_param          INT UNSIGNED,
	IN document_model_request_id_param         INT UNSIGNED,
	IN vendor_code_param                       VARCHAR(12),
	IN site_id_param                           VARCHAR(32),
	IN invoice_number_param                    VARCHAR(32),
	IN invoice_date_param                      DATE,
	IN due_date_param                          DATE,
	IN service_term_start_date_param           DATE,
	IN service_term_end_date_param             DATE,
	IN payment_term_code_param                 VARCHAR(32),
	IN currency_code_param                     VARCHAR(32),
	IN scanned_total_param                     DOUBLE,
	IN po_code_param                           VARCHAR(32),
	IN model_def_id_param                      INT UNSIGNED,
	IN create_id_param                         VARCHAR(32),
	IN create_date_param                       DATETIME
)
BEGIN
	SET invoice_document_id_param = (SELECT invoice_document_id FROM apad_invoice_document WHERE invoice_document_file_location = invoice_document_file_location_param AND company_code = company_code_param);
    
    IF ISNULL(invoice_document_id_param) THEN
		SET invoice_document_id_param = (SELECT MAX(invoice_document_id) + 1 FROM apad_invoice_document);

		IF ISNULL(invoice_document_id_param) THEN
			SET invoice_document_id_param = 1;
		END IF;

		IF EXISTS (SELECT
					1
				FROM
					apad_invoice_document
				WHERE
					invoice_number = invoice_number_param
					AND vendor_code = vendor_code_param
					AND site_id = site_id_param
					AND company_code = company_code_param
					AND is_deleted = FALSE) THEN
			SET duplicate_invoice_flag_param = 'Y';
		END IF;
 
		INSERT INTO apad_invoice_document
		(
			company_code,
			invoice_document_id,
			invoice_document_file_location,
			invoice_document_status_id,
			invoice_document_status_attribute,
			duplicate_invoice_flag,
			master_document_model_id,
			document_model_request_id,
			vendor_code,
			site_id,
			invoice_number,
			invoice_date,
			due_date,
			service_term_start_date,
			service_term_end_date,
			payment_term_code,
			currency_code,
			scanned_total,
			po_code,
			model_def_id,
			create_id,
			create_date
		)
		SELECT
			company_code_param,
			invoice_document_id_param,
			invoice_document_file_location_param,
			CASE WHEN duplicate_invoice_flag_param = 'Y' THEN 40 ELSE invoice_document_status_id_param END,
			invoice_document_status_attribute_param,
			duplicate_invoice_flag_param,
			master_document_model_id_param,
			document_model_request_id_param,
			vendor_code_param,
			site_id_param,
			invoice_number_param,
			invoice_date_param,
			due_date_param,
			service_term_start_date_param,
			service_term_end_date_param,
			payment_term_code_param,
			currency_code_param,
			scanned_total_param,
			po_code_param,
			model_def_id_param,
			create_id_param,
			create_date_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_list`(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	DROP TEMPORARY TABLE IF EXISTS temp_invoice_document;
	DROP TEMPORARY TABLE IF EXISTS temp_client;

	CREATE TEMPORARY TABLE temp_invoice_document
	(
		company_code                            INT NOT NULL,
		invoice_document_id                     INT UNSIGNED NOT NULL,
		invoice_document_file_location          VARCHAR(1024) DEFAULT NULL,
		invoice_document_status_id              INT UNSIGNED NOT NULL,
		invoice_document_status_attribute       CHAR(1) DEFAULT NULL,
		duplicate_invoice_flag                  CHAR(1) NOT NULL,
		master_document_model_id                INT UNSIGNED DEFAULT NULL,
		document_model_request_id               INT UNSIGNED DEFAULT NULL,
		vendor_code                             VARCHAR(12) DEFAULT NULL,
		site_id                                 VARCHAR(32) DEFAULT NULL,
		invoice_number                          VARCHAR(32) DEFAULT NULL,
		invoice_date                            DATE DEFAULT NULL,
		due_date                                DATE DEFAULT NULL,
		service_term_start_date                 DATE DEFAULT NULL,
		service_term_end_date                   DATE DEFAULT NULL,
		payment_term_code                       VARCHAR(32) DEFAULT NULL,
		currency_code                           VARCHAR(32) DEFAULT NULL,
		po_code                                 VARCHAR(32) DEFAULT NULL,
		replaced_by_invoice_document_file_location VARCHAR(1024) DEFAULT NULL,
		transaction_id                          VARCHAR(32) DEFAULT NULL,
		model_def_id                            INT UNSIGNED DEFAULT 1 NOT NULL,
		create_id                               VARCHAR(32) NOT NULL,
		create_date                             DATETIME NOT NULL,
		modify_id                               VARCHAR(32) DEFAULT NULL,
		modify_date                             DATETIME DEFAULT NULL,
		total_amount                            DOUBLE,
		request_to_map                          CHAR(1),
		manual_processing                       CHAR(1),
		invoice_document_scan_status_id         INT UNSIGNED,
		manual_upload_flag                      CHAR(1),
		invoice_document_posting_status_id      INT UNSIGNED,
		invoice_document_posting_error_message  VARCHAR(1024),
		vendor_name                             VARCHAR(256),
		short_name                              VARCHAR(128),
		routing_history_count                   BIGINT,
		date_updated                            DATETIME
	);

	CREATE TEMPORARY TABLE temp_client
	(
		company_code        INT NOT NULL,
		invoice_document_id INT UNSIGNED NOT NULL,
		client_code         VARCHAR(32),
		client_name         VARCHAR(256)
	);

	INSERT INTO temp_invoice_document
	(
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		replaced_by_invoice_document_file_location,
		transaction_id,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		total_amount,
		request_to_map,
		manual_processing,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		date_updated
	)
	SELECT
		company_code,
		invoice_document_id,
		invoice_document_file_location,
		invoice_document_status_id,
		invoice_document_status_attribute,
		duplicate_invoice_flag,
		IFNULL(master_document_model_id, zero) AS master_document_model_id,
		document_model_request_id,
		vendor_code,
		site_id,
		invoice_number,
		invoice_date,
		due_date,
		service_term_start_date,
		service_term_end_date,
		payment_term_code,
		currency_code,
		po_code,
		replaced_by_invoice_document_file_location,
		transaction_id,
		model_def_id,
		create_id,
		create_date,
		modify_id,
		modify_date,
		TotalAmount,
		request_to_map,
		manual_processing,
		IFNULL(invoice_document_scan_status_id, zero) AS invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_posting_status_id,
		invoice_document_posting_error_message,
		vendor_name,
		short_name,
		routing_history_count,
		IFNULL(modify_date, create_date) AS date_updated
	FROM
		v_InvoiceDocument
	WHERE
		company_code = company_code_param
		AND model_def_id = model_def_id_param;

	INSERT INTO temp_client
	(
		company_code,
		invoice_document_id,
		client_code,
		client_name
	)
	SELECT DISTINCT
		t1.company_code,
		t1.invoice_document_id,
		t2.client_code,
		t2.client_name
	FROM
		temp_invoice_document t1
	LEFT OUTER JOIN (SELECT DISTINCT
						idd.company_code,
						idd.invoice_document_id,
						ph.po_code,
						ph.vendor_code,
						ph.site_id,
						ph.client_code,
						ph.client_name
					FROM
						apad_invoice_document_detail idd
						INNER JOIN apad_po_header ph ON ph.po_code = idd.io_number
														AND ph.company_code = idd.company_code
														AND ph.model_def_id = model_def_id_param
					) t2 ON t2.invoice_document_id = t1.invoice_document_id
							AND t2.company_code = t1.company_code
							AND t2.vendor_code = t1.vendor_code
							AND t2.site_id = t1.site_id;
	SELECT
		t.company_code,
		t.invoice_document_id,
		t.invoice_document_file_location,
		t.invoice_document_status_id,
		t.invoice_document_status_attribute,
		t.duplicate_invoice_flag,
		t.master_document_model_id,
		t.document_model_request_id,
		t.vendor_code,
		t.site_id,
		t.invoice_number,
		t.invoice_date,
		t.due_date,
		t.service_term_start_date,
		t.service_term_end_date,
		t.payment_term_code,
		t.currency_code,
		t.po_code,
		t.replaced_by_invoice_document_file_location,
		t.transaction_id,
		t.model_def_id,
		t.create_id,
		t.create_date,
		t.modify_id,
		t.modify_date,
		t.total_amount,
		t.request_to_map,
		t.manual_processing,
		t.invoice_document_scan_status_id,
		t.manual_upload_flag,
		t.invoice_document_posting_status_id,
		t.invoice_document_posting_error_message,
		t.vendor_name,
		t.short_name,
		t.routing_history_count,
		t.date_updated,
		c.client_code,
		c.client_name
	FROM
		temp_invoice_document t
		LEFT OUTER JOIN temp_client c ON t.invoice_document_id = c.invoice_document_id
										AND t.company_code = c.company_code
	ORDER BY
		t.date_updated DESC,
		t.invoice_document_id;

	DROP TEMPORARY TABLE IF EXISTS temp_invoice_document;
	DROP TEMPORARY TABLE IF EXISTS temp_client;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_setdeleted` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_setdeleted`(
	IN company_code_param                               INT,
	IN invoice_document_id_param                        INT,
	IN replaced_by_invoice_document_file_location_param VARCHAR(1024),
	IN modify_id_param                                  VARCHAR(32),
	IN modify_date_param                                DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		is_deleted                                  = TRUE,
		replaced_by_invoice_document_file_location  = CASE WHEN IFNULL(replaced_by_invoice_document_file_location_param, '') <> '' THEN replaced_by_invoice_document_file_location_param ELSE replaced_by_invoice_document_file_location END,
		modify_id                                   = modify_id_param,
		modify_date                                 = modify_date_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_update`(
	IN company_code_param                      INT,
	IN invoice_document_id_param               INT UNSIGNED,
	IN invoice_document_file_location_param    VARCHAR(1024),
	IN invoice_document_status_id_param        INT UNSIGNED,
	IN invoice_document_status_attribute_param CHAR(1),
	IN duplicate_invoice_flag_param            CHAR(1),
	IN master_document_model_id_param          INT UNSIGNED,
	IN document_model_request_id_param         INT UNSIGNED,
	IN vendor_code_param                       VARCHAR(12),
	IN site_id_param                           VARCHAR(32),
	IN invoice_number_param                    VARCHAR(32),
	IN invoice_date_param                      DATE,
	IN due_date_param                          DATE,
	IN service_term_start_date_param           DATE,
	IN service_term_end_date_param             DATE,
	IN payment_term_code_param                 VARCHAR(32),
	IN currency_code_param                     VARCHAR(32),
	IN po_code_param                           VARCHAR(32),
	IN modify_id_param                         VARCHAR(32),
	IN modify_date_param                       DATETIME
)
BEGIN
	IF EXISTS (SELECT
					1
				FROM
					apad_invoice_document
				WHERE
					invoice_number = invoice_number_param
					AND vendor_code = vendor_code_param
					AND site_id = site_id_param
					AND company_code = company_code_param
					AND is_deleted = FALSE
					AND invoice_document_id <> invoice_document_id_param) THEN
		SET duplicate_invoice_flag_param = 'Y';
	ELSE
		SET duplicate_invoice_flag_param = 'N';
	END IF;
 
	UPDATE
		apad_invoice_document
	SET
		invoice_document_status_id			= invoice_document_status_id_param,
		invoice_document_status_attribute	= invoice_document_status_attribute_param,
		invoice_document_file_location		= invoice_document_file_location_param,
		duplicate_invoice_flag				= duplicate_invoice_flag_param,
		master_document_model_id			= master_document_model_id_param,
		document_model_request_id			= document_model_request_id_param,
		vendor_code							= vendor_code_param,
		site_id								= site_id_param,
		invoice_number						= invoice_number_param,
		invoice_date						= invoice_date_param,
		due_date							= due_date_param,
		service_term_start_date				= service_term_start_date_param,
		service_term_end_date				= service_term_end_date_param,
		payment_term_code					= payment_term_code_param,
		currency_code						= currency_code_param,
		po_code                             = po_code_param,
		modify_id							= modify_id_param,
		modify_date							= modify_date_param
	WHERE
		company_code = company_code_param
		AND invoice_document_id = invoice_document_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_updatebymasterdocumentmodel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_updatebymasterdocumentmodel`(

	IN company_code_param               INT,

	IN master_document_model_id_param   INT UNSIGNED,

	IN modify_id_param                  VARCHAR(32),

	IN modify_date_param                DATETIME

)
BEGIN

	UPDATE

		apad_invoice_document id

	INNER JOIN apam_document_model dm ON dm.master_document_model_id = id.master_document_model_id

										AND dm.company_code = id.company_code

	INNER JOIN apam_document_model_request dmr ON dmr.document_model_request_id = id.document_model_request_id

												AND dmr.company_code = id.company_code

	SET

		dmr.request_completed           = 'Y',

		dmr.modify_id                   = modify_id_param,

		dmr.modify_date                 = modify_date_param,

		id.invoice_document_status_id   = 50,

		id.vendor_code                  = dm.vendor_code,

		id.site_id                      = dm.site_id,

		id.modify_id                    = modify_id_param,

		id.modify_date                  = modify_date_param

	WHERE

		id.company_code = company_code_param

		AND id.master_document_model_id = master_document_model_id_param

		AND invoice_document_status_id IN (30, 35);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_updatestatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_updatestatus`(
	IN company_code_param                           INT,
	IN invoice_document_id_param                    INT,
	IN invoice_document_status_id_param             INT UNSIGNED,
	IN transaction_id_param							VARCHAR(32),
	IN invoice_document_posting_error_message_param	VARCHAR(1024),
	IN modify_id_param                              VARCHAR(32),
	IN modify_date_param                            DATETIME
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		invoice_document_status_id = invoice_document_status_id_param,
		transaction_id 			   = transaction_id_param,
		modify_id                  = modify_id_param,
		modify_date                = modify_date_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;

	UPDATE
		apad_invoice_posting_monitor
	SET
		invoice_document_posting_status_id      =
												CASE
													WHEN invoice_document_status_id_param = 170 THEN 10
													WHEN invoice_document_status_id_param = 180 THEN 20
													ELSE invoice_document_posting_status_id
												END,
		invoice_document_posting_update_date    = modify_date_param,
		invoice_document_posting_error_message  = invoice_document_posting_error_message_param
	WHERE
		invoice_document_id = invoice_document_id_param
		AND company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicedocument_verifyduplication` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicedocument_verifyduplication`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicemodel_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicemodel_list`(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	DECLARE zero INT UNSIGNED;
	SET zero = 0;

	SELECT
		dm.company_code,
		zero AS document_model_request_id,
		dm.invoice_document_sample_file_location AS invoice_document_file_location,
		'N' AS manual_upload_flag,
		mdm.master_document_model_id,
		mdm.model_def_id,
		dm.document_model_name,
		dm.document_model_name_tag,
		dm.document_model_status_id,
		mdm.is_active,
		dm.document_model_is_active,
		dm.invoice_document_sample_file_location,
		zero AS invoice_document_id,
		v.vendor_code,
		v.vendor_name,
		v.short_name,
		v.site_id
	FROM
		qa_apautomation_common.apam_master_document_model mdm
		INNER JOIN apam_document_model dm ON dm.master_document_model_id = mdm.master_document_model_id
													AND dm.company_code = company_code_param
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = dm.vendor_code
										AND v.site_id = dm.site_id
										AND v.company_code = dm.company_code
	WHERE
		mdm.model_def_id = model_def_id_param
	UNION
	SELECT
		dmr.company_code,
		dmr.document_model_request_id,
		id.invoice_document_file_location,
		sm.manual_upload_flag,
		IFNULL(mdm.master_document_model_id, zero) AS master_document_model_id,
		model_def_id_param AS model_def_id,
		dm.document_model_name,
		dm.document_model_name_tag,
		IFNULL(dm.document_model_status_id, zero) AS document_model_status_id,
		IFNULL(mdm.is_active, 'N') AS is_active,
		'N' AS document_model_is_active,
		id.invoice_document_file_location AS invoice_document_sample_file_location,
		id.invoice_document_id,
		NULL AS vendor_code,
		NULL AS vendor_name,
		NULL AS short_name,
		NULL AS site_id
	FROM
		apam_document_model_request dmr
		INNER JOIN apad_invoice_scanner_monitor sm ON sm.scanner_monitor_record_id = dmr.scanner_monitor_record_id
														AND sm.company_code = dmr.company_code
														AND sm.model_def_id = model_def_id_param
		INNER JOIN apad_invoice_document id ON id.document_model_request_id = dmr.document_model_request_id
													AND id.company_code = dmr.company_code
													AND id.model_def_id = model_def_id_param
		LEFT OUTER JOIN qa_apautomation_common.apam_master_document_model mdm ON mdm.master_document_model_id = id.master_document_model_id
																				AND id.model_def_id = model_def_id_param
		LEFT OUTER JOIN apam_document_model dm ON dm.master_document_model_id = mdm.master_document_model_id
	WHERE
		dmr.company_code = company_code_param
		AND dmr.request_to_map = 'Y'
		AND dmr.request_completed = 'N'
		AND dm.master_document_model_id IS NULL
	ORDER BY
		invoice_document_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicemodel_setdocumentmodelrequestcompleted` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicemodel_setdocumentmodelrequestcompleted`(

	IN company_code_param               INT,

	IN document_model_request_id_param  INT UNSIGNED,

	IN modify_id_param                  INT,

	IN modify_date_param                DATETIME

)
BEGIN

	UPDATE

		apam_document_model_request

	SET

		request_completed   = 'Y',

		modify_id           = modify_id_param,

		modify_date         = modify_date_param

	WHERE

		company_code = company_code_param

		AND document_model_request_id = document_model_request_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicemodel_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicemodel_update`(
	IN company_code_param                   INT,
	IN master_document_model_id_param       INT,
	IN document_model_name_param            VARCHAR(64),
	IN document_model_name_tag_param        VARCHAR(32),
	IN vendor_code_param                    VARCHAR(12),
	IN site_id_param                        VARCHAR(32),
	IN invoice_document_file_location_param VARCHAR(1024),
	IN document_model_status_id_param       INT,
	IN is_active_param                      CHAR(1)
)
BEGIN
	UPDATE
		apam_document_model
	SET
		document_model_name                   = document_model_name_param,
		document_model_name_tag               = document_model_name_tag_param,
		vendor_code                           = vendor_code_param,
		site_id                               = site_id_param,
		invoice_document_sample_file_location = invoice_document_file_location_param,
		document_model_status_id              = document_model_status_id_param,
		modify_id                             = 'system',
		modify_date                           = current_date()
	WHERE
		master_document_model_id = master_document_model_id_param
		AND company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_invoicescannermonitor_getbyfilename` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_invoicescannermonitor_getbyfilename`(
	IN company_code_param                   INT,
    IN invoice_document_file_location_param	VARCHAR(1024)
)
BEGIN
	SELECT
		scanner_monitor_record_id,
		company_code,
		invoice_document_file_location,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_scan_update_date,
		invoice_document_scan_duration,
		invoice_document_scan_error_message,
		invoice_document_scanner_process_tag_string,
		model_def_id
	FROM
		apad_invoice_scanner_monitor
	WHERE
		company_code = company_code_param
		AND invoice_document_file_location LIKE(CONCAT(invoice_document_file_location_param, '%'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level2resources_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level2resources_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		level2_key              VARCHAR(32),
		resource_id             CHAR(16),
		position_category_code  INT,
		effective_date          DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		resource_id,
		position_category_code,
		effective_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	INSERT INTO apad_level2_resources
	(
		company_code,
		level2_key,
		resource_id,
		position_category_code,
		effective_date
	)
	SELECT DISTINCT
		t.company_code,
		t.level2_key,
		t.resource_id,
		t.position_category_code,
		t.effective_date
	FROM
		_temp t
		INNER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
		INNER JOIN apad_resources r ON r.resource_id = t.resource_id
										AND r.company_code = t.company_code
		INNER JOIN apam_position_category pc ON pc.position_category_code = t.position_category_code
										AND pc.company_code = t.company_code
		LEFT OUTER JOIN apad_level2_resources l2r ON l2r.level2_key = t.level2_key
											AND l2r.resource_id = t.resource_id
											AND l2r.position_category_code = t.position_category_code
											AND l2r.effective_date = t.effective_date
											AND l2r.company_code = t.company_code
	WHERE
		l2r.level2_key IS NULL
		OR l2r.resource_id IS NULL
		OR l2r.position_category_code IS NULL
		OR l2r.effective_date IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level2_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level2resource_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level2resource_list`(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	SELECT DISTINCT
		l2.company_code,
		l2.level2_key,
		l2.level2_description,
		l2.level2_status_id,
		l2.open_date,
		l2.customer_code,
		l2.customer_name,
		l2.customer_po_number,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.title,
		r.email,
		r.login_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_level2 l2
		INNER JOIN apad_level2_resources l2r ON l2r.company_code = l2.company_code
												AND l2r.level2_key = l2.level2_key
		INNER JOIN apad_resources r ON r.company_code = l2.company_code
										AND r.resource_id = l2r.resource_id
										AND r.active_flag = TRUE
		INNER JOIN apam_position_category pc ON pc.company_code = l2.company_code
												AND pc.position_category_code = l2r.position_category_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history rrh ON rrh.company_code = l2.company_code
																				AND rrh.invoice_document_id = IFNULL(invoice_document_id_param, 0)
																				AND rrh.resource_id = r.resource_id
																				AND rrh.suggestion_flag <> 'N'
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND (IFNULL(invoice_document_id_param, 0) = 0 OR (IFNULL(invoice_document_id_param, 0) <> 0 AND rrh.resource_id IS NOT NULL))
	ORDER BY
		r.resource_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level2_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level2_list`(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN no_po_flag_param     CHAR(1)
)
BEGIN
	SELECT DISTINCT
		l2.company_code,
		l2.level2_key,
		l2.level2_description,
		l2.level2_status_id,
		l2.open_date,
		l2.customer_code,
		l2.customer_name,
		l2.customer_po_number,
		l2.po_required_flag,
		l2.tolerance_po_flag,
		l2.tolerance_po_amount
	FROM
		apad_level2 l2
		LEFT OUTER JOIN v_PODetail pd ON pd.level2_key = l2.level2_key
											AND pd.company_code = l2.company_code
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND ((IFNULL(po_code_param, '') = '' AND (IFNULL(no_po_flag_param, 'N') = 'Y' OR IFNULL(l2.po_required_flag, 'N') = 'N')) OR pd.po_code = po_code_param)
	ORDER BY
		l2.level2_description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level2_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level2_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		level2_key          VARCHAR(32),
		level2_description  VARCHAR(128),
		level2_status_id    INT UNSIGNED,
		open_date           DATETIME,
		customer_code       VARCHAR(16),
		customer_name       VARCHAR(64),
		customer_po_number  VARCHAR(16),
		po_required_flag    CHAR(1),
		tolerance_po_flag   CHAR(1),
		tolerance_po_amount DECIMAL(6, 2)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		level2_description,
		level2_status_id,
		open_date,
		customer_code,
		customer_name,
		customer_po_number,
		po_required_flag,
		tolerance_po_flag,
		tolerance_po_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_level2 l
	INNER JOIN _temp t ON t.level2_key = l.level2_key
						AND t.company_code = l.company_code
	SET
		l.level2_description    = t.level2_description,
		l.level2_status_id      = t.level2_status_id,
		l.open_date             = t.open_date,
		l.customer_code         = t.customer_code,
		l.customer_name         = t.customer_name,
		l.customer_po_number    = t.customer_po_number,
		l.po_required_flag      = t.po_required_flag,
		l.tolerance_po_flag     = t.tolerance_po_flag,
		l.tolerance_po_amount   = t.tolerance_po_amount;

	INSERT INTO apad_level2
	(
		company_code,
		level2_key,
		level2_description,
		level2_status_id,
		open_date,
		customer_code,
		customer_name,
		customer_po_number,
		po_required_flag,
		tolerance_po_flag,
		tolerance_po_amount
	)
	SELECT
		t.company_code,
		t.level2_key,
		t.level2_description,
		t.level2_status_id,
		t.open_date,
		t.customer_code,
		t.customer_name,
		t.customer_po_number,
		t.po_required_flag,
		t.tolerance_po_flag,
		t.tolerance_po_amount
	FROM
		_temp t
		LEFT OUTER JOIN apad_level2 l ON l.level2_key = t.level2_key
										AND l.company_code = t.company_code
	WHERE
		l.level2_key IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level2', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level3withcostcodes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level3withcostcodes_list`(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32)
)
BEGIN
	CALL apas_level3_list(company_code_param, level2_key_param, '');

	SELECT DISTINCT
		cc.company_code,
		cc.cost_type,
		cc.res_type,
		cc.effective_date,
		cc.rtype_name,
		cc.rtype_description
	FROM
		apad_cost_codes cc
		INNER JOIN apad_level3 l3 ON cc.cost_type = l3.cost_type
										AND cc.company_code = l3.company_code
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
		AND l3.level3_status_id = 1
		AND l3.expense_flag = TRUE
	ORDER BY
		cc.rtype_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level3_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level3_list`(
	IN company_code_param   INT,
	IN level2_key_param     VARCHAR(32),
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT DISTINCT
		l3.company_code,
		l3.level2_key,
		l3.level3_key,
		l3.level3_description,
		l3.level3_status_id,
		l3.open_date,
		l3.cost_type,
		l3.customer_po_number,
		l3.expense_flag,
		l2.po_required_flag,
		l2.tolerance_po_flag,
		l2.tolerance_po_amount
	FROM
		apad_level3 l3
		INNER JOIN apad_level2 l2 ON l2.level2_key = l3.level2_key
										AND l2.company_code = l3.company_code
										AND l2.level2_status_id = 1
		LEFT OUTER JOIN apad_po_detail pd ON pd.level2_key = l3.level2_key
											AND pd.level3_key = l3.level3_key
											AND pd.company_code = l3.company_code
	WHERE
		l3.company_code = company_code_param
		AND (IFNULL(level2_key_param, '') = '' OR l3.level2_key = level2_key_param)
		AND l3.level3_status_id = 1
		AND l3.expense_flag = TRUE
		AND (IFNULL(po_code_param, '') = '' OR pd.po_code = po_code_param)
	ORDER BY
		l3.level3_description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_level3_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_level3_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		level3_description  VARCHAR(128),
		level3_status_id    INT UNSIGNED,
		open_date           DATETIME,
		cost_type           INT,
		customer_po_number  VARCHAR(16),
		expense_flag        TINYINT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		level2_key,
		level3_key,
		level3_description,
		level3_status_id,
		open_date,
		cost_type,
		customer_po_number,
		expense_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_level3 l
	INNER JOIN _temp t ON t.level2_key = l.level2_key
						AND t.level3_key = l.level3_key
						AND t.company_code = l.company_code
	SET
		l.level3_description    = t.level3_description,
		l.level3_status_id      = t.level3_status_id,
		l.open_date             = t.open_date,
		l.cost_type             = t.cost_type,
		l.customer_po_number    = t.customer_po_number,
		l.expense_flag          = t.expense_flag;

	INSERT INTO apad_level3
	(
		company_code,
		level2_key,
		level3_key,
		level3_description,
		level3_status_id,
		open_date,
		cost_type,
		customer_po_number,
		expense_flag
	)
	SELECT
		t.company_code,
		t.level2_key,
		t.level3_key,
		t.level3_description,
		t.level3_status_id,
		t.open_date,
		t.cost_type,
		t.customer_po_number,
		t.expense_flag
	FROM
		_temp t
		INNER JOIN apad_level2 l2 ON l2.level2_key = t.level2_key
										AND l2.company_code = t.company_code
		LEFT OUTER JOIN apad_level3 l3 ON l3.level2_key = t.level2_key
										AND l3.level3_key = t.level3_key
										AND l3.company_code = t.company_code
	WHERE
		l3.level2_key IS NULL
		OR l3.level3_key IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_level3', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_masterdocumentmodelfielddetail_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_masterdocumentmodelfielddetail_list`(
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		d.master_document_model_id,
		d.master_document_model_field_id,
		d.master_document_model_field_seq_id,
		d.model_def_field_source_id,
		d.model_def_field_alignment_type_id,
        d.block_id,
		d.field_format,
		d.classifier_text,
		d.page_number,
		d.table_number,
		d.table_row_index,
		d.table_col_index,
		d.boundingbox_left,
		d.boundingbox_top,
		d.boundingbox_width,
		d.boundingbox_height,
		d.confidence_level,
		d.internal_comment,
        f.model_def_field_id
	FROM
		apam_master_document_model_field_detail d
        INNER JOIN apam_master_document_model_field f ON f.master_document_model_id = d.master_document_model_id
													AND d.master_document_model_field_id = f.master_document_model_field_id
	WHERE
		f.model_def_id = model_def_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_manuallyuploadedinvoice_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_manuallyuploadedinvoice_add`(
	OUT document_manual_upload_record_id_param          INT UNSIGNED,
	IN company_code_param                               INT,
	IN resource_id_param                                CHAR(16),
	IN document_manual_upload_file_location_param       VARCHAR(1024),
	IN document_manual_upload_file_update_date_param    DATETIME,
	IN scanned_flag_param                               CHAR(1),
	IN scanner_monitor_record_id_param                  INT UNSIGNED,
	IN document_model_request_id_param                  INT UNSIGNED,
	IN invoice_document_id_param                        INT UNSIGNED,
	IN model_def_id_param                               INT UNSIGNED
)
BEGIN
	SET document_manual_upload_record_id_param = (SELECT MAX(document_manual_upload_record_id) + 1 FROM apad_document_manual_upload);

	IF ISNULL(document_manual_upload_record_id_param) THEN
			SET document_manual_upload_record_id_param = 1;
	END IF;

	INSERT INTO apad_document_manual_upload
	(
		document_manual_upload_record_id,
		company_code,
		resource_id,
		document_manual_upload_file_location,
		document_manual_upload_file_update_date,
		scanned_flag,
		scanner_monitor_record_id,
		document_model_request_id,
		invoice_document_id,
		model_def_id
	)
	SELECT
		document_manual_upload_record_id_param,
		company_code_param,
		resource_id_param,
		document_manual_upload_file_location_param,
		document_manual_upload_file_update_date_param,
		scanned_flag_param,
		scanner_monitor_record_id_param,
		document_model_request_id_param,
		invoice_document_id_param,
		model_def_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_manuallyuploadedinvoice_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_manuallyuploadedinvoice_delete`(

	IN company_code_param                       INT,

	IN document_manual_upload_record_id_param   INT UNSIGNED

)
BEGIN

	DELETE FROM

		apad_document_manual_upload

	WHERE

		company_code = company_code_param

		AND document_manual_upload_record_id = document_manual_upload_record_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_manuallyuploadedinvoice_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_manuallyuploadedinvoice_get`(
	IN company_code_param                       INT,
	IN document_manual_upload_record_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		dmu.document_manual_upload_record_id,
		dmu.company_code,
		dmu.resource_id,
		dmu.document_manual_upload_file_location,
		dmu.document_manual_upload_file_update_date,
		dmu.scanned_flag,
		dmu.scanner_monitor_record_id,
		dmu.document_model_request_id,
		dmu.model_def_id,
		ism.invoice_document_scan_status_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		dmr.request_to_map,
		dmr.manual_processing,
		dmr.request_completed
	FROM
		apad_document_manual_upload dmu
		LEFT OUTER JOIN apad_invoice_scanner_monitor ism ON ism.scanner_monitor_record_id = dmu.scanner_monitor_record_id
															AND ism.company_code = dmu.company_code
															AND ism.model_def_id = dmu.model_def_id
		LEFT OUTER JOIN apam_document_model_request dmr ON dmr.scanner_monitor_record_id = ism.scanner_monitor_record_id
															AND dmr.company_code = dmu.company_code
		LEFT OUTER JOIN apad_invoice_document id ON (id.invoice_document_id = dmu.invoice_document_id OR id.invoice_document_file_location = ism.invoice_document_file_location)
															AND id.company_code = dmu.company_code
															AND id.model_def_id = dmu.model_def_id
	WHERE
		dmu.company_code = company_code_param
		AND IFNULL(id.is_deleted, FALSE) = FALSE
		AND document_manual_upload_record_id = document_manual_upload_record_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_manuallyuploadedinvoice_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_manuallyuploadedinvoice_list`(
	IN company_code_param       INT,
	IN model_def_id_param       INT UNSIGNED,
	IN resource_id_param        CHAR(16),
	IN weeks_to_filter_param    INT
)
BEGIN
	SET @filter_date = DATE_SUB(UTC_DATE(), INTERVAL (weeks_to_filter_param * 7) DAY);

	SELECT
		dmu.document_manual_upload_record_id,
		dmu.company_code,
		dmu.resource_id,
		dmu.document_manual_upload_file_location,
		dmu.document_manual_upload_file_update_date,
		dmu.scanned_flag,
		dmu.scanner_monitor_record_id,
		dmu.document_model_request_id,
		dmu.model_def_id,
		ism.invoice_document_scan_status_id,
		id.invoice_document_id,
		id.invoice_document_status_id,
		dmr.request_to_map,
		dmr.manual_processing,
		dmr.request_completed
	FROM
		apad_document_manual_upload dmu
		LEFT OUTER JOIN apad_invoice_scanner_monitor ism ON ism.scanner_monitor_record_id = dmu.scanner_monitor_record_id
															AND ism.company_code = dmu.company_code
															AND ism.model_def_id = dmu.model_def_id
		LEFT OUTER JOIN apam_document_model_request dmr ON dmr.scanner_monitor_record_id = ism.scanner_monitor_record_id
															AND dmr.company_code = dmu.company_code
		LEFT OUTER JOIN apad_invoice_document id ON (id.invoice_document_id = dmu.invoice_document_id OR id.invoice_document_file_location = ism.invoice_document_file_location)
															AND id.company_code = dmu.company_code
															AND id.model_def_id = dmu.model_def_id
	WHERE
		dmu.company_code = company_code_param
		AND dmu.model_def_id = model_def_id_param
		AND IFNULL(id.is_deleted, FALSE) = FALSE
		AND (id.invoice_document_id IS NULL OR id.invoice_document_status_id <> 170)
		AND (IFNULL(resource_id_param, '') = '' OR (dmu.resource_id = resource_id_param))
		AND (DATE(dmu.document_manual_upload_file_update_date) > @filter_date OR IFNULL(weeks_to_filter_param, 0) = 0)
	ORDER BY
		dmu.document_manual_upload_file_update_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_manuallyuploadedinvoice_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_manuallyuploadedinvoice_update`(
	IN document_manual_upload_record_id_param           INT UNSIGNED, 
	IN company_code_param                               INT,
	IN resource_id_param                                CHAR(16),
	IN document_manual_upload_file_location_param       VARCHAR(1024),
	IN document_manual_upload_file_update_date_param    DATETIME,
	IN scanned_flag_param                               CHAR(1),
	IN scanner_monitor_record_id_param                  INT UNSIGNED,
	IN document_model_request_id_param                  INT UNSIGNED,
	IN invoice_document_id_param                        INT UNSIGNED,
	IN model_def_id_param                               INT UNSIGNED
)
BEGIN
	SET scanner_monitor_record_id_param = (SELECT MAX(scanner_monitor_record_id) + 1 FROM apad_invoice_scanner_monitor);

	IF ISNULL(scanner_monitor_record_id_param) THEN
			SET scanner_monitor_record_id_param = 1;
	END IF;

	INSERT INTO apad_invoice_scanner_monitor
	(
		scanner_monitor_record_id,
		company_code,
		invoice_document_file_location,
		invoice_document_scan_status_id,
		manual_upload_flag,
		invoice_document_scan_update_date,
		invoice_document_scan_duration,
		invoice_document_scan_error_message,
		invoice_document_scanner_process_tag_string,
		model_def_id
	)
	SELECT
		scanner_monitor_record_id_param,
		company_code_param,
		document_manual_upload_file_location_param,
		30,
		'Y',
		document_manual_upload_file_update_date_param,
		NULL,
		NULL,
		NULL,
		model_def_id_param;

	UPDATE
		apad_document_manual_upload
	SET
		scanner_monitor_record_id               = scanner_monitor_record_id_param
	WHERE
		company_code = company_code_param
		AND document_manual_upload_record_id = document_manual_upload_record_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_delete`(

	IN company_code_param               INT,

	IN scanner_monitor_record_id_param  INT UNSIGNED

)
BEGIN

	DELETE FROM

		apad_document_manual_upload

	WHERE

		company_code = company_code_param

		AND scanner_monitor_record_id = scanner_monitor_record_id_param;



	DELETE FROM

		apad_invoice_scanner_monitor

	WHERE

		company_code = company_code_param

		AND scanner_monitor_record_id = scanner_monitor_record_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_get`(

	IN company_code_param               INT,

	IN model_def_id_param               INT UNSIGNED,

	IN scanner_monitor_record_id_param  INT UNSIGNED

)
BEGIN

	SELECT

		scanner_monitor_record_id,

		company_code,

		invoice_document_file_location,

		invoice_document_scan_status_id,

		manual_upload_flag,

		invoice_document_scan_update_date,

		invoice_document_scan_duration,

		invoice_document_scan_error_message,

		invoice_document_scanner_process_tag_string,

		model_def_id

	FROM

		apad_invoice_scanner_monitor

	WHERE

		company_code = company_code_param

		AND model_def_id =  model_def_id_param

		AND scanner_monitor_record_id = scanner_monitor_record_id_param

	ORDER BY

		company_code;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_list`(

	IN company_code_param                       INT,

	IN resource_id_param                        CHAR(16),

	IN model_def_id_param                       INT UNSIGNED,

	IN invoice_document_scan_status_id_param    INT UNSIGNED

)
BEGIN

	SELECT

		m.scanner_monitor_record_id,

		m.company_code,

		m.invoice_document_file_location,

		m.invoice_document_scan_status_id,

		m.manual_upload_flag,

		m.invoice_document_scan_update_date,

		m.invoice_document_scan_duration,

		m.invoice_document_scan_error_message,

		m.invoice_document_scanner_process_tag_string,

		m.model_def_id

	FROM

		apad_invoice_scanner_monitor m

		LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.scanner_monitor_record_id = m.scanner_monitor_record_id

															AND dmu.company_code = m.company_code

		LEFT OUTER JOIN apam_document_model_request r ON m.scanner_monitor_record_id = r.scanner_monitor_record_id

		LEFT OUTER JOIN apad_invoice_document id ON id.invoice_document_file_location = m.invoice_document_file_location

													AND id.company_code = m.company_code

													AND id.model_def_id =  model_def_id_param

	WHERE

		m.company_code = company_code_param

		AND m.model_def_id =  model_def_id_param

		AND IFNULL(id.is_deleted, FALSE) = FALSE

		AND r.document_model_request_id IS NULL

		AND (IFNULL(resource_id_param, '') = '' OR (dmu.resource_id = resource_id_param))

		AND ((id.invoice_document_status_id IN (10, 35, 40) AND m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 10) OR (m.invoice_document_scan_status_id = invoice_document_scan_status_id_param AND invoice_document_scan_status_id_param = 20))

	ORDER BY

		m.invoice_document_scan_update_date DESC;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_update`(
	IN scanner_monitor_record_id_param INT UNSIGNED,
	IN company_code_param INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN invoice_document_scan_status_id_param INT UNSIGNED,
	IN manual_upload_flag_param CHAR(1),
	IN invoice_document_scan_update_date_param DATETIME,
	IN invoice_document_scan_duration_param INT UNSIGNED,
	IN invoice_document_scan_error_message_param VARCHAR(1024),
	IN invoice_document_scanner_process_tag_string_param VARCHAR(1024),
	IN request_to_map_param CHAR(1),
	IN manual_processing_param CHAR(1)
)
BEGIN
	DECLARE document_model_request_id_param INT UNSIGNED;

	SET document_model_request_id_param = (SELECT MAX(document_model_request_id) + 1 FROM apam_document_model_request);

	IF ISNULL(document_model_request_id_param) THEN
			SET document_model_request_id_param = 1;
    END IF;

	IF EXISTS(SELECT 1 FROM apam_document_model_request WHERE scanner_monitor_record_id = scanner_monitor_record_id_param) THEN
		UPDATE
			apam_document_model_request
		SET
			request_to_map = request_to_map_param,
			manual_processing = manual_processing_param
		WHERE
			company_code = company_code_param
			AND scanner_monitor_record_id = scanner_monitor_record_id_param;
	ELSE
		INSERT INTO apam_document_model_request
		(
			document_model_request_id,
			company_code,
			scanner_monitor_record_id,
			request_to_map,
			manual_processing,
			request_completed,
			create_id,
			create_date
		)
		SELECT
			document_model_request_id_param,
			company_code_param,
			scanner_monitor_record_id_param,
			request_to_map_param,
			manual_processing_param,
			'N',
			'system',
			CURDATE();
	END IF;

	IF manual_upload_flag_param = 'Y' THEN
		UPDATE
			apad_document_manual_upload
		SET
			document_model_request_id = document_model_request_id_param
		WHERE
			company_code = company_code_param
			AND scanner_monitor_record_id = scanner_monitor_record_id_param
			AND document_manual_upload_file_location = invoice_document_file_location_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_updatescanstatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_updatescanstatus`(
	IN company_code_param                       INT,
	IN invoice_document_file_location_param     VARCHAR(1024),
	IN invoice_document_scan_status_id_param    INT UNSIGNED,
	IN invoice_document_scan_update_date_param  DATETIME,
	IN model_def_id_param                       INT UNSIGNED
)
BEGIN
	DECLARE scanner_monitor_record_id_param INT UNSIGNED;

	IF NOT EXISTS (SELECT 1 FROM apad_invoice_scanner_monitor WHERE company_code = company_code_param AND invoice_document_file_location = invoice_document_file_location_param) THEN
		SET scanner_monitor_record_id_param = (SELECT MAX(scanner_monitor_record_id) + 1 FROM apad_invoice_scanner_monitor);

		IF ISNULL(scanner_monitor_record_id_param) THEN
			SET scanner_monitor_record_id_param = 1;
		END IF;

		INSERT INTO apad_invoice_scanner_monitor
		(
			scanner_monitor_record_id,
			company_code,
			invoice_document_file_location,
			invoice_document_scan_status_id,
			manual_upload_flag,
			invoice_document_scan_update_date,
			invoice_document_scan_duration,
			invoice_document_scan_error_message,
			invoice_document_scanner_process_tag_string,
			model_def_id
		)
		SELECT
			scanner_monitor_record_id_param,
			company_code_param,
			invoice_document_file_location_param,
			invoice_document_scan_status_id_param,
			'N',
			invoice_document_scan_update_date_param,
			NULL,
			NULL,
			NULL,
			model_def_id_param;
	ELSE
		UPDATE
			apad_invoice_scanner_monitor
		SET
			invoice_document_scan_status_id = invoice_document_scan_status_id_param,
			invoice_document_scan_update_date = invoice_document_scan_update_date_param
		WHERE
			company_code = company_code_param
			AND invoice_document_file_location = invoice_document_file_location_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_scannedinvoice_updatestatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_scannedinvoice_updatestatus`(

	IN company_code_param                   INT,

	IN invoice_document_file_location_param VARCHAR(1024),

	IN document_model_request_id_param      INT UNSIGNED,

	IN invoice_document_status_id_param     INT UNSIGNED,

	IN modify_id_param                      VARCHAR(32),

	IN modify_date_param                    DATETIME

)
BEGIN

	UPDATE

		apad_invoice_document

	SET

		document_model_request_id   = document_model_request_id_param,

		invoice_document_status_id  = invoice_document_status_id_param,

		modify_id                   = modify_id_param,

		modify_date                 = modify_date_param

	WHERE

		invoice_document_file_location = invoice_document_file_location_param

		AND company_code = company_code_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_updatedocumentmodelrequestId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_updatedocumentmodelrequestId`(

	IN document_model_request_id_param              INT UNSIGNED,

	IN company_code_param                           INT,

    IN document_manual_upload_file_location_param   VARCHAR(1024)

)
BEGIN

	UPDATE

		apad_document_manual_upload

	SET

		document_model_request_id = document_model_request_id_param

	WHERE

		company_code = company_code_param

		AND document_manual_upload_file_location = document_manual_upload_file_location_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_nonmappedinvoice_updateinvoicedocumentid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_nonmappedinvoice_updateinvoicedocumentid`(

	IN company_code_param                           INT,

	IN document_manual_upload_file_location_param   VARCHAR(1024),

	IN invoice_document_id_param                    INT UNSIGNED

)
BEGIN

	UPDATE

		apad_document_manual_upload

	SET

		invoice_document_id = invoice_document_id_param

	WHERE

		company_code = company_code_param

		AND document_manual_upload_file_location = document_manual_upload_file_location_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymentdashboard_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymentdashboard_list`(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED,
	IN user_role_id_param   INT,
	IN resource_id_param    CHAR(16)
)
BEGIN
	SELECT DISTINCT
		id.company_code,
		id.invoice_number,
		id.invoice_date,
		id.transaction_id,
		idd.amount,
		v.vendor_code,
		v.vendor_name,
		poh.po_code AS io_number,
		poh.campaign_name,
		poh.media_plan_name,
		pod.level2_key,
		pod.level2_key AS job_code,
		pod.level3_key,
		pod.level3_key AS activity_code,
		p.check_number,
		p.document_date,
		CASE WHEN IFNULL(d_p.payment_amount, 0.0) = 0.0 THEN 1 WHEN IFNULL(d_p.payment_amount, 0.0) >= idd.amount THEN 3 ELSE 2 END AS payment_status_id,
		CASE WHEN IFNULL(d_p.payment_amount, 0.0) = 0.0 THEN 'Unpaid' WHEN IFNULL(d_p.payment_amount, 0.0) >= idd.amount THEN 'Fully Paid' ELSE 'Partially Paid' END AS payment_status,
		IFNULL(d_p.payment_amount, 0.0) AS payment_amount,
		d_p.payment_info,
		pm.invoice_document_posting_update_date AS posted_date,
		iah.approval_rejection_user_id,
		CONCAT(rr.name_last,', ', rr.name_first) AS approved_by
	FROM
		apad_invoice_document id
	INNER JOIN (
				SELECT
					company_code,
					invoice_document_id,
					CAST(SUM(io_invoice_amount) AS DECIMAL(19, 2)) AS amount
				FROM
					apad_invoice_document_detail
				WHERE
					company_code = company_code_param
				GROUP BY
					company_code,
					invoice_document_id
				) AS idd ON idd.company_code = id.company_code
							AND idd.invoice_document_id = id.invoice_document_id
	INNER JOIN apad_vendors v ON v.company_code = id.company_code
								AND v.vendor_code = id.vendor_code
	INNER JOIN apad_po_header poh ON poh.company_code = id.company_code
									AND poh.po_code = id.po_code
	INNER JOIN apad_invoice_posting_monitor pm ON pm.company_code = id.company_code
													AND pm.invoice_document_id = id.invoice_document_id
													AND pm.invoice_document_posting_status_id = 20
	INNER JOIN v_ResourcesByInvoiceDocument rbid ON rbid.company_code = id.company_code
													AND rbid.invoice_document_id = id.invoice_document_id
	INNER JOIN (
				SELECT
					company_code,
					invoice_document_id,
					approval_rejection_user_id,
					MAX(sequence_id)
				FROM
					apad_invoice_document_routing_history
				GROUP BY
					invoice_document_id
				) iah ON iah.company_code = id.company_code 
					AND iah.invoice_document_id = id.invoice_document_id
	INNER JOIN apad_user_role_position_categories urpc ON urpc.position_category_code = rbid.position_category_code
															AND urpc.company_code = rbid.company_code
															AND (urpc.user_role_id = user_role_id_param OR IFNULL(resource_id_param, '') = '')
	LEFT OUTER JOIN apad_ap_payment p ON p.company_code = id.company_code
										AND p.invoice_number = id.invoice_number
	LEFT OUTER JOIN (
					SELECT
						company_code,
						invoice_number,
						SUM(payment_amount) AS payment_amount,
						GROUP_CONCAT(DISTINCT CONCAT(check_number, ' (', payment_amount, ')') ORDER BY check_number SEPARATOR ', ') AS payment_info
					FROM
						apad_ap_payment
					GROUP BY
						company_code,
						invoice_number
					) AS d_p ON d_p.company_code = id.company_code
								AND d_p.invoice_number = id.invoice_number
	LEFT OUTER JOIN apad_invoice_document_resource_routing_history idrrh ON idrrh.company_code = id.company_code
																			AND idrrh.invoice_document_id = id.invoice_document_id
	LEFT OUTER JOIN apad_resources r ON r.resource_id = idrrh.resource_id
										AND r.company_code = p.company_code
										AND r.active_flag = TRUE
	LEFT OUTER JOIN apad_resources rr ON rr.resource_id = iah.approval_rejection_user_id
										AND rr.company_code = iah.company_code
										AND rr.active_flag = TRUE
	LEFT OUTER JOIN apad_po_detail pod ON pod.company_code = poh.company_code
										AND pod.po_code = poh.po_code
	WHERE
		id.company_code = company_code_param
		AND id.model_def_id = model_def_id_param
	ORDER BY
		document_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymenttermsmap_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymenttermsmap_add`(
	IN apam_invoice_terms_code_param    CHAR(64),
	IN terms_code_param                 CHAR(64)
)
BEGIN
	INSERT INTO apam_payment_terms_map (apam_invoice_terms_code, terms_code)
	VALUES (apam_invoice_terms_code_param, terms_code_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymenttermsmap_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymenttermsmap_delete`(
	IN terms_code_param CHAR(64)
)
BEGIN
	DELETE FROM apam_payment_terms_map
	WHERE
		terms_code = terms_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymenttermsmap_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymenttermsmap_get`(

)
BEGIN

	SELECT

		apam_invoice_terms_code,

		terms_code

	FROM

		apam_payment_terms_map;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymentterms_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymentterms_get`(

)
BEGIN

	SELECT

		terms_code,

		terms_desc,

		days_due

	FROM

		apam_payment_terms;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_paymentTerm_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_paymentTerm_save`(
	termsCode           VARCHAR(64),
	termsDesc           VARCHAR(64),
	daysDue             INT,
	company_code_param  INT,
	update_date_param   DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_payment_terms WHERE terms_code = termsCode) THEN
		UPDATE
			apam_payment_terms
		SET
			terms_desc  = termsDesc,
			days_due    = daysDue
		WHERE
			terms_code = termsCode;
	ELSE
		INSERT INTO apam_payment_terms
		(
			terms_code,
			terms_desc,
			days_due
		)
		VALUES
		(
			termsCode,
			termsDesc,
			daysDue
		);
	END IF;

	CALL apas_datalastupdated_update(company_code_param, 'apam_payment_terms', update_date_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_podetail_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_podetail_list`(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT
		pd.company_code,
		pd.po_code,
		pd.line_id,
		pd.level2_key,
        l2.level2_description,
		pd.level3_key,
		pd.cost_category,
		pd.due_date,
		pd.quantity,
		pd.net_cost,
		pd.match_to_date_net,
		pd.close_flag
	FROM
		apad_po_detail pd
	INNER JOIN apad_level2 l2 ON pd.company_code = l2.company_code 
								AND pd.level2_key = l2.level2_key 
	WHERE
		pd.company_code = company_code_param
        AND (IFNULL(po_code_param, '') = '' OR pd.po_code = po_code_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_podetail_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_podetail_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		po_code             VARCHAR(32),
		line_id             INT,
		level2_key          VARCHAR(32),
		level3_key          VARCHAR(32),
		cost_category       INT,
		due_date            DATETIME,
		quantity            FLOAT,
		net_cost            FLOAT,
		match_to_date_net   FLOAT,
		close_flag          TINYINT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		line_id,
		level2_key,
		level3_key,
		cost_category,
		due_date,
		quantity,
		net_cost,
		match_to_date_net,
		close_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_detail pd
	INNER JOIN _temp t ON t.po_code = pd.po_code
						AND t.line_id = pd.line_id
						AND t.company_code = pd.company_code
	SET
		pd.level2_key           = t.level2_key,
		pd.level3_key           = t.level3_key,
		pd.cost_category        = t.cost_category,
		pd.due_date             = t.due_date,
		pd.quantity             = t.quantity,
		pd.net_cost             = t.net_cost,
		pd.match_to_date_net    = t.match_to_date_net,
		pd.close_flag           = t.close_flag;

	INSERT INTO apad_po_detail
	(
		company_code,
		po_code,
		line_id,
		level2_key,
		level3_key,
		cost_category,
		due_date,
		quantity,
		net_cost,
		match_to_date_net,
		close_flag
	)
	SELECT
		t.company_code,
		t.po_code,
		t.line_id,
		t.level2_key,
		t.level3_key,
		t.cost_category,
		t.due_date,
		t.quantity,
		t.net_cost,
		t.match_to_date_net,
		t.close_flag
	FROM
		_temp t
		INNER JOIN apad_po_header ph ON ph.po_code = t.po_code
										AND ph.company_code = t.company_code
		LEFT OUTER JOIN apad_po_detail pd ON pd.po_code = t.po_code
											AND pd.line_id = t.line_id
											AND pd.company_code = t.company_code
	WHERE
		pd.po_code IS NULL
	GROUP BY
		t.company_code,
		t.po_code,
		t.line_id;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_detail', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_poheaderandresourcebyvendor_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_poheaderandresourcebyvendor_list`(
	IN company_code_param           INT,
	IN vendor_code_param            CHAR(12),
	IN site_id_param                CHAR(32),
	IN invoice_document_id_param    INT UNSIGNED
)
BEGIN
	SELECT DISTINCT
		ph.company_code,
		ph.vendor_code,
		ph.site_id,
		ph.client_code,
		ph.client_name,
		ph.job_code,
		ph.campaign_name,
		ph.activity_code,
		ph.media_plan_name,
		ph.model_def_id,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.title,
		r.email,
		r.login_id,
		pc.position_category_code,
		pc.position_category_name,
		pc.protected_role_flag
	FROM
		apad_po_header ph
		INNER JOIN apad_po_resources pr ON pr.po_code = ph.po_code
											AND pr.company_code = ph.company_code
		INNER JOIN apad_resources r ON r.resource_id = pr.resource_id
											AND r.company_code = ph.company_code
											AND r.active_flag = TRUE
		INNER JOIN apam_position_category pc ON pc.position_category_code = pr.position_category_code
												AND pc.company_code = ph.company_code
		LEFT OUTER JOIN apad_invoice_document_resource_routing_history rrh ON rrh.company_code = ph.company_code
																				AND rrh.invoice_document_id = IFNULL(invoice_document_id_param, 0)
																				AND rrh.resource_id = r.resource_id
																				AND rrh.suggestion_flag <> 'N'
	WHERE
		ph.company_code = company_code_param
		AND (IFNULL(vendor_code_param, '') = '' OR ph.vendor_code = vendor_code_param)
		AND (IFNULL(site_id_param, '') = '' OR ph.site_id = site_id_param)
		AND (IFNULL(invoice_document_id_param, 0) = 0 OR (IFNULL(invoice_document_id_param, 0) <> 0 AND rrh.resource_id IS NOT NULL))
	ORDER BY
		r.resource_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_poheaderbypocodelist_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_poheaderbypocodelist_list`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_poheaderbyvendor_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_poheaderbyvendor_list`(
	IN company_code_param               INT,
	IN vendor_code_param                CHAR(12),
	IN site_id_param                    CHAR(32),
	IN service_term_start_date_param    DATE,
	IN service_term_end_date_param      DATE,
	IN model_def_id_param               INT UNSIGNED,
	IN invoice_document_id_param        INT UNSIGNED
)
BEGIN
	IF model_def_id_param = 1 THEN
		SELECT
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			ph.po_amount,
			ph.consumed_amount + IFNULL(dt_io.io_invoice_amount, 0.00) AS consumed_amount,
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
														AND pmd.delivery_date BETWEEN service_term_start_date_param AND service_term_end_date_param
			LEFT OUTER JOIN (SELECT
								id.company_code,
								idd.io_number,
								SUM(idd.io_invoice_amount) AS io_invoice_amount
							FROM
								apad_invoice_document id
								LEFT OUTER JOIN apad_invoice_document_detail idd ON idd.company_code = id.company_code
																					AND idd.invoice_document_id = id.invoice_document_id
							WHERE
								id.company_code = company_code_param
								AND id.vendor_code = vendor_code_param
								AND id.site_id = site_id_param
								AND id.invoice_document_id <> invoice_document_id_param
								AND id.is_deleted = 0
								AND id.invoice_document_status_id <> 170
								AND idd.io_number IS NOT NULL
							GROUP BY
								id.company_code,
								idd.io_number) dt_io ON dt_io.company_code = ph.company_code
														AND dt_io.io_number = ph.po_code
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param
			AND ph.model_def_id = model_def_id_param
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
			ph.po_code;
	ELSE
		SELECT DISTINCT
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			SUM(pd.net_cost) AS po_amount,
			SUM(pd.match_to_date_net) + IFNULL(dt_io.io_invoice_amount, 0.00) AS consumed_amount,
			ph.client_code,
			pd.customer_name AS client_name,
			pd.level2_key AS job_code,
			pd.level2_description AS campaign_name,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id
		FROM
			apad_po_header ph
			INNER JOIN v_PODetail pd ON pd.company_code = ph.company_code
											AND pd.po_code = ph.po_code
			LEFT OUTER JOIN (SELECT
								id.company_code,
								id.po_code,
								SUM(idd.io_invoice_amount) AS io_invoice_amount
							FROM
								apad_invoice_document id
								LEFT OUTER JOIN apad_invoice_document_detail idd ON idd.company_code = id.company_code
																					AND idd.invoice_document_id = id.invoice_document_id
							WHERE
								id.company_code = company_code_param
								AND id.vendor_code = vendor_code_param
								AND id.site_id = site_id_param
								AND id.invoice_document_id <> invoice_document_id_param
								AND id.is_deleted = 0
								AND id.invoice_document_status_id <> 170
								AND idd.io_number IS NOT NULL
							GROUP BY
								id.company_code,
								id.po_code) dt_io ON dt_io.company_code = ph.company_code
														AND dt_io.po_code = ph.po_code
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param
			AND ph.active_flag = TRUE
		GROUP BY
			ph.company_code,
			ph.po_code,
			ph.vendor_code,
			ph.site_id,
			ph.client_code,
			pd.customer_name,
			pd.level2_key,
			pd.level2_description,
			ph.activity_code,
			ph.media_plan_name,
			ph.model_def_id
		ORDER BY
			ph.po_code;

		SELECT
			pd.company_code,
			pd.po_code,
			pd.line_id,
			pd.level2_key,
			pd.level3_key,
			pd.cost_category,
			pd.due_date,
			pd.quantity,
			pd.net_cost,
			pd.match_to_date_net,
			pd.close_flag,
			IFNULL(l2.tolerance_po_flag, 'N') AS tolerance_po_flag,
			IFNULL(l2.tolerance_po_amount, 0) AS tolerance_po_amount
		FROM
			apad_po_header ph
			INNER JOIN apad_po_detail pd ON pd.company_code = ph.company_code
											AND pd.po_code = ph.po_code
											AND pd.close_flag = FALSE
			INNER JOIN apad_level2 l2 ON l2.company_code = pd.company_code
										AND l2.level2_key = pd.level2_key
										AND l2.level2_status_id = 1
		WHERE
			ph.company_code = company_code_param
			AND ph.vendor_code = vendor_code_param
			AND ph.site_id = site_id_param;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_poheader_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_poheader_list`(
	IN company_code_param   INT,
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	FROM
		apad_po_header
	WHERE
		company_code = company_code_param
		AND model_def_id = model_def_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_poresources_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_poresources_list`(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32),
	IN resource_id_param    CHAR(16)
)
BEGIN
	SELECT
		por.company_code,
		por.po_code,
		por.resource_id,
		por.position_category_code,
		r.name_first,
		r.name_last,
		pc.position_category_name
	FROM
		apad_po_resources por
		INNER JOIN apad_resources r ON r.company_code = por.company_code
										AND r.resource_id = por.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = por.company_code
										AND pc.position_category_code = por.position_category_code
	WHERE
		por.company_code = company_code_param
		AND (IFNULL(po_code_param, '') = '' OR por.po_code = po_code_param)
		AND (IFNULL(resource_id_param, '') = '' OR por.resource_id = resource_id_param)
	ORDER BY
		por.po_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_position_category_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_position_category_list`(

	IN company_code_param INT

)
BEGIN

	SELECT

		company_code,

		position_category_code,

		position_category_name,

		protected_role_flag

	FROM

		apam_position_category

	WHERE

		company_code = company_code_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_position_category_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_position_category_save`(
	companyCode                 INT,
	positionCategoryCode        INT,
	positionCategoryName        VARCHAR(64),
	protected_role_flag_param   INT,
	update_date_param           DATETIME
)
BEGIN
	IF EXISTS (SELECT 1 FROM apam_position_category WHERE company_code = companyCode AND position_category_code = positionCategoryCode)
	THEN
		UPDATE
			apam_position_category
		SET
			position_category_name  = positionCategoryName,
			protected_role_flag     = protected_role_flag_param
		WHERE
			company_code = companyCode
			AND position_category_code = positionCategoryCode;
	ELSE
		INSERT INTO apam_position_category
		(
			company_code,
			position_category_code,
			position_category_name,
			protected_role_flag
		)
		VALUES
		(
			companyCode,
			positionCategoryCode,
			positionCategoryName,
			protected_role_flag_param
		);
	END IF;

	CALL apas_datalastupdated_update(companyCode, 'apam_position_category', update_date_param);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_po_header_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_po_header_get`(
	IN company_code_param   INT,
	IN po_code_param        VARCHAR(32)
)
BEGIN
	SELECT
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id
	FROM
		apad_po_header
	WHERE
		company_code = company_code_param
		AND po_code = po_code_param;

	SELECT
		d.company_code,
		d.po_code,
		d.line_id,
		d.level2_key,
		d.level3_key,
		d.cost_category,
		d.due_date,
		d.quantity,
		d.net_cost,
		d.match_to_date_net,
		d.close_flag,
		IFNULL(l2.tolerance_po_flag, 'N') AS tolerance_po_flag,
		IFNULL(l2.tolerance_po_amount, 0) AS tolerance_po_amount
	FROM
		apad_po_detail d
		LEFT OUTER JOIN apad_level2 l2 ON l2.level2_key = d.level2_key
										AND l2.company_code = d.company_code
	WHERE
		d.company_code = company_code_param
		AND d.po_code = po_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_po_header_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_po_header_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param  INT;
	DECLARE model_def_id_param  INT UNSIGNED;
	DECLARE table_name_param    VARCHAR(32);

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		po_code             VARCHAR(32),
		vendor_code         VARCHAR(12),
		site_id             VARCHAR(32),
		po_amount           DOUBLE,
		consumed_amount     DOUBLE,
		client_code         VARCHAR(32),
		client_name         VARCHAR(256),
		job_code            VARCHAR(32),
		campaign_name       VARCHAR(512),
		activity_code       VARCHAR(64),
		media_plan_name     VARCHAR(512),
		model_def_id        INT UNSIGNED,
		active_flag         TINYINT,
		po_date             DATETIME,
		currency_code       VARCHAR(32),
		payment_term_code   VARCHAR(32),
		due_date            DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_header po
	INNER JOIN _temp t ON t.po_code = po.po_code
						AND t.company_code = po.company_code
	SET
		po.po_amount            = t.po_amount,
		po.consumed_amount      = t.consumed_amount,
		po.client_code          = t.client_code,
		po.client_name          = t.client_name,
		po.job_code             = t.job_code,
		po.campaign_name        = t.campaign_name,
		po.activity_code        = t.activity_code,
		po.media_plan_name      = t.media_plan_name,
		po.model_def_id         = t.model_def_id,
		po.active_flag          = t.active_flag,
		po.po_date              = t.po_date,
		po.currency_code        = t.currency_code,
		po.payment_term_code    = t.payment_term_code,
		po.due_date             = t.due_date;

	INSERT INTO apad_po_header
	(
		company_code,
		po_code,
		vendor_code,
		site_id,
		po_amount,
		consumed_amount,
		client_code,
		client_name,
		job_code,
		campaign_name,
		activity_code,
		media_plan_name,
		model_def_id,
		active_flag,
		po_date,
		currency_code,
		payment_term_code,
		due_date
	)
	SELECT
		t.company_code,
		t.po_code,
		t.vendor_code,
		t.site_id,
		t.po_amount,
		t.consumed_amount,
		t.client_code,
		t.client_name,
		t.job_code,
		t.campaign_name,
		t.activity_code,
		t.media_plan_name,
		t.model_def_id,
		t.active_flag,
		t.po_date,
		t.currency_code,
		t.payment_term_code,
		t.due_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_po_header po ON po.po_code = t.po_code
											AND po.company_code = t.company_code
	WHERE
		po.po_code IS NULL
	GROUP BY
		t.company_code,
		t.po_code;

	SELECT company_code, model_def_id INTO company_code_param, model_def_id_param FROM _temp LIMIT 1;
	SET table_name_param = CONCAT('apad_po_header', '_', model_def_id_param);

	CALL apas_datalastupdated_update(company_code_param, table_name_param, update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_po_media_delivery_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_po_media_delivery_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code    INT,
		po_code         VARCHAR(32),
		delivery_date   DATETIME,
		delivery_amount DOUBLE
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		delivery_date,
		delivery_amount
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_po_media_delivery pmd
	INNER JOIN _temp t ON t.company_code = pmd.company_code
						AND t.po_code = pmd.po_code
						AND t.delivery_date = pmd.delivery_date
	SET
		pmd.delivery_amount = t.delivery_amount;

	INSERT INTO apad_po_media_delivery
	(
		company_code,
		po_code,
		delivery_date,
		delivery_amount
	)
	SELECT
		t.company_code,
		t.po_code,
		t.delivery_date,
		t.delivery_amount
	FROM
		_temp t
		INNER JOIN apad_po_header po ON po.company_code = t.company_code
												AND po.po_code = t.po_code
		LEFT OUTER JOIN apad_po_media_delivery pmd ON pmd.company_code = t.company_code
													AND pmd.po_code = t.po_code
													AND pmd.delivery_date = t.delivery_date
	WHERE
		pmd.po_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_media_delivery', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_po_resource_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_po_resource_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		po_code                 VARCHAR(32),
		resource_id             CHAR(16),
		position_category_code	INT
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		po_code,
		resource_id,
		position_category_code
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	INSERT INTO apad_po_resources
	(
		company_code,
		po_code,
		resource_id,
		position_category_code
	)
	SELECT DISTINCT
		t.company_code,
		t.po_code,
		t.resource_id,
		t.position_category_code
	FROM
		_temp t
		INNER JOIN apad_po_header po ON po.company_code = t.company_code
												AND po.po_code = t.po_code
		INNER JOIN apad_resources r ON r.company_code = t.company_code
										AND r.resource_id = t.resource_id
		INNER JOIN apam_position_category pc ON pc.company_code = t.company_code
										AND pc.position_category_code = t.position_category_code
		LEFT OUTER JOIN apad_po_resources pr ON pr.company_code = t.company_code
												AND pr.po_code = t.po_code
												AND pr.resource_id = t.resource_id
												AND pr.position_category_code = t.position_category_code
	WHERE
		pr.po_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_po_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_registration_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_registration_get`(

	IN registration_record_id_param INT

)
BEGIN

	SELECT

		registration_record_id,

		registration_business_name,

		registration_business_addr1,

		registration_business_addr2,

		registration_business_city,

		registration_business_state,

		registration_business_zip,

		registration_business_phone,

		registration_business_email,

		admin_login,

		admin_password,

		s3_storage_root_folder,

		is_trial_flag,

		trial_expiration_date,

		license_key,

		create_id,

		create_date,

		modify_id,

		modify_date

	FROM

		apam_registration

	WHERE

		registration_record_id = registration_record_id_param

	ORDER BY

		registration_business_name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_add`(

	IN company_code_param INT,

	IN resource_id_param  CHAR(16),

	IN name_last_param    VARCHAR(32),

	IN name_first_param   VARCHAR(32),

	IN name_init_param    VARCHAR(1),

	IN title_param        VARCHAR(64),

	IN email_param        VARCHAR(128),

	IN login_id_param     VARCHAR(64),

	IN res_password_param VARCHAR(256),

	IN active_flag_param  TINYINT,

	IN create_id_param    VARCHAR(32),

	IN create_date_param  DATETIME

)
BEGIN

	INSERT INTO apad_resources

	(

		company_code,

		resource_id,

		name_last,

		name_first,

		name_init,

		title,

		email,

		login_id,

		res_password,

		active_flag,

		create_id,

		create_date

	)

	SELECT

		company_code_param,

		resource_id_param,

		name_last_param,

		name_first_param,

		name_init_param,

		title_param,

		email_param,

		login_id_param,

		res_password_param,

		active_flag_param,

		create_id_param,

		create_date_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_authenticate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_resources_authenticate`(
	IN login_id_param       	VARCHAR(64),
	IN res_password_param   	VARCHAR(256),
	IN email_param          	VARCHAR(128),
	IN ignore_password_param    CHAR(1)
)
BEGIN
	SELECT
		u.company_code,
		u.resource_id,
		u.name_last,
		u.name_first,
		u.name_init,
		u.title,
		u.email,
		u.login_id,
		u.res_password,
		u.active_flag,
		u.password_reset_flag,
		u.create_id,
		u.create_date,
		u.modify_date,
		u.modify_id,
		c.co_name,
		c.co_short_name
	FROM
		apad_resources u
		INNER JOIN apam_company c ON c.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param = 'Y'))
		)
		AND active_flag = TRUE;

	SELECT
		u.resource_id,
		ur.company_code,
		ur.user_role_id,
		ur.user_role_name,
		ur.is_admin_role,
		ur.allow_routing_setup,
		ur.create_id,
		ur.create_date,
		ur.modify_id,
		ur.modify_date
	FROM
		apad_resources u
		INNER JOIN apad_user_roles_resource urr ON urr.resource_id = u.resource_id
												AND urr.company_code = u.company_code
		INNER JOIN apad_user_roles ur ON ur.user_role_id = urr.user_role_id
										AND ur.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(u.login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param  = 'Y'))
		)
		AND u.active_flag = TRUE;

	SELECT
		u.resource_id,
		urir.company_code,
		urir.user_role_id,
		urir.model_def_id,
		urir.allow_non_mapped_invoices_request_processing,
		urir.allow_invoice_model_mapping,
		urir.allow_invoice_manual_processing,
		urir.allow_invoice_document_management,
		urir.allow_invoice_correction,
		urir.allow_invoice_level_1_approval,
		urir.allow_invoice_level_2_approval,
		urir.allow_invoice_level_3_approval,
		urir.allow_invoice_level_4_approval,
		urir.allow_invoice_level_5_approval
	FROM
		apad_resources u
		INNER JOIN apad_user_roles_resource urr ON urr.resource_id = u.resource_id
												AND urr.company_code = u.company_code
		INNER JOIN apad_user_roles ur ON ur.user_role_id = urr.user_role_id
										AND ur.company_code = u.company_code
		INNER JOIN apad_user_roles_invoice_rights urir ON urir.user_role_id = ur.user_role_id
										AND urir.company_code = u.company_code
	WHERE
		(
			((IFNULL(email_param, '') <> '' AND u.email = email_param) AND (IFNULL(login_id_param, '') <> '' AND u.login_id = login_id_param)) OR
			(u.login_id = login_id_param AND (res_password = res_password_param OR ignore_password_param  = 'Y'))
		)
		AND u.active_flag = TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_delete`(

	IN company_code_param INT,

	IN resource_id_param  CHAR(16)

)
BEGIN

	DELETE FROM

		apad_resources

	WHERE

		company_code = company_code_param

        AND resource_id = resource_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_get_by_invoice_document` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_resources_get_by_invoice_document`(
	IN company_code_param           INT,
	IN invoice_document_id_param    INT UNSIGNED,
	IN accept_reject_param          TINYINT
)
BEGIN
	DECLARE routing_number_of_approval_levels_param INT;
	DECLARE max_possible_approved_status_id INT;
	DECLARE invoice_document_status_id_param INT UNSIGNED;
	DECLARE next_status INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code            INT,
		resource_id             CHAR(16),
		name_last               VARCHAR(32),
		name_first              VARCHAR(32),
		name_init               VARCHAR(1),
		title                   VARCHAR(64),
		email                   VARCHAR(128),
		login_id                VARCHAR(64),
		res_password            VARCHAR(256),
		active_flag             TINYINT,
		create_id               VARCHAR(32),
		create_date             DATETIME,
		modify_id               VARCHAR(32),
		modify_date             DATETIME,
		position_category_code  INT,
		position_category_name  VARCHAR(64),
		protected_role_flag     INT
	);

	SET routing_number_of_approval_levels_param = (SELECT
														cac.routing_number_of_approval_levels
													FROM
														apam_company_approval_configuration cac
														INNER JOIN apad_invoice_document id ON id.company_code = cac.company_code
																								AND id.model_def_id = cac.model_def_id
																								AND id.invoice_document_id = invoice_document_id_param
													WHERE
														cac.company_code = company_code_param);

	SET max_possible_approved_status_id = ((20 * routing_number_of_approval_levels_param) + 50);

	SET invoice_document_status_id_param = (SELECT invoice_document_status_id FROM apad_invoice_document WHERE invoice_document_id = invoice_document_id_param AND company_code = company_code_param);
	SET next_status = CASE WHEN accept_reject_param = TRUE THEN 20 WHEN accept_reject_param = FALSE THEN -30 ELSE 0 END;

	IF invoice_document_status_id_param = 50 AND next_status = 0 THEN
		SET next_status = 20;
	END IF;

	INSERT INTO _temp
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		res_password,
		active_flag,
		create_id,
		create_date,
		modify_date,
		modify_id,
		position_category_code,
		position_category_name,
		protected_role_flag
	)
	SELECT DISTINCT
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id,
		r.position_category_code,
		r.position_category_name,
		r.protected_role_flag
	FROM
		v_ResourcesByInvoiceDocument r
		INNER JOIN (
				SELECT
					urr.company_code,
					urr.resource_id,
					urir.model_def_id,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 35 ELSE NULL END AS allowed_missing_vendor_assignment,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 40 ELSE NULL END AS allowed_invoice_correction,
					CASE WHEN urir.allow_invoice_correction = 'Y' OR urir.allow_invoice_auto_routing THEN 60 ELSE NULL END AS allowed_vefified_invoice_error_correction,
					CASE WHEN urir.allow_invoice_level_1_approval = 'Y' THEN 70 ELSE NULL END AS allowed_level_1_status,
					CASE WHEN urir.allow_invoice_level_2_approval = 'Y' THEN 90 ELSE NULL END AS allowed_level_2_status,
					CASE WHEN urir.allow_invoice_level_3_approval = 'Y' THEN 110 ELSE NULL END AS allowed_level_3_status,
					CASE WHEN urir.allow_invoice_level_4_approval = 'Y' THEN 130 ELSE NULL END AS allowed_level_4_status,
					CASE WHEN urir.allow_invoice_level_5_approval = 'Y' THEN 150 ELSE NULL END AS allowed_level_5_status
				FROM
					apad_user_roles_invoice_rights urir
					INNER JOIN  apad_user_roles_resource urr ON urr.company_code = urir.company_code
														AND urr.user_role_id = urir.user_role_id
					INNER JOIN  apad_user_roles ur ON ur.company_code = urr.company_code
														AND ur.user_role_id = urr.user_role_id
					) AS dt_urir ON r.company_code = dt_urir.company_code
									AND r.resource_id = dt_urir.resource_id
									AND r.model_def_id = dt_urir.model_def_id
	WHERE
		r.invoice_document_id = invoice_document_id_param
		AND r.company_code = company_code_param
		AND r.active_flag = TRUE
		#AND IFNULL(r.email, '') <> ''
		AND ((r.invoice_document_status_id + next_status) IN (dt_urir.allowed_missing_vendor_assignment, dt_urir.allowed_invoice_correction, dt_urir.allowed_vefified_invoice_error_correction, dt_urir.allowed_level_1_status, dt_urir.allowed_level_2_status, dt_urir.allowed_level_3_status, dt_urir.allowed_level_4_status) OR r.invoice_document_status_id = max_possible_approved_status_id);

	IF EXISTS (SELECT 1 FROM _temp) THEN
		SELECT
			company_code,
			resource_id,
			name_last,
			name_first,
			name_init,
			title,
			email,
			login_id,
			res_password,
			#active_flag,
			create_id,
			create_date,
			modify_date,
			modify_id,
			position_category_code,
			position_category_name,
			protected_role_flag,
            NULL as is_admin_role
		FROM
			_temp;
	ELSE
		SELECT DISTINCT
			r.company_code,
			r.resource_id,
			r.name_last,
			r.name_first,
			r.name_init,
			r.title,
			r.email,
			r.login_id,
			r.res_password,
			#r.active_flag,
			r.create_id,
			r.create_date,
			r.modify_date,
			r.modify_id,
			ur.is_admin_role
		FROM
			apad_resources r
			INNER JOIN apad_user_roles_resource urr ON r.resource_id = urr.resource_id
														AND r.company_code = urr.company_code
			INNER JOIN apad_user_roles ur ON urr.user_role_id = ur.user_role_id
														AND urr.company_code = ur.company_code
			LEFT OUTER JOIN apad_document_manual_upload dmu ON dmu.company_code = r.company_code
																AND dmu.invoice_document_id = invoice_document_id_param
		WHERE
			r.company_code = company_code_param
			AND r.active_flag = TRUE
			#AND IFNULL(r.email, '') <> ''
			AND (ur.is_admin_role = 'Y' OR dmu.resource_id = r.resource_id);
	END IF;

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_get_by_level2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_get_by_level2`(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN level2_key_param                     VARCHAR(32),
	IN level2_description_param             VARCHAR(128),
	IN customer_code_param                  VARCHAR(16),
	IN customer_name_param                  VARCHAR(64)
)
BEGIN
	DECLARE invoice_document_id_param   INT UNSIGNED;
	DECLARE model_def_id_param          INT UNSIGNED;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		resource_id             CHAR(16),
		position_category_code  INT
	);

	SELECT invoice_document_id, model_def_id INTO invoice_document_id_param, model_def_id_param FROM apad_invoice_document WHERE invoice_document_file_location LIKE (CONCAT(invoice_document_file_location_param, '%')) AND company_code = company_code_param;

	INSERT INTO _temp
	(
		resource_id,
		position_category_code
	)
	SELECT
		l2r.resource_id,
		l2r.position_category_code
	FROM
		apad_level2 l2
		LEFT OUTER JOIN apad_level2_resources l2r ON l2r.company_code = l2.company_code
												AND l2r.level2_key = l2.level2_key
	WHERE
		l2.company_code = company_code_param
		AND l2.level2_status_id = 1
		AND ((IFNULL(level2_key_param, '') <> '' AND l2.level2_key = level2_key_param)
		OR (IFNULL(level2_description_param, '') <> '' AND l2.level2_description = level2_description_param)
		OR (IFNULL(customer_code_param, '') <> '' AND l2.customer_code = customer_code_param)
		OR (IFNULL(customer_name_param, '') <> '' AND l2.customer_name = customer_name_param));

	SELECT DISTINCT
		invoice_document_id_param AS invoice_document_id,
		model_def_id_param AS model_def_id,
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id
	FROM
	(
		SELECT
			t.resource_id,
			t.user_role_id
		FROM
		(
			SELECT DISTINCT
				t.resource_id,
				IFNULL(urpc.user_role_id, urr.user_role_id) AS user_role_id
			FROM
				_temp t
			LEFT OUTER JOIN apad_user_role_position_categories urpc ON urpc.company_code = company_code_param
																	AND urpc.position_category_code = t.position_category_code
			LEFT OUTER JOIN apad_user_roles_resource urr ON urr.company_code = company_code_param
															AND urr.resource_id = t.resource_id
			WHERE
				urpc.user_role_id IS NOT NULL OR urr.user_role_id IS NOT NULL
		) t
		INNER JOIN apad_user_roles_invoice_rights urir ON urir.company_code = company_code_param
															AND urir.user_role_id = t.user_role_id
															AND urir.model_def_id = model_def_id_param
															AND urir.allow_invoice_auto_routing = 'Y'
	) dt_r
	INNER JOIN apad_resources r ON r.resource_id = dt_r.resource_id
									AND r.company_code = company_code_param
									AND r.active_flag = TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_get_by_po_header` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_get_by_po_header`(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN po_code_param                        VARCHAR(32),
	IN client_code_param                    VARCHAR(32),
	IN client_name_param                    VARCHAR(256),
	IN campaign_name_param                  VARCHAR(512),
	IN media_plan_name_param	            VARCHAR(512)
)
BEGIN
	DECLARE invoice_document_id_param   INT UNSIGNED;
	DECLARE model_def_id_param          INT UNSIGNED;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		resource_id             CHAR(16),
		position_category_code  INT
	);

	SELECT invoice_document_id, model_def_id INTO invoice_document_id_param, model_def_id_param FROM apad_invoice_document WHERE invoice_document_file_location LIKE (CONCAT(invoice_document_file_location_param, '%')) AND company_code = company_code_param;

	INSERT INTO _temp
	(
		resource_id,
		position_category_code
	)
	SELECT
		CASE WHEN model_def_id_param = 1 THEN por.resource_id WHEN model_def_id_param = 2 THEN dt_l2r.resource_id ELSE  '' END AS resource_id,
		CASE WHEN model_def_id_param = 1 THEN por.position_category_code WHEN model_def_id_param = 2 THEN dt_l2r.position_category_code ELSE  '' END AS position_category_code
	FROM
		apad_po_header ph
		LEFT OUTER JOIN apad_po_resources por ON por.po_code = ph.po_code
												AND por.company_code = ph.company_code
												AND ph.model_def_id = model_def_id_param
		LEFT OUTER JOIN
		(
			SELECT
				pd.company_code,
				pd.po_code,
				l2r.level2_key,
				l2r.resource_id,
				l2r.position_category_code
			FROM
				apad_po_detail pd
				INNER JOIN apad_level2_resources l2r ON l2r.level2_key = pd.level2_key
														AND l2r.company_code = pd.company_code
		) dt_l2r ON dt_l2r.po_code = ph.po_code
					AND dt_l2r.company_code = ph.company_code
					AND ph.model_def_id = model_def_id_param
	WHERE
		ph.company_code = company_code_param
		AND ((IFNULL(po_code_param, '') <> '' AND ph.po_code = po_code_param)
		OR (IFNULL(client_code_param, '') <> '' AND ph.client_code = client_code_param)
		OR (IFNULL(client_name_param, '') <> '' AND ph.client_name = client_name_param)
		OR (IFNULL(campaign_name_param, '') <> '' AND ph.campaign_name = campaign_name_param)
		OR (IFNULL(media_plan_name_param, '') <> '' AND ph.media_plan_name = media_plan_name_param));

	SELECT DISTINCT
		invoice_document_id_param AS invoice_document_id,
		model_def_id_param AS model_def_id,
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id
	FROM
	(
		SELECT
			t.resource_id,
			t.user_role_id
		FROM
		(
			SELECT DISTINCT
				t.resource_id,
				IFNULL(urpc.user_role_id, urr.user_role_id) AS user_role_id
			FROM
				_temp t
			LEFT OUTER JOIN apad_user_role_position_categories urpc ON urpc.company_code = company_code_param
																	AND urpc.position_category_code = t.position_category_code
			LEFT OUTER JOIN apad_user_roles_resource urr ON urr.company_code = company_code_param
															AND urr.resource_id = t.resource_id
			WHERE
				urpc.user_role_id IS NOT NULL OR urr.user_role_id IS NOT NULL
		) t
		INNER JOIN apad_user_roles_invoice_rights urir ON urir.company_code = company_code_param
															AND urir.user_role_id = t.user_role_id
															AND urir.model_def_id = model_def_id_param
															AND urir.allow_invoice_auto_routing = 'Y'
	) dt_r
	INNER JOIN apad_resources r ON r.resource_id = dt_r.resource_id
									AND r.company_code = company_code_param
									AND r.active_flag = TRUE;

	DROP TEMPORARY TABLE IF EXISTS _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_get_by_resources` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_get_by_resources`(
	IN company_code_param                   INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN resource_id_param                    CHAR(16),
	IN name_last_param                      VARCHAR(128),
	IN name_first_param                     VARCHAR(16),
	IN email_param                          VARCHAR(64),
	IN login_id_param                       VARCHAR(64)
)
BEGIN
	DECLARE invoice_document_id_param   INT UNSIGNED;
	DECLARE model_def_id_param          INT UNSIGNED;

	SELECT invoice_document_id, model_def_id INTO invoice_document_id_param, model_def_id_param FROM apad_invoice_document WHERE invoice_document_file_location LIKE (CONCAT(invoice_document_file_location_param, '%')) AND company_code = company_code_param;

	SELECT DISTINCT
		invoice_document_id_param AS invoice_document_id,
		model_def_id_param AS model_def_id,
		r.company_code,
		r.resource_id,
		r.name_last,
		r.name_first,
		r.name_init,
		r.title,
		r.email,
		r.login_id,
		r.res_password,
		r.active_flag,
		r.create_id,
		r.create_date,
		r.modify_date,
		r.modify_id
	FROM
		apad_resources r
	WHERE
		r.company_code = company_code_param
		AND r.active_flag = TRUE
		AND ((IFNULL(resource_id_param, '') <> '' AND r.resource_id = resource_id_param)
		OR (IFNULL(name_last_param, '') <> '' AND r.name_last = name_last_param)
		OR (IFNULL(name_first_param, '') <> '' AND r.name_first = name_first_param)
		OR (IFNULL(email_param, '') <> '' AND r.email = email_param)
		OR (IFNULL(login_id_param, '') <> '' AND r.login_id = login_id_param));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_list`(

	IN company_code_param   INT

)
BEGIN

	SELECT

		company_code,

		resource_id,

		name_last,

		name_first,

		name_init,

		title,

		email,

		login_id,

		res_password,

		active_flag,

		create_id,

		create_date,

		modify_date,

		modify_id

	FROM

		apad_resources

	WHERE

		company_code = company_code_param;



	SELECT

		company_code,

		user_role_id,

		resource_id,

		create_id,

		create_date,

		modify_id,

		modify_date

	FROM

		apad_user_roles_resource

	WHERE

		company_code = company_code_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_reset_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_reset_password`(

	IN resource_id_param  			   CHAR(16),

	IN res_password_param			   VARCHAR(256),

    IN password_reset_flag_param	   CHAR(1),

	IN modify_id_param    			   VARCHAR(32),

	IN modify_date_param  			   DATETIME

)
BEGIN

	UPDATE

		apad_resources

	SET

		res_password        = res_password_param,

        password_reset_flag = password_reset_flag_param,

		modify_date         = modify_date_param,

		modify_id           = modify_id_param

	WHERE

		resource_id = resource_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resources_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_resources_update`(
	IN company_code_param INT,
	IN resource_id_param  CHAR(16),
	IN name_last_param    VARCHAR(32),
	IN name_first_param   VARCHAR(32),
	IN name_init_param    VARCHAR(1),
	IN title_param        VARCHAR(64),
	IN email_param        VARCHAR(128),
	IN login_id_param     VARCHAR(64),
	IN active_flag_param  TINYINT,
	IN modify_id_param    VARCHAR(32),
	IN modify_date_param  DATETIME
)
BEGIN
	UPDATE
		apad_resources
	SET
		name_last       = name_last_param,
		name_first      = name_first_param,
		name_init       = name_init_param,
		title           = title_param,
		email           = email_param,
		login_id        = login_id_param,
		active_flag     = active_flag_param,
		modify_date     = modify_date_param,
		modify_id       = modify_id_param
	WHERE
		company_code = company_code_param
		AND resource_id = resource_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_resource_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_resource_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code    INT,
		resource_id     CHAR(16),
		name_last       VARCHAR(32),
		name_first      VARCHAR(32),
		name_init       VARCHAR(1),
		title           VARCHAR(64),
		email           VARCHAR(128),
		login_id        VARCHAR(64),
		active_flag     TINYINT,
		create_id       VARCHAR(32),
		create_date     DATETIME,
		modify_id       VARCHAR(32),
		modify_date     DATETIME
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		active_flag,
		create_id,
		create_date,
		modify_id,
		modify_date
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_resources r
	INNER JOIN _temp t ON t.resource_id = r.resource_id
						AND t.company_code = r.company_code
	SET
		r.name_last       = t.name_last,
		r.name_first      = t.name_first,
		r.name_init       = t.name_init,
		r.title           = t.title,
		r.email           = t.email,
		r.login_id        = t.login_id,
		r.modify_date     = t.modify_date,
		r.modify_id       = t.modify_id;

	INSERT INTO apad_resources
	(
		company_code,
		resource_id,
		name_last,
		name_first,
		name_init,
		title,
		email,
		login_id,
		active_flag,
		create_id,
		create_date
	)
	SELECT
		t.company_code,
		t.resource_id,
		t.name_last,
		t.name_first,
		t.name_init,
		t.title,
		t.email,
		t.login_id,
		FALSE,
		t.create_id,
		t.create_date
	FROM
		_temp t
		LEFT OUTER JOIN apad_resources r ON r.resource_id = t.resource_id
											AND r.company_code = t.company_code
	WHERE
		r.resource_id IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_resources', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_updateinvoicedocumentscanstatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_updateinvoicedocumentscanstatus`(
	IN company_code_param INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN invoice_document_scan_status_id_param INT UNSIGNED
)
BEGIN
	UPDATE
		apad_invoice_scanner_monitor
	SET
		invoice_document_scan_status_id = invoice_document_scan_status_id_param
	WHERE
		company_code = company_code_param
		AND invoice_document_file_location = invoice_document_file_location_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_updateinvoicedocumentstatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_updateinvoicedocumentstatus`(
	IN company_code_param INT,
	IN invoice_document_file_location_param VARCHAR(1024),
	IN invoice_document_scan_status_id_param INT UNSIGNED
)
BEGIN
	UPDATE
		apad_invoice_document
	SET
		document_model_request_id = document_model_request_id_param,
		invoice_document_status_id = invoice_document_status_id_param
	WHERE
		invoice_document_file_location = invoice_document_file_location_param
		AND company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_userrolesinvoicerights_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_userrolesinvoicerights_save`(
	IN company_code_param									INT,
	IN user_role_id_param									INT,
	IN model_def_id_param									INT UNSIGNED,
	IN allow_non_mapped_invoices_request_processing_param	CHAR(1),
	IN allow_invoice_model_mapping_param					CHAR(1),
	IN allow_invoice_auto_routing_param				        CHAR(1),
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_userroles_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_userroles_add`(
	IN company_code_param			INT,
	OUT user_role_id_param			INT,
	IN user_role_name_param			VARCHAR(64),
	IN is_admin_role_param			CHAR(1),
	IN allow_routing_setup_param	CHAR(1),
	IN create_id_param				VARCHAR(32),
	IN create_date_param			DATETIME
)
BEGIN
	SET user_role_id_param = (SELECT MAX(user_role_id) + 1 FROM apad_user_roles WHERE company_code = company_code_param);

	IF ISNULL(user_role_id_param) THEN
			SET user_role_id_param = 1;
	END IF;

	INSERT INTO apad_user_roles
	(
		company_code,
		user_role_id,
		user_role_name,
		is_admin_role,
		allow_routing_setup,
		create_id,
		create_date
	)
	SELECT
		company_code_param,
		user_role_id_param,
		user_role_name_param,
		is_admin_role_param,
		allow_routing_setup_param,
		create_id_param,
		create_date_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_userroles_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_userroles_delete`(
	IN company_code_param   INT,
	IN user_role_id_param   INT
)
BEGIN
	DELETE FROM
		apad_user_roles_invoice_rights
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;

	DELETE FROM
		apad_user_role_position_categories
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;

	DELETE FROM
		apad_user_roles
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_userroles_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_userroles_list`(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		user_role_id,
		user_role_name,
		is_admin_role,
		allow_routing_setup,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apad_user_roles
	WHERE
		company_code = company_code_param;

	SELECT
		company_code,
		user_role_id,
		position_category_code,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apad_user_role_position_categories
	WHERE
		company_code = company_code_param;

	SELECT
		dt_ur.company_code,
		dt_ur.user_role_id,
		dt_ur.model_def_id,
		IFNULL(urir.allow_non_mapped_invoices_request_processing, 'N') AS allow_non_mapped_invoices_request_processing,
		IFNULL(urir.allow_invoice_model_mapping, 'N') AS allow_invoice_model_mapping,
		IFNULL(urir.allow_invoice_auto_routing, 'N') AS allow_invoice_auto_routing,
		IFNULL(urir.allow_invoice_manual_processing, 'N') AS allow_invoice_manual_processing,
		IFNULL(urir.allow_invoice_document_management, 'N') AS allow_invoice_document_management,
		IFNULL(urir.allow_invoice_correction, 'N') AS allow_invoice_correction,
		IFNULL(urir.allow_invoice_level_1_approval, 'N') AS allow_invoice_level_1_approval,
		IFNULL(urir.allow_invoice_level_2_approval, 'N') AS allow_invoice_level_2_approval,
		IFNULL(urir.allow_invoice_level_3_approval, 'N') AS allow_invoice_level_3_approval,
		IFNULL(urir.allow_invoice_level_4_approval, 'N') AS allow_invoice_level_4_approval,
		IFNULL(urir.allow_invoice_level_5_approval, 'N') AS allow_invoice_level_5_approval
	FROM
		(
		SELECT
			ur.user_role_id,
			ur.company_code,
			md.model_def_id
		FROM
			qa_apautomation_common.apai_model_def md
			CROSS JOIN apad_user_roles ur
		) dt_ur
		LEFT OUTER JOIN apad_user_roles_invoice_rights urir ON urir.user_role_id = dt_ur.user_role_id AND urir.model_def_id = dt_ur.model_def_id AND urir.company_code = dt_ur.company_code
	WHERE
		dt_ur.company_code = company_code_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_userroles_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_userroles_update`(
	IN company_code_param			INT,
	IN user_role_id_param			INT,
	IN user_role_name_param			VARCHAR(64),
	IN is_admin_role_param			CHAR(1),
	IN allow_routing_setup_param	CHAR(1),
	IN modify_id_param				VARCHAR(32),
	IN modify_date_param			DATETIME
)
BEGIN
	UPDATE
		apad_user_roles
	SET
		user_role_name		= user_role_name_param,
		is_admin_role		= is_admin_role_param,
		allow_routing_setup = allow_routing_setup_param,
		modify_id			= modify_id_param,
		modify_date			= modify_date
	WHERE
		company_code = company_code_param
		AND user_role_id = user_role_id_param;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_user_roles_resource_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_user_roles_resource_add`(

	IN company_code_param   INT,

	IN user_role_id_param	INT,

	IN resource_id_param    CHAR(16),

	IN create_id_param      VARCHAR(32),

	IN create_date_param    DATETIME

)
BEGIN

	INSERT INTO apad_user_roles_resource

	(

		company_code,

		user_role_id,

		resource_id,

		create_id,

		create_date

	)

	SELECT

		company_code_param,

		user_role_id_param,

		resource_id_param,

		create_id_param,

		create_date_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_user_roles_resource_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_user_roles_resource_delete`(

	IN company_code_param   INT,

	IN resource_id_param    CHAR(16)

)
BEGIN

	DELETE

	FROM

		apad_user_roles_resource

	WHERE

		company_code = company_code_param

		AND resource_id = resource_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_user_roles_resource_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_user_roles_resource_get`(

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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_user_role_position_categories_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_user_role_position_categories_add`(

	IN company_code_param   INT,

	IN user_role_id_param	INT,

	IN position_category_code_param    INT,

	IN create_id_param      VARCHAR(32),

	IN create_date_param    DATETIME

)
BEGIN

	INSERT INTO apad_user_role_position_categories

	(

		company_code,

		user_role_id,

		position_category_code,

		create_id,

		create_date

	)

	SELECT

		company_code_param,

		user_role_id_param,

		position_category_code_param,

		create_id_param,

		create_date_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_user_role_position_categories_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_user_role_position_categories_delete`(

	IN company_code_param   INT,

	IN user_role_id_param	INT

)
BEGIN

	DELETE

	FROM

		apad_user_role_position_categories

	WHERE

		company_code = company_code_param

		AND user_role_id = user_role_id_param;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_vendor_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `apas_vendor_list`(
	IN company_code_param INT
)
BEGIN
	SELECT
		company_code,
		vendor_code,
		site_id,
		vendor_name,
		short_name,
		addr1,
		addr2,
		addr3,
		addr4,
		addr5,
		addr6,
		attention_name,
		attention_phone,
		contact_name,
		contact_phone,
		email,
		phone_1,
		phone_2,
		tax_code,
		terms_code,
		currency_code,
		vendor_status_id,
		no_po_flag
	FROM
		apad_vendors
	WHERE
		company_code = company_code_param
	ORDER BY
		vendor_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apas_vendor_save` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE  PROCEDURE `apas_vendor_save`(
	valuesCSV           VARCHAR(65535),
	update_date_param   DATETIME
)
BEGIN
	DECLARE company_code_param INT;

	DROP TEMPORARY TABLE IF EXISTS _temp;

	CREATE TEMPORARY TABLE _temp
	(
		company_code        INT,
		vendor_code         VARCHAR(12),
		site_id             VARCHAR(32),
		vendor_name         VARCHAR(256),
		addr1               VARCHAR(64),
		addr2               VARCHAR(64),
		addr3               VARCHAR(64),
		addr4               VARCHAR(64),
		addr5               VARCHAR(64),
		addr6               VARCHAR(64),
		short_name          VARCHAR(128),
		attention_name      VARCHAR(64),
		attention_phone	    VARCHAR(32),
		contact_name        VARCHAR(64),
		contact_phone       VARCHAR(32),
		email               VARCHAR(128),
		phone_1             VARCHAR(32),
		phone_2             VARCHAR(32),
		tax_code            VARCHAR(16),
		terms_code          VARCHAR(64),
		currency_code       CHAR(8),
		vendor_status_id    INT,
		no_po_flag          CHAR(1)
	);

	SET @query = CONCAT('INSERT INTO _temp
	(
		company_code,
		vendor_code,
		site_id,
		vendor_name,
		short_name,
		addr1,
		addr2,
		addr3,
		addr4,
		addr5,
		addr6,
		attention_name,
		attention_phone,
		contact_name,
		contact_phone,
		email,
		phone_1,
		phone_2,
		tax_code,
		terms_code,
		currency_code,
		vendor_status_id,
		no_po_flag
	) VALUES', valuesCSV, ';');

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	UPDATE
		apad_vendors v
	INNER JOIN _temp t ON t.vendor_code = v.vendor_code
						AND t.site_id = v.site_id
						AND t.company_code = v.company_code
	SET
		v.vendor_name       = t.vendor_name,
		v.short_name        = t.short_name,
		v.addr1             = t.addr1,
		v.addr2             = t.addr2,
		v.addr3             = t.addr3,
		v.addr4             = t.addr4,
		v.addr5             = t.addr5,
		v.addr6             = t.addr6,
		v.attention_name    = t.attention_name,
		v.attention_phone   = t.attention_phone,
		v.contact_name      = t.contact_name,
		v.contact_phone     = t.contact_phone,
		v.email             = t.email,
		v.phone_1           = t.phone_1,
		v.phone_2           = t.phone_2,
		v.tax_code          = t.tax_code,
		v.terms_code        = t.terms_code,
		v.currency_code     = t.currency_code,
		v.vendor_status_id  = t.vendor_status_id,
		v.no_po_flag        = t.no_po_flag;

	INSERT INTO apad_vendors
	(
		company_code,
		vendor_code,
		site_id,
		vendor_name,
		short_name,
		addr1,
		addr2,
		addr3,
		addr4,
		addr5,
		addr6,
		attention_name,
		attention_phone,
		contact_name,
		contact_phone,
		email,
		phone_1,
		phone_2,
		tax_code,
		terms_code,
		currency_code,
		vendor_status_id,
		no_po_flag
	)
	SELECT
		t.company_code,
		t.vendor_code,
		t.site_id,
		t.vendor_name,
		t.short_name,
		t.addr1,
		t.addr2,
		t.addr3,
		t.addr4,
		t.addr5,
		t.addr6,
		t.attention_name,
		t.attention_phone,
		t.contact_name,
		t.contact_phone,
		t.email,
		t.phone_1,
		t.phone_2,
		t.tax_code,
		t.terms_code,
		t.currency_code,
		t.vendor_status_id,
		t.no_po_flag
	FROM
		_temp t
		LEFT OUTER JOIN apad_vendors v ON v.vendor_code = t.vendor_code
											AND v.site_id = t.site_id
											AND v.company_code = t.company_code
	WHERE
		v.vendor_code IS NULL;

	SET company_code_param = (SELECT company_code FROM _temp LIMIT 1);
	CALL apas_datalastupdated_update(company_code_param, 'apad_vendors', update_date_param);

	DROP TEMPORARY TABLE _temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_InvoiceDocument`
--

/*!50001 DROP TABLE IF EXISTS `v_InvoiceDocument`*/;
/*!50001 DROP VIEW IF EXISTS `v_InvoiceDocument`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_InvoiceDocument` AS select `id`.`company_code` AS `company_code`,`id`.`invoice_document_id` AS `invoice_document_id`,`id`.`invoice_document_file_location` AS `invoice_document_file_location`,`id`.`invoice_document_status_id` AS `invoice_document_status_id`,`id`.`invoice_document_status_attribute` AS `invoice_document_status_attribute`,`id`.`duplicate_invoice_flag` AS `duplicate_invoice_flag`,`id`.`master_document_model_id` AS `master_document_model_id`,`id`.`document_model_request_id` AS `document_model_request_id`,`id`.`vendor_code` AS `vendor_code`,`id`.`site_id` AS `site_id`,`id`.`invoice_number` AS `invoice_number`,`id`.`invoice_date` AS `invoice_date`,`id`.`due_date` AS `due_date`,`id`.`service_term_start_date` AS `service_term_start_date`,`id`.`service_term_end_date` AS `service_term_end_date`,`id`.`payment_term_code` AS `payment_term_code`,`id`.`currency_code` AS `currency_code`,`id`.`po_code` AS `po_code`,`id`.`replaced_by_invoice_document_file_location` AS `replaced_by_invoice_document_file_location`,`id`.`transaction_id` AS `transaction_id`,`id`.`model_def_id` AS `model_def_id`,`id`.`create_id` AS `create_id`,`id`.`create_date` AS `create_date`,`id`.`modify_id` AS `modify_id`,`id`.`modify_date` AS `modify_date`,sum(`idd`.`io_invoice_amount`) AS `TotalAmount`,`mr`.`request_to_map` AS `request_to_map`,`mr`.`manual_processing` AS `manual_processing`,`sm`.`invoice_document_scan_status_id` AS `invoice_document_scan_status_id`,`sm`.`manual_upload_flag` AS `manual_upload_flag`,`pm`.`invoice_document_posting_status_id` AS `invoice_document_posting_status_id`,`pm`.`invoice_document_posting_error_message` AS `invoice_document_posting_error_message`,`v`.`vendor_name` AS `vendor_name`,`v`.`short_name` AS `short_name`,(select count(`apad_invoice_document_routing_history`.`sequence_id`) AS `routing_history_count` from `apad_invoice_document_routing_history` where ((`apad_invoice_document_routing_history`.`invoice_document_id` = `id`.`invoice_document_id`) and (`apad_invoice_document_routing_history`.`company_code` = `id`.`company_code`))) AS `routing_history_count` from (((((`apad_invoice_document` `id` left join `apad_invoice_document_detail` `idd` on(((`idd`.`invoice_document_id` = `id`.`invoice_document_id`) and (`idd`.`company_code` = `id`.`company_code`)))) left join `apam_document_model_request` `mr` on(((`mr`.`document_model_request_id` = `id`.`document_model_request_id`) and (`mr`.`company_code` = `id`.`company_code`) and (`mr`.`manual_processing` = 'Y') and (`mr`.`request_completed` = 'N')))) left join `apad_invoice_scanner_monitor` `sm` on(((`sm`.`invoice_document_file_location` = `id`.`invoice_document_file_location`) and (`sm`.`company_code` = `id`.`company_code`)))) left join `apad_invoice_posting_monitor` `pm` on(((`pm`.`invoice_document_id` = `id`.`invoice_document_id`) and (`pm`.`company_code` = `id`.`company_code`)))) left join `apad_vendors` `v` on(((`v`.`vendor_code` = `id`.`vendor_code`) and (`v`.`site_id` = `id`.`site_id`) and (`v`.`company_code` = `id`.`company_code`)))) where (`id`.`is_deleted` = false) group by `id`.`company_code`,`id`.`invoice_document_id`,`id`.`invoice_document_file_location`,`id`.`invoice_document_status_id`,`id`.`invoice_document_status_attribute`,`id`.`duplicate_invoice_flag`,`id`.`master_document_model_id`,`id`.`document_model_request_id`,`id`.`vendor_code`,`id`.`site_id`,`id`.`invoice_number`,`id`.`invoice_date`,`id`.`due_date`,`id`.`service_term_start_date`,`id`.`service_term_end_date`,`id`.`payment_term_code`,`id`.`currency_code`,`id`.`create_id`,`id`.`create_date`,`id`.`modify_id`,`id`.`modify_date`,`mr`.`request_to_map`,`mr`.`manual_processing`,`sm`.`invoice_document_scan_status_id`,`sm`.`manual_upload_flag`,`pm`.`invoice_document_posting_status_id`,`pm`.`invoice_document_posting_error_message`,`v`.`vendor_name`,`v`.`short_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_InvoiceModel`
--

/*!50001 DROP TABLE IF EXISTS `v_InvoiceModel`*/;
/*!50001 DROP VIEW IF EXISTS `v_InvoiceModel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_InvoiceModel` AS select `dmr`.`company_code` AS `company_code`,`dmr`.`document_model_request_id` AS `document_model_request_id`,`sm`.`invoice_document_file_location` AS `invoice_document_file_location`,`sm`.`manual_upload_flag` AS `manual_upload_flag`,ifnull(`dm`.`master_document_model_id`,0) AS `master_document_model_id`,`dm`.`document_model_name` AS `document_model_name`,`dm`.`document_model_name_tag` AS `document_model_name_tag`,ifnull(`dm`.`document_model_status_id`,0) AS `document_model_status_id`,`dm`.`document_model_is_active` AS `document_model_is_active`,`dm`.`invoice_document_sample_file_location` AS `invoice_document_sample_file_location`,ifnull(`id`.`invoice_document_id`,0) AS `invoice_document_id`,`v`.`vendor_code` AS `vendor_code`,`v`.`vendor_name` AS `vendor_name`,`v`.`short_name` AS `short_name`,`v`.`site_id` AS `site_id`,ifnull(`vs`.`vendor_status_id`,0) AS `vendor_status_id`,`vs`.`vendor_status_name` AS `vendor_status_name` from (((((`apam_document_model_request` `dmr` join `apad_invoice_scanner_monitor` `sm` on(((`sm`.`scanner_monitor_record_id` = `dmr`.`scanner_monitor_record_id`) and (`sm`.`company_code` = `dmr`.`company_code`)))) left join `apam_document_model` `dm` on(((`dm`.`invoice_document_sample_file_location` = `sm`.`invoice_document_file_location`) and (`dm`.`company_code` = `dmr`.`company_code`)))) left join `apad_invoice_document` `id` on(((`id`.`document_model_request_id` = `dmr`.`document_model_request_id`) and (`id`.`company_code` = `dmr`.`company_code`)))) left join `apad_vendors` `v` on(((`v`.`vendor_code` = `dm`.`vendor_code`) and (`v`.`site_id` = `dm`.`site_id`) and (`v`.`company_code` = `dmr`.`company_code`)))) left join `apam_vendor_status` `vs` on(((`vs`.`vendor_status_id` = `v`.`vendor_status_id`) and (`vs`.`company_code` = `dmr`.`company_code`)))) where (`dmr`.`request_completed` = 'N') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_InvoiceModelByDocumentModel`
--

/*!50001 DROP TABLE IF EXISTS `v_InvoiceModelByDocumentModel`*/;
/*!50001 DROP VIEW IF EXISTS `v_InvoiceModelByDocumentModel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_InvoiceModelByDocumentModel` AS select `dmr`.`company_code` AS `company_code`,`dmr`.`document_model_request_id` AS `document_model_request_id`,`sm`.`invoice_document_file_location` AS `invoice_document_file_location`,`sm`.`manual_upload_flag` AS `manual_upload_flag`,`dm`.`master_document_model_id` AS `master_document_model_id`,`dm`.`document_model_name` AS `document_model_name`,`dm`.`document_model_name_tag` AS `document_model_name_tag`,`dm`.`document_model_status_id` AS `document_model_status_id`,ifnull(`mdm`.`is_active`,'N') AS `is_active`,`dm`.`invoice_document_sample_file_location` AS `invoice_document_sample_file_location`,`id`.`invoice_document_id` AS `invoice_document_id`,`v`.`vendor_code` AS `vendor_code`,`v`.`vendor_name` AS `vendor_name`,`v`.`short_name` AS `short_name`,`v`.`site_id` AS `site_id` from (((((`apam_document_model_request` `dmr` join `apad_invoice_scanner_monitor` `sm` on(((`sm`.`scanner_monitor_record_id` = `dmr`.`scanner_monitor_record_id`) and (`sm`.`company_code` = `dmr`.`company_code`)))) left join `apam_document_model` `dm` on(((`dm`.`invoice_document_sample_file_location` = `sm`.`invoice_document_file_location`) and (`dm`.`company_code` = `dmr`.`company_code`)))) left join `qa_apautomation_common`.`apam_master_document_model` `mdm` on((`mdm`.`master_document_model_id` = `dm`.`master_document_model_id`))) left join `apad_invoice_document` `id` on(((`id`.`document_model_request_id` = `dmr`.`document_model_request_id`) and (`id`.`company_code` = `dmr`.`company_code`)))) left join `apad_vendors` `v` on(((`v`.`vendor_code` = `dm`.`vendor_code`) and (`v`.`site_id` = `dm`.`site_id`)))) where ((`dmr`.`request_to_map` = 'Y') and (`dmr`.`request_completed` = 'N')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_InvoiceModelByMasterDocumentModel`
--

/*!50001 DROP TABLE IF EXISTS `v_InvoiceModelByMasterDocumentModel`*/;
/*!50001 DROP VIEW IF EXISTS `v_InvoiceModelByMasterDocumentModel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_InvoiceModelByMasterDocumentModel` AS select `dmr`.`company_code` AS `company_code`,`dmr`.`document_model_request_id` AS `document_model_request_id`,`sm`.`invoice_document_file_location` AS `invoice_document_file_location`,`sm`.`manual_upload_flag` AS `manual_upload_flag`,`mdm`.`master_document_model_id` AS `master_document_model_id`,`dm`.`document_model_name` AS `document_model_name`,`dm`.`document_model_name_tag` AS `document_model_name_tag`,`dm`.`document_model_status_id` AS `document_model_status_id`,`mdm`.`is_active` AS `is_active`,`dm`.`invoice_document_sample_file_location` AS `invoice_document_sample_file_location`,`id`.`invoice_document_id` AS `invoice_document_id`,`v`.`vendor_code` AS `vendor_code`,`v`.`vendor_name` AS `vendor_name`,`v`.`short_name` AS `short_name`,`v`.`site_id` AS `site_id` from (((((`apam_document_model_request` `dmr` join `apad_invoice_scanner_monitor` `sm` on(((`sm`.`scanner_monitor_record_id` = `dmr`.`scanner_monitor_record_id`) and (`sm`.`company_code` = `dmr`.`company_code`)))) join `apad_invoice_document` `id` on(((`id`.`document_model_request_id` = `dmr`.`document_model_request_id`) and (`id`.`company_code` = `dmr`.`company_code`)))) join `qa_apautomation_common`.`apam_master_document_model` `mdm` on((`mdm`.`master_document_model_id` = `id`.`master_document_model_id`))) left join `apam_document_model` `dm` on((`dm`.`master_document_model_id` = `mdm`.`master_document_model_id`))) left join `apad_vendors` `v` on(((`v`.`vendor_code` = `id`.`vendor_code`) and (`v`.`site_id` = `id`.`site_id`) and (`v`.`company_code` = `dmr`.`company_code`)))) where ((`dmr`.`request_to_map` = 'Y') and (`dmr`.`request_completed` = 'N') and (`dm`.`invoice_document_sample_file_location` <> `id`.`invoice_document_file_location`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_PODetail`
--

/*!50001 DROP TABLE IF EXISTS `v_PODetail`*/;
/*!50001 DROP VIEW IF EXISTS `v_PODetail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_PODetail` AS select `pd`.`company_code` AS `company_code`,`pd`.`po_code` AS `po_code`,`pd`.`level2_key` AS `level2_key`,`pd`.`level3_key` AS `level3_key`,`pd`.`cost_category` AS `cost_category`,sum(`pd`.`quantity`) AS `quantity`,sum(`pd`.`net_cost`) AS `net_cost`,sum(`pd`.`match_to_date_net`) AS `match_to_date_net`,(sum(`pd`.`net_cost`) - sum(`pd`.`match_to_date_net`)) AS `remaining_amount`,`l2`.`customer_name` AS `customer_name`,`l2`.`level2_description` AS `level2_description`,`l2`.`po_required_flag` AS `po_required_flag`,`l2`.`tolerance_po_amount` AS `tolerance_po_amount`,`l2`.`tolerance_po_flag` AS `tolerance_po_flag` from ((`apad_po_detail` `pd` join `apad_level2` `l2` on(((`l2`.`company_code` = `pd`.`company_code`) and (`l2`.`level2_key` = `pd`.`level2_key`) and (`l2`.`level2_status_id` = 1)))) join `apad_level3` `l3` on(((`l3`.`company_code` = `pd`.`company_code`) and (`l3`.`level2_key` = `pd`.`level2_key`) and (`l3`.`level3_key` = `pd`.`level3_key`) and (`l3`.`level3_status_id` = 1)))) where (`pd`.`close_flag` = 0) group by `pd`.`company_code`,`pd`.`po_code`,`pd`.`level2_key`,`pd`.`level3_key`,`pd`.`cost_category`,`l2`.`customer_name`,`l2`.`level2_description`,`l2`.`po_required_flag`,`l2`.`tolerance_po_amount`,`l2`.`tolerance_po_flag` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ResourcesByInvoiceDocument`
--

/*!50001 DROP TABLE IF EXISTS `v_ResourcesByInvoiceDocument`*/;
/*!50001 DROP VIEW IF EXISTS `v_ResourcesByInvoiceDocument`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_ResourcesByInvoiceDocument` AS select distinct `r`.`company_code` AS `company_code`,`r`.`resource_id` AS `resource_id`,`r`.`name_last` AS `name_last`,`r`.`name_first` AS `name_first`,`r`.`name_init` AS `name_init`,`r`.`title` AS `title`,`r`.`email` AS `email`,`r`.`login_id` AS `login_id`,`r`.`res_password` AS `res_password`,`r`.`active_flag` AS `active_flag`,`r`.`create_id` AS `create_id`,`r`.`create_date` AS `create_date`,`r`.`modify_date` AS `modify_date`,`r`.`modify_id` AS `modify_id`,`id`.`invoice_document_id` AS `invoice_document_id`,`id`.`invoice_document_status_id` AS `invoice_document_status_id`,`id`.`model_def_id` AS `model_def_id`,`pc`.`position_category_code` AS `position_category_code`,`pc`.`position_category_name` AS `position_category_name`,`pc`.`protected_role_flag` AS `protected_role_flag` from ((((`apad_invoice_document` `id` join `apad_invoice_document_detail` `idd` on(((`idd`.`invoice_document_id` = `id`.`invoice_document_id`) and (`idd`.`company_code` = `id`.`company_code`)))) join `apad_po_resources` `por` on(((`por`.`po_code` = `idd`.`io_number`) and (`por`.`company_code` = `idd`.`company_code`)))) join `apad_resources` `r` on(((`r`.`resource_id` = `por`.`resource_id`) and (`r`.`company_code` = `por`.`company_code`)))) join `apam_position_category` `pc` on(((`pc`.`position_category_code` = `por`.`position_category_code`) and (`pc`.`company_code` = `por`.`company_code`)))) where ((`id`.`is_deleted` = 0) and (`id`.`model_def_id` = 1)) union select distinct `r`.`company_code` AS `company_code`,`r`.`resource_id` AS `resource_id`,`r`.`name_last` AS `name_last`,`r`.`name_first` AS `name_first`,`r`.`name_init` AS `name_init`,`r`.`title` AS `title`,`r`.`email` AS `email`,`r`.`login_id` AS `login_id`,`r`.`res_password` AS `res_password`,`r`.`active_flag` AS `active_flag`,`r`.`create_id` AS `create_id`,`r`.`create_date` AS `create_date`,`r`.`modify_date` AS `modify_date`,`r`.`modify_id` AS `modify_id`,`id`.`invoice_document_id` AS `invoice_document_id`,`id`.`invoice_document_status_id` AS `invoice_document_status_id`,`id`.`model_def_id` AS `model_def_id`,`pc`.`position_category_code` AS `position_category_code`,`pc`.`position_category_name` AS `position_category_name`,`pc`.`protected_role_flag` AS `protected_role_flag` from ((((`apad_invoice_document` `id` join `apad_invoice_document_detail` `idd` on(((`idd`.`invoice_document_id` = `id`.`invoice_document_id`) and (`idd`.`company_code` = `id`.`company_code`)))) join `apad_level2_resources` `l2r` on(((`l2r`.`level2_key` = `idd`.`level2_key`) and (`l2r`.`company_code` = `idd`.`company_code`)))) join `apad_resources` `r` on(((`r`.`resource_id` = `l2r`.`resource_id`) and (`r`.`company_code` = `l2r`.`company_code`)))) join `apam_position_category` `pc` on(((`pc`.`position_category_code` = `l2r`.`position_category_code`) and (`pc`.`company_code` = `l2r`.`company_code`)))) where ((`id`.`is_deleted` = 0) and (`id`.`model_def_id` = 2)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_lookup_apam_currencies`
--

/*!50001 DROP TABLE IF EXISTS `v_lookup_apam_currencies`*/;
/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_currencies`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_lookup_apam_currencies` AS select 1 AS `apa_code`,1 AS `erp_code` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_lookup_apam_payment_terms`
--

/*!50001 DROP TABLE IF EXISTS `v_lookup_apam_payment_terms`*/;
/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_payment_terms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_lookup_apam_payment_terms` AS select 1 AS `apa_code`,1 AS `erp_code` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;*/
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-04 15:05:59
