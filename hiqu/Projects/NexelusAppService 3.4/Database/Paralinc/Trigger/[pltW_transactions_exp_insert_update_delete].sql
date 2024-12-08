drop TRIGGER [dbo].[pltW_transactions_exp_insert_update_delete]               
    go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TRIGGER [dbo].[pltW_transactions_exp_insert_update_delete]               
   ON  [dbo].[pld_transactions_exp]              
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
*       Module:                                                       *                                                                                                                 
* Date created: June 29 2015            *                                                                                                                 
*           By: Hamza Mughal                    *     
*      Comment: Save the change in the change log table               *                                         
*                   *                                                       
*                   *     
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
    
    if EXISTS(SELECT * FROM INSERTED where source like '%app%' )
    BEGIN
		if dbo.fn_is_column_updated('pld_transactions_exp', 'source', COLUMNS_UPDATED())=1
		begin
		print 'from app'
		return
		end
    END
		print 'not from app'
    
      
    select top 0 i.transaction_id, i.company_code, resource_id ,i.[source] into  #data  from inserted i inner join pld_transactions p on p.transaction_id = i.transaction_id  
      
     if @action = 1   
     begin  
     insert into #data select i.transaction_id, i.company_code, resource_id ,i.[source] from inserted i inner join pld_transactions p on p.transaction_id = i.transaction_id  
  end  
  else   
  begin  
  insert into #data select i.transaction_id, i.company_code,  resource_id ,i.[source]  from deleted i inner join pld_transactions p on p.transaction_id = i.transaction_id  
  end      
  
  
  
declare @entity_id int     
select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'TransactionExpense'   


 ---****to get the exp transactions approvers***----    
   declare @exp_transaction_id char(16)    
       
   select @exp_transaction_id=transaction_id from #data  
    
   create table #exp_transaction_approvers    
   (transaction_id char(16),resource_id char(16))    
   insert  into #exp_transaction_approvers    
   select transaction_id,resource_id from fn_approvers_get(@exp_transaction_id)     
    
   
   insert into #data    
   select  d.transaction_id , d.company_code,    a.resource_id ,d.[source]
   from #data d inner join #exp_transaction_approvers a on a.transaction_id =d.transaction_id    
   and d.resource_id not in (select distinct resource_id from #exp_transaction_approvers )     
       
               ---****to get the exp transactions approvers***----    


 
     
 insert into plv_event_notification    
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                  
 select     convert(varchar, d.company_code)+ '~-~'+ transaction_id ,  d.company_code, @action, @entity_id, subscriber_id,  d.resource_id, GETDATE()    
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id     
     
 where      is_active = 1   
   
  and  not exists   
  (  
  select  1 from plv_event_notification n with(nolock)  
  where primary_key = convert(varchar, d.company_code)+ '~-~'+ transaction_id    and   
    n.entity_action_id = @action and   
    n.entity_type_id = @entity_id and   
    n.subscriber_id = i.subscriber_id   
  )    
       --and (isnull(d.[source],'')=''  or @action = 3)  
  
               
END   
  
  
  
  




go 