/****** Object:  StoredProcedure [dbo].[pdsw_apps_exprpt_fields_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_exprpt_fields_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_exprpt_fields_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_exprpt_fields_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  

CREATE PROCEDURE   [dbo].[pdsw_apps_exprpt_fields_get]        
  @company_code int          
 , @last_sync_date datetime = null           
---- plsW_apps_exptrx_hdr_get 10,'EMP000228','02/02/1966','02/02/2006',4              
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
        
[plsW_apps_exptrx_hdr_get] 2, 451        
******************************************************************** */              
AS             
 begin          
  select * from pdd_exprpt_fields      
   where @last_sync_date is null or (create_date > @last_sync_date or modify_date > @last_sync_date)  
          
  end 





go