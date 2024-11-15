use ipc_82
go

begin tran
-- need for new client
declare @access_tag varchar(256) = 'BILLING_PROD_HY'
declare @ipc_name varchar(256) = 'Billing Production HY'

declare @user_agent varchar(max) = 'HY-Adwords'
declare @dev_token varchar(max) = 'iN8sGMQLsngLK-oWTXeHHA'
declare @client_cust_id varchar(max) = '226-304-0363'
declare @email varchar(max) = 'HY@pdmtech.com'
declare @password varchar(max) = 'B310607C23CFE8454913AA94B8DE0D51'
declare @run_adhoc_reports varchar(max) = 'NO' -- YES, NO

-- Get these from console.google.com & developers.google.com/oauthplayground
-- These should be separate from BO because it has different scope from BO
declare @oath_client_invoice varchar(max) = '1027671525240-b8tkv4u1e0p2j8v70b4k1o1vjuve46js.apps.googleusercontent.com'
declare @oath_secret_invoice varchar(max) = 'Ihu7t_pvX-1-ESystIHnEZip'
declare @oath_refresh_invoice varchar(max) = '1/bjL6c2bmgQl6bNKKAdsbFVTyuv4wqDKsSyMwiwnJpfQ'

-- Get these from console.google.com & developers.google.com/oauthplayground
declare @oath_client varchar(max) = '1027671525240-gun2029vgmbscpd8a271dafs7dms4gt2.apps.googleusercontent.com'
declare @oath_secret varchar(max) = 'NwXoZqAThhTfcmeiOqKa12Rm'
declare @oath_refresh varchar(max) = '1/NHFI8iqfhG7ZxzWNwx-_PRQKROjnsWQTtTTbtckVi2k'

-- General
declare @ad_tool_name varchar(64) = 'AdWords 2018.06'
declare @consumer_name varchar(64) = 'AdWords' -- both can be different

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
INSERT INTO pdm_account_user_ad_tool
([account_id],[ad_tool_id],[seq_id],[user_id],[create_id],[create_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,N'AdWordsBilling',N'sys',GETDATE()) -- ONLY CHANGE IF REQUIRED ELSE LEAVE IT AS IS.

SET NOCOUNT ON
INSERT INTO pdm_account_ad_tool_api_access
([account_id],[ad_tool_id],[seq_id],[api_access_property_id],[api_access_property_value],[api_access_property_info1],[api_access_property_info2],[api_access_property_info3],[api_access_property_info4],[api_access_property_info5],[api_access_property_info6],[create_id],[create_date],[modify_id],[modify_date])
VALUES
 (@account_id,@ad_tool_id,@seq_id,1,@user_agent,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,2,@dev_token,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,3,@client_cust_id ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,4,@email ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,5,@password ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,6,@run_adhoc_reports ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,7,@oath_client_invoice ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,8,@oath_secret_invoice ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,9,@oath_refresh_invoice ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,10,@oath_client ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,11,@oath_secret ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
,(@account_id,@ad_tool_id,@seq_id,12,@oath_refresh ,N'',NULL,NULL,NULL,NULL,NULL,N'system',GETDATE(),NULL,CONVERT(datetime,NULL,121))
;

select * from pdm_account_ad_tool where account_id = @account_id
select * from pdm_account_ad_tool_api_access where account_id = @account_id and seq_id = @seq_id
select * from pdm_account_user_ad_tool where account_id = @account_id and seq_id = @seq_id

rollback