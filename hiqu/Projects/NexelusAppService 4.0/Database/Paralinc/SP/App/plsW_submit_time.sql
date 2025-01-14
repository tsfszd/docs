if exists(select 1 from sys.procedures where name ='plsW_submit_time')
begin 
drop procedure plsW_submit_time
end
go   


/****** Object:  Stored Procedure dbo.plsW_app_trx_update    Script Date: 06/23/2000 12:39:33 ******/
--DROP PROCEDURE plsW_app_trx_update
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE PROC [dbo].[plsW_submit_time]        
 @company_code int,        
 @resource_id   varchar(16) ,        
 @Level2_from varchar(32) = NULL,        
 @Level2_to varchar(32) = NULL,        
 @date_from datetime = NULL,        
 @date_to datetime = NULL        
        
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
*         Name: plsW_submit_time                          *        
*       Module:                                                 *        
* Date created: 31/13/2000                                        *        
*           By: Val Roznoshchik           *        
*      Version:                                                 *        
        
*      Comment:                                                 *        
*                                                               *        
* Date revised:                                                 *        
*                  *        
*           By:               *        
*        
*      Comment:                                             *        
*                                                                 *        
*                                                                 *        
***************************************************************** */        
AS        
      
----Begin        
if @Level2_from is null and @Level2_to is null and @date_from is null and @date_to is null        
BEGIN        
 -- AS20110513 Create log file for issue in time sheet approval      
 insert approval_log(transaction_id, units, nonbill_flag, submitted_date, approval_flag, sequence_id)      
 select transaction_id, units, nonbill_flag, getdate(), case approval_flag when 2 then null else approval_flag end , 0      
 from pld_transactions      
 WHERE  company_code = @company_code        
 AND resource_id =  @resource_id        
 AND submitted_flag  = 0        
 AND trx_type < 2000        
      
 -------------------------------------        
 UPDATE pld_transactions        
 SET        
 submitted_flag = 1,        
 submitted_date = GETDATE(),        
 modify_date= GETDATE(), -- HAMZA -- 20150202 -- ADDED THE MODIFIED DATE  
 approval_flag  = case approval_flag when 2 then null else approval_flag END          
 ,outlook_entry_id = NULL -- HAMZA -- 20150203 -- FOR THE APP TO BE ABLE TO FIND IT WHEN SYNCING
 WHERE company_code = @company_code        
 AND resource_id =  @resource_id        
 AND submitted_flag  = 0 
 AND trx_type < 2000        
      
 ----------------------------------------        
 IF @@error = 0        
  SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION        
 ELSE        
  SELECT 1050 ERROR_CODE,  CONVERT(varchar(8),@company_code)+', '+@resource_id+', '+ ': Submit Time Transaction Failed' ERROR_DESCRIPTION        
      
 RETURN(0)        
END        
      
        
IF @Level2_from Is Null SELECT @Level2_from = Char(0)        
IF @Level2_to Is Null SELECT @Level2_to = Char(254)        
IF @date_from Is Null        
 SELECT @date_from = Min(applied_date)        
 FROM   pld_transactions        
 WHERE company_code = @company_code        
 AND resource_id =  @resource_id        
 AND level2_key BETWEEN @Level2_from AND @Level2_to        
      
IF @date_to Is Null        
 SELECT @date_to = MAX(applied_date)        
 FROM   pld_transactions        
 WHERE company_code = @company_code        
 AND resource_id =  @resource_id        
 AND level2_key BETWEEN @Level2_from AND @Level2_to        
      
-- AS20110513 Create log file for issue in time sheet approval      
insert approval_log(transaction_id, units, nonbill_flag, submitted_date, approval_flag, sequence_id)      
select transaction_id, units, nonbill_flag, getdate(), case approval_flag when 2 then null else approval_flag end , 0      
from pld_transactions      
WHERE company_code = @company_code        
AND resource_id =  @resource_id        
AND submitted_flag  = 0        
AND trx_type < 2000        
AND pld_transactions.applied_date BETWEEN @date_from AND @date_to        
AND pld_transactions.level2_key BETWEEN @Level2_from AND @Level2_to        
      
---------------------------------

    --------RS20180101 to notify the approvers 
	declare @supervisor char(16)  
	select @supervisor=reports_to from plv_resource where resource_id=@resource_id    
select transaction_id,level2_key,level3_key,resource_id into #pld_transaction
from pld_transactions 
WHERE company_code = @company_code        
AND   resource_id =  @resource_id        
AND      submitted_flag  = 0        
AND      trx_type < 2000        
AND      pld_transactions.applied_date BETWEEN @date_from AND @date_to  



 --------RS20180101 to notify the approvers 
        
UPDATE pld_transactions        
SET        
submitted_flag = 1,        
submitted_date = GETDATE(),        
modify_date= GETDATE(), -- HAMZA -- 20150202 -- ADDED THE MODIFIED DATE       
approval_flag  = case approval_flag when 2 then null else approval_flag END     
,outlook_entry_id = NULL -- HAMZA -- 20150203 -- FOR THE APP TO BE ABLE TO FIND IT WHEN SYNCING   
WHERE        
company_code = @company_code        
AND   resource_id =  @resource_id        
AND      submitted_flag  = 0        
AND      trx_type < 2000        
AND      pld_transactions.applied_date BETWEEN @date_from AND @date_to        
AND      pld_transactions.level2_key BETWEEN @Level2_from AND @Level2_to        
IF @@error = 0        
 SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION        
ELSE        
 SELECT 1050 ERROR_CODE,  CONVERT(varchar(8),@company_code)+', '+@resource_id+', '+ ': Submit Time Transaction Failed' ERROR_DESCRIPTION       



select l2.level2_key,l3.level3_key,trx_approval_required_flag,trx_approval_flag ,r.resource_id,p.transaction_id into #level2level3
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
notification_type,create_id,create_date,[source],transaction_id)
select @company_code,t.resource_id,v.subscriber_id,'Time Transaction '+ltrim(rtrim(transaction_id))+' has been submitted for your approval.',
'TIME APPROVAL',@resource_id,getdate(),'eSM TIME',transaction_id
from #level2level3 t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id


  
RETURN(0)        
---end 





go