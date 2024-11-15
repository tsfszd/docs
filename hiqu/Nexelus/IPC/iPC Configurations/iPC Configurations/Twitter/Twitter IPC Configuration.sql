

declare @account_id varchar(128) = '106'
declare @ad_tool_id int 

declare @access_tag varchar(256) = 'Twitter_360i_PROD'
declare @ipc_name varchar(256) = 'Twitter Production'
--Your key is like your username. It is used to verify who you are to Twitter.
declare @API_KEY varchar(1000) = '9laRrjKnzSKIOdVVVM0dAvyVT'; --1. API Consumer Key
declare @API_SECRET varchar(1000) = 'YLH8S9o2wEtr0eI1Ki7nvKeoT8Vgbve6mzR81VRgJAhXcrUb7d'; --2. Consumer Secret
declare @OAUTH20_CLIENT_ID varchar(1000) = '1349050182911062025-0gO9RQrp0lrINJKl6dH8hfK20Ht4kB'; --3. Access Token
declare @OAUTH20_CLIENT_SECRET varchar(1000) = 'WFCD6TgRZRrsjGCaDIzmfdWWQM20cEIfqnY7KzYa9b6me'; --4. Access Token Secret

declare @ad_tool_name varchar(64) = 'Twitter'

declare @user_account_ID varchar(64) = 'TwitterCampaignImporter'
declare @user_account_Name varchar(64) = 'Twitter Campaign Importer' 
declare @consumer_name varchar(64) = 'Paradigm Test' -- both can be different

begin tran


-- New Twitter Client Integration

--3A. Add Consumer if not exists
IF NOT EXISTS(SELECT 1 FROM pdm_consumer WHERE NAME = @consumer_name)
BEGIN
	INSERT INTO pdm_consumer
	([name],[consumer_type_id],[cat_code_01_id],[cat_code_02_id],[cat_code_03_id],[cat_code_04_id],[cat_code_05_id],[cat_code_06_id],[cat_code_07_id],[cat_code_08_id],[cat_code_09_id],[cat_code_10_id],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@consumer_name,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',getdate(),NULL,CONVERT(datetime,NULL,121))
	;
END
declare @consumer_id int = (select consumer_id from pdm_consumer where name = @consumer_name)



 IF NOT EXISTS (SELECT 1 FROM pdm_consumer_account WHERE account_id = @account_id) 
 BEGIN
INSERT INTO pdm_consumer_account
([account_id],[consumer_id],[eff_date],[exp_date],[payment_method_id],[payment_terms_id],[billing_address_seq_id],[create_id],[create_date],[modify_id],[modify_date])
VALUES
 (@account_id,@consumer_id,getdate(),getdate(),NULL,NULL,NULL,N'sys',getdate(),NULL,CONVERT(datetime,NULL,121))	;
END

if (@account_id= 'ACCOUNTID')
begin 
select 'invalid User ID'
Rollback
return
end

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

set @ad_tool_id = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)

 --3A. Insert Ad tool if it doesn't exist.
 IF ISNULL(@ad_tool_id, 0) = 0
 BEGIN
	INSERT INTO pdim_ad_tool
	([orig_name],[orig_version],[ipc_name],[ipc_description],[ad_tool_category],[is_active],[ipc_connector_dll_name],[ipc_connector_dll_description],[ipc_connector_dll_is_active],[ipc_connector_dll_version],[ipc_connector_dll_release_date],[create_id],[create_date],[modify_id],[modify_date])
	VALUES
	 (@ad_tool_name, N'V 7.0',@ad_tool_name, NULL,2,1,N'Twitter\\iPCTwitterConnector.dll',NULL,1,N'1.0.0', getdate(),N'SYS',getdate(),NULL,CONVERT(datetime,NULL,121))
	;
END

select * from pdm_account_ad_tool where account_id = @account_id AND ad_tool_id = @ad_tool_id

SET @ad_tool_id = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)
declare @seq_id int = (select isnull(max(seq_id),0) + 1 from pdm_account_ad_tool where account_id = @account_id AND ad_tool_id = @ad_tool_id)

IF ISNULL(@seq_id, 0) = 0
	SET @seq_id = 1



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
 
 IF NOT EXISTS(SELECT 1 FROM pdi_table_lookup where [entity_name] = 'AD_TOOL_API_ACCESS' AND ENTITY_CODE = 'OAUTH20_REFRESH_TOKEN')
 BEGIN

	 INSERT INTO pdi_table_lookup
	([entity_name],[entity_id],[entity_code],[description],[comments],[is_list])
	VALUES
	('AD_TOOL_API_ACCESS',24,N'API_KEY',N'API Key for Twitter',N'Use for Twitter',0),
	('AD_TOOL_API_ACCESS',26,N'API_SECRET',N'API Secret for Twitter',N'Use for Twitter',0),	 
	('AD_TOOL_API_ACCESS',10,N'OAUTH20_CLIENT_ID',N'AOAUTH20 CLIENT ID for Twitter',N'Use for Twitter',0),
	('AD_TOOL_API_ACCESS',11,N'OAUTH20_CLIENT_SECRET',N'OAUTH20 CLIENT SECRET for Twitter',N'Use for Twitter',0)
	END

 IF NOT EXISTS(SELECT 1 FROM pdim_ad_tool_api_access where ad_tool_id = @ad_tool_id)
 BEGIN
 INSERT INTO pdim_ad_tool_api_access
([ad_tool_id],[api_access_property_id],[display_order],[label],[help_description],[is_required],[create_id],[create_date],[modify_id],[modify_date])
VALUES
 (@ad_tool_id,24,4,N'API Key',N'',1,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@ad_tool_id,26,10,N'API Secret',N'',1,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@ad_tool_id,10,11,N'OAuth 2.0 Client ID',N'',1,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@ad_tool_id,11,12,N'OAuth 2.0 Client Secret',N'',1,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
;
 END
 select @account_id, @ad_tool_id, @seq_id
 SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool_api_access
([account_id],[ad_tool_id],[seq_id],[api_access_property_id],[api_access_property_value],[api_access_property_info1],[api_access_property_info2],[api_access_property_info3],[api_access_property_info4],[api_access_property_info5],[api_access_property_info6],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,24,@API_KEY,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE()),
 (@account_id,@ad_tool_id,@seq_id,26,@API_SECRET,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE()),
 (@account_id,@ad_tool_id,@seq_id,10,@OAUTH20_CLIENT_ID,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE()),
 (@account_id,@ad_tool_id,@seq_id,11,@OAUTH20_CLIENT_SECRET,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE());

------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (Select 1 from pdi_ad_tool_entity_category WHERE ad_tool_id=@ad_tool_id and  entity_category_code='AccountService')
INSERT INTO pdi_ad_tool_entity_category
([ad_tool_id],[entity_category_code],[entity_category_desc],[entity_category_type_id],[create_id],[create_date],[modify_id],[modify_date])
VALUES
 (@ad_tool_id,N'AccountService',N'Customer Account Service',3,N'system',getdate(),NULL,CONVERT(datetime,NULL,121))
,(@ad_tool_id,N'CampaignService',N'Campaign Service',1,N'system',getdate(),NULL,CONVERT(datetime,NULL,121))
,(@ad_tool_id,N'ReportingService',N'Reporting Service',2,N'system',getdate(),NULL,CONVERT(datetime,NULL,121))
;

IF NOT EXISTS (Select 1 from pdi_ad_tool_ipc_entity WHERE ad_tool_id=@ad_tool_id  and  entity_id=1) 
INSERT INTO pdi_ad_tool_ipc_entity
([ad_tool_id],[entity_id],[global_entity_id],[ad_tool_entity_name],[entity_category_code],[is_active],[create_id],[create_date],[modify_id],[modify_date],[configure_for_save],[sp_name])
VALUES
 (@ad_tool_id,1,1,N'Campaign',N'CampaignService',1,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),0,NULL)
,(@ad_tool_id,2,2,N'Campaign Performance Report',N'ReportingService',1,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),1,'')
,(@ad_tool_id,3,3,N'AccountInfo',N'AccountService',1,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),0,NULL)
;

IF NOT EXISTS (Select 1 from pdi_ad_tool_ipc_entity_element WHERE ad_tool_id=@ad_tool_id and entity_id=1  and element_id=1) 
INSERT INTO pdi_ad_tool_ipc_entity_element
([ad_tool_id],[entity_id],[element_id],[global_entity_id],[global_element_id],[order_id],[ad_tool_element_name],[element_description],[is_active],[element_data_type],[array_level],[is_sortable],[is_filterable],[allowed_filter_operators],[is_required],[read_only],[default_value],[create_id],[create_date],[modify_id],[modify_date],[param_name])
VALUES
 (@ad_tool_id,1,1,1,1,1,N'Id',N'ID of the campaign. This field is read only and should not be set while adding new Campaign. This field is required and should not be null while updating Camaign.',1,3,0,1,1,N'1,3',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,2,1,2,2,N'Name',N'Name of the campaign. On add, defaults to Campaign #N . This string must not be empty.',1,1,0,1,1,N'1,6',0,0,N'Campaign #N',N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,3,1,3,3,N'Status',N'Status of the campaign. On add, defaults to ACTIVE. ',1,7,0,0,1,N'1,3,4',0,0,N'ACTIVE',N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,4,NULL,NULL,4,N'StartDate',N'Date the campaign begins. On add, defaults to the current day in the parent account''s local timezone. The date''s format should be YYYY-MM-DD.',1,4,0,0,1,N'1,7,8,9',0,0,N'Today''s date',N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,5,NULL,NULL,5,N'EndDate',N'Date the campaign ends. On add, defaults to 2037-12-31, which means the campaign will run indefinitely. To set an existing campaign to run indefinitely, set this field to 2037-12-30 . The date''s format should be YYYY-MM-DD.',1,4,0,0,1,N'1,7,8,9',0,0,N'2037-12-31',N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,6,1,4,6,N'Budget.Amount',N'Amount of budget. This field must be greater than or equal to 1. This field is required and should not be null when adding Campaign.',1,5,0,0,0,NULL,1,0,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,7,NULL,NULL,7,N'DailyBudgetAmount',N'Amount of daily budget. This field must be greater than or equal to 1. This field is required and should not be null when adding Campaign.',1,5,0,0,0,NULL,1,0,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,8,NULL,NULL,8,N'POCode',N'PO Code for Campaign Invoice detail line is associated with.',1,1,0,1,1,NULL,1,0,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,1,9,NULL,NULL,9,N'CustomerId',N'The 10-digit ID that uniquely identifies the Twitter account.',1,1,0,0,1,N'1,3',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)

,(@ad_tool_id,2,1,NULL,NULL,30,N'Amount',N'Budget Amount',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'budget_amount')
,(@ad_tool_id,2,2,NULL,NULL,40,N'CampaignId',N'Campaign Id',1,3,0,0,1,N'1,3',0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'search_ad_tool_campaign_id')
,(@ad_tool_id,2,3,NULL,NULL,50,N'CampaignName',N'Campaign Name',1,1,0,1,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'campaign_name')
,(@ad_tool_id,2,4,NULL,NULL,60,N'Clicks',N'Clicks',1,3,0,1,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'number_of_clicks')
,(@ad_tool_id,2,5,NULL,NULL,70,N'Conversions',N'Conversions',1,3,0,1,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'number_of_conversions')
,(@ad_tool_id,2,6,NULL,NULL,80,N'Cost',N'Cost',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'cost_amt')
,(@ad_tool_id,2,7,NULL,NULL,90,N'Impressions',N'Impressions',1,3,0,1,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'number_of_impressions')
,(@ad_tool_id,2,8,NULL,NULL,100,N'Date',N'Date',1,4,0,1,1,N'7',0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'delivery_date')
,(@ad_tool_id,2,9,NULL,NULL,110,N'ConversionRate',N'Conv. rate (1-per-click)',1,6,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'conv_rate')
,(@ad_tool_id,2,10,NULL,NULL,120,N'CostPerConversion',N'Cost / conv. (1-per-click)',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,11,NULL,NULL,130,N'Ctr',N'CTR',1,6,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,12,NULL,NULL,140,N'Status',N'Campaign Status',1,7,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,13,NULL,NULL,150,N'TotalConvValue',N'Total conv. value',1,3,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,14,NULL,NULL,10,N'AccountId',N'Account ID',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'search_ad_tool_account_id')
,(@ad_tool_id,2,15,NULL,NULL,20,N'AccountDescriptiveName',N'Account Descriptive Name',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,16,NULL,NULL,5,N'CustomerId',N'The 10-digit ID that uniquely identifies the Twitter account.',1,1,0,1,1,N'1,3',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,17,NULL,NULL,160,N'AverageCpc',N'Avg. CPC',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'average_cpc')
,(@ad_tool_id,2,18,NULL,NULL,170,N'AverageCpm',N'Avg. CPM',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),'average_cpm')
,(@ad_tool_id,2,19,NULL,NULL,180,N'AveragePosition',N'Avg. position',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,20,NULL,NULL,190,N'BiddingStrategy',N'Bidding strategy',1,7,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,21,NULL,NULL,200,N'ClickType',N'Click type',1,7,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,22,NULL,NULL,210,N'ConversionOptimizerBidType',N'Conversion optimizer bid type',1,7,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,23,NULL,NULL,220,N'ConversionRateManyPerClick',N'Conv. rate (many-per-click)',1,6,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,24,NULL,NULL,230,N'ConversionsManyPerClick',N'Conv. (many-per-click)',1,3,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,25,NULL,NULL,240,N'CostPerConversionManyPerClick',N'Cost / conv. (many-per-click)',1,5,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,26,NULL,NULL,250,N'CustomerDescriptiveName',N'Client name',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,27,NULL,NULL,260,N'Device',N'Device',1,7,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,28,NULL,NULL,270,N'ExternalCustomerId',N'Customer ID',1,3,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,30,NULL,NULL,290,N'InvalidClickRate',N'Invalid Click Rate',1,6,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,31,NULL,NULL,300,N'InvalidClicks',N'Invalid Clicks',1,3,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,32,NULL,NULL,310,N'Month',N'Month',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,33,NULL,NULL,320,N'Period',N'Budget period',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,34,NULL,NULL,330,N'PrimaryCompanyName',N'Company name',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,2,35,NULL,NULL,340,N'PrimaryUserLogin',N'Login email',1,1,0,0,0,NULL,0,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,1,NULL,NULL,1,N'Name',N'The name used by the manager to refer to the client.',1,1,0,1,1,N'1',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,2,NULL,NULL,2,N'Login',N'The email address of the account''s first login user, if any.',1,1,0,1,1,N'1',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,3,NULL,NULL,3,N'CompanyName',N'The company name of the account, if any.',1,1,0,0,0,NULL,1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,4,NULL,NULL,4,N'CustomerId',N'The 10-digit ID that uniquely identifies the Twitter account.',1,3,0,1,1,N'1,3',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,5,NULL,NULL,5,N'CanManageClients',N'Whether this account can manage clients. ',1,8,0,0,1,N'1',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,6,NULL,NULL,6,N'CurrencyCode',N'The currency in which this account operates.',1,1,0,0,0,NULL,1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,7,NULL,NULL,7,N'DateTimeZone',N'The local timezone ID for this customer.',1,1,0,0,0,NULL,1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)
,(@ad_tool_id,3,8,NULL,NULL,8,N'ManagerCustomerId',N'The manager customer id if any.',1,3,0,0,1,N'1,3',1,1,NULL,N'system',getdate(),NULL,CONVERT(datetime,NULL,121),NULL)

IF NOT EXISTS (Select 1 from pdi_ad_tool_ipc_entity_alter_operation WHERE ad_tool_id=@ad_tool_id and  entity_id=1 and alter_operation_id=1) 
Insert into pdi_ad_tool_ipc_entity_alter_operation 
values(@ad_tool_id,1,1,'LOCATE_AND_UPDATE',1,NULL,1,'system',getdate(),NULL,NULL),
(@ad_tool_id,1,2,'ADD_NEW',1,NULL,1,'system',getdate(),NULL,NULL),
(@ad_tool_id,1,3,'UPDATE',1,NULL,1,'system',getdate(),NULL,NULL),
(@ad_tool_id,1,4,'DELETE',1,NULL,1,'system',getdate(),NULL,NULL)

  -- Validation Check for above call are correct or not
select * from pdm_account_ad_tool_api_access where account_id = @account_id and seq_id = @seq_id and ad_tool_id=@ad_tool_id


-- SP CALL VALIDATES THE ACCOUNT
-- RETURN 0 AS ERROR_CODE IN CASE OF SUCCESS 
exec sp_validate_login_attempt @account_id, @user_account_ID, '584432EE5DE8F4DE398C1D914371DB3D', 'dummy', @ad_tool_id, @access_tag

--commit
rollback



