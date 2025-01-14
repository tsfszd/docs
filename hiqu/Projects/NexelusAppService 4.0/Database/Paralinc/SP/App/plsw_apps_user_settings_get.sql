/****** Object:  StoredProcedure [dbo].[plsw_apps_user_settings_get]    Script Date: 02/04/2015 12:13:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsw_apps_user_settings_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsw_apps_user_settings_get]
GO

/****** Object:  StoredProcedure [dbo].[plsw_apps_user_settings_get]    Script Date: 02/04/2015 12:13:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE plsw_apps_user_settings_get                
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
*         Name: plsw_apps_profile_get                                 *                                                                       
*       Module:                                                       *                                                                       
* Date created: Jan 20 2015                                           *                                                                       
*           By: Hamza Mughal                                          *                                                                       
*      Comment:                                                       *                                         
*                                                                     *                                                                       
*                                                                     *                                                          
********************************************************************* */                     
@company_code int,                
@resource_id varchar(64)                
AS                
BEGIN                
       
 CREATE TABLE #user_setting                
 (                
  sort_by int default 1,                
  max_hours_day int default 8,                
  max_hours_month int default 800,                
  max_hours_week int default 40,                
week_starts int default 1,              
  resource_id varchar(64) ,  
  Date_Format varchar(32) ,  
  Activity_description varchar(32),
  Level2Level3ColumnLength varchar(32)            
 )                
                 
                  
 -- SORT BY            
 if exists (select 1 from plvW_resource_profile where key_name = 'Show Level2 Code and Description' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  insert into #user_setting                
  (sort_by)                
  select top 1 param1 from plvW_resource_profile where key_name = 'Show Level2 Code and Description' and resource_id = @resource_id                
  and company_code = @company_code                
 end                
 else                
 begin                
  insert into #user_setting                
  (sort_by)                
  select top 1 param1 from plvw_resource_profile where key_name = 'Show Level2 Code and Description' and resource_id = 'DEFAULT_USER'      
 end              
       
 -- MAX HOURS/DAY                
 if exists (select 1 from plvW_resource_profile where key_name = 'Max Hours/Day' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set max_hours_day =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Max Hours/Day' and resource_id = @resource_id                
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set max_hours_day = (select top 1 param1 from plvw_resource_profile where key_name = 'Max Hours/Day' and resource_id = 'DEFAULT_USER')      
 end                
       
 -- MAX HOURS/MONTH                
 if exists (select 1 from plvW_resource_profile where key_name = 'Max Hours/Month' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set max_hours_month =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Max Hours/Month' and resource_id = @resource_id                
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set max_hours_month = (select top 1 param1 from plvw_resource_profile where key_name = 'Max Hours/Month' and resource_id = 'DEFAULT_USER')                
 end                
       
 -- MAX HOURS/WEEK                
 if exists (select 1 from plvW_resource_profile where key_name = 'Max Hours/Week' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set max_hours_week =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Max Hours/Week' and resource_id = @resource_id                
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set max_hours_week = (select top 1 param1 from plvw_resource_profile where key_name = 'Max Hours/Week' and resource_id = 'DEFAULT_USER')                          
 end                
       
 -- WEEK STARTS                
 if exists (select 1 from plvW_resource_profile where key_name = 'Week Starts' and resource_id = @resource_id                
 and company_code = @company_code)                
 begin                
  update #user_setting                
  set week_starts =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Week Starts' and resource_id = @resource_id                
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set week_starts = (select top 1 param1 from plvw_resource_profile where key_name = 'Week Starts' and resource_id = 'DEFAULT_USER')                          
 end    
 -- date format               
 if exists (select 1 from plvW_resource_profile where key_name = 'Date Format' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set Date_Format =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Date Format' and resource_id = @resource_id              
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set Date_Format = (select top 1 param1 from plvw_resource_profile where key_name = 'Date Format' and resource_id = 'DEFAULT_USER')                          
 end   
   
   
  -- Activity/Campaign           
 if exists (select 1 from plvW_resource_profile where key_name = 'Level3 Description' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set Activity_description =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Level3 Description' and resource_id = @resource_id              
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set Activity_description = (select top 1 param1 from plvw_resource_profile where key_name = 'Level3 Description' and resource_id = 'DEFAULT_USER')                          
 end   
   
 
 -- Mati -- Level2Level3ColumnLength--             
 if exists (select 1 from plvW_resource_profile where key_name = 'Level2 Level3 Column Length' and resource_id = @resource_id                
  and company_code = @company_code)                
 begin                
  update #user_setting                
  set Level2Level3ColumnLength =                
  (select top 1 param1 from plvW_resource_profile where key_name = 'Level2 Level3 Column Length' and resource_id = @resource_id                
  and company_code = @company_code)                
 end                
 else                
 begin                
  update #user_setting                
  set Level2Level3ColumnLength = (select top 1 param1 from plvw_resource_profile where key_name = 'Level2 Level3 Column Length' and resource_id = 'DEFAULT_USER')      
 end         
   
               
               
 update #user_setting              
 set resource_id = @resource_id              
                  
 select * from #user_setting                
      
 drop Table #user_setting                
                 
END     
    
        
    
      

go
