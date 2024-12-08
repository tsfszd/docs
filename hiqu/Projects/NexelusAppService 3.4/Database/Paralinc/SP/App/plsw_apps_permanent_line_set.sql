/****** Object:  StoredProcedure [dbo].[plsw_apps_permanent_line_set]    Script Date: 02/04/2015 12:34:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsw_apps_permanent_line_set]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsw_apps_permanent_line_set]
GO

/****** Object:  StoredProcedure [dbo].[plsw_apps_permanent_line_set]    Script Date: 02/04/2015 12:34:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[plsw_apps_permanent_line_set]        
        
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
*           Name: plsw_apps_permanent_line_set                        *          
*         Module:                                                     *          
*   Date created: 11/12/2014                                          *          
*             By: Sohail Nazir                                        *          
*        Version:                                                     *          
*        Comment:                                                     *          
*                                                                     *          
*   Date revised:                               *          
*             By:                        *          
*        Comment:               *          
*                                                                     *          
*                                                                     *          
******************************************************************** */        
@action_flag tinyint,       /* 1 - insert new row, 2 - update row, 3 - delete row */        
@company_code int,        
@resource_id varchar(16),        
@level2_key varchar(32),        
@level3_key varchar(64),        
@TS binary(8) = NULL,        
@start_date datetime = NULL,        
@task_code char(16) = NULL        
        
AS        
BEGIN    
 DECLARE @l2_open_date datetime,    
   @l2_close_date datetime,    
   @l3_open_date datetime,    
   @l3_close_date datetime,    
   @l2_sysname varchar(64),    
   @l3_sysname varchar(64)    
   
    CREATE TABLE #tempResult     
 (        
  ERROR_CODE int,        
  ERROR_DESCRIPTION varchar(3000)        
 )    
        
    SELECT @l2_open_date = date_opened, @l2_close_date = date_closed    
    FROM plv_level2    
    WHERE level2_key = @level2_key    
        
    SELECT @l3_open_date = date_opened, @l3_close_date = date_closed    
    FROM plv_level3    
    WHERE level2_key = @level2_key and level3_key = @level3_key    
        
        -- select  @l3_close_date
        
    SELECT @l2_sysname = (select Display_Name from plv_sysnames where field_name = 'TIME_BASED_Level2_descr')    
    SELECT @l3_sysname = (select Display_Name from plv_sysnames where field_name = 'TIME_BASED_Level3_descr')    
        
    IF @action_flag <> 3    
BEGIN    
  IF not exists (select 1 from plv_level2 where Level2_key = @level2_key)    
  BEGIN    
   SELECT -1000 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ' does not exists.'  ERROR_DESCRIPTION  
   RETURN    
  END    
      
  IF exists (select 1 from plv_level2 where Level2_key = @level2_key and level2_status <> 1)    
  BEGIN    
   SELECT -999 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ' is not active.'  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF not exists (select 1 from plv_level3 where Level2_key = @level2_key and level3_key = @level3_key)    
  BEGIN    
   SELECT -998 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ', ' + rtrim(ltrim(@l3_sysname)) + ': ' +rtrim(ltrim(@level3_key)) + ' does not exists.'  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF exists (select 1 from plv_level3 where Level2_key = @level2_key and level3_key = @level3_key and level3_status <> 1)    
  BEGIN    
   SELECT -997 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ', ' + rtrim(ltrim(@l3_sysname)) + ': ' +rtrim(ltrim(@level3_key)) + ' is not active.'  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF exists (select 1 from plv_level3 where Level2_key = @level2_key and level3_key = @level3_key and level3_status = 1 and labor_flag <> 1)    
  BEGIN    
   SELECT -997 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ', ' + rtrim(ltrim(@l3_sysname)) + ': ' +rtrim(ltrim(@level3_key)) + ' is not a valid Time Entry.'  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF @l2_open_date IS NOT NULL AND    
	convert(date, @start_date) < convert(date, @l2_open_date)    
  BEGIN    
   SELECT -1001 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + '.' + rtrim(ltrim(@l2_sysname)) + '(s) is not valid earlier than '+  convert(varchar,month(@l2_open_date))+'/'+
   convert(varchar,day(@l2_open_date))+'/'+convert(varchar,year(@l2_open_date))  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF @l2_close_date IS NOT NULL AND    
   convert(date, @start_date) > convert(date, @l2_close_date)    
  BEGIN    
   SELECT -1002 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + '.' + rtrim(ltrim(@l2_sysname)) + '(s) is not valid later than '+  convert(varchar,month(@l2_close_date))+'/'+convert(varchar,day(@l2_close_date








))+'/'+convert(varchar,year(@l2_close_date))  ERROR_DESCRIPTION      
   RETURN    
  END    
      
  IF @l3_open_date IS NOT NULL AND    
   convert(date, @start_date) < convert(date, @l3_open_date)    
  BEGIN    
   SELECT -1003 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ', ' + rtrim(ltrim(@l3_sysname)) + ': ' +rtrim(ltrim(@level3_key))+'. ' + rtrim(ltrim(@l3_sysname)) + '(s) is not valid earlier than '+  convert








(varchar,month(@l3_open_date))+'/'+convert(varchar,day(@l3_open_date))+'/'+convert(varchar,year(@l3_open_date)) ERROR_DESCRIPTION                 
   RETURN    
  END    
      
  IF @l3_close_date IS NOT NULL AND    
	convert(date, @start_date) > convert(date, @l3_close_date)    
  BEGIN    
   SELECT -1003 ERROR_CODE, 'Cannot Pin for ' + rtrim(ltrim(@l2_sysname)) + ': ' + rtrim(ltrim(@level2_key)) + ', ' + rtrim(ltrim(@l3_sysname)) + ': ' +rtrim(ltrim(@level3_key))+'. ' + rtrim(ltrim(@l3_sysname)) + '(s) is not valid later than '+  
   convert(varchar,month(@l3_close_date))+'/'+convert(varchar,day(@l3_close_date))+'/'+convert(varchar,year(@l3_close_date)) ERROR_DESCRIPTION                 
   RETURN    
  END       
 END    
         
    
 INSERT INTO #tempResult        
 EXEC plsW_permanent_line_set @action_flag = @action_flag, 
  @company_code = @company_code,        
  @resource_id = @resource_id,        
  @level2_key = @level2_key,        
  @level3_key = @level3_key,        
  @TS = @TS,        
  @start_date = @start_date,        
  @task_code = @task_code        
    
    
    
 IF (SELECT ERROR_CODE FROM #tempResult) > 0        
 BEGIN        
  SELECT -ERROR_CODE AS ERROR_CODE,        
   ERROR_DESCRIPTION        
  FROM #tempResult        
 END        
 ELSE      
 BEGIN      
  SELECT ERROR_CODE,        
   ERROR_DESCRIPTION        
  FROM #tempResult        
 END      
    
 DROP TABLE #tempResult        
END 









  
  


go