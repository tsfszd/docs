if exists(select 1 from sys.procedures where name ='plsW_submit_exp')
begin 
drop procedure plsW_submit_exp
end
go   


/****** Object:  Stored Procedure dbo.plsW_app_trx_update    Script Date: 06/23/2000 12:39:33 ******/
--DROP PROCEDURE plsW_app_trx_update
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[plsW_submit_exp]              
  @company_code int                
 ,@resource_id varchar(16)               
 ,@report_name varchar(32)            
 ,@approver_id varchar(32)= NULL            
 ,@record_id varchar(16)             
 ,@date_from datetime = NULL              
 ,@date_to datetime = NULL              
 ,@submitter_id varchar(16)     --AK 20150427  ESM - 1863  
 ,@source varchar(32) = NULL      
AS              
/* ****************************************************************** *              
* Copyright 1996 Paradigm Technologies, Inc.                          *              
* All Rights Reserved                                                 *              
*                                                                     *              
* This Media contains confidential and proprietary information of     *              
* Paradigm Technologies, Inc.  No disclosure or use of any portion    *              
* of the contents of these materials may be made without the express  *              
* written consent of Paradigm Technologies, Inc.                      *              
*                                                                     *              
* Use of this software is restricted and governed by a License        *              
* Agreement.  This software contains confidential and proprietary     *              
* information of Paradigm Technologies, Inc. and is protected by      *              
* copyright, trade secret and trademark law.                          *              
*                                                                     *              
* ******************************************************************* *              
*                                                                     *              
*         Name: plsW_submit_exp                                       *              
*       Module:                                                       *              
* Date created: 01/03/2000                                            *              
*           By: Val Roznoshchik                                       *              
*      Version:                                                       *              
*      Comment:                                                       *              
*                                                                     *              
* Date revised: 24/01/2011                                            *              
*           By: Saqib Jillani                                         *              
*      Comment: SP was not updating the approver_id            
    in header and approval flag in transactions table                 *              
*                                                                     *              
*                                                                     *              
***********************************************************************/              
SET NOCOUNT ON              
DECLARE @value int              
              
--if @report_from is null and @report_to is null and @date_from is null and @date_to is null              
              
--Begin              
              
--UPDATE pld_transactions              
--SET              
--  submitted_flag = 1              
-- ,submitted_date = GETDATE()              
-- ,approval_flag =              
--    CASE approval_flag              
--    WHEN 2 THEN Null              
--    ELSE approval_flag              
--    END              
--WHERE company_code = @company_code              
--AND resource_id = @resource_id              
--AND submitted_flag = 0              
--AND trx_type = 2001              
--AND EXISTS (              
--  SELECT 1              
--  FROM pld_transactions_hdr              
--  WHERE pld_transactions_hdr.company_code = @company_code              
--  AND pld_transactions_hdr.resource_id =  @resource_id              
--  AND pld_transactions_hdr.record_id = pld_transactions.record_id              
   
--  )              
              
              
--IF @@error = 0              
--  SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION              
--ELSE              
--  SELECT 1050 ERROR_CODE, CONVERT(varchar(8),@company_code)+', '+@resource_id+', '+ ': Submit Expense Transaction Failed' ERROR_DESCRIPTION           
              
--RETURN(0)              
              
--END              
-------------------------------------------------------------------------------              
--IF @report_from Is Null SELECT @report_from = Char(0)              
--IF @report_to Is Null SELECT @report_to = Char(254)              
              
IF @date_from Is Null              
 Begin              
  SELECT @date_from = Min(date_from)              
  FROM pld_transactions_hdr             
  WHERE company_code = @company_code              
  AND resource_id = @resource_id              
  AND report_name = @report_name              
 End              
              
IF @date_to Is Null              
 Begin              
  SELECT @date_to = MAX(date_to)              
  FROM pld_transactions_hdr              
  WHERE company_code = @company_code              
  AND resource_id = @resource_id              
  AND report_name = @report_name              
 End              
  --RS20160408 validation FW: Expense Report Stuck (ESM - 2790)     
 create table #payment_tax_error    
 (    
 transaction_id  char(16),    
 payment_code int,    
 payment_name varchar(16),    
 gst_tax_code varchar(8),    
 record_id char(16)    
    
 )    
    
 insert into #payment_tax_error(    
 transaction_id  ,    
 payment_code ,    
 payment_name ,    
 gst_tax_code ,    
 record_id )    
 select transaction_id  ,    
 payment_code ,    
 payment_name ,    
 gst_tax_code ,    
 record_id    
 from  pld_transactions        
 WHERE company_code = @company_code                      
 AND resource_id = @resource_id                    
 AND record_id = @record_id      
                 
         
if  exists(select 1 from #payment_tax_error where isnull(payment_code,'')='')       
begin        
  SELECT -1 ERROR_CODE, CONVERT(varchar(8),@company_code)+', '+@resource_id+' '+ ': Submit Expense Transaction Failed. Payment Code is missing.' ERROR_DESCRIPTION                                       
RETURN(0)        
end          
    
if  exists(select 1 from #payment_tax_error where isnull(payment_name,'')='' or payment_name='undefined' )            
begin        
  SELECT -1 ERROR_CODE, CONVERT(varchar(8),@company_code)+', '+@resource_id+' '+ ': Submit Expense Transaction Failed. Payment Name is missing.' ERROR_DESCRIPTION                      
                      
RETURN(0)        
end         
    
if  exists(select 1 from #payment_tax_error where isnull(gst_tax_code,'')='' or gst_tax_code='undefine'  )                    
begin        
  SELECT -1 ERROR_CODE, CONVERT(varchar(8),@company_code)+', '+@resource_id+' '+ ': Submit Expense Transaction Failed. GST Tax Code is missing.' ERROR_DESCRIPTION                                       
RETURN(0)        
end                             
   --RS20160408 validation FW: Expense Report Stuck (ESM - 2790)                    
begin  

	 --------RS20180101 to notify the approveres 
 	declare @supervisor char(16)  
	select @supervisor=reports_to from plv_resource where resource_id=@resource_id    

	declare @overrride_exp_app varchar(255)
SELECT @overrride_exp_app=default_code                 
FROM plv_rule_group                 
WHERE path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'                
and user_group_code is NULL    

declare @override_approver varchar(32)
select @override_approver=approver_id from pld_transactions_hdr where record_id=@record_id




select transaction_id,level2_key,level3_key,resource_id,record_id into #pld_transaction
from pld_transactions 
WHERE company_code = @company_code              
AND resource_id = @resource_id              
AND submitted_flag = 0              
AND trx_type = 2001              
AND record_id = @record_id            
AND EXISTS (              
  SELECT 1 
  FROM pld_transactions_hdr              
  WHERE pld_transactions_hdr.company_code = @company_code              
  AND pld_transactions_hdr.resource_id =  @resource_id              
  AND pld_transactions_hdr.record_id = @record_id             
 AND pld_transactions_hdr.date_from >= @date_from              
 AND pld_transactions_hdr.date_to <= @date_to              
AND pld_transactions_hdr.report_name = @report_name              
  )    
 	 --------RS20180101 to notify the approveres 


            
UPDATE pld_transactions              
SET              
  submitted_flag = 1              
 ,submitted_date = GETDATE()              
 ,approval_flag =              
    CASE approval_flag              
    WHEN 2 THEN Null              
    ELSE  approval_flag              
    END  
 ,[source] = @source  
WHERE company_code = @company_code              
AND resource_id = @resource_id              
AND submitted_flag = 0              
AND trx_type = 2001              
AND record_id = @record_id            
AND EXISTS (              
  SELECT 1 
  FROM pld_transactions_hdr              
  WHERE pld_transactions_hdr.company_code = @company_code              
  AND pld_transactions_hdr.resource_id =  @resource_id              
  AND pld_transactions_hdr.record_id = @record_id             
 AND pld_transactions_hdr.date_from >= @date_from              
 AND pld_transactions_hdr.date_to <= @date_to              
AND pld_transactions_hdr.report_name = @report_name              
  )              
 --------------            
 UPDATE pld_transactions_hdr            
 SET            
 approver_id= @approver_id  ,       
 submitter_id  = @submitter_id,       --AK 20150427  ESM - 1863     
 -- HAMZA 20150624 change the modify_date on submit.            
 modify_date = getdate(),    
 modify_id = @resource_id    
 ,[source] = @source  
 WHERE company_code = @company_code              
 AND resource_id = @resource_id              
 AND report_name = @report_name            
 AND record_id = @record_id            
 AND pld_transactions_hdr.date_from >= @date_from              
 AND pld_transactions_hdr.date_to <= @date_to              
 ---------------------------            
IF @@error = 0              
  SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION              
ELSE              
  SELECT 1050 ERROR_CODE, CONVERT(varchar(8),@company_code)+', '+@resource_id+', '+ ': Submit Expense Transaction Failed' ERROR_DESCRIPTION              
 

 
  --------RS20180101 to notify the approveres 
create table #level2level3
(level2_key varchar(32),level3_key varchar(64),trx_approval_required_flag int,trx_approval_flag int,resource_id varchar(64),transaction_id varchar(256),record_id varchar(256))

if @overrride_exp_app='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'   
begin 
insert into #level2level3(resource_id)
select @override_approver
end
else 
begin 

insert into #level2level3
select l2.level2_key,l3.level3_key,trx_approval_required_flag,trx_approval_flag ,r.resource_id,p.transaction_id,p.record_id 
from pdd_level2 l2 inner join pdd_level3 l3 on l2.level2_key=l3.level2_key
inner join #pld_transaction p on p.level2_key=l3.level2_key and p.level3_key=l3.level3_key
left join pdd_level2_resource r on l2.level2_key =r.level2_key
where  trx_approval_required_flag in (1,2)
and trx_approval_flag in (1,2)

update #level2level3
set resource_id=@supervisor
where trx_approval_required_flag in (1,2)
and trx_approval_flag in (2)


insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
notification_type,create_id,create_date,[source],transaction_id,record_id)
select @company_code,t.resource_id,v.subscriber_id,'Expense Report '+ltrim(rtrim(@report_name))+' has been submitted for your approval.',
'EXP APPROVAL',@resource_id,getdate(),'eSM EXP',transaction_id,record_id
from #level2level3 t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id





end

  --------RS20180101 to notify the approveres 
 
 
 
 
              
RETURN(0)              
              
END              
              
-----------------------------------------------------------------------------------              
             




go