/****** Object:  StoredProcedure [dbo].[pdsw_apps_level3_delete_get]    Script Date: 02/04/2015 12:09:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_level3_delete_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_level3_delete_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_level3_delete_get]    Script Date: 02/04/2015 12:09:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[pdsw_apps_level3_delete_get]        
        
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
*         Name:  pdsw_apps_level3_delete_get                          *                                       
*       Module:                                                       *                                       
* Date created: Dec 30 2014                                           *                                       
*           By: Sohail Nazir                                          *                                       
*      Comment: A Delete log for offline-online synchronization       *                                       
* Date revised: Jan 12 2015             *                                       
*           By: Hamza Mughal                                          *                                       
*      Comment: Added the delete statement after retreiving the    *                                       
*               deleted records.                                      *                                 
*                                                                     *                                       
*                                                          *                                       
********************************************************************* */        
        
@company_code int,      
@include_level3 int = null, -- Just a dummy param      
@count int = null  -- Just a dummy param      
AS        

BEGIN        
   SELECT              
		company_code,              
		level2_key,              
		null as level2_description,            
		level3_key,              
		null as level3_description,            
		null as open_date,            
		null as task_type,            
		null as billable_flag,            
		null as closed_date,      
		null as open_date,      
		null as labor_flag,
		null as org_unit,
		null as Location_code,
		null as expense_flag,
		null as Date_due,
		null as cost_type,
		null as rate_table1,
		null as  rate_table2,
	      created_date          
   FROM pdd_level3_delete_log              
   WHERE company_code = @company_code              
   AND created_Date >= DATEADD(DAY, -7, GETDATE())              
           
   -- HAMZA -- 20151201 -- Also delete those records        
   DELETE FROM pdd_level3_delete_log              
   WHERE company_code = @company_code              
   AND created_Date < DATEADD(DAY, -7, GETDATE())  
END    





go