/****** Object:  StoredProcedure [dbo].[Plsw_Apps_Transaction_Set]    Script Date: 02/04/2015 12:10:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Plsw_Apps_Transaction_Set]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Plsw_Apps_Transaction_Set]
GO

/****** Object:  StoredProcedure [dbo].[Plsw_Apps_Transaction_Set]    Script Date: 02/04/2015 12:10:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Plsw_Apps_Transaction_Set]          
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
*         Name: Plsw_Apps_Transaction_Set                             *               
*       Module:    *                                                                                                            
* Date created: Nov 20 2014                   *                            
*           By: Sohail Nazir                                  *                                                         
*      Comment:                                                       *                        
* Date revised: Decmber 4 2014         *        
*          By: Arif Hasan        *              
* Comment: Optimization                     *                                                  *                   *                                         
* Date revised: January 09 2015            *                                                  
*           By: Hamza Mughal            *                                                        
*      Comment: offline Synchronization          *                                                                               
*                                           *                                                                   
* Date revised: January 20 2015            *                                                                                                         
*  By: Hamza Mughal               *                                                                             
*      Comment: Some Validations           *                                                                                                         
*                   *                                                                                  
* Date revised: February 09 2015           *                                                                                                            
*           By: Hamza Mughal            *                                                                                                            
* Comment: Return the transaction on success or error on     *                                                                                    
*       error (01)               *                                                                                                            
*                   *                                                          
* Date revised: March 05 2015            *                                                                                                            
*           By: Hamza Mughal            *                                                                                                            
* Comment: Timestamp Handling            *                                                                                    
*                   *                                                          
********************************************************************* */                                                                                                    
@company_code int,                                                                                                     
@action_flag int, -- 1. New, 2. Update, 3. Delete                                                                                                                      
@resource_id char(16),                                                                                                                          
@transaction_id char(16),                                                                                                                          
@comments varchar(3000) = null,                                                                                                                      
@level2_key char(32),                                                                                      
@level3_key char(64),                                 
@task_code char(16) = null,   
@res_usage_code char(16),                                  
@line_id varchar(16) = '0',                                                                       
@units float,                                                       
@applied_date datetime,                                                                                      
@submitted_flag tinyint,                                          
@create_id varchar(32),           
@modify_date datetime = null, -- Hamza -- 20150901 -- For synchronization                                
@TS binary(8) = null,                                
@device_info varchar(3000) = null,      
@approval_comments varchar(3000)=null,      
@upload_flag int =null      
                                                             
                                                                    
AS                                                      
BEGIN   
--/*

   create table #transaction_approvers    
   (transaction_id char(16),resource_id char(16))  
   
   
      --------RS20180101 to notify the approveres 
 
 declare 
		@level2_trx_approval_flag int,    
		@level3_trx_approval_flag int,    
		@supervisor char(16)    

select @level2_trx_approval_flag= trx_approval_required_flag from plv_level2 where level2_key=@level2_key    
select @level3_trx_approval_flag= trx_approval_flag from plv_level3 where level2_key=@level2_key and level3_key=@level3_key    
select @supervisor=reports_to from plv_resource where resource_id=@resource_id    

   --------RS20180101 to notify the approveres 
  --  */
--FS20190516 dataFilters for mobile App notification Ref: Mobile Support Tickets Assign To DB team
DECLARE @org_unit_level2 VARCHAR(16),@location_code_level2 varchar(16),@org_unit_level3 VARCHAR(16),@location_code_level3 varchar(16),
@parent_org_unit_level2 VARCHAR(16),@parent_org_unit_level3 VARCHAR(16)

               
 set @applied_date = convert(date , @applied_date)                  
    set @applied_date = dateadd(hour, 12, @applied_date)                                     
                  
 DECLARE @org_unit varchar(16),                                              
 @location_code char(16),                                                
   @nonbill_flag tinyint,                                                                                        
   @override_flag tinyint = 0,                                      
   @validate tinyint = 1,                                                            
   @trx_type int                                               
                                              
                      
                      
                      
DECLARE @old_task varchar(16),                                                          
  @old_units float ,                                                          
  @old_comments varchar(3000),                                                          
  @old_res_usage varchar(16),                                            
  @old_submit_flag int                                             
                                              
 -- HAMZA -- 20150224 -- assign the task_code if show_task is not mandatory.                                                              
 DECLARE @user_group_code varchar(32),                                                                                              
   @permission_status int,                                                                                              
   @show_task int, -- 0: no show, 1: show but not compulsory, 3: show and compulsory                                                     
   @show_workfunction int -- 0: no show, 2: show and readonly, 3: show                                            
                                       
if isnull(@user_group_code, '') = ''  
begin  
	select @user_group_code = user_group_code from pdm_group_user_link where company_code = @company_code and resource_id = @resource_id and preferred_group_flag = 1  
   
	if ISNULL(@user_group_code, '') = ''  
		select top 1 @user_group_code = user_group_code from pdm_group_user_link where company_code = @company_code and resource_id = @resource_id  
end                                                 
                                            
 IF EXISTS (select 1 from plv_rule_group WHERE path = 'Rules/TimeandExpense/TimeSheet/Task'                            
  AND user_group_code = @user_group_code)                           
 BEGIN                                                                                
  SELECT          
  @show_task =                                          
   CASE                                                                                              
    WHEN permission_status = 1 THEN 0                                                                                              
   ELSE 1             
   END 
  FROM plv_rule_group                               
  WHERE path = 'Rules/TimeandExpense/TimeSheet/Task'                                                                                              
  AND user_group_code = @user_group_code                                                  
 END                       
 ELSE                                     
 BEGIN                                                                                
  SELECT @show_task = 0                                                       
 END                                                                   
                                            
 -- HAMZA -- 20150120 -- If the task is on header level then make it editable and compulsory                                                                            
 IF EXISTS (select 1 from plv_rule_group where path = 'Rules/TimeandExpense/TimeSheet/Task/ToShow'                                                                            
  AND user_group_code = @user_group_code) AND @show_task <> 0                                                                            
 BEGIN                                                            IF (SELECT default_code from plv_rule_group where path = 'Rules/TimeandExpense/TimeSheet/Task/ToShow'                                                                            
   AND user_group_code = @user_group_code) = 2                                                                      
  BEGIN                                                         
   SELECT @show_task = 3                                                                             
  END                                  
 END                                                                 
                                            
 -- HAMZA -- 20150120 -- Set the @show_work_function according to the rule                                                                    
 IF EXISTS (select 1 FROM plv_rule_group WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'                                                                                  
  AND user_group_code = @user_group_code)                                    
 BEGIN                                                                    
  SELECT @show_workfunction =                                                                                  
   CASE                                                                                  
    WHEN permission_status = 1 THEN 0                                                                    
    WHEN permission_status = 2 THEN 1                                                                    
    WHEN permission_status = 3 THEN 2                                                                    
    ELSE 0                                                  
   END                 
  FROM plv_rule_group                                                                                  
  WHERE path = 'Rules/TimeandExpense/TimeSheet/ResourceUsage'                                
  AND user_group_code = @user_group_code                                              
END                              
 ELSE       
 BEGIN                                                         
  SELECT @show_workfunction = 0      
 END                                             
                 
 select @trx_type = trx_type from  plv_resource where company_code = @company_code and resource_id = @resource_id                                        
                                                                         
 --SET @applied_date = CONVERT(date, @applied_date)                              
                                               
 create table #retTable                                           
 (                                                 
  error_code int,                                              
  error_flag int,                                                    
  error_description varchar(max),                         
  transaction_id varchar(16),                                                                                    
  level2_key varchar(32),                     
  level3_key varchar(64),        --FS20180817 32 to 64   Re: Mobile App 3.0 with Internal Timesheet 
  applied_date datetime,                                                                           
  trx_type int,                                                                                    
  resource_id varchar(16),                                                                                    
  res_usage_code varchar(16),                                                                                    
  units float,                                                                                    
  location_code varchar(16),                                                       
  org_unit varchar(16),                                                                                    
  task_code varchar(16),                                                  
  comments varchar(3000),                                                                                    
  nonbill_flag int,                                                                                    
  submitted_flag int,                                                                   
  submitted_date datetime,                                                                              
  approval_flag int,                                                                                    
  timestamp binary(8),      
  approval_comments varchar(3000),      
  upload_flag int                                
 )                                                                                  
                                                                                      
                                                   
  -- HAMZA -- 20150109 -- IF action flag = 2 and transaction does not exist then add the transaction.                                 
 if @action_flag = 2 and not exists (select 1 from pld_transactions where transaction_id = @transaction_id)                                                     
  and (@TS is null OR @TS = 0x0000000000000000)                                                        
 begin                                                              
  set @action_flag = 1                                                                                          
 end                                                                                                      
                               
 if @action_flag = 2                                                                     
 begin             
  set @override_flag = 1 
 end               
                                                                
 if @action_flag = 1                                                                      
 begin                                 
  if exists (select   * from plv_level2 where billable_flag = 1 /*non billable */  and Level2_key = @level2_key)                                        
  begin                
   set @nonbill_flag = 1                        
  end                                       
  else           
  begin                                            
   if exists (select   * from plv_level3 where billable_flag = 1 /*non billable */  and Level2_key = @level2_key and Level3_key = @level3_key)                                    
   begin                                                                                                    
    set @nonbill_flag = 1          
   end                            
   else                          
   begin               
    set @nonbill_flag = 0                                                                          
   end                                                                                                                        
  end                                                                                          
 end                                                                                                  
                                                                             
       --  select @nonbill_flag                                                                                              
                                                                             
                                                                 
 INSERT INTO #retTable                                                    
 values                                                                                  
 (0, 0, '', @transaction_id, @level2_key, @level3_key, @applied_date, @trx_type, @resource_id, @res_usage_code, @units,                                                                                  
  @location_code, @org_unit, @task_code, @comments, @nonbill_flag, @submitted_flag, null, null, @TS,@approval_comments ,      
  @upload_flag )                                                                          
                                                                                                           

---RS20171027 to avoid others transaction update   
   declare @create_id_trx varchar(32)
select @create_id_trx=create_id from pld_transactions where transaction_id = @transaction_id
if @action_flag=2 and @create_id_trx<>@create_id
begin 
 UPDATE #retTable                                                            
  SET error_code = - 106,                                                                          
  error_flag = 1,                                                                          
  error_description = 'Transaction can not be updated for other users.'                                                                          
  WHERE transaction_id = @transaction_id                                             
                                                                       
  SET @validate = 0   
end
---END RS20171027 to avoid others transaction update   
                                                                     
 -- HAMZA -- 20150119 -- Level2 Validation  
 
  declare @timebasedlevel2_sysname varchar(20),                                                     
@timebasedlevel3_sysname varchar(20)                                                     
                                 
 Select @timebasedlevel2_sysname = Display_name from plv_sysnames where Field_Name = 'TIME_BASED_Level2_descr'                                                    
 Select @timebasedlevel3_sysname = Display_name from plv_sysnames where Field_Name = 'TIME_BASED_Level3_descr'  
                                                                     
 IF NOT EXISTS(Select 1 from plv_level2 where level2_key = @level2_key) AND @validate = 1                                                            
 begin       
  --SELECT -103 ERROR_CODE, '<<TIME_BASED_Level2_descr>> does not exists.' ERROR_DESCRIPTION                 
  -- HAMZA -- 20150209 -- (01)                                                     
                                                 
                                                      
  UPDATE #retTable                                                                    
  SET error_code = - 103,                                                                                  
  error_flag = 1,                                                                                  
  error_description = @timebasedlevel2_sysname + ' does not exists.'                                                                                  
  WHERE transaction_id = @transaction_id                                                     
                                                                               
  SET @validate = 0                                                                                  
 end                                                                    
                       
declare @Max_Hours_Day float = 23, @Max_Hours_Week float=168                      
declare @Hours_Day float, @Hours_Week float                      
                      
select @Max_Hours_Day =param1   from plvw_resource_profile   where key_name = 'Max Hours/Day' and resource_id = @resource_id                      
select @Max_Hours_Week =param1   from plvw_resource_profile   where key_name = 'Max Hours/Week' and resource_id = @resource_id                      
select @Hours_Day = sum(units) from pld_transactions                       
where applied_date = @applied_date and resource_id = @resource_id and trx_type between 1000  and 1999                       
                
and transaction_id <> @transaction_id                
                      
select @Hours_Day = @Hours_Day + @units                      
                      
if @Hours_Day > @Max_Hours_Day  and @action_flag != 3                    
begin                      
                      
UPDATE #retTable                          
  SET error_code = -114,                                                                                  
  error_flag = 1,                                                                                  
  error_description = isnull(@timebasedlevel3_sysname, '') + ' Total hours of the resource per day can not be greater than ' + cast (@Max_Hours_Day as nvarchar(10))                       
  WHERE transaction_id = @transaction_id                                                       
                                                                       
  SET @validate = 0                                         
                       
end                      
                      
/* todo validation for week*/                      
                      print '@timebasedlevel3_sysname'
                           print @timebasedlevel3_sysname
 -- HAMZA -- 20150119 -- Level3 Validation     
 IF NOT EXISTS(Select 1 from plv_level3 where level2_key = @level2_key and level3_key = @level3_key)  
  AND @validate = 1                                                              
 begin                                                                                          
  -- SELECT -104 ERROR_CODE, '<<TIME_BASED_Level3_descr>> does not exists.' ERROR_DESCRIPTION                                
  -- HAMZA -- 20150209 -- (01)                                       
  UPDATE #retTable                                                                              
  SET error_code = - 104,                                                                            
  error_flag = 1,                                                                  
  error_description = @timebasedlevel3_sysname + ' does not exists.'                                                     
  WHERE transaction_id = @transaction_id        
                                                
                                                                    
                            
  SET @validate = 0                                                          
 end                                                                                    
                                       
 -- HAMZA -- 20150401 -- Added comments required check                                      
 IF (select comments_for_time_required_flag from plv_level2 where level2_key = @level2_key) = 1                                      
 AND isnull(@comments, '') = ''   AND @action_flag <> 3                                   
 BEGIN                          
  UPDATE #retTable                                                                                  
  SET error_code = - 110,                                                                                  
  error_flag = 1,                                                                                  
  error_description = 'Comments are required, please enter comments and then save.'                                                                                  
  WHERE transaction_id = @transaction_id                          
                                                                    
  SET @validate = 0                                        
 END            
                                                 
    IF @TS <> (select timestamp from pld_transactions where transaction_id = @transaction_id)                                                             
 begin                                                                 
  -- HAMZA -- 20150306 -- IF THE TIMESTAMP IS DIFFERENT THEN CHECK IF THE VALUES HAVE CHANGED, IF SO THEN GIVE ERROR, ELSE UPDATE THE TRANSACTION                                         
  SELECT @old_task  = (SELECT task_code from pld_transactions where transaction_id = @transaction_id),                                                          
  @old_units = (SELECT units from pld_transactions where transaction_id = @transaction_id),                                               
  @old_comments = (SELECT comments from pld_transactions where transaction_id = @transaction_id),                                           
  @old_res_usage = (SELECT res_usage_code from pld_transactions where transaction_id = @transaction_id),                                            
  @old_submit_flag = (SELECT submitted_flag from pld_transactions where transaction_id = @transaction_id)                                
                                            
  if (@show_task <> 3 AND (@old_task <> @task_code))                                                    
   OR (@show_workfunction <> 2 AND (@old_res_usage <> @res_usage_code))                                             
   OR  cast(round(@old_units,2) as numeric(20,2)) <> cast(round(@units,2) as numeric(20,2))                 
   OR @old_comments <> @comments                                            
  OR @old_submit_flag <> @submitted_flag                                
   OR ((select isnull(upload_flag, 0) from pld_transactions where transaction_id = @transaction_id) = 1             
  and (select isnull(approval_flag, 0) from pld_transactions where transaction_id = @transaction_id) = 0)                        
  BEGIN                                                         
   update #retTable            
   set error_code = -1001,                                                                                
    error_description = 'Transaction already updated from application. Please refresh.',                                                                     
    error_flag = 1                                                                                
   where transaction_id = @transaction_id                  
                                            
   set @validate = 0                               
                                            
   -- select * From #retTable                     
                                            
  END                                                          
 end                                            
                                                                                 
 -- HAMZA -- 20150109 -- If action flag = 2 and transaction exists then update the transaction.                                                                                                            
 if (@action_flag = 1 OR @action_flag = 2)                                                
  and exists(select 1 from pld_transactions where transaction_id = @transaction_id)                                                                               
  and @validate = 1                                                                              
 begin                                                                                                            
  if @action_flag = 1                                                                                                             
   set @action_flag = 2                                           
                                            
  -- select @show_task show_task, @show_workfunction show_workfunction            
                                
  if @show_task <> 3 and @validate = 1                                              
  begin                                                    
   select @task_code = task_code                                                            
   from pld_transactions                                                             
   where transaction_id = @transaction_id                       
  end                                                          
                                            
  if @show_workfunction <> 2 and @validate = 1                                                            
  begin                                                          
   select @res_usage_code = res_usage_code           
   from pld_transactions                                                          
   where transaction_id = @transaction_id                                                          
  end                                                          
                                             
  if @validate = 1                                
  begin                                            
   select @resource_id = resource_id,                      
     @transaction_id =transaction_id,                                                                                       
     @level2_key = level2_key,                                                                                  
     @level3_key = level3_key,                            
     @line_id = line_id,               
     @applied_date = applied_date,                                        
   @location_code = location_code,                                                                                        
  @org_unit = org_unit,                                    
     @nonbill_flag = nonbill_flag,                                                   
     @TS = timestamp,                                                            
     @trx_type = trx_type                                                     
     from pld_transactions where transaction_id = @transaction_id                                                                            
              
     --set @applied_date = convert(date , @applied_date)              
  --set @applied_date = dateadd(hour, 12, @applied_date)              
                                              
   update #retTable                             
   set resource_id = @resource_id,                          
    level2_key = @level2_key,                                        
    level3_key = @level3_key,                                             
    applied_date = @applied_date,                                                              
    location_code = @location_code,                                                              
    org_unit = @org_unit,                                                              
    nonbill_flag = @nonbill_flag,                                                              
    task_code = @task_code,                       
    timestamp = @TS                                                   
   where transaction_id = @transaction_id                                            
  end                                                                                
 end                                                                                                           
                                            
                                            
 -- HAMZA -- 20150109 -- If action_flag = 2 (Update) then first check to see if the transaction has not been deleted yet.                                                                                                    
 if (@action_flag = 2 or @action_flag = 1) and exists                        
 (select 1 from pld_transactions_delete_log where transaction_id = @transaction_id)                                                                 
 begin                                                          
 -- HAMZA -- 20150209 -- (01)                                                                    
 UPDATE #retTable                                                                                  
 SET error_code = - 102,                                       
 error_flag = 1,                                                                                  
 error_description = 'Transaction already deleted from the Application. Please refresh.'                                                                                  
 WHERE transaction_id = @transaction_id           
                                            
 SET @validate = 0                                                                                               
 end                                                                                                      
                                                                                           
                                
                                                                              
 -- HAMZA -- 20150901 -- changed plv_resource_all to plv_resource to only get the active resource.                    
 IF NOT EXISTS (select 1 from plv_resource where company_code = @company_code and resource_id = @resource_id)                                                     
  AND @validate = 1                                         
                                     
 BEGIN            
  -- SELECT - 102 ERROR_CODE, 'Resource does not exist or is not active.' ERROR_DESCRIPTION            
  -- HAMZA -- 20150209 -- (01)                                                                                
                                                   
  UPDATE #retTable                                                                                  
  SET error_code = - 105,                                                                              
  error_flag = 1,                                                 
  error_description = 'Resource does not exist or is not active.'        
  WHERE transaction_id = @transaction_id                                                              
                                                
  SET @validate = 0                                                                                        
 END                                                                        
 ELSE IF @action_flag = 1                                                 
 BEGIN                                                                                 
  SELECT @location_code = location_code,                                                                                                 
    @org_unit = org_unit                                                                                                                          
  FROM  plv_resource                                                                                                            
  WHERE company_code = @company_code       
  AND resource_id = @resource_id                                  
                                                                          
  update #retTable                                                                                  
  set location_code = @location_code,                                                                                  
   org_unit = @org_unit                                              
  where transaction_id = @transaction_id                                                          
 END                               
                                               
 create table #tempResult(ERROR_CODE int, ERROR_DESCRIPTION varchar(3000))                                                              
                      
 IF @submitted_flag = 1 AND @validate = 1                                            
 begin                                              
 SELECT @old_task  = (SELECT task_code from pld_transactions where transaction_id = @transaction_id),                                                          
  @old_units = (SELECT units from pld_transactions where transaction_id = @transaction_id),                                                          
  @old_comments = (SELECT comments from pld_transactions where transaction_id = @transaction_id),                                                          
  @old_res_usage = (SELECT res_usage_code from pld_transactions where transaction_id = @transaction_id)                                                        
 -- NEW CHANGE START HERE --                                                        
 IF not exists (select 1 from pld_transactions where transaction_id = @transaction_id)                                                 
 begin
   
 declare @applied_date_to_send datetime = convert(date, @applied_date)          
  insert into #tempResult                                                                                                
  exec plsW_timetrx_set   
   @action_flag = 1,                                                   
   @company_code = @company_code,                
   @level2_key = @level2_key,                 
   @level3_key = @level3_key,                                                                                                                   
   @transaction_id_inp = @transaction_id,                                                                                      
   @applied_date = @applied_date_to_send,          
   @org_unit = @org_unit,                                                                                        
   @location_code = @location_code,                                   
   @resource_id = @resource_id,                                                                                                          
   @comments = @comments,                                                                                                         
   @task_code = @task_code,                                                     
   @res_usage_code = @res_usage_code,     
   @submitted_flag = @submitted_flag,      
   @trx_type = @trx_type,                              
   @line_id = @line_id,                               
   @units = @units,                                                                                                    
   @nonbill_flag = @nonbill_flag,                                 
   @TS = default,                                                                                                                      
   @approval_flag = NULL,       
   @approval_comment=@approval_comments,                                                                                                             
   --@approval_comment = NULL,                                                                                                                      
   @extra_param_1 = NULL,                                                                               
   @extra_param_2 = NULL,                                       
   @outlook_entry_id = 'FROM APP',                                                     
   @create_id = @create_id,                                                     
   @modify_id = NULL,                                                             
   @override_flag = @override_flag                                                          
                                                        
  end -- IF not exists (select 1 from pld_transactions where transaction_id = @transaction_id)             -- HAMZA -- 20150310 -- IN CASE OF UPDATE, IF THE TIMESTAMP IS THE SAME THEN FIRST UPDATE THEN SUBMIT.                                             













       
  ELSE IF @TS = (select timestamp from pld_transactions where transaction_id = @transaction_id)                                              
   AND ((@old_units <> @units)                                              
   OR (@old_task <> @task_code)                                    
   OR (@old_res_usage <> @res_usage_code)                                              
   OR (@old_comments <> @comments))                                              
  BEGIN
                                  
  set @applied_date_to_send = convert(date, @applied_date)                          
   insert into #tempResult                                                                  
   exec plsW_timetrx_set                       
    @action_flag = 2,                      
    @company_code = @company_code,       
    @level2_key = @level2_key,                       
    @level3_key = @level3_key,                                                                                                                   
    @transaction_id_inp = @transaction_id,                                                                                      
    @applied_date = @applied_date_to_send,                                                             
    @org_unit = @org_unit,                                   
    @location_code = @location_code,                                                                                             
    @resource_id = @resource_id,                                                                                                                      
    @comments = @comments,                                                                                                           
    @task_code = @task_code,                                                                                                     
    @res_usage_code = @res_usage_code,                                        
    @submitted_flag = @submitted_flag,                                                                                                                      
    @trx_type = @trx_type,                                                        
    @line_id = @line_id,   
    @units = @units,                                                  
    @nonbill_flag = @nonbill_flag,                                                                                                                      
    @TS = @TS,                                                                                             
    @approval_flag = NULL,        
    @approval_comment=@approval_comments,                                                                                                            
   --@approval_comment = NULL,                              
    @extra_param_1 = NULL,                                  
    @extra_param_2 = NULL,                  
    @outlook_entry_id = 'FROM APP',                                                                                                                   
    @create_id = @create_id,         
    @modify_id = @create_id,                                                                      
    @override_flag = @override_flag     
	
	
	
	--Approval comments not updated--
	UPDATE pld_transactions                                                              
   SET
	approval_comment = @approval_comments
   WHERE transaction_id = @transaction_id   
   and resource_id = @resource_id 
	
	
	                                                        
  END -- ELSE IF @TS = (select timestamp from pld_transactions where transaction_id = @transaction_id)                                              
  ELSE                                  
  BEGIN 
                                           
   UPDATE pld_transactions                                                              
   SET submitted_flag = 1,                                                              
    submitted_date = GETDATE(),                                                              
    outlook_entry_id = 'FROM APP',                                                              
    cc_num = 'APP',                                                
    modify_id = @create_id,                                                              
    modify_date = GETDATE()                                                            
    ,source = 'APP TIME',
	approval_comment = @approval_comments,                  
    approval_flag  = case approval_flag when 2 then null else approval_flag END                                                                   
   WHERE transaction_id = @transaction_id   
   and resource_id = @resource_id    
 -- /* 
   --------RS20180101 to notify the approveres 
 
if @level2_trx_approval_flag<>0    
	begin     
	 if @level3_trx_approval_flag=2    
	 begin    
	   insert  into #transaction_approvers       
	  select @transaction_id ,@supervisor    
	 end    
	 else    
	 if @level3_trx_approval_flag=1    
	 begin    
	   insert  into #transaction_approvers      
	  select @transaction_id ,resource_id from plv_level2_resource where level2_key=@level2_key           
                                                                   and position_category_code=1    
	 end     

	end
 
/****************************************/
--FS20190516 dataFilters for mobile App notification Ref: Mobile Support Tickets Assign To DB team

ALTER TABLE #transaction_approvers ADD org_unit_res varchar(32),location_code_res varchar(32),parent_org_unit_res varchar(32)

SELECT @org_unit_level2=org_unit,@location_code_level2=location_code FROM pdd_level2 WHERE level2_key=@level2_key   
SELECT @org_unit_level3=org_unit,@location_code_level3=location_code FROM pdd_level3 WHERE level2_key=@level2_key  AND level3_key=@level3_key
SELECT @parent_org_unit_level2=ISNULL(parent_unit,'') FROM pdm_org_units where org_unit = @org_unit_level2
SELECT @parent_org_unit_level3=ISNULL(parent_unit,'') FROM pdm_org_units where org_unit = @org_unit_level3

UPDATE a
SET org_unit_res=r.org_unit
,location_code_res=r.location_code
FROM #transaction_approvers a INNER JOIN pdd_resources r 
ON a.resource_id = r.resource_id

UPDATE a
SET parent_org_unit_res= ISNULL(parent_unit,'')
FROM #transaction_approvers a INNER JOIN pdm_org_units u
ON org_unit_res = org_unit




SELECT @permission_status = permission_status                                      
    FROM   pdm_rule_group                                                                       
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level2/OrgUnit'                                                                     
           AND @user_group_code = user_group_code                                                                                                                                                                                 
                                               
    IF @permission_status = 2                                                                  
       BEGIN                                                                       
			DELETE FROM #transaction_approvers WHERE   org_unit_res <> @org_unit_level2 AND ((ISNULL(parent_org_unit_res,'')='' AND ISNULL(@parent_org_unit_level2,'')='') OR parent_org_unit_res<>@parent_org_unit_level2 )
       END                                      
                                                                                   
                         
     
    SELECT @permission_status = permission_status                                  
    FROM   pdm_rule_group                                                          
    WHERE  path =                                      
    'Rules/TimeandExpense/Approvals/DataFilter/Level2/LocationCode'                                          
           AND @user_group_code = user_group_code                                          
                                   
   IF @permission_status = 2                                         
     BEGIN                                                        
       DELETE FROM #transaction_approvers WHERE   location_code_res <> @location_code_level2
     END                                                           
                                                                         
                                                  
                                                                                                                                                                            
    SELECT @permission_status = permission_status                                                                                                           
    FROM pdm_rule_group                                                                                                                          
	WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level3/OrgUnit'                                                                                         
           AND @user_group_code = user_group_code                                                                                  
                                                                                                                                                        
 IF @permission_status = 2                                                                                               
      BEGIN                                                                                                                            
         DELETE FROM #transaction_approvers WHERE   org_unit_res <> @org_unit_level3 AND ((ISNULL(parent_org_unit_res,'')='' AND ISNULL(@parent_org_unit_level3,'')='') OR parent_org_unit_res<>@parent_org_unit_level3 )
      END                                                          
                  
    SELECT @permission_status = permission_status                    
    FROM  pdm_rule_group                                               
    WHERE  path =                                        
   'Rules/TimeandExpense/Approvals/DataFilter/Level3/LocationCode'                 
           AND @user_group_code = user_group_code   
         
    IF @permission_status = 2        
       BEGIN        
           DELETE FROM #transaction_approvers WHERE   location_code_res <> @location_code_level3                       
      END 


/******************************************/

insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
notification_type,create_id,create_date,[source],transaction_id)
select @company_code,t.resource_id,v.subscriber_id,'Time Transaction against '+ltrim(rtrim(@level2_key))+', '+
ltrim(rtrim(@level3_key))+' and '+ltrim(rtrim(@units))+' Hour(s) has been submitted for your approval.',
'TIME APPROVAL',@create_id,getdate(),'APP TIME',@transaction_id
from #transaction_approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id

delete from #transaction_approvers
ALTER TABLE #transaction_approvers drop column  org_unit_res,location_code_res ,parent_org_unit_res 


	 --------RS20180101 to notify the approveres 


   --*/
   
           
            
   -- HAMZA -- 20150330 -- In case of sumbit, get the device info from the table (if exists)   
  IF (select isnull(device_info, '') from pld_transactions where transaction_id = @transaction_id) <> ''                 
begin                     
  select @device_info = (select device_info from pld_transactions where transaction_id = @transaction_id)                                        
   end                                        
                                              
   update pld_transactions                                                                                
   set cc_num = 'APP',                                          
                     
    device_info = @device_info                   
    ,source = 'APP TIME'                                                                                     
   where transaction_id = @transaction_id                                                                                  
                                              
   update #retTable                                                                                  
   set transaction_id = (select transaction_id from pld_transactions where transaction_id = @transaction_id),                                                                                  
    level2_key = (select level2_key from pld_transactions where transaction_id = @transaction_id),                            
    level3_key = (select level3_key from pld_transactions where transaction_id = @transaction_id),                                                                                  
    applied_date = (select dateadd(hour, 12, applied_date) applied_date from pld_transactions where transaction_id = @transaction_id),                                                                                  
    trx_type = (select trx_type from pld_transactions where transaction_id = @transaction_id),                                    
    resource_id = (select resource_id from pld_transactions where transaction_id = @transaction_id),                                                                                  
    res_usage_code = (select res_usage_code from pld_transactions where transaction_id = @transaction_id),                                                                                  
    units = (select units from pld_transactions where transaction_id = @transaction_id),                                                                                  
    location_code = (select location_code from pld_transactions where transaction_id = @transaction_id),                                           
    org_unit = (select org_unit from pld_transactions where transaction_id = @transaction_id),             
    task_code = (select task_code from pld_transactions where transaction_id = @transaction_id),                                                                                  
    comments = (select comments from pld_transactions where transaction_id = @transaction_id),                                                                 
    nonbill_flag = (select nonbill_flag from pld_transactions where transaction_id = @transaction_id),                                                                                
    submitted_flag = (select submitted_flag from pld_transactions where transaction_id = @transaction_id),                                                                     
    submitted_date = (select submitted_date from pld_transactions where transaction_id = @transaction_id),                                               
    approval_flag = (select approval_flag from pld_transactions where transaction_id = @transaction_id),                                   
    timestamp = (select timestamp from pld_transactions where transaction_id = @transaction_id) ,      
    approval_comments=(select approval_comment from pld_transactions where transaction_id = @transaction_id),      
    upload_flag=(select upload_flag from pld_transactions where transaction_id = @transaction_id)     
   WHERE transaction_id = @transaction_id                                                    
    
   update #retTable                                                                                 
  set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )   from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'Level2_descr'                                            
                                              
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )    from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                            
   and Field_Name = 'Level3_descr'                                                   
                               
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', 'units' )    from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'units_1'                                                                                           
   
                                                                 
      ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
 --FS20180226
 
 ALTER TABLE #retTable ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint,is_finance_approver int default 0,is_approver int default 0
 
 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #retTable d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=l3.trx_approval_flag
 from #retTable d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #retTable d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 Update d
 set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 from #retTable d 
 inner join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key
 where l3.resource_id=@resource_id
 
 Update d
 set is_approver=CASE trx_approval_flag 
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.resource_id=d.reports_to THEN 1 ELSE 0 END END
						END
 from #retTable d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@resource_id



    
   SELECT * 
   ,isnull((select line_id from pld_transactions where transaction_id=t.transaction_id),0)line_id
   FROM #retTable t             
 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------                                            
   DROP TABLE #retTable                                                        
   -- DROP TABLE #tempResult                                                              
                                              
   RETURN                                                          
  END -- ELSE OF IF not exists (select 1 from pld_transactions where transaction_id = @transaction_id)                             
 end   -- IF @submitted_flag = 1 AND @validate = 1                        
   -- NEW CHANGE END HERE --                      
                                                  
    IF @submitted_flag = 1 AND @validate = 1                                              
    BEGIN                                  
  IF exists (select 1 from #tempResult) AND (select ERROR_CODE from #tempResult) = 0          
  begin                                                        
   UPDATE pld_transactions                                                              
   SET submitted_flag = 1,                                                              
    submitted_date = GETDATE(),                                                              
    outlook_entry_id = 'FROM APP',                                                              
    cc_num = 'APP',                                                              
    modify_id = @create_id,             
    modify_date = GETDATE(),     
	approval_comment = @approval_comments,                              
    approval_flag  = case approval_flag when 2 then null else approval_flag END                                       
    ,source = 'APP TIME'                  
 WHERE transaction_id = @transaction_id                                                              
   and resource_id = @resource_id                                                 
   
   --/*
   --------RS20180101 to notify the approveres 
 
if @level2_trx_approval_flag<>0    
	begin     
	 if @level3_trx_approval_flag=2    
	 begin    
	   insert  into #transaction_approvers       
	  select @transaction_id ,@supervisor    
	 end    
	 else    
	 if @level3_trx_approval_flag=1    
	 begin    
	   insert  into #transaction_approvers      
	  select @transaction_id ,resource_id from plv_level2_resource where level2_key=@level2_key           
                                                                   and position_category_code=1    
	 end     

	end
/****************************************/
--FS20190516 dataFilters for mobile App notification Ref: Mobile Support Tickets Assign To DB team

ALTER TABLE #transaction_approvers ADD org_unit_res varchar(32),location_code_res varchar(32),parent_org_unit_res varchar(32)

SELECT @org_unit_level2=org_unit,@location_code_level2=location_code FROM pdd_level2 WHERE level2_key=@level2_key   
SELECT @org_unit_level3=org_unit,@location_code_level3=location_code FROM pdd_level3 WHERE level2_key=@level2_key  AND level3_key=@level3_key
SELECT @parent_org_unit_level2=ISNULL(parent_unit,'') FROM pdm_org_units where org_unit = @org_unit_level2
SELECT @parent_org_unit_level3=ISNULL(parent_unit,'') FROM pdm_org_units where org_unit = @org_unit_level3

UPDATE a
SET org_unit_res=r.org_unit
,location_code_res=r.location_code
FROM #transaction_approvers a INNER JOIN pdd_resources r 
ON a.resource_id = r.resource_id

UPDATE a
SET parent_org_unit_res= ISNULL(parent_unit,'')
FROM #transaction_approvers a INNER JOIN pdm_org_units u
ON org_unit_res = org_unit




SELECT @permission_status = permission_status                                      
    FROM   pdm_rule_group                                                                       
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level2/OrgUnit'                                                                     
           AND @user_group_code = user_group_code                                                                                                                                                                                 
                                               
    IF @permission_status = 2                                                                  
       BEGIN                                                                       
			DELETE FROM #transaction_approvers WHERE   org_unit_res <> @org_unit_level2 AND parent_org_unit_res<>@parent_org_unit_level2
       END                                      
                                                                                   
                         
     
    SELECT @permission_status = permission_status                                  
    FROM   pdm_rule_group                                                          
    WHERE  path =                                      
    'Rules/TimeandExpense/Approvals/DataFilter/Level2/LocationCode'                                          
           AND @user_group_code = user_group_code                                          
                                   
   IF @permission_status = 2                                         
     BEGIN                                                        
       DELETE FROM #transaction_approvers WHERE   location_code_res <> @location_code_level2
     END                                                           
                                                                         
                                                  
                                                                                                                                                                            
    SELECT @permission_status = permission_status                                                                                                           
    FROM pdm_rule_group                                                                                                                          
	WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level3/OrgUnit'                                                                                                        
           AND @user_group_code = user_group_code                                                                                  
                                                                                                                                                        
 IF @permission_status = 2                                                                                               
      BEGIN                                                                                                                            
         DELETE FROM #transaction_approvers WHERE   org_unit_res <> @org_unit_level3 AND parent_org_unit_res<>ISNULL(parent_org_unit_level3,'') AND ISNULL(parent_org_unit_level3,'')=''                                                                                                                            
      END                                                          
                  
    SELECT @permission_status = permission_status                    
    FROM  pdm_rule_group                                               
    WHERE  path =                                        
    'Rules/TimeandExpense/Approvals/DataFilter/Level3/LocationCode'                    
           AND @user_group_code = user_group_code   
         
    IF @permission_status = 2        
       BEGIN        
           DELETE FROM #transaction_approvers WHERE   location_code_res <> @location_code_level3                       
      END  


/******************************************/
insert into pdd_apps_notification(company_code,resource_id,subscriber_id,notification_body,
notification_type,create_id,create_date,[source],transaction_id)
select @company_code,t.resource_id,v.subscriber_id,'Time Transaction against '+ltrim(rtrim(@level2_key))+', '+ltrim(rtrim(@level3_key))+
' and '+ltrim(rtrim(@units))+' Hour(s) has been submitted for your approval.',
'TIME APPROVAL',@create_id,getdate(),'APP TIME',@transaction_id
from #transaction_approvers t inner join plv_apps_subscriber_info v on t.resource_id=v.resource_id


delete from #transaction_approvers
ALTER TABLE #transaction_approvers drop column  org_unit_res,location_code_res ,parent_org_unit_res 

	 --------RS20180101 to notify the approveres 
   
   
--*/   
                                              
   update pld_transactions                                                       
   set cc_num = 'APP',                          
    device_info = @device_info                  
    ,source = 'APP TIME'                                                                                  
   where transaction_id = @transaction_id                                
                                              
   update #retTable                                                                                  
   set transaction_id = (select transaction_id from pld_transactions where transaction_id = @transaction_id),                                                                                  
    level2_key = (select level2_key from pld_transactions where transaction_id = @transaction_id),                                                                                
    level3_key = (select level3_key from pld_transactions where transaction_id = @transaction_id),                                                                                  
    applied_date = (select dateadd(hour, 12, applied_date) applied_date from pld_transactions where transaction_id = @transaction_id),                                          
    trx_type = (select trx_type from pld_transactions where transaction_id = @transaction_id),                                               
    resource_id = (select resource_id from pld_transactions where transaction_id = @transaction_id),                                                                                  
    res_usage_code = (select res_usage_code from pld_transactions where transaction_id = @transaction_id),                                    
    units = (select units from pld_transactions where transaction_id = @transaction_id),                                                                                  
    location_code = (select location_code from pld_transactions where transaction_id = @transaction_id),                                                                                  
    org_unit = (select org_unit from pld_transactions where transaction_id = @transaction_id),                                                                                  
    task_code = (select task_code from pld_transactions where transaction_id = @transaction_id),                                                           
    comments = (select comments from pld_transactions where transaction_id = @transaction_id),                                                                                  
    nonbill_flag = (select nonbill_flag from pld_transactions where transaction_id = @transaction_id),                                                                                  
    submitted_flag = (select submitted_flag from pld_transactions where transaction_id = @transaction_id),                                                                     
  submitted_date = (select submitted_date from pld_transactions where transaction_id = @transaction_id),                 
    approval_flag = (select approval_flag from pld_transactions where transaction_id = @transaction_id),                                                                                  
    timestamp = (select timestamp from pld_transactions where transaction_id = @transaction_id),      
   approval_comments=(select approval_comment from pld_transactions where transaction_id = @transaction_id),      
    upload_flag=(select upload_flag from pld_transactions where transaction_id = @transaction_id)                                                                               
   WHERE transaction_id = @transaction_id                                 
                                              
   update #retTable                                            
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )   from                                                   
   plv_sysnames                                                       
where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'Level2_descr'             
                                              
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )    from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'Level3_descr'   
                                
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', 'units' )    from                                           
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'units_1'   
   
    ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
 --FS20180226
 
 ALTER TABLE #retTable ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint,is_finance_approver int default 0,is_approver int default 0
 
 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #retTable d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=l3.trx_approval_flag
 from #retTable d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #retTable d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 Update d
 set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 from #retTable d 
 inner join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key
 where l3.resource_id=@resource_id
 
 Update d
 set is_approver=CASE trx_approval_flag 
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.resource_id=d.reports_to THEN 1 ELSE 0 END END
						END
 from #retTable d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@resource_id



    
   --SELECT * FROM #retTable              
 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------        
                       
   --SELECT * FROM #retTable                                                              
   SELECT * 
   ,isnull((select line_id from pld_transactions where transaction_id=t.transaction_id),0)line_id
   FROM #retTable t 
                                              
   DROP TABLE #retTable                                                        
   DROP TABLE #tempResult                                          
             
   RETURN                                                         
  end -- IF (select ERROR_CODE from #tempResult) = 0                                                        
  ELSE                                                        
  BEGIN                                                        
   if (select ERROR_CODE from #tempResult) > 0 OR                                                                     
    CHARINDEX('This transaction has 0 units and can not be saved',                                                                                    
    (select ERROR_DESCRIPTION from #tempResult)) > 0                                                                                   
   begin                      
    --SELECT - ERROR_CODE as ERROR_CODE, ERROR_DESCRIPTION FROM #tempResult                                                                                    
    -- HAMZA -- 20150209 -- (01)                                                                                    
    IF CHARINDEX('This transaction has 0 units and can not be saved',                                                          
     (select ERROR_DESCRIPTION from #tempResult)) > 0                                                                  
    BEGIN            
     UPDATE #retTable                                   
     SET error_code = - 400,                                      
      error_flag = 1,                                                                               
      error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                  
     WHERE transaction_id = @transaction_id                                              
    END -- IF CHARINDEX('This transaction has 0 units and can not be saved', 
    ELSE                                                                     
    BEGIN               
     UPDATE #retTable                                                  
     SET error_code = (SELECT - ERROR_CODE FROM #tempResult),                                                          
      error_flag = 1,                                                                                  
      error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                                                                  
     WHERE transaction_id = @transaction_id                                                                                  
                                              
    END -- ELSE OF IF CHARINDEX('This transaction has 0 units and can not be saved',                                                                                    
   end -- if (select ERROR_CODE from #tempResult) > 0                                                                                                                                                            
   else                                                                            
   begin                                                        
    -- HAMZA -- 20150209 -- (01)                                                                                                  
    UPDATE #retTable  
    SET error_code = (SELECT ERROR_CODE FROM #tempResult),                                                                           
    error_flag = 1,                                                                                
     error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                                                                  
    WHERE transaction_id = @transaction_id                                                                                  
   end  -- else of if (select ERROR_CODE from #tempResult) > 0                                                      
                                  
 update #retTable                                  
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )   from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                
   and Field_Name = 'Level2_descr'                                   
                                              
   update #retTable                                                                           
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )    from                                                   
   plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'Level3_descr'                                                   
                                              
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', 'units' )    from                                                   
   plv_sysnames                                                
   where ISNULL(error_description,'') <> ''                            
   and Field_Name = 'units_1'                                                    
 
  -- SELECT * FROM #retTable                                                              
    ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
 --FS20180226
 
 ALTER TABLE #retTable ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint,is_finance_approver int default 0,is_approver int default 0
 
 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #retTable d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=l3.trx_approval_flag
 from #retTable d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #retTable d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 Update d
 set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 from #retTable d 
 inner join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key
 where l3.resource_id=@resource_id
 
 Update d
 set is_approver=CASE trx_approval_flag 
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.resource_id=d.reports_to THEN 1 ELSE 0 END END
						END
 from #retTable d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@resource_id



    
   SELECT * FROM #retTable              
 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------                                                   
DROP TABLE #retTable    
   DROP TABLE #tempResult                                                              
                                              
   RETURN                                                          
  END -- ELSE OF IF (select ERROR_CODE from #tempResult) = 0                                              
    END -- IF @submitted_flag = 1 AND @validate = 1 (2nd ONE)                                              
                                    
                                                                                                   
 if @action_flag = 1 AND @validate = 1                                                                                                                     
 begin                                                                           
 set @applied_date_to_send = convert(date, @applied_date)                                                               
  insert into #tempResult                                                        
  exec plsW_timetrx_set                                                                                              
   @action_flag = @action_flag,                                                                                                       
   @company_code = @company_code,                                                                      
   @level2_key = @level2_key,                                                           
   @level3_key = @level3_key,                                                                   
   @transaction_id_inp = @transaction_id,                            
   @applied_date = @applied_date_to_send,                 
   @org_unit = @org_unit,                                             
   @location_code = @location_code,                  
   @resource_id = @resource_id,    
   @comments = @comments,                                                                                                                      
   @task_code = @task_code,                                                                                                                      
   @res_usage_code = @res_usage_code,              
   @submitted_flag = @submitted_flag,                                                                                                                      
   @trx_type = @trx_type,                                                                        
 
   @line_id = @line_id,                                                           
   @units = @units,                                          
   @nonbill_flag = @nonbill_flag,                                           
   @TS = default,                                                                                                                      
@approval_flag = NULL,                                                                                                              
   --@approval_comment = NULL,       
   @approval_comment=@approval_comments,      
   @extra_param_1 = NULL,                                    
   @extra_param_2 = NULL,   
   @outlook_entry_id = 'FROM APP',                                                                           
   @create_id = @create_id,                                                                                 
   @modify_id = NULL,                                                      
   @override_flag = @override_flag   
   
   --Approval comments not updated--
	UPDATE pld_transactions                                                    
   SET
	approval_comment = @approval_comments
   WHERE transaction_id = @transaction_id   
   and resource_id = @resource_id 
   
   
                       
 end                          
 else IF @validate = 1                                                                                                                   
 begin               
 set @applied_date_to_send = convert(date, @applied_date)                                        
  insert into #tempResult                                                                         
 exec plsW_timetrx_set                                                                                                                       
   @action_flag = @action_flag,                                                         
   @company_code = @company_code,                                             
   @level2_key = @level2_key,                                                                                                                      
   @level3_key = @level3_key,                                                                                                                      
   @transaction_id_inp = @transaction_id,                                                                                                                      
   @applied_date = @applied_date_to_send,                                                      
   @org_unit = @org_unit,                                                                                                  
   @location_code = @location_code,                                                                                                                      
   @resource_id = @resource_id,                                                                                 
   @comments = @comments,                  
   @task_code = @task_code,                                                                              
   @res_usage_code = @res_usage_code,                                                                       
   @submitted_flag = @submitted_flag,                                   
   @trx_type = @trx_type,                                                
   @line_id = @line_id,                                                                         
   @units = @units,                                                                                                                     
   @nonbill_flag = @nonbill_flag,                                                                  
   @TS = @TS,                                                                                                                      
   @approval_flag = NULL,                                                                                     
   --@approval_comment = NULL,      
   @approval_comment=@approval_comments,       
   @extra_param_1 = NULL,                                                                                
   @extra_param_2 = NULL,                                                                          
   @outlook_entry_id = 'FROM APP',                
   @create_id = @create_id,                                                
   @modify_id = NULL,                                                                              
   @override_flag = @override_flag     
   
   
   --Approval comments not updated--
	UPDATE pld_transactions                                                              
   SET
	approval_comment = @approval_comments
   WHERE transaction_id = @transaction_id   
   and resource_id = @resource_id                     
 end                                                                                                                      
                          
                                                                                
                                    
 if @validate = 1                                                                                  
 begin                                                                                  
 if (select ERROR_CODE from #tempResult) > 0 OR                   
CHARINDEX('This transaction has 0 units and can not be saved',                   
   (select ERROR_DESCRIPTION from #tempResult)) > 0                                                                                    
  begin                                                                                                                      
   --SELECT - ERROR_CODE as ERROR_CODE, ERROR_DESCRIPTION FROM #tempResult                                                                                    
   -- HAMZA -- 20150209 -- (01)                                                                                    
   IF CHARINDEX('This transaction has 0 units and can not be saved',                                                                                    
    (select ERROR_DESCRIPTION from #tempResult)) > 0                      
   BEGIN                                                                                    
    UPDATE #retTable                                                                                  
    SET error_code = - 400,                                                                                  
     error_flag = 1,                            error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                                                                  
    WHERE transaction_id = @transaction_id                                               
                                         
   END                                                                                    
   ELSE                              
   BEGIN                                                                                    
    UPDATE #retTable                                           
    SET error_code = (SELECT - ERROR_CODE FROM #tempResult),                                                                                  
     error_flag = 1,                                                                                  
     error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                       
    WHERE transaction_id = @transaction_id                    
                                                                    
   END                                                           
  end                                                                                      
  -- HAMZA -- 20150204 -- update the cc_num field to APP to identify that the transaction is from APP                                                                                      
  else if (select ERROR_CODE from #tempResult) = 0  AND                                       
   CHARINDEX('This transaction has 0 units and can not be saved',                       
   (select ERROR_DESCRIPTION from #tempResult)) = 0             
  begin        
   if @action_flag = 1 OR @action_flag = 2                                                      
   begin                                                                                      
    update pld_transactions   
    set cc_num = 'APP',                                          
  device_info = @device_info                   
  ,source = 'APP TIME'                                                                                          
    where transaction_id = @transaction_id                                                                                  
                                      
    update #retTable                
    set transaction_id = (select transaction_id from pld_transactions where transaction_id = @transaction_id),           
     level2_key = (select level2_key from pld_transactions where transaction_id = @transaction_id),                                                                                  
     level3_key = (select level3_key from pld_transactions where transaction_id = @transaction_id),                                                                                  
     applied_date = (select dateadd(hour, 12, applied_date) applied_date from pld_transactions where transaction_id = @transaction_id),                              
     trx_type = (select trx_type from pld_transactions where transaction_id = @transaction_id),                                                                     
     resource_id = (select resource_id from pld_transactions where transaction_id = @transaction_id),                                                                                  
     res_usage_code = (select res_usage_code from pld_transactions where transaction_id = @transaction_id),                                          
     units = (select units from pld_transactions where transaction_id = @transaction_id),                                                                                  
     location_code = (select location_code from pld_transactions where transaction_id = @transaction_id),                                                                                  
     org_unit = (select org_unit from pld_transactions where transaction_id = @transaction_id),                                                                                  
     task_code = (select task_code from pld_transactions where transaction_id = @transaction_id),  
     comments = (select comments from pld_transactions where transaction_id = @transaction_id),                                                     
     nonbill_flag = (select nonbill_flag from pld_transactions where transaction_id = @transaction_id),                                       
     submitted_flag = (select submitted_flag from pld_transactions where transaction_id = @transaction_id),                                                                                  
     submitted_date = (select submitted_date from pld_transactions where transaction_id = @transaction_id),                                                                        
     approval_flag = (select approval_flag from pld_transactions where transaction_id = @transaction_id),                                                                                  
     timestamp = (select timestamp from pld_transactions where transaction_id = @transaction_id),      
     approval_comments=(select approval_comment from pld_transactions where transaction_id = @transaction_id),      
     upload_flag=(select upload_flag from pld_transactions where transaction_id = @transaction_id)                                 
    WHERE transaction_id = @transaction_id   
   
  end                                                                                   
  else                               
  begin                  
   update #retTable                                               
   set transaction_id = @transaction_id,                                                                                  
    level2_key = @level2_key,                           
    level3_key = @level3_key,                                                                          
    applied_date = dateadd(hour, 12, @applied_date),                            
    trx_type = 1006,                    
    resource_id = @resource_id,                                                                             
    res_usage_code = @res_usage_code,                                                                                  
    units = @units,                                         
    location_code = @location_code,                                                                                  
    org_unit = @org_unit,                   
    task_code = @task_code,                                                                                  
    comments = @comments,                                                              
    nonbill_flag = @nonbill_flag,                                                                                  
    submitted_flag = @submitted_flag,                                                                                  
    submitted_date = (select submitted_date from pld_transactions where transaction_id = @transaction_id),                                                                               
    approval_flag = (select approval_flag from pld_transactions where transaction_id = @transaction_id),                                                                                  
   timestamp = @TS ,        
   approval_comments=(select approval_comment from pld_transactions where transaction_id = @transaction_id),      
    upload_flag=@upload_flag                                                     
   WHERE transaction_id = @transaction_id                                                                    
  end                                                          
end                                                                
  else                                                           
  begin                                                             
   -- HAMZA -- 20150209 -- (01)                                                         
   UPDATE #retTable                                                               
   SET error_code = (SELECT ERROR_CODE FROM #tempResult),                         
    error_flag = 1,           
    error_description = (SELECT ERROR_DESCRIPTION FROM #tempResult)                                                                                  
   WHERE transaction_id = @transaction_id                                                                                  
  end                                                                                  
 end                    
                                                      
   update #retTable     
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )   from                                                   
  plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''    
   and Field_Name = 'Level2_descr'                                                   
                                                     
    update #retTable                        
 set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', Display_Name )    from                                                   
  plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
   and Field_Name = 'Level3_descr'                                                   
  
   update #retTable                                                                                 
   set error_description = replace( error_description, '<<'+ ltrim(rtrim(Field_Name ))+ '>>', 'units' ) from                                                   
  plv_sysnames                                                       
   where ISNULL(error_description,'') <> ''                                                    
 and Field_Name = 'units_1'                                              
       
	   
declare @name_last varchar(32)	            ,@name_first varchar(32)
select @name_last=name_last	,@name_first=name_first from pdd_resources where resource_id=@resource_id
 
   ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
 --FS20180226
 
 ALTER TABLE #retTable ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint,is_finance_approver int default 0,is_approver int default 0
 
 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #retTable d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=l3.trx_approval_flag
 from #retTable d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #retTable d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 Update d
 set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 from #retTable d 
 inner join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key
 where l3.resource_id=@resource_id
 
 Update d
 set is_approver=CASE trx_approval_flag 
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.resource_id=d.reports_to THEN 1 ELSE 0 END END
						END
 from #retTable d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@resource_id



    
                 
 ----------------------------------------------------------------------------
 ---------------------------------------------------------------------------- 
 /*commented on 06212018 by nasir abbasi*/
 /* 
 SELECT *,@name_last name_last,@name_first name_first FROM #retTable                                                              
                           */

/*start */


 SELECT t.*,@name_last name_last,@name_first name_first 
 ,isnull((select line_id from pld_transactions where transaction_id=t.transaction_id),0)line_id
 FROM #retTable  t                                                               
  /*end*/                         

 --if not exists (select 1 from #retTable where error_flag > 0)                          
 --begin   
 ---- HAMZA -- 20150909 -- Break the sync loop here.                            
 -- IF exists (select 1 from plv_event_notification with (nolock)                            
 --  where primary_key = convert(varchar, @company_code) + '~-~' + @transaction_id                            
 --  --and subscriber_id = @subscriber_id\                            
 --   and entity_type_id = 7)                            
 -- BEGIN                            
 --  DELETE FROM plv_event_notification                            
 --  where primary_key = convert(varchar, @company_code) + '~-~' + @transaction_id                            
 --  --and subscriber_id = @subscriber_id                            
 --  and entity_type_id = 7                            
 -- END                             
 --end        
           
 drop table #retTable                                                           
 drop table #tempResult     
 
-- ---RS20180118 to notify seld approver of level3 for new transaction
--declare @level2_key varchar(32) 
-- if @action_flag=1
--  begin
--	select @level2_key =level2_key from pld_transactions where transaction_id=@transaction_id 
 
--	if (select count(*) from pld_transactions where @level2_key =level2_key  ) =1  
--	begin 
--	update pdd_level3
--	set modify_date=getdate()
--	where level2_key=@level2_key
--	end                               
--  end                                                          
END
go

