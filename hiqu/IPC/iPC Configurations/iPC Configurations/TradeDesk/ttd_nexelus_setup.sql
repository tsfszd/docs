declare @account_id varchar(max), @ad_tool_id int, @ad_tool_seq_id int, 
	@lookup_entity_id int, @ipc_user_id varchar(max), @ipc_password varchar(max), @company_code int,
	@record_id int

set @company_code = (select company_code from pdm_company)
set @ad_tool_id = 14 -- Need to provide (can check from pdm_company_ipc)

select @account_id = account_id, @ad_tool_seq_id = ad_tool_seq_id, @ipc_user_id = user_id, @ipc_password = password from pdm_company_ipc 
where ad_tool_id = @ad_tool_id and access_tag = 'TradeDesk_TMK_Test' -- need to provide the access tag just created in IPC script

SET NOCOUNT ON
INSERT INTO pdd_lookup_ipc_entities_header
([company_code],[account_id],[ad_tool_id],[ad_tool_seq_id],[lookup_entity_id],[lookup_filter_1],[lookup_filter_2],[lookup_filter_3],[ipc_user_id],[ipc_password],[refresh_date],[lookup_entity_name])
VALUES
 (@company_code,@account_id,@ad_tool_id,@ad_tool_seq_id,12,NULL,NULL,NULL,@ipc_user_id,@ipc_password,NULL,'TradeDesk Partner')
,(@company_code,@account_id,@ad_tool_id,@ad_tool_seq_id,13,NULL,NULL,NULL,@ipc_user_id,@ipc_password,NULL,'TradeDesk Advertiser')
;
 
select @record_id = record_id from pdd_lookup_ipc_entities_header where lookup_entity_name = 'TradeDesk Partner' and account_id = @account_id 
	and ad_tool_id = @ad_tool_id and ad_tool_seq_id = @ad_tool_seq_id

 SET NOCOUNT ON
INSERT INTO pdd_lookup_ipc_entities_detail
([record_id],[column_1],[column_2],[column_3],[column_4],[column_5],[column_6])
VALUES
 (@record_id,'uguh7l0','Trade Desk Partner',NULL,NULL,NULL,NULL)
;