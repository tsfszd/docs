if exists(select 1 from sys.views where name='plv_level3_resource')
begin 
drop VIEW [dbo].[plv_level3_resource] 
end
go 
CREATE VIEW [dbo].[plv_level3_resource]     
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
*         Name: plv_level3_resource                             *     
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
     
SELECT     
company_code  
,level2_key  
,level3_key  
,resource_id  
,effective_date  
,expiration_date  
,position_category_code  
,res_usage_code  
,trx_approval_level  
,position_code  
,resource_comments  
,active_flag     
FROM     
PARATRAC_DB_NAME..pdd_level3_resource     
    
    
    
    
    
    
    
    
    
    
    GO