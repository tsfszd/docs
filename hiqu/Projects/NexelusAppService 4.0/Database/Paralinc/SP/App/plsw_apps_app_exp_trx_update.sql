

if exists(select 1 from sys.procedures where name='plsw_apps_app_exp_trx_update')
begin 
drop procedure plsw_apps_app_exp_trx_update
end
go 

CREATE PROCEDURE [dbo].[plsw_apps_app_exp_trx_update]       
 @TS binary  (8)       
,@company_code  int       
,@transaction_id  char  (16)       
,@amount    float       
,@approval_flag tinyint       
,@approval_comment  varchar (255)        
,@nonbill_flag    tinyint       
,@save_as_unsubmitted tinyint          
,@amount_home      float       
,@amount_billable  float       
,@amount_tax          float       
,@amount_net          float       
,@approved_by  varchar(32) = null       
,@modify_id  varchar(32) = null       
,@finalise_flag  tinyint = null       
,@text1  varchar(255) =  null       
,@text2  varchar(255) =  null       
,@text3  varchar(255) =  null       
,@text4  varchar(255) =  null       
,@text5  varchar(255) =  null       
,@text6  varchar(255) =  null       
,@text7  varchar(255) =  null       
,@text8  varchar(255) =  null       
,@text9  varchar(255) =  null       
,@text10 varchar(255) =  null       
,@number11 float =  null       
,@number12 float =  null       
,@number13 float =  null       
,@number14 float =  null       
,@number15 float =  null       
,@number16 float =  null       
,@number17 float =  null       
,@number18 float =  null       
,@number19 float =  null       
,@number20 float =  null       
       
       
/* WITH RECOMPILE */       
/************** Copyright 1996 Paradigm Technologies, Inc. ***********       
* All Rights Reserved                                                       *       
*                                                                               *       
* This Media contains confidential and proprietary information of       *       
* Paradigm Technologies, Inc.  No disclosure or use of any portion      *       
* of the contents of these materials may be made without the express    *       
* written consent of Paradigm Technologies, Inc.                          *       
*                 *       
* Use of this software is restricted and governed by a License    *       
* Agreement.  This software contains confidential and proprietary       *       
* information of Paradigm Technologies, Inc. and is protected by        *       
* copyright, trade secret and trademark law.                              *       
       
*                                                                               *       
******************************************************************       
*                                                                               *       
* Name:  Wrapper for  plsw_app_exp_trx_update                                                 *       
* Module: Approvals           *       
* Date created: 12/06/2016          *       
* Version:              *       
* Comment:                                                        *       
*                                                                         *       
* Date revised:                                                       *       
* By:                                                           *       
* Comment:                                                        *       
*                                  *       
*                                                                       *       
******************************************************************/       
       
AS      
    
BEGIN
---------------------------------------------------------
DECLARE @report_uploaded tinyint = 0


---------------------------------------------------------


     
    DECLARE @r_ts TIMESTAMP     
 SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)            

 SET @finalise_flag = ISNULL(@finalise_flag,0) --FS20190131 As discussed with Abid
declare @is_mc int  
exec pls_mc_Apps_exists @company_code, 1, @is_mc output  
  
--/*************** for temp fix AA20120322***************************************** /      
-- HAMZA -- 20151517 -- added the mc check for App.  
if @is_mc <> 1  
begin  
 if @amount_home <> @amount  
 select @amount_home = @amount  
        
 if @amount_net  <> @amount  
 select @amount_net = @amount  
end      
--*************** for temp fix AA20120322*****************************************/      
       
DECLARE       
@ts_current BINARY(8)       
       
SELECT  @ts_current = 0x0       
       
SELECT  @ts_current = CONVERT(BINARY(8), TIMESTAMP)       
FROM     pld_transactions       
WHERE  transaction_id = @transaction_id       
AND       company_code = @company_code       
       
IF @ts_current=0x0       
BEGIN 

SELECT 1003 ERROR_CODE,'Transaction already deleted from the Application. Please refresh.' ERROR_DESCRIPTION  ,@r_ts r_ts ,
upload_flag , @report_uploaded report_uploaded from pld_transactions where transaction_id = @transaction_id    
RETURN(0)       
END       
       
IF @TS IS NOT NULL       
BEGIN       
IF @ts_current <> @TS       
BEGIN       
/* record was changed */ 
 
SELECT 1004 ERROR_CODE, 'Transaction already updated from application. Please refresh.' ERROR_DESCRIPTION ,@r_ts r_ts  ,upload_flag 
 , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id           
RETURN(0)       
END       
END       
       
IF @approval_flag = 0       
BEGIN       
SELECT @approval_flag = null       
END       

--------RS20180101 to notify the approvers
declare @default_code int
select @default_code=default_code from pdm_rule_group where path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'
--and user_group_code=NULL
AND ISNULL(user_group_code,'')='' /*NABBASI08252018*/




 create table #approvers(transaction_id char(16) NULL,resource_id char(16)) 
declare @level2_key varchar(32),    
  @level3_key varchar(64),    
  @resource_id char(16),    
  @level2_trx_approval_flag int,    
  @level3_trx_approval_flag int,    
  @supervisor char(16)  ,  
  @currency_code varchar(8),
  @amount_hdr float   
  
declare @trx_type int  
declare @record_id   char(16),@report_name varchar(32),@submitter_id varchar(16)
 
select  @record_id=record_id from pld_transactions where transaction_id=@transaction_id 
select @report_name=report_name ,@submitter_id=submitter_id,@amount_hdr=amount from pld_transactions_hdr where record_id=@record_id
select @level2_key=level2_key,@level3_key=level3_key,@resource_id=resource_id  ,@trx_type=trx_type  
from pld_transactions where transaction_id=@transaction_id    
 select @currency_code=currency_code from pdd_resources where resource_id=@resource_id    
select @supervisor=reports_to from plv_resource where resource_id=@resource_id    
    
select @level2_trx_approval_flag= trx_approval_required_flag from plv_level2 where level2_key=@level2_key    
select @level3_trx_approval_flag= trx_approval_flag from plv_level3 where level2_key=@level2_key and level3_key=@level3_key    
/*
declare @overrride_exp_app varchar(255)
SELECT @overrride_exp_app=default_code                 
FROM plv_rule_group                 
WHERE path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'                
and user_group_code is NULL    

declare @override_approver varchar(32)
select @override_approver=approver_id from pld_transactions_hdr where record_id=(select top 1 record_id from pld_transactions where transaction_id=@transaction_id )


if (@trx_type > 1999 and @trx_type < 2999) and  @overrride_exp_app='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'   
begin 
insert into #approvers    
  select @transaction_id ,@override_approver  
end
else 
begin
	if @level2_trx_approval_flag<>0    
	begin     
	 if @level3_trx_approval_flag=2    
	 begin    
	  insert into #approvers    
	  select @transaction_id ,@supervisor    
	 end    
	 else    
	 if @level3_trx_approval_flag=1    
	 begin    
	  insert into #approvers    
	  select @transaction_id ,resource_id from plv_level2_resource where level2_key=@level2_key           
      and position_category_code=1    
	 end 

	end
end*/
 --------RS20180101 to notify the approvers 
 insert into #approvers(resource_id)
 select  @submitter_id

 /*
 select distinct @transaction_id, resource_id from pdm_rule_group g
INNER JOIN pdm_group_user_link l ON g.user_group_code = l.user_group_code
where g.path = 'Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP' and g.permission_status = 2     */
	 -- select @transaction_id ,@submitter_id
if @default_code=2
begin
select distinct resource_id into #resources from pdm_group_user_link u inner join pdm_rule_group g on u.user_group_code=g.user_group_code
where   path='Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP' and permission_status=2
--insert into #approvers
select distinct  @transaction_id transaction_id,resource_id into #fin_approvers from #resources 
end
--FS20180614
SELECT * INTO #tmp_transactions FROM pld_transactions where record_id = @record_id

update tm
set tm.approval_flag=CASE WHEN l2.trx_approval_required_flag =0 OR l3.trx_approval_flag = 0 THEN 1  ELSE tm.approval_flag END
from #tmp_transactions tm 
INNER JOIN pld_transactions_hdr hdr ON tm.record_id=hdr.record_id
inner join pdd_level2 l2 ON tm.level2_key=l2.level2_key
INNER JOIN pdd_level3 l3 ON tm.level2_key=l3.level2_key AND tm.level3_key=l3.level3_key
WHERE ISNULL(hdr.approver_id,'')='' AND IsNull(tm.submitted_flag,0) = 1
       
IF @finalise_flag = 1       
BEGIN

declare @fin_flag int
select @fin_flag=finalise_flag from pld_transactions  WHERE   company_code  = @company_code       
AND        transaction_id    = @transaction_id 
     
UPDATE  pld_transactions 
SET     amount     = @amount,       
  amount_home     = @amount_home,       
amount_billable = @amount_billable,       
--gst_tax_amt     = @amount_tax,       
net_amount     = @amount_net, 
modify_date = GETDATE(),      
 modify_id = @modify_id,       
finalise_flag = @finalise_flag,       
finalised_date = getdate(),       
finalised_by = @modify_id ,       
approval_comment  = @approval_comment        
WHERE   company_code  = @company_code       
AND        transaction_id    = @transaction_id       

 SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)    
 
CREATE TABLE #error_msg (error_code int, error_desc varchar(64), voucher_trx_id varchar(32), voucher_seq_id int, 
							hold_flag int, hold_comment varchar(64),vouchers_on_hold int, report_name varchar(32),
							resource_id varchar(16),name_last varchar(32), name_first varchar(32))      
IF @@error != 0 
--BEGIN      
----INSERT INTO #error_msg(error_code , error_desc)
--SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION ,@r_ts r_ts 
--END 
--ELSE       
begin
SELECT 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION    ,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id --,@r_ts r_ts
return
end



if not exists(select 1 from pld_transactions where ISNULL(approval_flag,0) not in (1,4) 
				and record_id=@record_id ) 
				and @finalise_flag=1  and @fin_flag <> @finalise_flag
  AND NOT EXISTS (select 1 FROM pld_transactions where ISNULL(finalise_flag,0) <> 1 and record_id=@record_id )

begin

	select distinct @company_code company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' for '
	+rtrim(@currency_code)+' '+CAST(@amount_hdr as varchar)+' has been Approved by Finance.' notification_body,--' has received Finance approval.' notification_body,
	'EXP REPORT' notification_type,@modify_id modify_id,'APP EXP' [source],@record_id record_id INTO #FinanceApproversReceived
	from #approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id


	insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
	notification_type,create_id,create_date,[source],record_id)
	select distinct  company_code,resource_id,subscriber_id,notification_body,
	notification_type,modify_id,getdate(),[source],record_id
	from #FinanceApproversReceived r 
	where not exists 
	(select * from pdd_apps_notification where isnull(write_flag, 0) = 0 and resource_id = r.resource_id and subscriber_id = r.subscriber_id and notification_body = r.notification_body)
end

--------------------------------------------------------
--FS20180529

if object_id ('tempdb..#exec_temp_date') is not null
drop table #exec_temp_date

create table #exec_temp_date (error_code int, error_desc varchar(64), voucher_trx_id varchar(32), voucher_seq_id int, 
							hold_flag int, hold_comment varchar(64),vouchers_on_hold int, report_name varchar(32),
							resource_id varchar(16),name_last varchar(32), name_first varchar(32))   


Declare @permission_status int
Select @permission_status=permission_status from pdm_rule_group where path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/CreateVoucherOnFinanceApproval'

select @resource_id = resource_id from pld_transactions_hdr where record_id=@record_id

IF @permission_status = 2
BEGIN

IF NOT EXISTS( SELECT * FROM pld_transactions WHERE record_id=@record_id AND (/*approval_flag NOT IN (1,4) OR*/ ISNULL(finalise_flag,0)<>1 ))
BEGIN

declare @new_vchbatch_number varchar(16)
exec pds_vchbatch_number_get 2, @new_vchbatch_number out
--select @new_vchbatch_number
--INSERT INTO #error_msg
exec pdsW_upload_voucher_online @company_code=@company_code,@upload_resource_id=@resource_id,@level2_key_from=N'',@level2_key_to=N'',
@resource_id_from=N'',@resource_id_to=N'',@applied_date_from=N'',@applied_date_to=N'',@user_applied_date=NULL,
@reimbursable=N'1',@single_vch_per_exp_rpt=N'1',@create_id=@modify_id,@upl_record_id=@record_id,@batch_id=@new_vchbatch_number,@exec_mode=1

--select @resource_id,@record_id,* from #error_msg
END

END

IF NOT EXISTS (SELECT * FROM pld_transactions WHERE record_id = @record_id AND ISNULL(upload_flag,0) <> 1)
BEGIN
	SET @report_uploaded = 1
END

DECLARE @error_desc varchar(64)=''
--SELECT @error_desc= error_desc FROM #error_msg
IF @@error = 0  
BEGIN
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION ,@r_ts r_ts,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id 
END
ELSE
BEGIN
SELECT 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION  ,@r_ts r_ts,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id 
END
--------------------------------------------------------
        
RETURN(0)       
END       
       
       
IF @approval_flag = 2       
BEGIN       
UPDATE  pld_transactions       
SET          
approval_flag     = @approval_flag,       
approval_comment  = @approval_comment,       
       
submitted_flag    = 0,       
rejected_by = @approved_by,  
modify_date = GETDATE(),     
modify_id = @modify_id,       
approval_date= Getdate(),       
finalise_flag = 0,       
finalised_date = null,       
finalised_by = null       
WHERE   company_code  = @company_code       
AND        transaction_id    = @transaction_id       
  SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)            
IF @@error = 0       
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION   ,@r_ts r_ts      ,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id 
ELSE       
SELECT 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION  ,@r_ts r_ts    ,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id 

DECLARE @display_name varchar(32)
SELECT @display_name=display_name FROM pdm_sysnames WHERE field_name = 'TIME_EXP_rejected'
 
 --------RS20180101 to notify the approvers 
--if not exists(select 1 from pld_transactions where approval_flag<>2)
if exists(select 1 from pld_transactions where ISNULL(Approval_flag,0)=2 and record_id=@record_id) --FS20180809 if one trx is rejected
begin
	insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
	notification_type,create_id,create_date,[source],record_id)
	select distinct  @company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' for '+RTRIM(@currency_code)+' '+CAST(@amount_hdr as varchar)+' has been '+RTRIM(@display_name)+'.',
	'EXP REPORT',@modify_id,getdate(),'APP EXP',@record_id
	from #approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id
	WHERE NOT EXISTS (SELECT 1 FROM pdd_apps_notification 
						WHERE record_id=@record_id
							  and notification_body='Expense Report '+ltrim(rtrim(@report_name))+' for '+rtrim(@currency_code)+' '+CAST(@amount_hdr as varchar)+' has been '+RTRIM(@display_name)+'.'
							  and ISNULL(write_flag,0)=0
							  							  
							  )
end
   
   delete from #approvers  
    --------RS20180101 to notify the approvers  
RETURN(0)       
END       
ELSE       
IF @save_as_unsubmitted = 1       
begin       
UPDATE  pld_transactions       
SET          
approval_flag     = @approval_flag,       
approval_comment  = @approval_comment,       
       
submitted_flag    = 0,       
approved_by = @approved_by,       
modify_date = GETDATE(), 
modify_id = @modify_id,       
approval_date=NULL,       
finalise_flag = 0,       
finalised_date = null,       
finalised_by = null       
WHERE   company_code  = @company_code       
AND        transaction_id    = @transaction_id       
        
END       
       
ELSE       
BEGIN       
--FS20180820
declare @appr_flag int
SELECT @appr_flag=   ISNULL(approval_flag,0) from pld_transactions WHERE company_code  = @company_code       
AND      transaction_id    = @transaction_id 
         
UPDATE pld_transactions       
SET  amount     = @amount,       
amount_home     = @amount_home,       
amount_billable = @amount_billable,       
--gst_tax_amt     = @amount_tax,       
net_amount     = @amount_net,       
approval_flag   = @approval_flag,       
approval_comment = @approval_comment,       
nonbill_flag          = @nonbill_flag,       
approved_by = CASE WHEN ISNULL(@approval_flag,0)=ISNULL(approval_flag,0) THEN approved_by ELSE @approved_by END,  --FS20181106  Split functionality: Unit Testing of Database changes      
modify_date = GETDATE(), 
modify_id = @modify_id,       
approval_date=case when ISNULL(@approval_flag,0)=ISNULL(approval_flag,0) then approval_date else GetDate() end,       
finalise_flag = 0,       
finalised_date = null,       
finalised_by = null       
WHERE company_code  = @company_code       
AND      transaction_id    = @transaction_id   


select distinct @company_code company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' for '
+ltrim(rtrim(@currency_code))+' '+CAST(@amount_hdr as varchar)+' has been Approved.' notification_body,
	'EXP REPORT' notification_type,@modify_id modify_id,'APP EXP' [source],@record_id record_id INTO #approversDATA
	from #approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id
	



 --------RS20180101 to notify the approvers 
 PRINT '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
if not exists(select 1 from pld_transactions where ISNULL(Approval_flag,0) NOT IN (1,4) and record_id=@record_id) 
and   @approval_flag in (1,  4) AND  @appr_flag in(0,2) 
--and ( @approval_flag=1 OR @approval_flag=4) AND (@appr_flag<>@approval_flag) 
--AND ((@approval_flag=4 AND @appr_flag IN (0,2) ) OR (@approval_flag <> 4 AND @appr_flag<>@approval_flag )) --FS20180911 bug# 28051

begin
	insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
	notification_type,create_id,create_date,[source],record_id)
	select distinct company_code,resource_id,subscriber_id,notification_body,
	notification_type,modify_id,getdate(),[source],record_id
	from #approversDATA
if @default_code=2
begin

	select distinct @company_code company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' for '
	+ltrim(rtrim(@currency_code))+' '+CAST(@amount_hdr as varchar)+' has been submitted for Finance.' notification_body,
		'EXP APPROVAL' notification_type,@modify_id modify_id,'APP EXP' [source],@record_id record_id 
		INTO #FinanceApproversDATA
		from #fin_approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id


		insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
	notification_type,create_id,create_date,[source],record_id)
	select distinct company_code,resource_id,subscriber_id,notification_body,
	notification_type,modify_id,getdate(),[source],record_id
	from #FinanceApproversDATA
end
end
--if not exists(select 1 from pld_transactions where approval_flag<>4 and record_id=@record_id) and @approval_flag=4 and @finalise_flag=1
--begin
--	insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
--	notification_type,create_id,create_date,[source],record_id)
--	select @company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' has recieved Finance approval.',
--	'EXP REPORT',@modify_id,getdate(),'APP EXP',@record_id
--	from #approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id
--end
      
   delete from #approvers  
    --------RS20180101 to notify the approvers  


        
END       
    SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)       
IF @@error = 0       
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION ,@r_ts r_ts ,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id           
ELSE       
SELECT 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION ,@r_ts r_ts ,upload_flag  , @report_uploaded report_uploaded  from pld_transactions where transaction_id = @transaction_id      
       

--DECLARE @r_ts TIMESTAMP     
-- SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)                                                

  
-- SELECT error_code, error_description, @r_ts r_ts FROM #error_list    
    
END






go

