/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_set] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_exptrx_set]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_exptrx_set]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_set] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROC [dbo].[plsW_apps_exptrx_set]      
@action_flag tinyint,       /* 1 - insert new row, 2 - update row, 3 - delete row,  4 - update file attached flag*/                                                                                                                                            

@company_code      int,                                                                                                                                              
@level2_key        varchar(32) =  null,                                                                              
@level3_key        varchar(64) =  null,                                                                              
@transaction_id_inp    varchar(18) =  null         ,                                                                                                                                              
@applied_date      datetime =  null,                                                                                                                                              
@org_unit          varchar(16)=  null,                                                                                                                                              
@location_code      char(16)  =  null,                                                                                                                                              
@resource_id       varchar(16)  =  null,                                                                                                                                              
@comments          varchar(3000) =  null,                                                                                                                                              
@submitted_flag    tinyint =  null,                                                                                        
@trx_type          int  =  null,  -- NEED TO DISCUSS WHERE TO GET IT FROM                                                                                                                                            
@res_type     int     =  null,                                                                                        
@vendor_id         varchar(16)  =  null,                                                                                                                                              
@payment_code      int       =  null,                                                                                        
@payment_name      varchar(16) =  null,                                                                                        
@pmt_vendor_code   varchar(16)  =  null,                                                                                        
@currency_code     varchar(8)   =  null,                                                                                        
@currency_conversion_rate float  =  null,                                                                                        
@allocation_prc    float  =  null,                                
@amount        float    =  null,                                                                                        
@amount_home       float  =  null,                                                  
@amount_billable   float  =  null,                                               
@receipt_flag      tinyint   =  null,                                                                                        
@reimbursment_flag tinyint  =  null,                        
@trx_level     float        =  null,                                                                                        
@parent_id     varchar(64) =  null,                
@line_id       varchar(16) =  null,                        
@record_id varchar(16)  = null,                                                 
@tax_code      varchar(8) = null, -- NEED TO DISCUSS WHERE TO GET IT                                        
@tax_amount    float = 0,-- NEED TO DISCUSS WHERE TO GET IT                              
@net_amount        float = 0,                                              
@res_usage_code    varchar(16) = '',                                                                  
@mileage_units  float = -1,                                 
@TS            binary(8) = null,                                                     
@override_flag     tinyint = 0,                                                                    
@approval_flag     tinyint = 0,                                                                               
@approval_comment  varchar(255) = null,                                                                                        
@nonbill_flag   tinyint = 0,                                                                                        
@create_id varchar(32) = null,                                                                                        
@modify_id varchar(32) = null,                                                           
@extra_param_1 varchar(255) = null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                                                           
@extra_param_2 varchar(255) = null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                   
@business_reason  varchar(255) = null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                                     
@finalise_flag  tinyint = null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                       
@finalised_by  varchar(12)= null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                                       
@finalised_date  datetime = null, -- NEED TO DISCUSS WHERE TO GET IT                                                                                                                          
@text1  varchar(255) =  null,                                                                                        
@text2  varchar(255) =  null,                                                                                
@text3  varchar(255) =  null,                                                                                        
@text4  varchar(255) =  null,                                                                                
@text5  varchar(255) =  null,                                                                                        
@text6  varchar(255) =  null,                                                                        
@text7  varchar(255) =  null,                                                                                        
@text8  varchar(255) =  null,                     
@text9  varchar(255) =  null,                                                                  
@text10  varchar(255) =  null,                                                                  
@number11 float =  null,                
@number12 float =  null,                                                                  
@number13 float =  null,                                                                  
@number14 float =  null,                                               
@number15 float =  null,                                                                  
@number16 float =  null,                                            
@number17 float =  null,                                                                  
@number18 float =  null,                                   
@number19 float =  null,                                                   
@number20 float =  null,                           
@cc_exp_id int=NULL,                              
@cc_num  varchar(32)=null,                                                                                        
@validate tinyint = 1,                                                                                        
@Is_file_attached  tinyint=0, --RS20150528                                                                                       
@subscriber_id varchar(64) = null,
@cc_TS  binary(8) = null                           
/* ****************************************************************** *                                              
* Copyright 1996 Paradigm Technologies, Inc.                          *                                                                                        
* All Rights Reserved                      *                                                                *                                                                     *                                                                        
                                        
* This Media contains confidential and proprietary information of     *                                                                                        
* Paradigm Technologies, Inc.  No disclosure or use of any portion   *                                                                                        
* of the contents of these materials may be made without the express  *                                                        * written consent of Paradigm Technologies, Inc.                      *                                                        


                              
*                                                       *                                                                                        
* Use of this software is restricted and governed by a License        *                                                                                        
* Agreement.  This software contains confidential and proprietary     *                                                                   
* information of Paradigm Technologies, Inc. and is protected by      *                                                                                        
* copyright, trade secret and trademark law.                          *                                                                                        
*                   *                                                                                        
* ******************************************************************* *                                                                                                                        
*     *                                                                                        
*      Name: plsW_apps_exptrx_set                                *                                                                                        
*   Date created: July 06, 2015            *                                      
*             By: Hamza Mughal            *    
*        Comment: Used by app to set the expense transacition    *                                                                              
*                   *                                                                 
* ******************************************************************* *                                                                                                         
*     *                                                   
*           Name: plsW_apps_exptrx_set                                *                                               
*   Date created: 11/18/2015           *                                          
*             By: Hamad Safder            *                                                                                        
*        Comment: Recalculate convertion amount    *                                                               
*                   *                                                                                        
******************************************************************** */                                         
                                                                              
                                                                                        
AS                                                                                                                               
begin                                                                                                          
                                                                              
--SELECT 1 ERROR_FLAG, -1002 ERROR_CODE, 'Comments are required, please enter comments and then save.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                                                     
SET @create_id = (select loginid from pdd_resources where company_code=@company_code and resource_id=@create_id)
SET @modify_id = (select loginid from pdd_resources where company_code=@company_code and resource_id=@modify_id)
       
--RETURN                                                                          
                                              
set @validate = 1 -- Always set validate to 1                                              
SET @finalise_flag = ISNULL(@finalise_flag,0) --FS20190131 As discussed with Abid                                                                     
if @action_flag = 2 and not exists (select top 1   transaction_id from pld_transactions  where transaction_id  = @transaction_id_inp)                                                                        begin                                             

  set @action_flag = 1                                                                                    
end                                                                                        
                                 
if @action_flag = 1 and exists (select top 1 transaction_id from pld_transactions where transaction_id = @transaction_id_inp)                                             
begin                                                                                        
 set @action_flag = 2                                                        
end                                                                                        
                                                                    
--------------------------------------------------- VALIDATION BEGIN --------------------------------------------------                                                                                               
                                                                                                                     
-- TO SEE IF REport THAT IS TO BE CHANGED IS ALREADY DELETED FROM THE ESM.                                                                                                                         
if exists (select 1 from plv_event_notification with(nolock) where  primary_key like  '%'+ @record_id  and entity_action_id = 3 AND entity_type_id = 4 and subscriber_id = isnull(@subscriber_id, ''))                                                        


begin                                                                                                         
 SELECT 1 ERROR_FLAG, -1002 ERROR_CODE, 'Report already deleted from the Application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                            
      
 RETURN                                                                                                                            
end                                    
-- TO SEE IF transaction THAT IS TO BE CHANGED IS ALREADY DELETED FROM THE ESM.         
if exists (select 1 from plv_event_notification with(nolock) where  primary_key like  '%'+ @transaction_id_inp  and entity_action_id = 3 AND entity_type_id = 5 and subscriber_id = isnull(@subscriber_id, ''))                                                

                  
begin                                                        
 SELECT 1 ERROR_FLAG, -1002 ERROR_CODE, 'Transaction already deleted from the Application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                                                 







  
    
      
        
          
           
 RETURN                                                                                                                 
end                                                                  
                                                                                               
-- TO SEE IF TRANSACTION WAS CHANGED                                                    
IF /*@action_flag = 2 AND */ (@TS is not null AND @TS <> 0x0000000000000000)                                                                                                       
 AND @TS <> (select timestamp from pld_transactions where transaction_id = @transaction_id_inp)                                                         
BEGIN                                                                            
 SELECT 1 ERROR_FLAG, -1001 ERROR_CODE, 'Transaction already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                                                
 RETURN                                                                                                
END                                                                                                 

IF @action_flag = 1 AND (@cc_TS is not null AND @cc_TS <> 0x0000000000000000)                                                                                                       
 AND @cc_TS <> (select timestamp from pld_cc_exp where cc_exp_id = @cc_exp_id)                                                         
BEGIN                                                                            
 SELECT 1 ERROR_FLAG, -1001 ERROR_CODE, 'CC Transaction already updated from application. Please refresh.' ERROR_DESCRIPTION, @cc_TS [timestamp]                                                                
 RETURN                                                                                                
END                                                                                                                        
--  CHECK TO SEE IF THE RESOURCE IS ACTIVE OR NOT (plv_resource only gets the active resource)                                                                                                                            
IF not exists (select 1 from plv_resource where resource_id = @resource_id and company_code = @company_code)                                                                                                                            
begin                                                                                       
 SELECT 1 ERROR_FLAG, -1003 ERROR_CODE, 'Resource does not exist or is not active.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                                                            
 RETURN       
end                                            
                                                
---- HAMZA -- 20150831 -- SHOULD NOT ADD THE TRANSACTION WITH SAME CC-EXP-ID                         
IF exists (select 1 from pld_transactions where ISNULL(cc_exp_id, 0) <> 0 and cc_exp_id = @cc_exp_id)                                                               
 and @action_flag = 1                                                                 
begin                                                                  
 SELECT 1 ERROR_FLAG, -1005 ERROR_CODE, 'Another transaction is already associated with same CC charge, Please Cancel/Delete and then Refresh' ERROR_DESCRIPTION, @TS [timestamp]                                            
 RETURN                             
end                                                                  
                                                        
                                                      
if @action_flag <> 3        
begin                                                     
 if isnull(@comments,'') = ''and                                                   
 (select comments_for_expense_required_flag from plv_level2 where level2_key=@level2_key)=1                                                      
 begin                                                                                                                             
  SELECT 1 ERROR_FLAG, -1002 ERROR_CODE, 'Comments are required, please enter comments and then save.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                                  
  RETURN                                                                              
 end                                                     
 ----To see if the custom field already updated                                                 
 declare @custom_field_number int                                                        
 declare @exp_custom_field_number int                                                        
                                                         
 set @custom_field_number = 0                                                      
 set @exp_custom_field_number = 0                                                      
 select  @custom_field_number = @custom_field_number + power(2 , field_number) from plv_exprpt_fields                                                      
 where res_type = @res_type                                              
                                                     
 if (isnull(@text1, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 2                                                        
 if (isnull(@text2, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 4                                                        
 if (isnull(@text3, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 8                                                        
 if (isnull(@text4, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 16                                                        
 if (isnull(@text5, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 32                                                        
 if (isnull(@text6, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 64                                                        
 if (isnull(@text7, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 128                                                        
 if (isnull(@text8, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 256                                                        
 if (isnull(@text9, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 512                                                    
 if (isnull(@text10, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 1024  
 if (isnull(@number11, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 2048                                                        
 if (isnull(@number12, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 4096                                                         
 if (isnull(@number13, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 8192                                                        
 if (isnull(@number14, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 16384                                   
 if (isnull(@number15, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 32768                                                        
 if (isnull(@number16, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 65536                                 if (isnull(@number17, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 131072                         








 
 
    
       
        
         
            
              
            
                 
                     
                     
                        
                               
 if (isnull(@number18, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 262144                                                        
 if (isnull(@number19, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 524288                             
 if (isnull(@number20, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 1048576                                                        
                                                   
 print @custom_field_number                                          
 print @exp_custom_field_number                                                  
                                                   
 if @custom_field_number != @exp_custom_field_number                                              
 begin                                                         
 SELECT 1 ERROR_FLAG, -1004 ERROR_CODE, 'Custom field(s) have been changed from application. Please save the transaction after refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                    







  
    
      
       
           
            
              
                
                  
                    
                      
                        
                         
                            
                            
                              
                                 
                                 
                                  
                                    
                                   
                                        
                                         
    RETURN                         
 end                                                   
                                                   
 -- HAMZA -- 20150909 -- added location code and department checks                                                  
                                                   
 DECLARE @location_code_sysname varchar(64),                                                  
   @org_unit_sysname varchar(64),                                            
   @user_group_code varchar(64),                                                  
   @sequence_id int,                                                  
   @org_unit_for_check varchar(64),                                                  
   @location_code_for_check varchar(64)                                                  
                              
 select @user_group_code = user_group_code from plv_group_user_link where resource_id = @resource_id and preferred_group_flag = 1  
 select @location_code_sysname = display_name from plv_sysnames where Field_Name = 'location_descr'                                                  
 select @org_unit_sysname = display_name from plv_sysnames where Field_Name = 'org_unit'                                                  
                                                    select @sequence_id = sequence_id from plv_rule_group where user_group_code = @user_group_code and path = 'Rules/TimeandExpense/ExpenseReport/Location'                                                   









                                                   
 if not exists (select 1 from plv_resource_all where resource_id = @resource_id and location_code = @location_code) AND                                            
 not exists (select 1 from plv_rule_group_detail  where sequence_id = @sequence_id and path = 'Rules/TimeandExpense/ExpenseReport/Location'                                                  
    and sub_selected_code = @location_code)       
 begin                                                  
 SELECT 1 ERROR_FLAG, -1006 ERROR_CODE, 'The selected ' + @location_code_sysname + ' is no longer available in application. '                                                   
 + 'Please select another ' + @location_code_sysname + ' and Save.' ERROR_DESCRIPTION, @TS [timestamp]                                            
    RETURN                         
 end                                                  
                                                   
 select @sequence_id = sequence_id from plv_rule_group where user_group_code = @user_group_code and path = 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                             
 
 -- HAMZA -- 20160208  
 IF NOT EXISTS (SELECT 1 FROM dbo.plv_org_units WHERE org_unit = @org_unit) AND LEN(@org_unit) = 15  
 BEGIN  
 -- PRINT 'here'  
 SELECT @org_unit = (SELECT org_unit FROM dbo.plv_org_units WHERE org_unit LIKE @org_unit + '%')  
 END  
                                                   
 if not exists (select 1 from plv_resource_all where resource_id = @resource_id and org_unit = @org_unit) AND                                            
 not exists (select 1 from plv_rule_group_detail  where sequence_id = @sequence_id and path = 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                                  
    and sub_selected_code = @org_unit)                                                  
 begin                                                  
 SELECT 1 ERROR_FLAG, -1007 ERROR_CODE, 'The selected ' + @org_unit_sysname + ' is no longer available in application. '                                                   
 + 'Please select another ' + @org_unit_sysname + ' and Save.' ERROR_DESCRIPTION, @TS [timestamp]                                                                                                           
    RETURN                                                   
 end                                                  
                                                   
 -- HAMZA -- 20150909 -- added location code and department checks                                               
end                                                      
                                                        
----- end here                                                       
                                                                                                      
IF not exists (select 1 from pld_transactions where transaction_id = @transaction_id_inp)                                                                                                      
begin            
 select @line_id = max(convert(int, line_id)) from pld_transactions where record_id = @record_id         
                                                           
 if @line_id is null                                                                                                        
  set @line_id = 0                                                                                                      
 else                                                                                           
  set @line_id = @line_id + 1                                                           
end                                                                        
                                                                                                      
if @allocation_prc is null  
 set @allocation_prc = ''                                                                                                                      
                                                                                                        
set @pmt_vendor_code=@resource_id                                                                    
                                                                                                                              
 if exists ( select 1 from plv_pmt_types                               
   where company_code = @company_code                                                                                                                                                
   and payment_code = @payment_code                                            
   and payment_category = 1 )                                                                                                                                                
  select @pmt_vendor_code = '*COMP*'            
                                                                                                                              
 --if isnull(@cc_exp_id,0) <> 0                                                                                                                                                       
 --begin                          
                                                                                           
 -- declare @payment_code_w1 int                                                                                                                       
 -- declare @payment_name_w1 varchar(16)                                                                                                                                                     
                                                                              
 -- select @payment_code_w1 = null                                                                                                                         
 -- select @payment_name_w1 = null                                                                                                                              
                                                                                                                                                            
 -- select @payment_code_w1 = payment_code, @payment_name_w1 = payment_name from pld_cc_exp where company_code = @company_code and cc_exp_id = @cc_exp_id                                                                                                     




 



 
    
      
         
         
            
              
                
                   
                   
                      
                        
                           
                            
                            
                             
                                
                                
                                 
 -- if isnull(@payment_code_w1,0) <> 0                                                    -- begin           
 --  select @vendor_id = vendor_code from plv_pmt_types where payment_name = @payment_name_w1                                                                                                                          
 --  select @payment_code=@payment_code_w1                                                                                                                                    
 --  select @payment_name=@payment_name_w1                                                                                                            
 -- end                                                                                         
                                    
 --end                                                                                                           
                                                                                            
 -- in case YES send 0 according to eSM Login                                                                                
 --if (select default_code from plv_rule_group where path = 'CompanyRules/TimeandExpense/ExpenseReport/AllowPartialSave') = 1                                                                                            
 --begin                                                                                                       
 -- set @validate = 0                                                                                                                           
 --end                                                                                   
 --else                                    
 --begin                                                                                                          
 -- set @validate = 1                                                                                                                          
 --end                                           
                                                  
--select @payment_code = default_code  from plv_rule_group                                                                                                           
--where path like 'Rules/TimeandExpense/ExpenseReport/PaymentType' and user_group_code=@user_group_code                      
                                                                                              
-- For the time being, remove when bug fixed                                                                                     
if @payment_code is not null                                                                                              
begin                                                                                               
 set @payment_name = (select payment_name from plv_pmt_types where payment_code = @payment_code)                                        
end                                                                                
                                    
--if isnull(@cc_exp_id, 0) <> 0      
--begin                            
-- set @reimbursment_flag = 1      
--end      
                        
-- REPLACE THE CHECK WITH MC_CHECK_SP  hamad 20151118                      
declare @is_mc int                      
EXECUTE pls_mc_Apps_exists  @company_code,1 ,@is_mc output                       
iF (@is_mc) = 0                                                                                          
begin                                                                                    
 set @currency_conversion_rate = 1                                                                     
end                                                      
            
-- TO SEE IF TRANSACTION WAS CHANGED                                                    
IF /*@action_flag = 2 AND */ (@TS is not null AND @TS <> 0x0000000000000000)                                        
 AND @TS <> (select timestamp from pld_transactions where transaction_id = @transaction_id_inp)                                                   
BEGIN                    
 if @action_flag <> 3 and (select submitted_flag from pld_transactions where transaction_id = @transaction_id_inp) <> 1              
 begin                    
  -- HAMZA -- 20151116 -- If the transactions parameters have not changed on the next save then do not throw the error.                    
  declare @old_applied_date datetime =  null,                                                                                                                                        
   @old_org_unit varchar(16)=  null,                                                                                            
   @old_location_code char(16)  =  null,                                                                                                                  
   @old_resource_id varchar(16)  =  null,                                                                                                                                        
   @old_comments varchar(3000) =  null,                    
   @old_res_type int =  null,                    
   @old_payment_code int =  null,                                                                                  
   @old_payment_name varchar(16) =  null,                    
   @old_currency_code varchar(8)   =  null,                    
 @old_amount float    = null,                                                                                  
   @old_amount_home float  =  null,                                            
   @old_amount_billable float  =  null,                    
   @old_reimbursment_flag tinyint  =  null,                                                        
   @old_net_amount float = 0,                    
   @old_nonbill_flag tinyint = 0,                      
   @old_text1 varchar(255) =  null,                                                                                  
   @old_text2 varchar(255) =  null,                                                              
   @old_text3 varchar(255) =  null,                                                                                  
   @old_text4 varchar(255) =  null,                                                                          
   @old_text5 varchar(255) =  null,                        
   @old_text6 varchar(255) =  null,                                                                  
   @old_text7  varchar(255) =  null,                                                                                  
   @old_text8  varchar(255) =  null,                                                            
   @old_text9  varchar(255) =  null,                                                            
   @old_text10  varchar(255) =  null,                                                            
   @old_number11 float =  null,                                                            
   @old_number12 float =  null,                                                      
   @old_number13 float =  null,                                                            
   @old_number14 float =  null,                                                            
   @old_number15 float =  null,                                                            
   @old_number16 float =  null,                                                            
   @old_number17 float =  null,                                                            
   @old_number18 float =  null,                                                            
   @old_number19 float =  null,                                                            
   @old_number20 float =  null,                    
   @old_Is_file_attached  tinyint=0                     
   
 select @old_applied_date = applied_date,                    
   @old_org_unit = org_unit,                                                                                                            
   @old_location_code = location_code,                    
   @old_comments = comments,                    
   @old_res_type = res_type,                    
   @old_payment_code = payment_code,                                                                                  
   @old_payment_name = payment_name,                    
   @old_currency_code = currency_code,                    
   @old_amount = amount,                                                                                  
   @old_amount_home = amount_home,                                            
   @old_amount_billable = amount_billable,                    
   @old_reimbursment_flag = reimbursment_flag,                                           
   @old_net_amount = net_amount,                    
   @old_nonbill_flag = nonbill_flag,                      
   @old_text1 = text1,                                                                                  
   @old_text2 = text2,                                                                          
   @old_text3 = text3,                                                                                  
   @old_text4 = text4,                                                                          
   @old_text5 = text5,                                                                                  
   @old_text6 = text6,                                                            
   @old_text7  = text7,                                                                                  
   @old_text8  = text8,                                                            
   @old_text9  = text9,                                                            
   @old_text10 = text10,                                                            
   @old_number11 = number11,                                                            
   @old_number12 = number12,                                                            
   @old_number13 = number13,                                                            
   @old_number14 = number14,                                                            
   @old_number15 = number15,                                                         
   @old_number16 = number16,                                                            
   @old_number17 = number17,                                                            
   @old_number18 = number18,                                                            
   @old_number19 = number19,                                                            
   @old_number20 = number20,                    
   @old_Is_file_attached  = Is_file_attached                    
 from pld_transactions trx inner join pld_transactions_exp trx_exp                    
  on trx.transaction_id = trx_exp.transaction_id                    
 where trx.transaction_id = @transaction_id_inp                    
                     
 --select  @old_applied_date,                                                                                                                                        
 --  @old_org_unit,                                                                                                                                        
 --  @old_location_code,                  
 --  @old_comments,                    
 --  @old_res_type,                    
 --  @old_payment_code,                                                                                  
 --  @old_payment_name,                    
 --  @old_currency_code,                    
 --  @old_amount,                                                                          
 --  @old_amount_home,                            
 --  @old_amount_billable,                    
 --  @old_reimbursment_flag,                                     
 --  @old_net_amount,                    
 --  @old_nonbill_flag,                      
 --  @old_text1,                                                                                  
 --  @old_text2,                                                            
 --  @old_text3,                                                                                  
 --  @old_text4,                                      
 --  @old_text5,                                                                                  
 --  @old_text6,                                                                  
 --  @old_text7,                                                                    
 --  @old_text8,                                                            
 --  @old_text9,                                                 
 --  @old_text10,                                       
 --  @old_number11,                                                            
 --  @old_number12,                                                            
 --  @old_number13,                                                            
 --  @old_number14,                                                            
 --  @old_number15,                                                            
 --  @old_number16,                                                            
 --  @old_number17,                                                            
 --  @old_number18,                                                            
 --  @old_number19,                                                           --  @old_number20,                    
 --  @old_Is_file_attached                    
                     
 IF @old_applied_date <> @applied_date OR                    
   @old_org_unit <> @org_unit OR                    
   @old_location_code <> @location_code OR                    
   @old_comments <> @comments OR                    
   @old_res_type <> @res_type OR                    
   @old_payment_code <> @payment_code OR                    
   @old_payment_name <> @payment_name OR                    
   @old_currency_code <> @currency_code OR                    
   @old_amount <> @amount OR                    
   @old_amount_home <> @amount_home OR                    
   @old_amount_billable <> @amount_billable OR                    
   @old_reimbursment_flag <> @reimbursment_flag OR                    
   @old_net_amount <> @net_amount OR                    
   @old_nonbill_flag <> @nonbill_flag OR                    
   isnull(@old_text1, '') <> isnull(@text1, '') OR                    
   isnull(@old_text2, '') <> isnull(@text2, '') OR                    
   isnull(@old_text3, '') <> isnull(@text3, '') OR                    
  isnull(@old_text4, '') <> isnull(@text4, '') OR                    
   isnull(@old_text5, '') <> isnull(@text5, '') OR                    
   isnull(@old_text6, '') <> isnull(@text6, '') OR                    
   isnull(@old_text7, '')  <> isnull(@text7, '') OR           
   isnull(@old_text8, '')  <> isnull(@text8, '') OR                    
   isnull(@old_text9, '')  <> isnull(@text9, '') OR                    
   isnull(@old_text10, '') <> isnull(@text10, '') OR                    
   isnull(@old_number11, 0) <> isnull(@number11, 0) OR                    
   isnull(@old_number12, 0) <> isnull(@number12, 0) OR                    
   isnull(@old_number13, 0) <> isnull(@number13, 0) OR                    
   isnull(@old_number14, 0) <> isnull(@number14, 0) OR                    
   isnull(@old_number15, 0) <> isnull(@number15, 0) OR                    
   isnull(@old_number16, 0) <> isnull(@number16, 0) OR                    
   isnull(@old_number17, 0) <> isnull(@number17, 0) OR               
   isnull(@old_number18, 0) <> isnull(@number18, 0) OR                    
   isnull(@old_number19, 0) <> isnull(@number19, 0) OR           
   isnull(@old_number20, 0) <> isnull(@number20, 0) OR                    
   isnull(@old_Is_file_attached, 0) <> isnull(@Is_file_attached, 0)                    
  BEGIN                     
   SELECT 1 ERROR_FLAG, -1001 ERROR_CODE, 'Transaction already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                                          
   RETURN                     
  END                    
  else                    
  begin                    
   set @TS = (select timestamp from pld_transactions where transaction_id = @transaction_id_inp)                    
  end                    
 end                
 else                
 begin                
 SELECT 1 ERROR_FLAG, -1001 ERROR_CODE, 'Transaction already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp]                                                          
 RETURN                
 end                                                                                          
END                          
                
   ------------------------------------    hamad 20151117 multicurrency calculation                          
   -- WILL ONLY WORK IF MC IS ACTIVE                          
                         
if (@is_mc = 1  )                      
if (@action_flag=1 or @action_flag=2)                          
begin                          
Create Table #CurrencyConversionForApp(                             
rate_type varchar(8),                             
from_currency varchar(8),                             
to_currency varchar(8),                             
factor  float,                             
effective_date datetime                                
)                           
                          
 declare                           
 @to_currency varchar(8)=NULL , -- resource       
 @rate_type varchar(8) = NULL,                        
  --@amount        float    =  null,                                                                                        
 @amount_home_recalculate       float  =  0,                                                  
 @amount_billable_recalculate   float  =  0,                      
 @net_amount_recalculate     float  =  0,                      
 @billable_flag_level2 int,                      
 @billable_flag_level3 int ,                  
 @convertion_date  datetime,              
 @factor_for_recalculation float                       
                            
select @to_currency = (select currency_code from plv_resource where resource_id = @resource_id)                        
 SELECT @rate_type = (select case when expcost_xrate_type = -1 then expcost_xrate_type_name else convert(varchar,expcost_xrate_type) end from plv_level2_mc where level2_key = @level2_key)                        
  ---RS20151208 currency implementation for optimization         
          
  Create Table #CurrencyConversion(             
 rate_type varchar(8),             
 from_currency varchar(8),             
 to_currency varchar(8),             
 factor  float,             
 effective_date datetime,             
 convert_date  int,             
 valid_for_days  int,             
 divide_flag smallint             
             
)             
          
 IF ((SELECT multi_currency_flag FROM plv_interfaces where company_code=@company_code)=1)             
 BEGIN         
          
  INSERT INTO #CurrencyConversion(rate_type,from_currency,to_currency,factor,             
  convert_date,valid_for_days)             
  SELECT CONVERT(varchar(8), rate_type), from_currency, to_currency,buy_rate,              
  convert_date,valid_for_days             
  FROM plv_mccurtdt             
  where rate_type = @rate_type        
  and from_currency =@currency_code           
  and from_currency not in ( select  currency_code from plv_currencies where status_flag <> 1 )             
  and to_currency  not in ( select  currency_code from plv_currencies where status_flag <> 1 )             
        
        
  UPDATE #CurrencyConversion             
  SET effective_date=dateadd(day, (convert_date - 700901)+1,'1/1/1920')             
  WHere convert_date <> 0             
        
        
  UPDATE #CurrencyConversion             
  SET effective_date=convert(datetime,'01/01/1900')             
  WHere convert_date = 0             
        
        
  UPDATE #CurrencyConversion             
  SET factor=dfrt.default_rate,             
  divide_flag=isnull(dfrt.divide_flag,0)             
  FROM #CurrencyConversion CurConv             
  JOIN plv_mccurate dfrt             
  ON CurConv.rate_type=dfrt.rate_type             
  AND CurConv.from_currency=dfrt.from_currency 
  AND CurConv.to_currency=dfrt.to_currency             
  WHERE CurConv.factor IS NULL   
        
  UPDATE #CurrencyConversion             
  SET factor=1/factor             
  FROM #CurrencyConversion CurConv             
  WHERE (IsNull( factor, 0) > 0 AND divide_flag = 1) OR (IsNull( factor, 0) < 0)             
        
  UPDATE #CurrencyConversion             
  SET factor=0             
  Where factor is NULL             
        
  UPDATE #CurrencyConversion             
  SET factor=ABS(factor)             
    END        
    ELSE        
    BEGIN             
  INSERT INTO #CurrencyConversion(rate_type,from_currency,to_currency,factor,effective_date)             
  SELECT CONVERT(varchar(8), mc_rate_type) rate_type, from_currency, to_currency, factor, effective_date             
  FROM plv_mc_rate_type_dtl             
  where convert(varchar(8),mc_rate_type) = @rate_type        
  and from_currency =@currency_code              
  and from_currency not in ( select  currency_code from pdm_currencies where status_flag <> 1 )             
  and to_currency  not in ( select  currency_code from pdm_currencies where status_flag <> 1 )             
             
 END          
        
 IF ((@to_currency is not NULL) and (@to_currency <> ''))             
 BEGIN         
  insert into #CurrencyConversionForApp         
  (        
   rate_type,        
   from_currency,      
   to_currency,        
   factor,        
   effective_date        
   )           
   SELECT rate_type,             
   from_currency,             
   to_currency,             
   factor,             
   effective_date             
   FROM #CurrencyConversion             
   Where to_currency=@to_currency             
   AND from_currency <> @to_currency             
 END             
 ELSE             
 BEGIN         
  insert into #CurrencyConversionForApp         
  (        
   rate_type,        
   from_currency,        
   to_currency,        
   factor,        
   effective_date        
   )             
   SELECT rate_type,             
   from_currency,             
   to_currency,             
   factor,             
   effective_date             
   FROM #CurrencyConversion             
 END         
           
        
          
  ---                              
 --insert into #CurrencyConversionForApp (rate_type,from_currency,to_currency,factor,effective_date)                            
 --exec plsW_apps_rate_types_dtl_get @company_code,@rate_type, @to_currency                    
                              
  --delete #CurrencyConversionForApp where from_currency <> @currency_code                           
                
 SELECT top 1 @factor_for_recalculation = factor              
 from #CurrencyConversionForApp              
 where effective_date =               
 ( SELECT MAX(effective_date)              
   FROM #CurrencyConversionForApp              
   WHERE effective_date <= @applied_date)              
           
  select @amount_home_recalculate = @amount * @factor_for_recalculation       
 ,@amount_billable_recalculate = @amount * @factor_for_recalculation                          
 ,@net_amount_recalculate = @amount * @factor_for_recalculation                       
                
   --RS20150108 Conversion rate for MC    
 if @currency_conversion_rate<>@factor_for_recalculation    
 set @currency_conversion_rate=@factor_for_recalculation     
     
                     
   if (@amount_home_recalculate <> @amount_home)                              
   set @amount_home=@amount_home_recalculate                          
                         
     if (@net_amount_recalculate <> @net_amount)                              
   set @net_amount=@net_amount_recalculate                        
                         
                           
   -- CHECK IF LEVEL3 IS BILLABLE                        
   select @billable_flag_level2= billable_flag from plv_level2 where Level2_key=@level2_key                      
                      
  select @billable_flag_level3= billable_flag from plv_level3 where Level2_key=@level2_key                      
                            
   if(@billable_flag_level2=0)                       
  if(@billable_flag_level3=0)                      
   if (@amount_billable <> 0 and @amount_billable_recalculate <> @amount_billable)                          
    set @amount_billable=@amount_billable_recalculate                        
                  
    drop table #CurrencyConversionForApp              
                   
end                           
    -------------------- end----------------                            
                  
-- Forcefully set to NULL as approval flag will never be set from the APP.                                                                                      
set @approval_flag = null                                                      
set @res_usage_code = ''                                                      
                                                                                                          
EXECUTE [plsW_exptrx_set]                                                                                                            
   @action_flag                                                                                                                              
  ,@company_code                                                                                                                        
  ,@level2_key                                                                            
  ,@level3_key                                                                                                           
  ,@transaction_id_inp                                                                                                                              
  ,@applied_date                                            
  ,@org_unit                                                          
  ,@location_code                                           
  ,@resource_id                                                                                                                              
  ,@comments                                                                                                                 
  ,@submitted_flag                                                                                                                              
  ,@trx_type                                                                                                                              
  ,@res_type                                                                                              
  ,@vendor_id                                                                                                             
  ,@payment_code                                     
  ,@payment_name                     
  ,@pmt_vendor_code                                                   
  ,@currency_code                                                                                                                          
  ,@currency_conversion_rate                                      
  ,@allocation_prc                                                                                                
  ,@amount                                                
  ,@amount_home                                                                                                                              
  ,@amount_billable                                                                  
  ,@receipt_flag                                                                                                                 
  ,@reimbursment_flag                                           
  ,@trx_level                                         
  ,@parent_id                      
  ,@line_id                                                             
  ,@record_id                                                                                                                              
  ,@tax_code                                                                                 
  ,@tax_amount                                                                        
  ,@net_amount                                                                                                           
  ,@res_usage_code                                                                                                                              
  ,@mileage_units                                                                                                            
  ,@TS                                                                                                                              
  ,@override_flag                                                                                                                              
  ,@approval_flag                                                                                                                              
  ,@approval_comment                                                                                            
,@nonbill_flag                                                                                                                              
  ,@create_id                                                    
  ,@modify_id                                                                     
  ,@extra_param_1                                                                                                   
  ,@extra_param_2                                                                                                                              
  ,@business_reason                                                                                                        
  ,@finalise_flag                                                                                                       
  ,@finalised_by                                                                                                         
  ,@finalised_date                                                                                                                              
  ,@text1                                                                                            
  ,@text2                                              
  ,@text3                                                                                                                            
  ,@text4                                                                     
  ,@text5  
  ,@text6                                
  ,@text7             
  ,@text8                                                                                                                              
 ,@text9                                                                                              
  ,@text10                                              
  ,@number11                                    
  ,@number12                                                                                                           
  ,@number13                                                                
  ,@number14                                                                                                                              
  ,@number15                                                                                              
  ,@number16                                                                                                                              
,@number17                                    
  ,@number18                                                                    
  ,@number19                                                                                                                 
  ,@number20                                                                                                                              
  ,@cc_exp_id                                                        
  ,@cc_num                                                              
  ,@validate                                                                                                                         
  ,@Is_file_attached                                           
  ,@source='APP EXP'                                                                                           
                                                  
                                                                                                 
------------ NEW CHANGE --                                                                         
                                                                        
declare @totalAmt float,                                                                                               
  @date_to datetime,                                                                                                            
@date_from datetime                                                                                                            
                                           
if exists (select 1 from pld_transactions where record_id = @record_id)                                                                                          
begin                                  
                 
--arifhasan 20150922 used temp table to optimize the query and avoid the deadlock                                  
 select   amount ,  applied_date, amount_home  into #pld_transactions                                   
 from pld_transactions  where  record_id = @record_id                                                        
                                                                
 -- ONLY WHEN MC IS NOT ACTIVE    hamad 20151118                       
 if(@is_mc=1)                      
 begin                                          
 select @totalAmt = sum(amount_home), @date_to = max(applied_date), @date_from = MIN(applied_date)                        
 from #pld_transactions                                     
 end                         
 else                      
 begin                      
 select @totalAmt = sum(amount), @date_to = max(applied_date), @date_from = MIN(applied_date)                                                        
 from #pld_transactions                         
 end                           
            
 update pld_transactions_hdr                                                                                                            
 set amount = @totalAmt,              
  date_to = @date_to,                                                                                              
  date_from = @date_from,                                    
  source = 'APP EXP'     
  ,modify_id=@modify_id
  ,modify_date = GETDATE()              
 where company_code = @company_code                                                                     
 and record_id = @record_id                                               
                                                         
 -- HAMZA -- 20150907 -- IF ONE TRANSACTION IS SAVED THEN SET ALL THE TRANSACTION TO DRAFT.                                -- Change the approval flag for the rest of the transactions, as when saved from app only one transaction call is sent.            







  
    
      
        
          
            
              
                
                   
                   
                      
                        
                          
                    
 update pld_transactions                                                        
 set approval_flag = null,                                                        
  submitted_flag = 0,                                    
  source = 'APP EXP'  
  ,modify_id=@modify_id
  ,modify_date = GETDATE()                                    
 where company_code = @company_code                                                        
 and record_id = @record_id                                   
 and approval_flag <> 4                                                        
 and approval_flag <> 1                                                        
 and approval_flag <> 2                                                        
 and transaction_id <> @transaction_id_inp                                    
                                                        
end                                                        
------------ NEW CHANGE ----------                                                        
                                                                                                  
                                                        
                                                
---- HAMZA -- 20150909 -- Break the sync loop here.                                                  
--IF exists (select 1 from plv_event_notification with (nolock)                                                  
-- where primary_key = convert(varchar, @company_code) + '~-~' + @transaction_id_inp                                                  
-- and subscriber_id = @subscriber_id and entity_type_id   in ( 4,5,6))              
--BEGIN                                                   
                                                 
-- DELETE FROM plv_event_notification                                                  
-- where primary_key = convert(varchar, @company_code) + '~-~' + @transaction_id_inp                                                  
-- and subscriber_id = @subscriber_id                                                  
-- and entity_type_id in (  5,6)                                                  
                                                
-- DELETE FROM plv_event_notification                 
-- where primary_key = convert(varchar, @company_code) + '~-~' + @record_id                                                
-- and subscriber_id = @subscriber_id                                                  
-- and entity_type_id in (  4)                                                  
--END          
                                                                                          
                                                                          
end   

 



go
