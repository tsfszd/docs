/****** Object:  StoredProcedure [dbo].[pdsW_apps_exprpt_approvers_get]    Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsW_apps_exprpt_approvers_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsW_apps_exprpt_approvers_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsW_apps_exprpt_approvers_get]   Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[pdsW_apps_exprpt_approvers_get]        
       
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
*              
* Date created: 04 june 2015  
*           By: Arif hasan                                         *       
*      Comment:    
        
******************************************************************** */       
@company_code int,       
@org_unit varchar(16)=NULL,       
@location_code varchar(16)=NULL,       
@resource_id char(16)=NULL       
       
as       
begin  

--Create Table #exprpt_approvers   
--(  
--timestamp binary(8),     
--company_code int,     
--org_unit varchar(16),     
--location_code varchar(16),     
--resource_id varchar(16),     
--create_date datetime,     
--create_id varchar(32),     
--modify_date datetime,     
--modify_id varchar(32),     
--name_last varchar(32),     
--name_first varchar(32),     
--is_supervisor int         
--)    


--insert into #exprpt_approvers
 exec [pdsW_exprpt_approvers_get]  
  @company_code =@company_code ,       
  @org_unit  =@org_unit ,       
  @location_code =@location_code ,       
  @resource_id = @resource_id  
  
 --select ap.*
 --from  #exprpt_approvers ap 
 --inner join pdd_resources r
 --on ap.resource_id=r.resource_id
 --and ap.company_code=r.company_code
 --and ap.company_code=@company_code
 --where r.active_flag=1          
  
end  





go