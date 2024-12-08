/****** Object:  StoredProcedure [dbo].[plsW_apps_exprpt_approvers_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_exprpt_approvers_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_exprpt_approvers_get]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_exprpt_approvers_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[plsW_apps_exprpt_approvers_get]     
     
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
*         Name: pdsW_exptypes_fields_get                                        *     
*       Module: eSMWeb                            *     
* Date created: Oct 19, 2007                                          *     
*           By: M Nauman Khan                                         *     
*      Comment: This procedure will Get info for vendor       *     
*                                                                     *     
* Date revised:                                                       *     
*           By:                                                       *     
*      Comment:                                                      *     
*                                                                     *     
*                                                                     *     
******************************************************************** */     
@company_code int,     
@org_unit varchar(16)=NULL,     
@location_code varchar(16)=NULL,     
@resource_id char(16)=NULL     
     
as     
     
Create table #TempSupervisors     
(      
resource_id char(16) null     
)     
     
     
IF ((@resource_id is NOT NULL) and (@resource_id <> ''))     
BEGIN     
  
	declare @reports_to varchar(16)   
    
   
	WHILE (1=1)   
		BEGIN  
			 select @reports_to=reports_to from plv_resource_all   
			 where res_category_code = 'EMPL'   
			 and resource_id = @resource_id      
		    
			 IF ((@reports_to is NOT NULL) and (@reports_to <> '')   
			  and (@reports_to not in (select resource_id from #TempSupervisors)))   
				 BEGIN   
				  INSERT INTO #TempSupervisors(resource_id)   
				  SELECT @reports_to   
				   
				  SELECT @resource_id=@reports_to   
				 END   
			 ELSE   
				 BEGIN   
				  BREAK   
				 END   
		END	 
   
END     
     
DECLARE @override_path varchar(255),     
@yes_path varchar(255),     
@default_code varchar(255),  
@chain_supervisor_path varchar(255),   -- AS20110412 from eSM74  
@chain_supervisor_permission_status int   -- AS20110412 from eSM74  
/**********************Yousaf Khan 4 Rabi-ul-awal 1430 h**********************************/     
SELECT @override_path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'     
SELECT @yes_path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'     
SELECT @chain_supervisor_path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/SupervisorChain'    -- AS20110412 from eSM74  
  
-- AS20110412 from eSM74  
SELECT @chain_supervisor_permission_status = permission_status       
FROM plv_rule_group         
WHERE path=@chain_supervisor_path        
and user_group_code is NULL       
     
SELECT @default_code=default_code     
FROM plv_rule_group     
WHERE path=@override_path     
and user_group_code is NULL     
/**********************Yousaf Khan 4 Rabi-ul-awal 1430 h**********************************/     
     
Create Table #Approvers     
(
	id int identity(1,1),     
	company_code int,     
	org_unit varchar(16),     
	location_code varchar(16),     
	resource_id varchar(16),     
	name_last varchar(32),     
	name_first varchar(32),     
	is_supervisor int     
 
)     
     
-- AS20110412 IF (@default_code = @yes_path)     
IF (@default_code = @yes_path)  and (@chain_supervisor_permission_status = 2)      
BEGIN     
 INSERT INTO #Approvers     
 ( company_code,org_unit,location_code,resource_id, name_last,name_first,is_supervisor     
 )     
 SELECT   pr.company_code,pr.org_unit,pr.location_code,pr.resource_id,  pr.name_last,pr.name_first,0     
 FROM plv_resource_all pr     
 Where resource_id in (Select resource_id from #TempSupervisors)     
 order by pr.name_last,pr.name_first     
     
 INSERT INTO #Approvers     
 ( company_code,org_unit,location_code,resource_id,  name_last,name_first,is_supervisor     
 )     
 SELECT  pa.company_code,pa.org_unit,pa.location_code,pa.resource_id, pr.name_last,pr.name_first,0     
 FROM plv_exprpt_approvers pa     
 join plv_resource_all pr     
 on pr.resource_id = pa.resource_id     
 WHERE pa.company_code=@company_code     
 and  isnull(pa.org_unit,'') = isnull(@org_unit,'')     
 and isnull(pa.location_code,'') = isnull(@location_code,'')     
 and  pa.resource_id not in (Select resource_id from #TempSupervisors)     
 order by pr.name_last,pr.name_first     
END     
ELSE IF (@default_code = @yes_path)  and (@chain_supervisor_permission_status = 1)   -- AS20110412 from eSM74      
BEGIN    
 INSERT INTO #Approvers    
 (  company_code,org_unit,location_code,resource_id,  name_last,name_first,is_supervisor    
 )    
 SELECT  pa.company_code,pa.org_unit,pa.location_code,pa.resource_id ,pr.name_last,pr.name_first,0    
 FROM plv_exprpt_approvers pa    
 join plv_resource_all pr     
 on pr.resource_id = pa.resource_id    
 WHERE pa.company_code=@company_code    
 and  isnull(pa.org_unit,'') = isnull(@org_unit,'')    
 and isnull(pa.location_code,'') = isnull(@location_code,'')    
 order by pr.name_last,pr.name_first    
END    
ELSE  
BEGIN     
 INSERT INTO #Approvers     
 (  company_code,org_unit,location_code,resource_id, name_last,name_first,is_supervisor     
 )     
 SELECT  pa.company_code,pa.org_unit,pa.location_code,pa.resource_id, pr.name_last,pr.name_first,0     
 FROM plv_exprpt_approvers pa     
 join plv_resource_all pr     
 on pr.resource_id = pa.resource_id     
 WHERE pa.company_code=@company_code     
 and  isnull(pa.org_unit,'') = isnull(@org_unit,'')     
 and isnull(pa.location_code,'') = isnull(@location_code,'')     
 and  pa.resource_id not in (Select resource_id from #TempSupervisors)     
 order by pr.name_last,pr.name_first     
END     
     
     
SELECT  
company_code,     
org_unit,     
location_code,     
resource_id,     
            
name_last,     
name_first,     
is_supervisor     
FROM #Approvers     
order by id     
     
RETURN     




      


go