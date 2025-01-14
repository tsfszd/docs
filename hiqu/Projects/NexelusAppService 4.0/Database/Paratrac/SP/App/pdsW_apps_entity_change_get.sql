/****** Object:  StoredProcedure [dbo].[pdsW_apps_entity_change_get]    Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsW_apps_entity_change_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsW_apps_entity_change_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsW_apps_entity_change_get]   Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

 
  CREATE PROCEDURE [dbo].[pdsW_apps_entity_change_get]        
  @company_code int,        
  @subscriber_id int,                       
  @last_sync_date nvarchar(100)         
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
*         Name: pdsW_apps_entity_change_get                             *                                                                                                             
*       Module:                                                       *                                                                                                             
* Date created: June 29 2015            *                                                                                                             
*           By: Hamza Mughal                                          *   
*      Comment: To get the changes from entity change log             *                                     
*                   *                                                   
*                   *                                     
********************************************************************* */          
with recompile
AS        
 BEGIN        
       
 declare @last_sync_date_dt datetime              
        
 if isdate(@last_sync_date) = 1             
  begin                    
  set @last_sync_date_dt = @last_sync_date              
  end              
 else              
  begin              
  set @last_sync_date_dt = getdate()              
  end              
                        
 SELECT                 
  replace(convert(nvarchar, getdate(), 126), 'T', ' ') current_sync_date,                 
  entity_type_id,                      
  primary_key,                     
  max(entity_action_id) entity_action_id,                     
  max(entity_change_id) entity_change_id ,           
  subscriber_id                   
  into #pdd_event_notification      
  FROM [pdd_event_notification]   with(nolock)                                           
 WHERE   subscriber_id = @subscriber_id                     
 group by entity_type_id,primary_key, subscriber_id                    
                  
 create index idx on #pdd_event_notification(entity_change_id)  
  
   
 --Arif hasan 20150915 created #delete_event to avoid deadlocks  
  
 select entity_change_id into #delete_event   
  from  [pdd_event_notification]   with(nolock)                       
 WHERE   
  subscriber_id = @subscriber_id and   
  entity_change_id not in ( select entity_change_id from #pdd_event_notification )    
  
                  
 if exists ( select * from #delete_event )  
  begin   
              
   delete [pdd_event_notification]                        
   WHERE          
      entity_change_id   in ( select entity_change_id from #delete_event)                    
  
  end     
        
                      
   select * from #pdd_event_notification  order by  entity_type_id , entity_action_id                     
                                   
                
 if exists (select top 1 * from [pdd_event_notification] with(nolock) where create_date  > dateadd(day, 30, getdate())              )                  
 begin    
  delete [pdd_event_notification]                      
  where create_date  > dateadd(day, 30, getdate())                  
 end    
       
        
                          
  update pdd_apps_subscriber_info                    
  set is_active = 0                     
  where last_access_date  > dateadd(day, 30, getdate())                    
                          
                      
END     



go