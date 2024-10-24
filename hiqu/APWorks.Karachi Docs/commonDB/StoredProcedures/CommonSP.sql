DELIMITER $$
DROP PROCEDURE IF EXISTS apas_domain_list;$$

CREATE PROCEDURE apas_domain_list(
)
BEGIN
	SELECT
		ent_domain_name,
		ent_record_id,
		active_flag,
		sso_type,
		sso_login_url,
		sso_logout_url,
		callback_url,
		signing_authority_certificate,
		client_logo,
		create_id,
		create_date,
		modify_id,
		modify_date 
	FROM
		ent_domain
	WHERE
		active_flag = 1;

	SELECT
		ent_record_id,
		ent_client_name,
		active_flag,
		db_schema_name,
		db_hostname,
		db_port,
		db_username,
		db_password,
		db_password_access_attributes,
		db_connection_attributes,
		saml_enabled_flag,
		saml_provider_name,
		saml_idp_id,
		saml_attributes,
		client_key,
		client_secret,
		erp_url,
		system_type,
		create_id,
		create_date, 
		modify_id,
		modify_date
	FROM
		ent_client
	WHERE
		active_flag = 1;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_add;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_add(
	IN master_document_model_id_param             INT UNSIGNED,
	IN master_document_model_field_id_param       INT UNSIGNED,
	IN master_document_model_field_seq_id_param   INT UNSIGNED,
	IN model_def_field_source_id_param            INT UNSIGNED,
	IN model_def_field_alignment_type_id_param    INT UNSIGNED,
	IN model_def_field_parse_type_id_param        INT UNSIGNED,
	IN block_id_param                             VARCHAR(38),
	IN field_format_param                         VARCHAR(128),
	IN classifier_text_param                      VARCHAR(128),
	IN page_number_param                          INT UNSIGNED,
	IN table_number_param                         INT UNSIGNED,
	IN table_row_index_param                      INT UNSIGNED,
	IN table_col_index_param                      INT UNSIGNED,
	IN boundingbox_left_param                     DECIMAL(24,20),
	IN boundingbox_top_param                      DECIMAL(24,20),
	IN boundingbox_width_param                    DECIMAL(24,20),
	IN boundingbox_height_param                   DECIMAL(24,20),
	IN confidence_level_param                     DECIMAL(24,20),
	IN internal_comment_param                     VARCHAR(1024)
)
BEGIN
	INSERT INTO apam_master_document_model_field_detail
	(
		master_document_model_id,
		master_document_model_field_id,
		master_document_model_field_seq_id,
		model_def_field_source_id,
		model_def_field_alignment_type_id,
		model_def_field_parse_type_id,
		block_id,
		field_format,
		classifier_text,
		page_number,
		table_number,
		table_row_index,
		table_col_index,
		boundingbox_left,
		boundingbox_top,
		boundingbox_width,
		boundingbox_height,
		confidence_level,
		internal_comment
	)
	SELECT
		master_document_model_id_param,
		master_document_model_field_id_param,
		master_document_model_field_seq_id_param,
		model_def_field_source_id_param,
		model_def_field_alignment_type_id_param,
		model_def_field_parse_type_id_param,
		block_id_param,
		field_format_param,
		classifier_text_param,
		page_number_param,
		table_number_param,
		table_row_index_param,
		table_col_index_param,
		boundingbox_left_param,
		boundingbox_top_param,
		boundingbox_width_param,
		boundingbox_height_param,
		confidence_level_param,
		internal_comment_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_delete;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_delete(
	IN master_document_model_id_param INT UNSIGNED
)
BEGIN
	DELETE FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_list;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_list(
	IN model_def_id_param   INT UNSIGNED
)
BEGIN
	SELECT
		d.master_document_model_id,
		d.master_document_model_field_id,
		d.master_document_model_field_seq_id,
		d.model_def_field_source_id,
		d.model_def_field_alignment_type_id,
		d.model_def_field_parse_type_id,
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
		f.model_def_field_id,
		mfd.model_def_field_weightage,
		md.model_def_recognition_threshold
	FROM
		apam_master_document_model_field_detail d
		INNER JOIN apam_master_document_model_field f ON f.master_document_model_id = d.master_document_model_id
													AND d.master_document_model_field_id = f.master_document_model_field_id
		INNER JOIN apam_master_document_model m ON m.master_document_model_id = f.master_document_model_id
													AND m.model_def_id = f.model_def_id
		INNER JOIN apai_model_field_def mfd ON mfd.model_def_field_id = f.model_def_field_id
												AND mfd.model_def_id = f.model_def_id
		INNER JOIN apai_model_def md ON md.model_def_id = f.model_def_id
	WHERE
		f.model_def_id = model_def_id_param
		AND m.is_active = 'Y';
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfielddetail_update;$$

CREATE PROCEDURE apas_masterdocumentmodelfielddetail_update(
	IN master_document_model_id_param             INT UNSIGNED,
	IN master_document_model_field_id_param       INT UNSIGNED,
	IN master_document_model_field_seq_id_param   INT UNSIGNED,
	IN model_def_field_source_id_param            INT UNSIGNED,
	IN model_def_field_alignment_type_id_param    INT UNSIGNED,
	IN model_def_field_parse_type_id_param        INT UNSIGNED,
	IN block_id_param                             VARCHAR(38),
	IN field_format_param                         VARCHAR(128),
	IN classifier_text_param                      VARCHAR(128),
	IN page_number_param                          INT UNSIGNED,
	IN table_number_param                         INT UNSIGNED,
	IN table_row_index_param                      INT UNSIGNED,
	IN table_col_index_param                      INT UNSIGNED,
	IN boundingbox_left_param                     DECIMAL(24,20),
	IN boundingbox_top_param                      DECIMAL(24,20),
	IN boundingbox_width_param                    DECIMAL(24,20),
	IN boundingbox_height_param                   DECIMAL(24,20),
	IN confidence_level_param                     DECIMAL(24,20),
	IN internal_comment_param                     VARCHAR(1024)
)
BEGIN
	DELETE
	FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param;

	CALL apas_masterdocumentmodelfielddetail_add
	(
		master_document_model_id_param,
		master_document_model_field_id_param,
		master_document_model_field_seq_id_param,
		model_def_field_source_id_param,
		model_def_field_alignment_type_id_param,
		model_def_field_parse_type_id_param,
		block_id_param,
		field_format_param,
		classifier_text_param,
		page_number_param,
		table_number_param,
		table_row_index_param,
		table_col_index_param,
		boundingbox_left_param,
		boundingbox_top_param,
		boundingbox_width_param,
		boundingbox_height_param,
		confidence_level_param,
		internal_comment_param
	);
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfield_add;$$

CREATE PROCEDURE apas_masterdocumentmodelfield_add(
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN model_def_field_id_param             INT UNSIGNED,
	IN model_def_field_parse_type_id_param  INT UNSIGNED
)
BEGIN
	INSERT INTO apam_master_document_model_field
	(
		master_document_model_id,
		master_document_model_field_id,
		model_def_id,
		model_def_field_id,
		model_def_field_parse_type_id
	)
	SELECT
		master_document_model_id_param,
		master_document_model_field_id_param,
		model_def_id_param,
		model_def_field_id_param,
		model_def_field_parse_type_id_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodelfield_update;$$

CREATE PROCEDURE apas_masterdocumentmodelfield_update(
	IN master_document_model_id_param       INT UNSIGNED,
	IN master_document_model_field_id_param INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN model_def_field_id_param             INT UNSIGNED,
	IN model_def_field_parse_type_id_param  INT UNSIGNED
)
BEGIN
	UPDATE
		apam_master_document_model_field
	SET
		model_def_id                     = model_def_id_param,
		model_def_field_id               = model_def_field_id_param,
		model_def_field_parse_type_id    = model_def_field_parse_type_id_param
	WHERE
		master_document_model_id            = master_document_model_id_param
		AND master_document_model_field_id  = master_document_model_field_id_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_add;$$

CREATE PROCEDURE apas_masterdocumentmodel_add(
	INOUT master_document_model_id_param    INT UNSIGNED,
	IN model_def_id_param                   INT UNSIGNED,
	IN master_document_model_comments_param	VARCHAR(512),
	IN is_active_param                      CHAR(1),
	IN create_id_param                      VARCHAR(32),
	IN create_date_param                    DATETIME
)
BEGIN
	SET master_document_model_id_param = (SELECT MAX(master_document_model_id) + 1 FROM apam_master_document_model);

	IF ISNULL(master_document_model_id_param) THEN
		SET master_document_model_id_param = 1;
    END IF;
    
	INSERT INTO apam_master_document_model
	(
		master_document_model_id,
		model_def_id,
		master_document_model_comments,
		is_active,
		create_id,
		create_date
	)
	SELECT
		master_document_model_id_param,
		model_def_id_param,
		master_document_model_comments_param,
		is_active_param,
		create_id_param,
		create_date_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_get;$$

CREATE PROCEDURE apas_masterdocumentmodel_get(
	IN master_document_model_id_param INT
)
BEGIN
	SELECT
		master_document_model_id,
		model_def_id,
		master_document_model_comments,
		is_active,
		create_id,
		create_date,
		modify_id,
		modify_date
	FROM
		apam_master_document_model
	WHERE
		master_document_model_id = master_document_model_id_param;

	SELECT
		master_document_model_id,
		master_document_model_field_id,
		model_def_id,
		model_def_field_id,
		model_def_field_parse_type_id
	FROM
		apam_master_document_model_field
	WHERE
		master_document_model_id = master_document_model_id_param;

	SELECT
		master_document_model_id,
		master_document_model_field_id,
		master_document_model_field_seq_id,
		model_def_field_source_id,
		model_def_field_alignment_type_id,
        model_def_field_parse_type_id,
        block_id,
		field_format,
		classifier_text,
		page_number,
		table_number,
		table_row_index,
		table_col_index,
		boundingbox_left,
		boundingbox_top,
		boundingbox_width,
		boundingbox_height,
		confidence_level,
		internal_comment
	FROM
		apam_master_document_model_field_detail
	WHERE
		master_document_model_id = master_document_model_id_param;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_setactive;$$

CREATE PROCEDURE apas_masterdocumentmodel_setactive(
	IN master_document_model_id_param         INT UNSIGNED,
	IN model_def_id_param                     INT UNSIGNED,
	IN is_active_param                        CHAR(1),
	IN modify_id_param                        VARCHAR(32),
	IN modify_date_param                      DATETIME
)
BEGIN
	UPDATE
		apam_master_document_model
	SET
		is_active                       = is_active_param,
		modify_id                       = modify_id_param,
		modify_date                     = modify_date_param
	WHERE
		master_document_model_id    = master_document_model_id_param
		AND model_def_id            = model_def_id_param
		AND is_active <> 'Y';
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS apas_masterdocumentmodel_update;$$

CREATE PROCEDURE apas_masterdocumentmodel_update(
	IN master_document_model_id_param         INT UNSIGNED,
	IN model_def_id_param                     INT UNSIGNED,
	IN master_document_model_comments_param   VARCHAR(512),
	IN is_active_param                        CHAR(1),
	IN modify_id_param                        VARCHAR(32),
	IN modify_date_param                      DATETIME
)
BEGIN
	UPDATE
		apam_master_document_model
	SET
		master_document_model_comments  = master_document_model_comments_param,
		is_active                       = CASE WHEN is_active = 'Y' THEN 'Y' ELSE is_active_param END,
		modify_id                       = modify_id_param,
		modify_date                     = modify_date_param
	WHERE
		master_document_model_id    = master_document_model_id_param
		AND model_def_id            = model_def_id_param;
END$$
DELIMITER ;

