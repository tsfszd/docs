

use iPC_82
go

-- New TradeDesk Client Integration

begin tran
declare @access_tag varchar(256) = 'Facebook_PROD_Loc'
declare @ipc_name varchar(256) = 'Facebook Location Production'

declare @fb_access_token varchar(max) = 'EAAIkF2P5Nd4BADe5dutBobEWN3Y6FpNYaH7P0rCBbI6ppkYDzEkugDo1UC2kZAtRjXGRpjkVoaJbhB4RkBVxRQq5wBXXV4HBTmAMeW1kDHbxwFVlBaQMODIH25X0k4XiLCFV7hUfYZCCZASgZCZBl3gZAUkfU8wzbRZAPtIlnCr63CVr69IEpzOmIWI76KEkWVL4uUb6vSbKQZDZD'

declare @ad_tool_name varchar(64) = 'Facebook Ad'
declare @consumer_name varchar(64) = 'Paradigm Test' -- both can be different
DECLARE @consumer_account varchar(64) = '501'-- Will be used only if not account exist against the conusmer


declare @user_account_ID varchar(64) = 'FacebookCampaignImporter'
declare @user_account_Name varchar(64) = 'Facebook Campaign Importer Nexelus - Nex Test'



--3A. Add Consumer if not exists
IF NOT EXISTS(SELECT 1 FROM pdm_consumer WHERE NAME = @consumer_name)
BEGIN
	INSERT INTO pdm_consumer
	([name],[consumer_type_id],[cat_code_01_id],[cat_code_02_id],[cat_code_03_id],[cat_code_04_id],[cat_code_05_id],[cat_code_06_id],[cat_code_07_id],[cat_code_08_id],[cat_code_09_id],[cat_code_10_id],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@consumer_name,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',getdate(),NULL,CONVERT(datetime,NULL,121))
	;
END



--3A. Get consumer account
declare @account_id varchar(6) = (select top 1 account_id from pdm_consumer_account where consumer_id in (select consumer_id from pdm_consumer where name = @consumer_name))


--3A. Add consumer account if it doesn't exist.
IF ISNULL(@account_id, '') = ''
BEGIN
	DECLARE @consuemr_ID varchar(64) = (select consumer_id from pdm_consumer where name = @consumer_name)
	INSERT INTO pdm_consumer_account
	([account_id],[consumer_id],[eff_date],[exp_date],[payment_method_id],[payment_terms_id],[billing_address_seq_id],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@consumer_account,@consuemr_ID, getdate(), CONVERT(datetime,'2030-12-31 00:00:00.000',121),NULL,NULL,NULL,N'sys',getdate(),NULL,NULL)
	;
END


 
 --3A. Add user against the consumer account.
 IF NOT EXISTS (SELECT 1 FROM pdm_account_user WHERE account_id = @account_id and [user_id] = @user_account_ID)
 BEGIN
	SET NOCOUNT ON
	INSERT INTO pdm_account_user
	([account_id],[user_id],[user_name],[password],[is_active],[dev_token],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@account_id, @user_account_ID, @user_account_Name, N'584432EE5DE8F4DE398C1D914371DB3D',1,N'3333',N'system',getdate(),NULL,NULL)
	;
END
 


declare @ad_tool_id int = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)

 --3A. Insert Ad tool if it doesn't exist.
 IF ISNULL(@ad_tool_id, 0) = 0
 BEGIN
	INSERT INTO pdim_ad_tool
	([orig_name],[orig_version],[ipc_name],[ipc_description],[ad_tool_category],[is_active],[ipc_connector_dll_name],[ipc_connector_dll_description],[ipc_connector_dll_is_active],[ipc_connector_dll_version],[ipc_connector_dll_release_date],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@ad_tool_name, N'V 1.0',@ad_tool_name, NULL,2,1,N'FacebookConnector_v1.dll',NULL,1,N'1.0.0', getdate(),N'SYS',getdate(),NULL,CONVERT(datetime,NULL,121))
	;
END

select * from pdm_account_ad_tool where account_id = @account_id AND ad_tool_id = @ad_tool_id

SET @ad_tool_id = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)
declare @seq_id int = (select max(seq_id) + 1 from pdm_account_ad_tool where account_id = @account_id AND ad_tool_id = @ad_tool_id)

IF ISNULL(@seq_id, 0) = 0
	SET @seq_id = 1

--select @account_id, @ad_tool_id, @seq_id

SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool
([account_id],[ad_tool_id],[seq_id],[access_tag],[ipc_name],[ipc_description],[eff_date],[exp_date],[is_primary],[comment],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,@access_tag,@ipc_name,NULL,GETDATE(),CONVERT(datetime,'2030-12-31 00:00:00.000',121),0,NULL,N'sys',GETDATE())
;
 

 SET NOCOUNT ON
INSERT INTO pdm_account_user_ad_tool
([account_id],[ad_tool_id],[seq_id],[user_id],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,@user_account_ID ,N'sys',GETDATE()) -- ONLY CHANGE IF REQUIRED ELSE LEAVE IT AS IS.
;
 
 IF NOT EXISTS(SELECT 1 FROM pdi_table_lookup where [entity_name] = 'AD_TOOL_API_ACCESS' AND ENTITY_CODE = 'OAUTH20_ACCESS_TOKEN')
 BEGIN
	 INSERT INTO pdi_table_lookup
	([entity_name],[entity_id],[entity_code],[description],[comments],[is_list])
	VALUES
	 ('AD_TOOL_API_ACCESS',23,N'OAUTH20_ACCESS_TOKEN',N'Access token for Facebook',N'Use for Facebook Ad',0)
 END


 SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool_api_access
([account_id],[ad_tool_id],[seq_id],[api_access_property_id],[api_access_property_value],[api_access_property_info1],[api_access_property_info2],[api_access_property_info3],[api_access_property_info4],[api_access_property_info5],[api_access_property_info6],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,23,@fb_access_token,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE())

;
 


 --select * from pdm_account_ad_tool where account_id = @account_id
--select * from pdm_account_ad_tool_api_access where account_id = @account_id and seq_id = @seq_id
--select * from pdm_account_user_ad_tool where account_id = @account_id and seq_id = @seq_id

-- SP CALL VALIDATES THE ACCOUNT
-- RETURN 0 AS ERROR_CODE IN CASE OF SUCCESS 
exec sp_validate_login_attempt @account_id, @user_account_ID, '584432EE5DE8F4DE398C1D914371DB3D', 'dummy', @ad_tool_id, @access_tag

rollback



