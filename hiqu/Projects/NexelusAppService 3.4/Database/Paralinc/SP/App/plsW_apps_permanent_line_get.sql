/****** Object:  StoredProcedure [dbo].[plsW_apps_permanent_line_get]    Script Date: 02/04/2015 12:15:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_permanent_line_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_permanent_line_get]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_permanent_line_get]    Script Date: 02/04/2015 12:15:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[plsW_apps_permanent_line_get]
                 
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
*         Name: plsW_apps_permanent_line_get                          *                                               
*       Module:                                                       *                                               
* Date created: Nov 11 2014                                           *                                               
*           By: Sohail Nazir                                          *                                               
*      Comment:                                                       *                                               
* Date revised:                                                       *                    
*           By:                                                       *                                               
*      Comment:                                                       *                                               
*                                                                   *                                               
*                                                                     *                                               
********************************************************************* */                            
                                
@company_code int,                          
@resource_id char(16),                          
@start_date datetime = NULL,                          
@end_date datetime = NULL                          
                          
AS                          
                          
BEGIN                          
                          
   DECLARE @permission_status_l2_org int = NULL,                
           @permission_status_l2_location int = NULL,                          
           @permission_status_l3_org int = NULL,                          
           @permission_status_l3_location int = NULL,                          
         @l2org_unit1 char(16),                     
        @l2location_code1 char(16),                          
           @l3org_unit1 char(16),                          
           @l3location_code1 char(16),                          
      @user_group varchar(16)                          
                          
                          
SELECT                          
      @l2org_unit1 = org_unit,                          
      @l2location_code1 = location_code,                          
      @l3org_unit1 = org_unit,                          
      @l3location_code1 = location_code                          
   FROM plv_resource                          
   WHERE company_code = @company_code                          
 AND resource_id = @resource_id                          
                          
   SELECT                          
      @user_group = user_group_code                          
   FROM plv_group_user_link                          
   WHERE resource_id = @resource_id               AND preferred_group_flag = 1                          
                 
   If Exists (SELECT 1                         
   FROM plv_rule_group                          
   WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/OrgUnit'                          
   AND user_group_code=@user_group )              
   Begin                    
   SELECT                          
      @permission_status_l2_org = permission_status                         
   FROM plv_rule_group                          
   WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/OrgUnit'                          
   AND user_group_code=@user_group               
   End               
  Else               
  Begin              
  Set @permission_status_l2_org=0              
  End                       
                          
   IF @permission_status_l2_org <> 2                          
   BEGIN                          
      SET @l2org_unit1 = ''                          
   END                          
                 
   If Exists (SELECT 1                         
   FROM plv_rule_group                          
   WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/LocationCode'                         
   AND user_group_code=@user_group )                    
   Begin              
   SELECT                          
      @permission_status_l2_location = permission_status                          
   FROM plv_rule_group                          
   WHERE path =                          
   'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/LocationCode'                          
 AND user_group_code=@user_group                           
   End              
   Else              
   Begin              
   Set @permission_status_l2_location=0              
   End                       
   IF @permission_status_l2_location <> 2                     
   BEGIN                          
      SET @l2location_code1 = ''                          
   END                          
                 
   If Exists (SELECT 1                         
   FROM plv_rule_group      
   WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level3/OrgUnit'                          
   AND user_group_code=@user_group )                  
   Begin                   
   SELECT                          
      @permission_status_l3_org = permission_status                          
   FROM plv_rule_group                          
   WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level3/OrgUnit'                          
   AND user_group_code=@user_group             
   End              
   Else              
   Begin  
   Set @permission_status_l3_org=0              
   End                       
   IF @permission_status_l3_org <> 2                          
   BEGIN        
      SET @l3org_unit1 = ''                          
   END  
                 
   If Exists (SELECT 1                         
    FROM plv_rule_group                          
    WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level3/LocationCode'                         
    AND user_group_code=@user_group )               
    Begin                         
    SELECT                          
    @permission_status_l3_location = permission_status                          
    FROM plv_rule_group                          
    WHERE path =                          
    'Rules/TimeandExpense/TimeSheet/DataFilter/Level3/LocationCode'                          
    AND user_group_code =@user_group                          
  End              
   Else              
   Begin              
  Set @permission_status_l3_location=0              
   End             
                       
   IF @permission_status_l3_location <> 2                          
   BEGIN                          
      SET @l3location_code1 = ''                          
   END                         
                          
   CREATE TABLE #temp (                          
       level2_key char(32),                          
       level3_key char(64),                          
       [timestamp] binary(8),                          
       level2_description varchar(128),                          
       level3_description varchar(64),                          
       customer_code varchar(16),                          
       customer_name varchar(64),                          
       start_date datetime,                          
       task_code char(16),                          
       end_date datetime,                          
       resource_schedule_exist int,                          
       validate_resource tinyint,                          
       task_description varchar(64)                          
   )                          
                     
                   
                   
 --print @l2org_unit1                      
 --print @l2location_code1                 
 --print @l3org_unit1                
 --print @l3location_code1                          
 --print @start_date                          
 --print @end_date                   
                 
                     
   --INSERT INTO #temp                          
   --EXEC plsW_permanent_line_get @company_code = @company_code,                          
   --                             @resource_id = @resource_id,                          
   --                             @l2_org_unit = @l2org_unit1,                          
   --     @l2_location_code = @l2location_code1,                          
   --                             @l3_org_unit = @l3org_unit1,                          
   --                             @l3_location_code = @l3location_code1, 
   --                             @start_date = @start_date,                          
   --                             @end_date = @end_date                          
                   
   INSERT INTO #temp                          
  EXEC plsW_permanent_line_get @company_code = @company_code,                          
                                @resource_id = @resource_id,                          
                                @l2_org_unit = '',                          
                          @l2_location_code = '',                          
                                @l3_org_unit = '',                          
                                @l3_location_code = '', 
                                @start_date = @start_date,                          
                                @end_date = @end_date                      
      
  select         
  level2_key,               
  level3_key,                          
  level2_description,                          
  level3_description,                          
  customer_code,           
  customer_name,                          
  isnull(min(start_date), '2015-01-01') start_date ,                       
  task_code ,                          
  isnull(convert(varchar, max(end_date)), '') as end_date,                          
  resource_schedule_exist ,                          
  validate_resource ,                          
  task_description,                  
  @resource_id as resource_id                      
 from #temp                
 group by       
  -- start_date,
  level2_key,                          
  level3_key,                          
  level2_description,                          
  level3_description,             
  customer_code,                          
  customer_name,         
  task_code ,               
  resource_schedule_exist ,                          
  validate_resource ,                          
  task_description               
                          
END 






  


go