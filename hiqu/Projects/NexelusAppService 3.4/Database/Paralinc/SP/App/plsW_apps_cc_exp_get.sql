/****** Object:  StoredProcedure [dbo].[plsW_apps_cc_exp_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_cc_exp_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_cc_exp_get]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_cc_exp_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





CREATE  PROCEDURE [dbo].[plsW_apps_cc_exp_get]    
@company_code int = 1,                 
@resource_id varchar(16) ,            
@last_sync_date datetime=null                   
           
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
*   Date revised: 4th june 2015          
*             By: arif hasan                                  *              
*        Comment:           
   --[plsW_apps_cc_exp_get]      2, '653'        
******************************************************************** */              
          
                
                  
as                 
begin        
          
  CREATE TABLE #pld_cc_exp (        
  [timestamp] binary(8) ,        
  [company_code] [int] NOT NULL,        
  [cc_exp_id] [int] NOT NULL,        
  [resource_id] [varchar](16) NULL,        
  [comments] [varchar](400) NULL,         
  [applied_date] [datetime] NULL,        
  [amount] [float] NULL,        
  [ext_reference_no] [varchar](32) NOT NULL,        
          
  [create_id] [varchar](32) NOT NULL,        
  [create_date] [datetime] NOT NULL,        
  [modify_id] [varchar](33) NULL,        
  [modify_date] [datetime] NULL,        
  [split_flag] [int] NULL,        
  [company_or_personal_flag] [int] NULL,        
  [cc_num] [varchar](32) NULL,        
  cc_type_id int,   
  [payment_code] [int] NULL,        
  [payment_name] [varchar](16) NULL,        
  cc_type_name varchar(max),      
  vendor_name varchar(max)        
)        
        
 IF @last_sync_date is null  
 begin  
  insert into #pld_cc_exp (        
   [timestamp]  ,        
   [company_code]  ,        
   [cc_exp_id]  ,        
   [resource_id] ,        
   [comments]  ,         
   [applied_date]  ,        
   [amount]  ,        
   [ext_reference_no]  ,        
   [create_id]  ,        
   [create_date] ,        
   [modify_id]  ,        
   [modify_date] ,        
   [company_or_personal_flag]  ,        
   [cc_num]  ,         
   cc_type_id  ,          
   [payment_code] ,        
   [payment_name] ,        
   cc_type_name          
 )      
  exec [plsW_cc_exp_get]  
    @company_code  = @company_code ,                 
    @resource_id = @resource_id  ,            
    @filter = 0,            
    @all_cc_types = null                
          
   update t        
   set split_flag = p.split_flag,      
   vendor_name = p.vendor_name         
   from #pld_cc_exp t inner join pld_cc_exp p on p.[cc_exp_id] = t.[cc_exp_id]  
           
   select * from #pld_cc_exp        
   -- where @last_sync_date is null OR isnull(modify_date, create_date) > @last_sync_date  
 end  
 else  
 begin  
 select [timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
     [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
     [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
     [payment_name], vendor_name   
 from pld_cc_exp  
 where resource_id = @resource_id  
 and isnull(modify_date, create_date) > @last_sync_date  
 end  
      
end     



      


go