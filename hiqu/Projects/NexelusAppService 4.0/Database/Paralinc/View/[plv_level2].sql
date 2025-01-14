
/****** Object:  View [dbo].[plv_level2]    Script Date: 01/17/2012 15:50:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[plv_level2]'))
DROP VIEW [dbo].[plv_level2]
GO

/****** Object:  View [dbo].[plv_level2]    Script Date: 01/17/2012 15:50:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[plv_level2]

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
    
    
*         Name: plv_level2                                      *    
*       Module:                                                 *    
* Date created: 10/02/96                                        *    
*           By: Leon Miskin                                     *    
*      Version:                                                 *    
    
*      Comment:                                                 *    
*                                                               *    
* Date revised:                                                 *    
*           By:                                         *    
    
*      Comment:                                         *    
*                                                                     *    
*                                                                     *    
******************************************************************** */ 

as

SELECT  DISTINCT    
 Company_code,    
 Level2_key,    
 level2_description,    
 level2_status,    
 validate_resource,    
 level_category_code,    
 generic_step_flag ,    
 cost_type,    
 task_type,    
 res_group_id,    
 billable_flag,    
 trx_approval_required_flag,  
   
 Level1_key,    
 date_opened,    
 date_closed,    
 org_unit,    
 location_code,  
 comments_for_time_required_flag, -- HAMZA -- 20150401 -- Flag needed for the check in APP Transaction SP 
 comments_for_expense_required_flag -- Rabia -- 20150802 -- Flag needed for the check in APP Transaction SP  
FROM ParatracDataBase..pdd_level2   
GO
