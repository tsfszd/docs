if exists(select 1 from sys.procedures where name='plsW_apps_app_trx_update')
begin 
drop procedure plsW_apps_app_trx_update
end
  go 



CREATE PROC plsW_apps_app_trx_update    
    
@company_code int ,    
@transaction_id varchar(16) ,    
@units   float ,    
@nonbill_flag tinyint ,    
@TS    binary(8) = null ,    
@approval_flag tinyint ,           -- 0 - pending, 1 - approved, 2 - rejected    
@approval_comment varchar(255) = null,    
@approved_by varchar(32) = null,    
@modify_id  varchar(32) = null    
    
/************************************************************************    
* Copyright 1996 Paradigm Technologies, Inc.                             *    
* All Rights Reserved                                                     *    
*                                                                           *    
* This Media contains confidential and proprietary information of       *    
* Paradigm Technologies, Inc.  No disclosure or use of any portion      *    
* of the contents of these materials may be made without the express    *    
* written consent of Paradigm Technologies, Inc.                         *    
*                                                                           *    
* Use of this software is restricted and governed by a License          *    
* Agreement.  This software contains confidential and proprietary       *    
* information of Paradigm Technologies, Inc. and is protected by        *    
* copyright, trade secret and trademark law.                             *    
*                                                                           *    
*************************************************************************    
*                                                                           *    
*   Name: Wrapper for plsW_app_trx_update                                  *    
*   Module:                                                       *    
*   Date created: 12/05/2016                                             *    
*   By: M.Shahid                                      *    
*   Version:                                                       *    
*   Comment:                                                      *    
*                                                                       *    
*   Date revised:                                                      *    
*   By:                                                    *    
*   Comment:                                                   *    
*                                                                           *    
*                                                                           *    
*************************************************************************/    
    
AS    
SET NOCOUNT ON    
    
BEGIN     
    
     
 CREATE TABLE  #error_list ( error_code INT , error_description VARCHAR(MAX))    
     
 INSERT INTO #error_list    
         ( error_code, error_description )    
     
 EXEC [plsW_app_trx_update]    
    
 @company_code = @company_code,    
 @transaction_id =@transaction_id,    
 @units   = @units ,    
 @nonbill_flag = @nonbill_flag ,    
 @TS    = @TS,    
 @approval_flag = @approval_flag ,           -- 0 - pending, 1 - approved, 2 - rejected    
 @approval_comment = @approval_comment,    
 @approved_by = @approved_by,    
 @modify_id  = @modify_id    
 
 update pdd_apps_notification 
 set [source]='APP TIME'
 where transaction_id=@transaction_id
    
 DECLARE @r_ts TIMESTAMP     
 SET @r_ts =  (select timestamp from pld_transactions where transaction_id = @transaction_id)   
    
 SELECT error_code, error_description, @r_ts r_ts FROM #error_list    
        
    
end    







go