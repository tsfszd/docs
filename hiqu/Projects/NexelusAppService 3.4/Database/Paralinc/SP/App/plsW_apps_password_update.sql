/****** Object:  StoredProcedure [dbo].[plsW_apps_password_update]    Script Date: 02/04/2015 12:13:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_password_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_password_update]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_password_update]    Script Date: 02/04/2015 12:13:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROC plsW_apps_password_update        
        
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
*         Name: plsW_apps_password_update                             *            
*       Module: Maintenance/Change Password/                          *            
* Date created: 01/27/2015                                            *            
*           By: Sohail Nazir                                          *            
*      Version:                                                       *            
*      Comment:                                                       *            
*                                                                     *            
* Date revised:                                                       *            
*           By:                                                       *            
*      Comment: o                                                     *            
*                                                                     *            
*       *            
******************************************************************** */        
        
@company_code int,        
@login_id varchar(30),        
@old_password varchar(32),        
@new_password varchar(32)        
        
AS        
    

        
  CREATE TABLE #tempResult       
  (        
    ERROR_CODE int,        
    ERROR_DESCRIPTION varchar(3000)        
  )        
        
  INSERT INTO #tempResult        
  EXEC plsW_password_update @company_code = @company_code,        
                       @login_id = @login_id,        
                            @old_password = @old_password,        
                            @new_password = @new_password      
                               
      
  if exists (select 1 from #tempResult where ERROR_CODE != 0)    
  BEGIN     
 SELECT - ERROR_CODE as ERROR_CODE, ERROR_DESCRIPTION FROM #tempResult WHERE ERROR_CODE != 0    
 RETURN    
  END    
  ELSE    
  BEGIN    
 SELECT 0 ERROR_CODE, '' ERROR_DESCRIPTION    
 RETURN     
  END 








go