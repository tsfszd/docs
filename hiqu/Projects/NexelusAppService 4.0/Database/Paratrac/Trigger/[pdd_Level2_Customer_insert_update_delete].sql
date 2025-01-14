/****** Object:  Trigger [pdd_Level2_Customer_insert_update_delete]    Script Date: 07/14/2015 03:25:43 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[pdd_Level2_Customer_insert_update_delete]'))
DROP TRIGGER [dbo].[pdd_Level2_Customer_insert_update_delete]
GO


/****** Object:  Trigger [dbo].[pdd_Level2_Customer_insert_update_delete]    Script Date: 07/14/2015 03:25:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER [dbo].[pdd_Level2_Customer_insert_update_delete]               
   ON  [dbo].[pdd_level2_customer]            
   AFTER insert, update, delete              
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
*           By: Hamza Mughal                                          *                                              
*      Comment: Save the change in the change log table               *                                         
*                   *                                                       
*         *     
********************************************************************* */              
AS               
BEGIN              
--select * from [pdd_entity_type]  
 DECLARE @action int;    
   DECLARE @permission_status INT=NULL,                                                                                                           
            @org_unit1         CHAR(16),                                                                                                    
            @location_code1    CHAR(16),                                                                                                           
            @user_group        VARCHAR(16)   
 SET @action = 1; -- Set Action to Insert by default.    
    IF EXISTS(SELECT * FROM DELETED)    
    BEGIN    
        SET @action =     
            CASE    
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 2 -- Set Action to Updated.    
                ELSE 3 -- Set Action to Deleted.           
            END    
    END    
        
    select top 0 d.company_code, d.level2_key,d.customer_code,      resource_id, subscriber_id into  #data from inserted d, pdd_apps_subscriber_info   
        
     if @action = 1     
     begin    
     insert into #data select  d.company_code, d.level2_key,d.customer_code,      resource_id, subscriber_id from inserted d, pdd_apps_subscriber_info   
  end    
  else     
  begin    
  insert into #data select  d.company_code, d.level2_key,d.customer_code,     resource_id, subscriber_id from deleted d, pdd_apps_subscriber_info       
  end    
    
  alter table #data add user_group varchar(32), org_permission int,localtion_permission int, org_unit1 CHAR(16), location_code1 char(16)  
    
  update d   
  set user_group = user_group_code   
  from #data d inner join  pdm_group_user_link p  
 on   d.resource_id =  p.resource_id   
  where preferred_group_flag = 1     
    
    
   update d   
  set location_code1 = p.location_code    ,  org_unit1 = p.org_unit  
  from #data d inner join  pdd_resources p  
 on   d.resource_id =  p.resource_id   
    
    
   update d   
  set org_permission = permission_status   
  from #data d inner join  pdm_rule_group p  
 on   d.user_group =  p.user_group_code   
  where  path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/OrgUnit'  
    
   update d   
  set localtion_permission = permission_status   
  from #data d inner join  pdm_rule_group p  
 on   d.user_group =  p.user_group_code   
  where  path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/LocationCode'        
    
   delete d    
   from #data d inner join pdd_level2 l3 on l3.level2_key = d.level2_key    
   where org_permission = 2 and org_unit <> org_unit1  
      
   delete d    
   from #data d inner join pdd_level2 l3 on l3.level2_key = d.level2_key    
   where localtion_permission = 2 and  location_code <> location_code1  
    
    
declare @entity_id int     
select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level2Customer'    
     
 insert into pdd_event_notification    
 (primary_key,   
 company_code,   
 entity_action_id,  
 entity_type_id,  
 subscriber_id,   
 create_id,   
 create_date)                  
 select    convert(varchar, company_code) + '~-~' + level2_key  + '~-~' +  customer_code  ,   
 company_code,   
 @action,   
 @entity_id,   
 subscriber_id ,  
 null,   
 GETDATE()    
 from #data d
   where not exists 
	 (
		select  1 from pdd_event_notification n with(nolock)
		where primary_key = convert(varchar, d.company_code) + '~-~' + d.level2_key  + '~-~' +  d.customer_code   and 
				n.entity_action_id = @action and 
				n.entity_type_id = @entity_id and 
				n.subscriber_id = d.subscriber_id 
		)   
               
END 