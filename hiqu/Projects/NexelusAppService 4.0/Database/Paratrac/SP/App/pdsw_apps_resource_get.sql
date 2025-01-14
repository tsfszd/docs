/****** Object:  StoredProcedure [dbo].[pdsw_apps_resource_get]    Script Date: 02/04/2015 12:00:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_resource_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_resource_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_resource_get]    Script Date: 02/04/2015 12:00:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pdsw_apps_resource_get]    
                                          
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
* Date revised: Jan 20 2015                                           *                                                             
*           By: Hamza Mughal                                          *                                                             
*      Comment: Set the show_work_function and show_task according to *                            
*    group rule                                            *                                                             
*                                                                     *                                                             
*                                                                     *                                                        
********************************************************************* */                                  
                                          
@company_code int,                    
@login_id varchar(30),                                    
@password varchar(32) = null                                     
                        
AS            
          
BEGIN              
declare @te_db varchar(32),                                    
  @str_query varchar(max)                                    
                                      
-- set @te_db = (select database_name_esmte from Nexelus_APP..pdi_company_sites where company_code = @company_code)                                    
                                    
----------------------------------------- Validation -----------------------------------------                                    
   IF NOT EXISTS (select 1 from pdd_resources where loginid = @login_id and active_flag = 1)                                    
 begin                                    
  select -1 ERROR_CODE, 'User does not exist' ERROR_DESCRIPTION                                    
  return                                    
 end                                  
                                     
 if @password is not null                                    
 begin                                    
  -- create table #valid_resource ( is_valid int )                                    
                                      
  --set @str_query =  'insert into #valid_resource'                             
  --set @str_query += ' exec ' + @te_db + '..plsW_validate_user @login_id = ''' + @login_id + ''', @password = ''' + @password + ''''                                    
                                      
  -- exec(@str_query)                                    
                                      
  if not exists (Select 1 from pdd_resources where loginid = @login_id and res_password = @password)                                  
  begin                                        
   select -2 ERROR_CODE, 'Password is incorrect' ERROR_DESCRIPTION                                    
   return                                     
 end                                      
                                   
 end                                     
--------------------------------------- Validation Ends -------------------------------------------                                    
  create table #res_defaults                                     
  (                                    
      name_first varchar(32),                                      
   name_last varchar(32),                                      
   res_usage_code varchar(16),                                      
   res_usage_description varchar(64),                                      
   org_unit varchar(16),                                      
   org_name varchar(16),                                      
   location_code varchar(16),                                      
   loc_name varchar(16),                                      
   res_type int,                                      
   rtype_name varchar(16),                                      
   trx_type int,                                      
   ttype_name varchar(16),                                      
   currency_code varchar(8),                                      
   currency_name varchar(16),                                      
   bus_email varchar(40)                                    
  )                                    
                                    
  DECLARE @user_group_code varchar(32),                                          
    @Resource_id varchar(16),                                      
          @permission_status int,                                          
          @show_task int, --0: no show, 1: show/* 0: no show, 1: show but not compulsory, 3: show and compulsory  */                                        
          @show_workfunction int -- 0: no show, 2: show and readonly, 3: show                            
                                          
  select @Resource_id = resource_id from pdd_resources where loginid = @Login_id and active_flag = 1     
                                      
  SELECT                                          
    @user_group_code = user_group_code     
  FROM pdm_group_user_link                                          
  WHERE company_code = @Company_Code                        
  AND resource_id = @Resource_id                                         
  AND preferred_group_flag = 1                                          
                              
  IF EXISTS (select 1 from pdm_rule_group WHERE path = 'Rules/TimeandExpense/TimeSheet/Task'                   
   AND user_group_code = @user_group_code)                            
  BEGIN                            
  SELECT                                          
    @show_task =                                          
CASE                                          
                  WHEN permission_status = 1 THEN 0                                          
                  ELSE 3--1  --RS20190124 RE: HY Items 01/14/19                                           
                END                       
  FROM pdm_rule_group                                          
  WHERE path = 'Rules/TimeandExpense/TimeSheet/Task'                                          
  AND user_group_code = @user_group_code                            
  END               
  ELSE                            
  BEGIN                            
 SELECT @show_task = 0                            
  END                                   
       
	   /*    --RS20190124 RE: HY Items 01/14/19                   
  -- HAMZA -- 20150120 -- If the task is on header level then make it editable and compulsory                            
  IF EXISTS (select 1 from pdm_rule_group where path = 'Rules/TimeandExpense/TimeSheet/Task/ToShow'                            
   AND user_group_code = @user_group_code) AND @show_task <> 0                            
  BEGIN                            
 IF (SELECT default_code from pdm_rule_group where path = 'Rules/TimeandExpense/TimeSheet/Task/ToShow'                            
   AND user_group_code = @user_group_code) = 2                      
 BEGIN                            
  SELECT @show_task = 3                             
 END                            
  END  

  */   --RS20190124 RE: HY Items 01/14/19                        
                              
  -- HAMZA -- 20150120 -- Set the @show_work_function according to the rule                            
  IF EXISTS (select 1 FROM pdm_rule_group WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'                                          
   AND user_group_code = @user_group_code)                                  
  BEGIN                            
   SELECT                                          
  @show_workfunction =                                          
       CASE                                          
         WHEN permission_status = 1 THEN 0                            
         WHEN permission_status = 2 THEN 1                            
         WHEN permission_status = 3 THEN 2                            
         ELSE 0                            
    END                                          
   FROM pdm_rule_group                                          
   WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'                                          
   AND user_group_code = @user_group_code                                        
  END                            
  ELSE                            
  BEGIN                            
 SELECT @show_workfunction = 0                            
  END                               
                              
                              
                              
                              
  --set @str_query =  'insert into #res_defaults'        
  --set @str_query += ' exec ' + @te_db + '..plsW_resource_def_get @company_code = ' + convert(varchar,@company_code)                                     
  --set @str_query += ', @resource_id = ''' + @Resource_id + ''''                                    
                                      
  --print @str_query                                    
                                      
  --exec(@str_query)                            
  -- plsW_resource_def_get                                    
    -- select * FROM pdm_rule_group WHERE path like 'Security/ESM_FO/Forms/TAE_APP/TAE_EXPENSE_FUNC'              
 declare @Is_expenseReport_availible int,              
   @Is_timeSheet_availible int               
     
 if (select permission_status FROM pdm_rule_group WHERE path like '%Security/ESM_FO/Forms/TAE_APP/TAE_EXPENSE_FUNC/TAE_EXPENSE_NR_FUNC%' and user_group_code = @user_group_code) = 2    
 begin    
 set @Is_expenseReport_availible = 2    
 end    
 else    
 begin    
 select @Is_expenseReport_availible = permission_status FROM pdm_rule_group WHERE path like 'Security/ESM_FO/Forms/TAE_APP/TAE_EXPENSE_FUNC' and user_group_code = @user_group_code            
 end    
     
 if (select permission_status FROM pdm_rule_group WHERE path like 'Security/ESM_FO/Forms/TAE_APP/TAE_TIME_FUNC/TAE_TIME_TS_FUNC' and user_group_code = @user_group_code) = 2    
 begin    
 set @Is_timeSheet_availible = 2    
 end    
 else    
 begin    
 select @Is_timeSheet_availible = permission_status FROM pdm_rule_group WHERE path like 'Security/ESM_FO/Forms/TAE_APP/TAE_TIME_FUNC' and user_group_code = @user_group_code            
 end   
   
   
   
 declare @is_expense_approval_available  int,              
   @is_time_approval_available  int, @is_pending_finance_approval_available int, @is_finance_approved_available int               
     
 if (select permission_status FROM pdm_rule_group WHERE path like '%Security/ESM_FO/Forms/APL_APP/APL_TIME_FUNC%' and user_group_code = @user_group_code) = 2    
 begin    
 set @is_time_approval_available = 2    
 end    
 else    
 begin    
 select @is_time_approval_available = permission_status FROM pdm_rule_group WHERE path like  '%Security/ESM_FO/Forms/APL_APP/APL_TIME_FUNC%' and user_group_code = @user_group_code            
 end  
   
  if (select permission_status FROM pdm_rule_group WHERE path like '%Security/ESM_FO/Forms/APL_APP/APL_EXP_FUNC%' and user_group_code = @user_group_code) = 2    
 begin    
 set @is_expense_approval_available = 2    
 end    
 else    
 begin    
 select @is_expense_approval_available = permission_status FROM pdm_rule_group WHERE path like  '%Security/ESM_FO/Forms/APL_APP/APL_EXP_FUNC%' and user_group_code = @user_group_code            
 end  
   
   -------- Pending Finance approval ---------
  if (select permission_status FROM pdm_rule_group WHERE path like '%Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP%' and user_group_code = @user_group_code) = 2    
 begin    
 set @is_pending_finance_approval_available = 2    
 end    
 else    
 begin    
 select @is_pending_finance_approval_available = permission_status FROM pdm_rule_group WHERE path like  '%Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP%' and user_group_code = @user_group_code            
 end  
 
    -------- Finance approved ---------
  if (select permission_status FROM pdm_rule_group WHERE path like '%Security/ESM_FO/Forms/APL_APP/FIN_APP%' and user_group_code = @user_group_code) = 2    
 begin    
 set @is_finance_approved_available = 2    
 end    
 else    
 begin    
 select @is_finance_approved_available = permission_status FROM pdm_rule_group WHERE path like  '%Security/ESM_FO/Forms/APL_APP/FIN_APP%' and user_group_code = @user_group_code            
 end  
   
                                      
  SELECT                                       
 resource_id,                      
    name_first,             
    name_last,                                          
    res_usage_code,                                       
    r.org_unit,                                    
    r.location_code,                    
    @show_task as show_task,                                          
    @show_workfunction as show_workfunction ,             
    case when @Is_expenseReport_availible = 2 then 1 else 0 end as Is_expenseReport_availible,                  
    -- 1 as Is_expenseReport_availible,            
    case when @Is_timeSheet_availible = 2 then 1 else 0 end as Is_timeSheet_availible,                  
 -- 1 as Is_timeSheet_availible,            
 r.Currency_code,      
 org.org_name,      
 loc.loc_name ,  
 case when @is_expense_approval_available=2 then 1 else 0 end  as  Is_expense_approval_availible  ,  
 case when @is_time_approval_available=2 then 1 else 0 end  as  Is_timeSheet_approval_available ,
 case when @is_pending_finance_approval_available = 2 then 1 else 0 end  as  Is_pending_finance_approval_available ,
 case when @is_finance_approved_available = 2 then 1 else 0 end  as  Is_finance_approved_available
  ,reports_to 
   ,isnull(nullif(parent_unit,''),r.org_unit)    parent_org_unit
  ,isnull(nullif((select o.org_name from  pdm_org_units o where o.org_unit=org.parent_unit),''),org.org_name) parent_org_unit_name
              
  FROM pdd_resources r inner join pdm_org_units org       
                       on r.org_unit=org.org_unit      
                       and r.company_code=org.company_code      
                              
  inner join pdm_locations loc       
  on r.location_code=loc.location_code       
  and r.company_code=loc.company_code                                                              
  where r.company_code = @company_code                                  
  and loginid = @login_id                           
  and active_flag = 1                               
  and (@password is null or res_password = @password)                                  
                   
END 





go