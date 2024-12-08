
drop TRIGGER [dbo].[pltW_transactions_hdr_insert_update_delete] 
go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER [dbo].[pltW_transactions_hdr_insert_update_delete]               
   ON  [dbo].[pld_transactions_hdr]              
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
*           By: Hamza Mughal              *        
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
		if dbo.fn_is_column_updated('pld_transactions_hdr', 'source', COLUMNS_UPDATED())=1
		begin
		print 'from app'
		return
		end
    END
		print 'not from app'

      
    select top 0 record_id , company_code,    resource_id,[source] into  #data from inserted i  
      
     if @action = 3  
     begin  
     insert into #data select  record_id , company_code,   resource_id ,[source] from deleted i  
  end  
  else   
  begin  
  insert into #data select  record_id , company_code,    resource_id ,[source] from inserted   i  
  end      
  
declare @entity_id int     
select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'TransactionHeader'    
     
 insert into plv_event_notification    
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                  
 select     convert(varchar, d.company_code)+ '~-~'+ record_id ,  d.company_code, @action, @entity_id, subscriber_id, d.resource_id, GETDATE()    
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id      
 where      is_active = 1   
   
  and  not exists   
  (  
  select  1 from plv_event_notification n with(nolock)  
  where primary_key = convert(varchar, d.company_code)+ '~-~'+ record_id   and   
    n.entity_action_id = @action and   
    n.entity_type_id = @entity_id and   
    n.subscriber_id = i.subscriber_id   
  )    
  --and (isnull(d.[source],'')=''   or @action = 3)  
               
END   
  
  
  
  
  
  
  



go 