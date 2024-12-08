IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[pltW_transactions_insert_update_delete]'))
drop TRIGGER [dbo].[pltW_transactions_insert_update_delete]      
GO

              
go
    

CREATE TRIGGER [dbo].[pltW_transactions_insert_update_delete]                          
   ON  [dbo].[pld_transactions]                                  
   AFTER insert , update , DELETE                                  
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
*         Name: pltW_transactions_hdr_del                             *   
*       Module:                         *                                               
* Date created: June 29 2015            *                                
*           By: Hamza Mughal                                          *                                   
*      Comment: Save the change in the change log table       *                               
*   *                   
*             *                          
********************************************************************* */                                  
AS                                   
BEGIN                                  
                
 DECLARE @action int;                
                
    SET @action = 1; -- Set Action to Insert by default.                
    IF EXISTS(SELECT * FROM DELETED)                
    BEGIN                
        SET @action =                 
            CASE                
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 2 -- Set Action to Updated.                
                ELSE 3 -- Set Action to Deleted.                       
            END                
    END                
  -----to update event notification from apps for subscribers other than that resource----
  declare @sub_resource varchar(30)
  select  @sub_resource=resource_id from inserted
  
   create table #subscriber_IDS    
   (resource_id char(16),subscriber_id int) 
   insert into #subscriber_IDS
   select resource_id,subscriber_id from plv_apps_subscriber_info where resource_id<>@sub_resource  
  /*              
 --if EXISTS(SELECT * FROM INSERTED where outlook_entry_id like '%app%' )            
 --   BEGIN            
 -- if dbo.fn_is_column_updated('pld_transactions', 'outlook_entry_id', COLUMNS_UPDATED())=1            
 -- begin            
 -- print 'from app outlook_entry_id'            
 -- return            
 -- end          
 --end      
       
 --if EXISTS(SELECT * FROM INSERTED where source like '%app%' )            
 --   BEGIN            
       
            
	--	  if dbo.fn_is_column_updated('pld_transactions', 'source', COLUMNS_UPDATED())=1            
	--	  begin            
	--		  print 'from app source'            
	--		  return            
	--	  end            
             
 --   END 
 */           
  print 'not from app  source'            
            
                    
    select top 0  transaction_id , company_code,    resource_id, trx_type ,[source],outlook_entry_id into  #data from inserted                
                    
 if @action = 3                 
  BEGIN ---111
            
		  insert into #data select  transaction_id , company_code,    resource_id, trx_type ,[source],outlook_entry_id from deleted              

  END ---111                
 else                 
  BEGIN ----222  
  if EXISTS(SELECT * FROM INSERTED where outlook_entry_id like '%app%' or source like '%app%')            
    BEGIN  ---3333          
	  if dbo.fn_is_column_updated('pld_transactions', 'outlook_entry_id', COLUMNS_UPDATED())=1            
	  begin            
		print 'from app outlook_entry_id'   
		insert into #data select  transaction_id , company_code, s.resource_id, trx_type ,[source],outlook_entry_id from inserted d,#subscriber_IDS s              
	  --return            
	  end
	   if dbo.fn_is_column_updated('pld_transactions', 'source', COLUMNS_UPDATED())=1            
	   begin            
			 print 'from app source'            
			insert into #data select  transaction_id , company_code, s.resource_id, trx_type ,[source],outlook_entry_id from inserted d,#subscriber_IDS s              
			 --return            
		end   
	            
    END ---3333
  else 
   BEGIN   
   print 'not from app update'          
	insert into #data select  transaction_id , company_code,    resource_id, trx_type ,[source],outlook_entry_id from inserted                    
   END
  
  END   ----222           
            
declare @entity_id_time int , @entity_id_exp int                  
select @entity_id_time =entity_type_id from  [plv_entity_type] where entity_type_desc = 'ExpenseTransaction'                  
 
 ---****to get the exp transactions approvers***----    
   declare @exp_transaction_id char(16)    
       
   select @exp_transaction_id=transaction_id from #data  where trx_type > 1999 and trx_type < 2999  
    
   create table #exp_transaction_approvers    
   (transaction_id char(16),resource_id char(16))    
   insert  into #exp_transaction_approvers    
   select transaction_id,resource_id from fn_approvers_get(@exp_transaction_id)     
    
   
   insert into #data    
   select  d.transaction_id , d.company_code,    a.resource_id, d.trx_type ,d.[source],d.outlook_entry_id    
   from #data d inner join #exp_transaction_approvers a on a.transaction_id =d.transaction_id    
   and d.resource_id not in (select distinct resource_id from #exp_transaction_approvers )     
       
               ---****to get the exp transactions approvers***----    
 
 
 
                      
 insert into [plv_event_notification]                     
 (primary_key,  company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                  
 select  convert(varchar, d.company_code) + '~-~' + transaction_id    ,                 
 d.company_code, @action, @entity_id_time, subscriber_id, d.resource_id, GETDATE()                    
 from #data d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id                
 where trx_type > 1999 and trx_type < 2999 and is_active = 1               
 and  not exists               
  (              
  select  1 from plv_event_notification n with(nolock)              
  where primary_key = convert(varchar, d.company_code) + '~-~' + transaction_id   and               
    n.entity_action_id = @action and               
    n.entity_type_id = @entity_id_time and               
    n.subscriber_id = i.subscriber_id               
  )              
--and isnull(d.[source],'')=''              
--and isnull(d.outlook_entry_id,'')=''              
                   
     select @entity_id_exp  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'Transaction'                  
       
    ---****to get the time transactions approvers***----    
   declare @transaction_id char(16)    
       
   select @transaction_id=transaction_id from #data  where trx_type < 1999    
    
   create table #transaction_approvers    
   (transaction_id char(16),resource_id char(16))    
   insert  into #transaction_approvers    
   select transaction_id,resource_id from fn_approvers_get(@transaction_id)     
    
   
   insert into #data    
   select  d.transaction_id , d.company_code,    a.resource_id, d.trx_type ,d.[source],d.outlook_entry_id    
   from #data d inner join #transaction_approvers a on a.transaction_id =d.transaction_id    
   and d.resource_id not in (select distinct resource_id from #transaction_approvers )     
       
               ---****to get the time transactions approvers***----        
 insert into [plv_event_notification]                     
 (primary_key,  company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                  
 select convert(varchar, d.company_code) + '~-~' + transaction_id   ,d.company_code,                
  @action, @entity_id_exp, subscriber_id, d.resource_id, GETDATE()                    
 from #data d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id                  
 where trx_type < 1999   and is_active = 1                
 and  not exists               
  (              
  select  1 from plv_event_notification n with(nolock)              
  where primary_key = convert(varchar, d.company_code) + '~-~' + d.transaction_id   and               
    n.entity_action_id = @action and               
    n.entity_type_id = @entity_id_exp and               
    n.subscriber_id = i.subscriber_id               
  )               
--and ((isnull(d.[source],'')='' and isnull(d.outlook_entry_id,'')='' ) or @action = 3   )              
END                 
                
                
               
              
              


go 