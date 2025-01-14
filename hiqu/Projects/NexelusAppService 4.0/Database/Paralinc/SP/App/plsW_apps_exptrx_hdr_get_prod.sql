go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if exists(select * from sys.procedures where name='plsW_apps_exptrx_hdr_get_prod'
)
begin 
drop proc [plsW_apps_exptrx_hdr_get_prod]
end
go

 

CREATE PROCEDURE [plsW_apps_exptrx_hdr_get_prod]    
  @company_code int                          
 ,@resource_id  varchar(16)                          
 ,@date_from    datetime=null                          
 ,@date_to      datetime=null                          
 ,@filter_flag tinyint = 0 --- 0 = No Filter, 1 = Drafts only, 2 = Submitted  3 = Rejected 4 =  Approved 5 = Finance Approved                          
 ,@record_id char(16)=''                       
 , @last_sync_date datetime = null,              
 @subscriber_id int = null,         
@keys xml = null        
                            
---- plsW_apps_exptrx_hdr_get 10,'EMP000228','02/02/1966','02/02/2006',4                          
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
*   Date revised: 4th june 2015                      
*             By: arif hasan                                  *                          
*        Comment:                       
                    
[plsW_apps_exptrx_hdr_get] 2, 451         
      
'<keys>        
 <key>        
  <record_id>21042015</record_id>        
 </key>        
 <key>         
  <record_id>002</record_id>        
 </key>        
</keys>'                 
******************************************************************** */                          
AS                         
 begin            
       
  select      
 T.c.value('./record_id[1]', 'varchar(64)') record_id      
             into #transaction               
                       FROM     @keys.nodes('/keys/key') T ( c )                  
                     
create TABLE #pld_transaction_hdr(                    
 [report_name] [varchar](32) NOT NULL,                    
 [record_id] [char](16) NOT NULL,                    
 [comments] [varchar](252) NOT NULL,                    
 [date_from] [datetime] NOT NULL,                    
 [date_to] [datetime] NOT NULL,                    
 [expense_num] [varchar](16) NULL,                    
 [amount] [float] NOT NULL,                    
 [timestamp] [binary](8) NULL,                    
 [submitted_flag] [tinyint] NOT NULL,                    
 [home_amount] [float] NOT NULL, 
 [reimburse_home_amount] [float] NOT NULL,                    
 [upload_flag] [tinyint] NULL,                    
 [approval_flag] [tinyint] NULL,                    
 [finalise_flag] [tinyint] NULL,                    
 [summary_flag] [tinyint] NULL,            
 [approver_id] [varchar](32) NULL,                    
 [print_format] [varchar](50) NULL,    
 [approver_name] [varchar](70) NULL,                    
 [re_approval_flag] [tinyint] NULL                    
)                     
       
  insert into #pld_transaction_hdr                    
                      
exec [plsW_exptrx_hdr_get]       
  @company_code = @company_code                      
 ,@resource_id  = @resource_id                        
 ,@date_from    = @date_from                          
 ,@date_to      = @date_to                            
 ,@filter_flag = @filter_flag                       
 ,@record_id  =@record_id                       
               
 select t.*, @resource_id as resource_id, p.submitter_id, p.create_date, p.modify_date , p.create_id, p.modify_id            
 into #data           
 from #pld_transaction_hdr T INNER JOIN pld_transactions_hdr P             
  ON P.record_id = t.record_id                    
 where (@last_sync_date is null OR (ISNULL(p.modify_date, p.create_date) > @last_sync_date))              
 and create_date > DATEADD(week,  -10, GETDATE())          
    and (@keys is null or exists (select * from #transaction c where t.record_id = c.record_id)  )          
    
    
     update #data     
     set date_from = convert(date , date_from)  
        ,date_to = convert(date , date_to)    
       
       
       
     update #data     
     set date_from = dateadd(hour, 12,date_from)  
        ,date_to = dateadd(hour, 12,date_to)  
  
 if @subscriber_id is null          
   begin          
   select * from #data          
   end          
  else          
   begin          
   select top 100 * from #data order by  [record_id]          
   delete top (100) #data          
   where record_id in          
   (select top 100  record_id from #data order by  [record_id])          
             
             
 declare @entity_id int             
 select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'TransactionHeader'            
          
 insert into plv_event_notification            
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                          
  select    convert(varchar, @company_code) + '~-~' + [record_id]  ,    @company_code, 2, @entity_id, subscriber_id,  d.resource_id, GETDATE()            
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id    and  subscriber_id =@subscriber_id           
 where      is_active = 1           
           
   end          
                    
 end 







go