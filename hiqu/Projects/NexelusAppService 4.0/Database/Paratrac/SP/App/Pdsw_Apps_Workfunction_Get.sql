/****** Object:  StoredProcedure [dbo].[Pdsw_Apps_Workfunction_Get]    Script Date: 02/04/2015 11:57:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pdsw_Apps_Workfunction_Get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Pdsw_Apps_Workfunction_Get]
GO

/****** Object:  StoredProcedure [dbo].[Pdsw_Apps_Workfunction_Get]    Script Date: 02/04/2015 11:57:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Pdsw_Apps_Workfunction_Get]                      
                      
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
*         Name: Pdsw_Apps_Resource_Get                                *                                             
*       Module:                                                       *                                             
* Date created: Dec 04 2014                                           *                                             
*           By: Sohail Nazir                                          *                                             
*      Comment:                                                       *                                             
* Date revised: Dec 22 2014                                           *                                             
*           By: Hamza Mughal                                          *                                             
*      Comment: Added the LastSyncDate                                *           
* Date revised: Jan 20 2015                                           *                                             
*           By: Hamza Mughal                                          *                                             
*      Comment: Get the Work Functions from the group rule instead of *                           
*    the table.                                            *                                             
*                                                                     *                                             
********************************************************************* */                          
@company_code int,          
@login_id varchar(64),          
@last_sync_date datetime = null -- HAMZA -- 20141222 -- Added the LastSyncDate                  
                 
AS                      
                      
BEGIN                      
              
 DECLARE @user_group_code varchar(32),                        
   @resource_id varchar(16),                    
   @sequence_id int 
              
    SELECT           
  @resource_id = resource_id           
    FROM pdd_resources           
    WHERE loginid = @login_id          
              
 SELECT          
  @user_group_code = user_group_code                        
 FROM pdm_group_user_link             
 WHERE company_code = @company_Code                      
  AND resource_id = @resource_id           
  AND preferred_group_flag = 1             
              
    SELECT          
  @sequence_id = sequence_id          
 FROM pdm_rule_group          
 WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'          
  AND user_group_code = @user_group_code          
              
 Create Table #activeWF                     
 (                    
  res_category_code char(8),                    
  ts binary(8),                    
  company_code int,                    
  res_usage_code char(16),                    
  res_usage_description varchar(64),                    
  seg_value varchar(16),                    
  active_flag tinyint,                    
  create_id varchar(32),                    
  create_date datetime,                    
  modify_id varchar(32),                    
  modify_date datetime,
  org_unit varchar(32)
 )                      
           
 create table #ruleWF          
 (          
  res_usage_code char(16)          
 )          
         
 create table #finalWF        
 (        
 res_usage_code varchar(16),        
 res_usage_description varchar(64)        
 )        
           
           -- pds_res_Usage_get 2, 'EMPL', '', 0
           
 Insert Into #activeWF                     
 Exec pds_res_Usage_get @COMPANY_CODE=@company_code,@res_category_code='EMPL',@USAGE_CODE='',@ShowActiveOnly=0      
           
 INSERT INTO #ruleWF          
 SELECT           
  sub_selected_code          
 FROM pdm_rule_group_detail          
 WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'          
 AND sequence_id = @sequence_id          
           
 -- HAMZA -- 20141222 -- Added the LastSyncDate        
 INSERT INTO #finalWF                    
 SELECT                      
  aWF.res_usage_code,          
  aWF.res_usage_description          
 FROM #activeWF aWF INNER JOIN #ruleWF rWF          
  ON aWF.res_usage_code = rWF.res_usage_code          
 WHERE company_code = @company_code                  
 AND (@last_sync_date is null OR @last_sync_date < ISNULL(modify_date, create_date))             
         
 --IF NOT EXISTS (SELECT 1 FROM #finalWF where res_usage_code = (SELECT res_usage_code FROM pdd_resources WHERE resource_id = @resource_id))        
 --BEGIN        
 --INSERT INTO #finalWF        
 --SELECT r.res_usage_code, ru.res_usage_description        
 --FROM pdd_resources r INNER JOIN pdm_res_usage ru        
 -- ON r.res_usage_code = ru.res_usage_code        
 --WHERE r.resource_id = @resource_id        
 --END        
         
 -- SELECT  * FROM #finalWF  -- HAMZA -- 20150203 -- ONLY GET THE GROUP RULE WF      
       
 IF NOT EXISTS (SELECT 1 FROM #ruleWF where res_usage_code = (SELECT res_usage_code FROM pdd_resources WHERE resource_id = @resource_id))        
 BEGIN        
  INSERT INTO #ruleWF        
  SELECT r.res_usage_code      
  FROM pdd_resources r         
  WHERE r.resource_id = @resource_id        
 END        
       
 SELECT  wf.res_usage_code,          
   wf.res_usage_description          
 FROM #ruleWF rw inner join pdm_res_usage wf      
 ON rw.res_usage_code = wf.res_usage_code      
 ORDER BY wf.res_usage_description asc    
           
 DROP TABLE #activeWF          
 DROP TABLE #ruleWF          
 DROP TABLE #finalWF        
     
END   




go