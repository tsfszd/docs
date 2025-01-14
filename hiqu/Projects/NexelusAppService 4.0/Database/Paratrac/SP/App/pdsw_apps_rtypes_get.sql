/****** Object:  StoredProcedure [dbo].[pdsw_apps_rtypes_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_rtypes_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].pdsw_apps_rtypes_get
GO

/****** Object:  StoredProcedure [dbo].pdsw_apps_rtypes_get Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE pdsw_apps_rtypes_get    
 @company_code int,    
 @last_sync_date datetime = null    
AS    
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
*   Date revised: 8th July 2015                
*             By: Hamza Mughal               *                    
*        Comment:                 
*   -- exec [plsW_exptransactions_get_temp] 2, '451', 1      *   
*    
*    Date revised: 08/13/2015                                         *     
*           By:    Hamad Safder                                       *     
*      Comment:                *   
              
******************************************************************** */         
BEGIN    
     
-- create table #res_types    
-- (    
--  timestamp binary(8),    
--  company_code int,    
--  res_category_code char(8),    
--  res_type int,    
--  rtype_name varchar(16),    
--  rtype_description varchar(64),    
--  uom_code char(8),    
--  rtype_status tinyint,    
--  normalize_units_flag tinyint,    
--  standard_units float,    
--  seg_value varchar(16),    
--  gl_account varchar(32),    
--  create_id varchar(33),    
--  create_date datetime,    
--  modify_id varchar(32),    
--  modify_date datetime    
-- )    
     
-- insert into #res_types    
-- --exec pds_rtypes_get @COMPANY_CODE=@company_code, @Res_Category_Code='exp'    
-- ----------CODE ADDED HAMAD  
   
--SELECT timestamp ,    
--company_code ,    
--res_category_code ,    
--res_type ,    
--rtype_name ,    
--rtype_description ,    
--uom_code ,    
--rtype_status ,    
--normalize_units_flag ,    
--standard_units ,    
--seg_value ,    
--gl_account ,    
--create_id ,    
--create_date ,    
--modify_id ,    
--modify_date      
        
--FROM pdm_resource_types         
--WHERE res_category_code ='exp'        
--AND company_code=@company_code    
    
 select *     
 from pdm_resource_types     
 where @last_sync_date is null or (ISNULL(modify_date, create_date) >= @last_sync_date)  
 and res_category_code ='exp'        
AND company_code=@company_code    
     
END 





go