use ipc_82
go

begin tran
-- need for new client
declare @access_tag varchar(256) = 'TMK_DCM_4875155'
declare @ipc_name varchar(256) = 'DCM TMK 4875155'

-- need for new api access properties
declare @api_project_name varchar(max) = 'tmk-nexelus-net'
declare @oauth_client_id varchar(max) = '946992936107-nko8hn4vpviakdg164schijn3bbdta99.apps.googleusercontent.com'
declare @oauth_client_secret varchar(max) = 'DBNlbESX7ohaUeET5aGl96Te'
declare @data_file_path varchar(max) = 'C:\PDM\services\IPC_12.1-Beta\TMK' -- this needs to be replaced if IPC virtual path is changed.
declare @profile_id varchar(max) = '4875155' -- DCM test profile under the network.

-- General
declare @ad_tool_name varchar(64) = 'DCM'
declare @consumer_name varchar(64) = 'DCM' -- both can be different

declare @account_id varchar(6) = (select account_id from pdm_consumer_account where consumer_id in (select consumer_id from pdm_consumer where name = @consumer_name))
declare @ad_tool_id int = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)
declare @seq_id int = (select isnull(max(seq_id), 0) + 1 from pdm_account_ad_tool where account_id = @account_id)

select @account_id, @ad_tool_id, @seq_id

SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool
([account_id],[ad_tool_id],[seq_id],[access_tag],[ipc_name],[ipc_description],[eff_date],[exp_date],[is_primary],[comment],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,@access_tag,@ipc_name,NULL,GETDATE(),CONVERT(datetime,'2020-12-31 00:00:00.000',121),0,NULL,N'sys',GETDATE())
;
 

SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool_api_access
([account_id],[ad_tool_id],[seq_id],[api_access_property_id],[api_access_property_value],[api_access_property_info1],[api_access_property_info2],[api_access_property_info3],[api_access_property_info4],[api_access_property_info5],[api_access_property_info6],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,1,@api_project_name,NULL,NULL,NULL,NULL,NULL,NULL,N'system',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,10,@oauth_client_id,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,11,@oauth_client_secret,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,13,@data_file_path,NULL,NULL,NULL,NULL,NULL,NULL,N'system',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,14,@profile_id,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE())
;
 

SET NOCOUNT ON
INSERT INTO pdm_account_user_ad_tool
([account_id],[ad_tool_id],[seq_id],[user_id],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,N'DFACampaignManagement',N'sys',GETDATE()) -- ONLY CHANGE IF REQUIRED ELSE LEAVE IT AS IS.
;

select * from pdm_account_ad_tool where account_id = @account_id
select * from pdm_account_ad_tool_api_access where account_id = @account_id and seq_id = @seq_id
select * from pdm_account_user_ad_tool where account_id = @account_id and seq_id = @seq_id

rollback