/****** Object:  StoredProcedure [dbo].[plsw_apps_transaction_delete_get]    Script Date: 02/04/2015 12:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsw_apps_transaction_delete_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsw_apps_transaction_delete_get]
GO

/****** Object:  StoredProcedure [dbo].[plsw_apps_transaction_delete_get]    Script Date: 02/04/2015 12:19:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[plsw_apps_transaction_delete_get]                
                
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
*         Name: plsw_apps_transaction_delete_get                      *                                               
*       Module:                                                       *                                               
* Date created: Dec 30 2014                                           *                                               
*           By: Sohail Nazir                                          *                                               
*      Comment: A Delete log for offline-online synchronization       *                                               
* Date revised: Jan 12 2015             *       
*           By: Hamza Mughal                                          *                                               
*      Comment: Added the delete statement after retreiving the    *                                               
*               deleted records.                                      *                                               
*                                                                     *                                               
*                            *                                               
********************************************************************* */                
                
@company_code int,                
@resource_id char(16)                
               
AS                
                
BEGIN                
                
   SELECT                
      company_code,                
      transaction_id,              
      null as level2_key,              
      null as level3_key,              
      null as applied_date,              
      null as trx_type,                
      resource_id,                
      null as res_usage_code,              
      null as units,              
      null as location_code,       
      null as org_unit,              
      null as task_code,     
      null as comments,              
      null as nonbill_flag,              
      null as submitted_flag,              
      null as submitted_date,              
      null as approval_flag,        
      null as timestamp,              
 created_date            
   FROM pld_transactions_delete_log                
   WHERE company_code = @company_code                
AND resource_id = @resource_id                
   AND created_Date >= DATEADD(DAY, -7, GETDATE())                
             
   -- HAMZA -- 20151201 -- Also delete those records          
   DELETE FROM pld_transactions_delete_log                
   WHERE company_code = @company_code                
   AND resource_id = @resource_id                
   AND created_Date >= DATEADD(DAY, -7, GETDATE())          
             
END 


go