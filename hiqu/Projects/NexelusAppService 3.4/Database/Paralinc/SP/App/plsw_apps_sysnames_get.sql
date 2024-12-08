/****** Object:  StoredProcedure [dbo].[plsw_apps_sysnames_get]    Script Date: 02/04/2015 12:20:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsw_apps_sysnames_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsw_apps_sysnames_get]
GO

/****** Object:  StoredProcedure [dbo].[plsw_apps_sysnames_get]    Script Date: 02/04/2015 12:20:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[plsw_apps_sysnames_get]                
  
 @company_code int,                 
 @last_sync_date datetime = null  --20141222   @last_sync_date parameter is added              
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
*         Name: Pdsw_Apps_Task_Get           *                                           
*       Module:                                                       *                                           
* Date created: Dec 04 2014                                           *                                           
*           By: Sohail Nazir                                          *                                           
*      Comment:                                                       *                                           
* Date revised:                                                       *                                         
*           By:                                                       *                                           
*      Comment:                                                       *        
*                  *                                           
*                                                                     *                                           
********************************************************************* */     
AS                
BEGIN                
 create table #temp                
 (field_name varchar(64), display_name varchar(64), create_date datetime default null, modify_date datetime default null)                
                 
 insert into #temp  
 exec plsW_sysnames_get @company_code                
                 
 select field_name,             
  display_name,            
  create_date,            
  modify_date            
 from #temp                
 where field_name in  
  ('app_name', 'cust_descr', 'emp_id', 'TIME_BASED_Level2_descr','TIME_BASED_Level3_descr','location_descr',                
   'org_unit','Resource ID','Resource_Usage', 'Level2_descr', 'Level3_descr', 'Cost_Code_Name','TIME_EXP_rejected',
   'Resource','finance_approved','pending_finance_approval')    
   and (@last_sync_date is null OR @last_sync_date < ISNULL(modify_date, create_date))              
 order by field_name asc                
        
 drop table #temp                
                 
END   
  
  
  


go