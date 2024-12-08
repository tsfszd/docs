if exists (select * from sys.triggers where name='pltW_transactions_insert_update_delete')
begin
drop TRIGGER [dbo].[pltW_transactions_insert_update_delete]                          
end
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
*   *              
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
         
  print 'not from app  source'            
            
                    
    select top 0  transaction_id , company_code,    resource_id, trx_type ,[source],outlook_entry_id into  #data1 from inserted                
                    
 if @action = 3                 
  BEGIN ---111
            
		  insert into #data1 select  transaction_id , company_code,    resource_id, trx_type ,[source],outlook_entry_id from deleted              

  END ---111                
 else                 
  BEGIN ----222  
  if EXISTS(SELECT * FROM INSERTED where outlook_entry_id like '%app%' or source like '%app%')            
    BEGIN  ---3333      
	print 'apps'    
	  if dbo.fn_is_column_updated('pld_transactions', 'outlook_entry_id', COLUMNS_UPDATED())=1            
	  begin            
		print 'from app outlook_entry_id'   
		insert into #data1 select distinct  transaction_id , d.company_code, i.resource_id, trx_type ,[source],outlook_entry_id from inserted d,plv_apps_subscriber_info   i
	  --return            
	  end
	   if dbo.fn_is_column_updated('pld_transactions', 'source', COLUMNS_UPDATED())=1            
	   begin            
			 print 'from app source'            
			insert into #data1 select distinct transaction_id , d.company_code, i.resource_id, trx_type ,[source],outlook_entry_id from inserted d,plv_apps_subscriber_info i 
			 --return            
		end 
		else
		begin
		insert into #data1 select distinct transaction_id , d.company_code, i.resource_id, trx_type ,[source],outlook_entry_id from inserted d,plv_apps_subscriber_info i
		end
		  
	            
    END ---3333
  else 
   BEGIN   
   print 'not from app update'          
	insert into #data1 select distinct transaction_id , d.company_code,    i.resource_id, trx_type ,[source],outlook_entry_id from inserted d,plv_apps_subscriber_info i                   
   END
  print '1,2'
  END   ----222           
            
declare @entity_id_time int , @entity_id_exp int                  
select @entity_id_time =entity_type_id from  [plv_entity_type] where entity_type_desc = 'ExpenseTransaction'                  
 /*
 ---****to get the exp transactions approvers***----    
   declare @exp_transaction_id char(16)    
       
   select @exp_transaction_id=transaction_id from #data1  where trx_type > 1999 and trx_type < 2999  
    
   create table #exp_transaction_approvers    
   (transaction_id char(16),resource_id char(16))    
   insert  into #exp_transaction_approvers    
   select transaction_id,resource_id from fn_approvers_get(@exp_transaction_id)     
    
   
   insert into #data1    
   select  d.transaction_id , d.company_code,    a.resource_id, d.trx_type ,d.[source],d.outlook_entry_id    
   from #data1 d inner join #exp_transaction_approvers a on a.transaction_id =d.transaction_id    
   and d.resource_id not in (select distinct resource_id from #exp_transaction_approvers )     
       
               ---****to get the exp transactions approvers***----    
 
 */
 
                      
 insert into [plv_event_notification]                     
 (primary_key,  company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                      
select  distinct convert(varchar, d.company_code) + '~-~' + transaction_id    ,                 
 d.company_code, @action, @entity_id_time, subscriber_id, d.resource_id, GETDATE()                    
 from #data1 d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id                
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
 /*      
    ---****to get the time transactions approvers***----    
   declare @transaction_id char(16)    
       
   select @transaction_id=transaction_id from #data1  where trx_type < 1999    
   print 'qqqq'
    print @transaction_id
   create table #transaction_approvers    
   (transaction_id char(16),resource_id char(16))    
   insert  into #transaction_approvers    
   select transaction_id,resource_id from fn_approvers_get(@transaction_id)     
    
   
   insert into #data1    
   select  d.transaction_id , d.company_code,    a.resource_id, d.trx_type ,d.[source],d.outlook_entry_id    
   from #data1 d inner join #transaction_approvers a on a.transaction_id =d.transaction_id    
   and d.resource_id not in (select distinct resource_id from #transaction_approvers )     
       
               ---****to get the time transactions approvers***---- 
			   */ 
			   print 'here '      
 insert into [plv_event_notification]                     
 (primary_key,  company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                  
 select distinct convert(varchar, d.company_code) + '~-~' + transaction_id   ,d.company_code,                
  @action, @entity_id_exp, subscriber_id, d.resource_id, GETDATE()                    
 from #data1 d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id                  
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

/*
-----for self approver 
declare @entity_id_level3 int  
declare @level2_key varchar(32),@level3_key varchar(64)   
select @entity_id_level3  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level3'    
if @action=1

begin

select @level2_key =level2_key,@level3_key=level3_key from pld_transactions where transaction_id=@transaction_id or transaction_id=@exp_transaction_id

if (select count(*) from pld_transactions where @level2_key =level2_key and @level3_key=level3_key ) =1
begin 
print 'data'
declare @subscriber varchar(64)

--select * from #data1
 insert into pdd_event_notification    
 (primary_key,   
 company_code,   
 entity_action_id,  
 entity_type_id,  
 subscriber_id,   
 create_id,   
 create_date)                  
 select convert(varchar, d.company_code) + '~-~' + rtrim(ltrim(@level2_key))  + '~-~' + ltrim(rtrim(@level3_key))  ,   
		 d.company_code,   
		 @action,   
		 @entity_id_level3,   
		 subscriber_id, 
		 null,   
		 GETDATE()    
	 from #data1   d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id     
 where not exists 
	 (
		select  1 from pdd_event_notification n with(nolock)
		where primary_key = convert(varchar, d.company_code) + '~-~' + rtrim(ltrim(@level2_key))  + '~-~' + ltrim(rtrim(@level3_key)) and 
				n.entity_action_id = @action and 
				n.entity_type_id = @entity_id_level3 and 
				n.subscriber_id = i.subscriber_id 
		)  
end

end

*/

         
END                 
                
                
               
              
              
GO








