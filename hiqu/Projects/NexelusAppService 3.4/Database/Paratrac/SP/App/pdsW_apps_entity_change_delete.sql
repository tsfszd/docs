/****** Object:  StoredProcedure [dbo].[pdsW_apps_entity_change_delete] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsW_apps_entity_change_delete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsW_apps_entity_change_delete]
GO

/****** Object:  StoredProcedure [dbo].[pdsW_apps_entity_change_delete] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[pdsW_apps_entity_change_delete]
 @company_code int,        
 @entity_change_id int = null,     
 @entity_type_id int =  null,     
 @primary_key varchar(3000)=null,     
 @subscriber_id varchar(64)=null,   
 @keys xml = null   
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
*         Name: [pdsW_apps_entity_change_delete]                           *                                                                                                             
*       Module:                                                       *                                                                   
* Date created: June 29 2015            *                                                                                                             
*           By: Hamza Mughal                                *                                                                                                             
*      Comment: To get the changes from entity change log             *                                     
*                 *                          
*                   *                        
'<keys>    
 <key>    
  <entity_change_id >21042015</entity_change_id >    
 </key>    
 <key>     
  <entity_change_id >002</entity_change_id >    
 </key>    
</keys>'                
********************************************************************* */          
BEGIN      
  
  select  
 T.c.value('./entity_change_id[1]', 'varchar(64)') entity_change_id  
             into #keys           
                       FROM     @keys.nodes('/keys/key') T ( c )   
                         
if @keys is not null  
 begin  
 DELETE FROM pdd_event_notification        
 WHERE entity_change_id in (select entity_change_id from #keys)   
 end   
Else                         
if   @entity_change_id is not null    
 begin    
 DELETE FROM pdd_event_notification        
 WHERE entity_change_id= @entity_change_id     
 end    
else    
 begin    
 DELETE FROM pdd_event_notification        
 WHERE     
  entity_type_id = @entity_type_id and      
  primary_key  =@primary_key and      
  subscriber_id = @subscriber_id     
 end    
              
END 





go