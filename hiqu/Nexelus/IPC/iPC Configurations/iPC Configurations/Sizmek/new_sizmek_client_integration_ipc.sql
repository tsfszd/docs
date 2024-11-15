-- New Sizmek Client Integration

begin tran
declare @access_tag varchar(256) = 'Sizmek_HY_Prod'
declare @ipc_name varchar(256) = 'Sizmek HY Production'

declare @user_name varchar(max) = 'HY@nexelus.net'
declare @password varchar(max) = '68F1A899EF4021C430C63FA73F5450B7'
declare @api_domain varchar(max) = 'https://api.sizmek.com/rest/' -- TEST ACCOUNT https://uat.dev.sizmek.com/rest/

declare @ad_tool_name varchar(64) = 'Sizmek'
declare @consumer_name varchar(64) = 'Sizmek' -- both can be different

declare @account_id varchar(6) = (select account_id from pdm_consumer_account where consumer_id in (select consumer_id from pdm_consumer where name = @consumer_name))
declare @ad_tool_id int = (select ad_tool_id from pdim_ad_tool where orig_name = @ad_tool_name)
declare @seq_id int = (select max(seq_id) + 1 from pdm_account_ad_tool where account_id = @account_id)

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
 (@account_id,@ad_tool_id,@seq_id,20,@user_name,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,21,@password,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE())
,(@account_id,@ad_tool_id,@seq_id,22,@api_domain,NULL,NULL,NULL,NULL,NULL,NULL,N'sys',GETDATE())
;
 

SET NOCOUNT ON
INSERT INTO pdm_account_user_ad_tool
([account_id],[ad_tool_id],[seq_id],[user_id],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,N'SizmekCampaignManagement',N'sys',GETDATE()) -- ONLY CHANGE IF REQUIRED ELSE LEAVE IT AS IS.
;
 
 select * from pdm_account_ad_tool where account_id = @account_id
select * from pdm_account_ad_tool_api_access where account_id = @account_id and seq_id = @seq_id
select * from pdm_account_user_ad_tool where account_id = @account_id and seq_id = @seq_id

rollback