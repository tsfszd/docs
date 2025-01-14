/****** Object:  StoredProcedure [dbo].[Pdsw_Apps_Task_Get]    Script Date: 02/04/2015 12:08:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pdsw_Apps_Task_Get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Pdsw_Apps_Task_Get]
GO

/****** Object:  StoredProcedure [dbo].[Pdsw_Apps_Task_Get]    Script Date: 02/04/2015 12:08:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  


 

CREATE PROCEDURE [dbo].[Pdsw_Apps_Task_Get]                 
                
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
*         Name: Pdsw_Apps_Task_Get                                *                                       
*       Module:                                                       *                                       
* Date created: Dec 04 2014                                           *                                       
*           By: Sohail Nazir                                          *                                       
*      Comment:                                                       *                                       
* Date revised:                                                       *                                       
*           By:                                                       *                                       
*      Comment:                                                       *                                       
*                                                                     *                                       
*                                                                     *                                
********************************************************************* */                
                
@company_code int,                
@task_code char(16) = null,            
@last_sync_date datetime = null            
                
AS                
BEGIN                
              
Create Table #task              
(              
 ts binary(8),              
 company_code int,              
 task_code char(16),               
 task_description varchar(64),                
 create_date datetime,              
 create_id varchar(32),               
 modify_date datetime,              
 modify_id varchar(32)               
)              
              
Insert into #task               
              
Exec pds_Tasks_get @COMPANY_CODE=@company_code,@Type_CODE=@task_code,@SORT_ORDER='' ,@NUMBER_OF_RECORDS=''              
              
 SELECT                
    ptt.task_type,                
    ptt.task_type_description,              
    tsk.task_code,              
    tsk.task_description    
    FROM pdm_task_types ptt                  
    INNER JOIN pdd_task pt             
    ON ptt.company_code = pt.company_code                
    AND ptt.task_type = pt.task_type                
 INNER JOIN #task tsk              
  on tsk.company_code =pt.company_code               
  and tsk.task_code =pt.task_code            
  WHERE ptt.company_code = @company_code                
  AND (@task_code is null OR pt.task_code = @task_code)            
  --AND (@last_sync_date is null or convert(date, @last_sync_date) < isnull(pt.modify_date, pt.create_date))
  
End





go