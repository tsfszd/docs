IF EXISTS (SELECT * FROM sys.procedures where name='pdsw_apps_rules_get')
BEGIN
DROP PROCEDURE [dbo].[pdsw_apps_rules_get]                                                                
END
GO
CREATE PROCEDURE [dbo].[pdsw_apps_rules_get]                                                                
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
*         Name: Pdsw_Apps_Resource_Get                                *                    
*       Module:                                                       *                    
* Date created: Ju 15 2015                                            *                    
*           By: Arif hasan             *                    
*                   *                  
* Date revised: August 24 2015            *                    
*   By: Hamad Safder            *                    
*    Comment:                                                       *                      
*                                                                     *                    
* Date revised: Novmber 06 2015            *                    
*           By: Hamad Safder            *                    
*      Comment: update multi-currency flag                            *                                                  
*                                                                     *                    
********************************************************************* */                    
@company_code int,                    
@Resource_id varchar(16)                    
                                
AS                                          
                                
begin                                                            
                                                           
 DECLARE @user_group_code varchar(32),                                                            
 @is_Customfields_By_ExpanseGroup int,                                      
 @exp_currencyCode_rule int,                                      
 @number_Of_Days_Prior_Allowed    varchar(255),                                      
 @OverrideApprovals int    ,                                                             
 @ShowBillable int,                                        
 @TaxCode varchar(255),                                                           
 @Receipt int ,                                                 
 @payment_code int,   
 @show_tax_code int,                                                    
 @show_payment_type int,                                                
 @Allow_CreditCard_Report  int,                                                    
 @Copy_cc_comments int ,                                                    
 @Allow_submit int ,                               
 @show_org_unit int,                                              
 @show_location int,                                                    
 @org_unit char(16),                         
 @location char(16),                                            
 @is_mc int,                      @number_of_decimal_places   varchar(255) ,                           
 --------------added variables Hamad---08/24/2015                               
@filter_level2_orgunit_time int,                                 
@filter_level3_orgunit_time int,                   
@filter_level2_locationcode_time int,                                 
@filter_level3_locationcode_time int,                     
@filter_level2_orgunit_exp int,                                 
@filter_level3_orgunit_exp int,                                 
@filter_level2_locationcode_exp int,                                 
@filter_level3_locationcode_exp int,                              
@expense_report_name int,                            
@approvers_based_on int,                 
            
------            
@Time_approval_comment_required_on_rejection  int,            
@expense_approval_comment_required_on_rejection  int ,          
@Time_Transaction_Editing_Allowed int,          
@TimeSheet_DefaultView  int,      
@Finance_Approval_Required int,      
@show_reimburse_check int ,    
@Create_Voucher_On_Finance_Approval int,  
-------  
  
@filter_approvals_level2_orgunit int,                                 
@filter_approvals_level3_orgunit int,                   
@filter_approvals_level2_locationcode int,                                 
@filter_approvals_level3_locationcode int ,
@attachment_is_required int,
@attachment_level  int   ,
@show_cc_mark_as INT       
   
                                      
                      
                        
 SELECT                                                                
   @user_group_code = user_group_code                                                                
  FROM pdm_group_user_link                                                                
 WHERE company_code = @Company_Code                                         
   AND resource_id = @Resource_id                                                               
   AND preferred_group_flag = 1                          
                              
----------------------------added code---08/24/2015                                
SELECT @filter_level2_orgunit_time = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/timesheet/DataFilter/Level2/OrgUnit'                                                               
           AND @user_group_code = user_group_code                                 
                                         
                                                   
SELECT @filter_level2_orgunit_exp = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                   
    WHERE  path = 'Rules/TimeandExpense/expensereport/DataFilter/Level2/OrgUnit'                    
           AND @user_group_code = user_group_code                                         
                                                
                                                
SELECT @filter_level3_orgunit_time = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/timesheet/DataFilter/Level3/OrgUnit'                                                               
           AND @user_group_code = user_group_code                                   
                                           
                                           
SELECT @filter_level3_orgUnit_exp = permission_status                                                                                                                                                                    
    FROM   pdm_rule_group                                                                                           
    WHERE  path = 'Rules/TimeandExpense/expensereport/DataFilter/Level3/OrgUnit'                                                               
           AND @user_group_code = user_group_code                                
                                           
SELECT @filter_level2_locationcode_time = permission_status                                             
    FROM   pdm_rule_group                         
    WHERE  path = 'Rules/TimeandExpense/timesheet/DataFilter/Level2/LocationCode'                                                               
           AND @user_group_code = user_group_code                        
                                       
                                                   
SELECT @filter_level2_locationcode_exp = permission_status                         
    FROM   pdm_rule_group                                  
    WHERE  path = 'Rules/TimeandExpense/expensereport/DataFilter/Level2/LocationCode'                                
           AND @user_group_code = user_group_code                       
                                                
                                                
SELECT @filter_level3_locationcode_time = permission_status                                                                                 
FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/timesheet/DataFilter/Level3/LocationCode'                                                               
          AND @user_group_code = user_group_code                                   
                                           
                                           
SELECT @filter_level3_locationcode_exp = permission_status                                                                                                                                                      
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/expensereport/DataFilter/Level3/LocationCode'                                                               
           AND @user_group_code = user_group_code                                
                            
-- HAMZA -- Added the expense_report_name rule                              
select @expense_report_name = case when default_code = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName/Default' then 1 else 0 end                              
 from pdm_rule_group                               
 where path = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName'                              
                            
-- HAMZA -- Added the approvers_based_on rule                            
IF (select default_code from pdm_rule_group where path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes')                            
 = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'                            
BEGIN                            
 SELECT @approvers_based_on = default_code                            
 from pdm_rule_group where path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'                            
END                            
                            
                            
   ------------------------------------end new code                                        
                                                                  
                                       
 select  @number_Of_Days_Prior_Allowed = default_code   FROM pdm_rule_group                                                                 
 WHERE path like 'Rules/TimeandExpense/ExpenseReport/NumberOfDaysPriorAllowed'                                       
   AND user_group_code = @user_group_code                                                              
                                                  
 select  @exp_currencyCode_rule= permission_status   FROM pdm_rule_group                                       
 WHERE path like 'Rules/TimeandExpense/ExpenseReport/Currency'                                       
   AND user_group_code = @user_group_code                              
                                                  
    --------CUSTOM                                              
                               
 select  @is_Customfields_By_ExpanseGroup = default_code   FROM pdm_rule_group                                       
 WHERE path like 'CompanyRules/TimeandExpense/ExpenseReport/CustomFields'                 
    --AND user_group_code = @user_group_code                                                                            
                                                               
                                                               
 select  @OverrideApprovals = case when default_code like '%Yes' then 1 else 0 end  FROM pdm_rule_group                                 
 WHERE path like   'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'                                                                 
                                                        
 select   @ShowBillable = default_code    FROM pdm_rule_group                   
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/NonBillable'                   
                                         
   AND user_group_code = @user_group_code                                                      
                    
  select   @Receipt = permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/Receipt'                                                            
   AND user_group_code = @user_group_code                                                             
                                                         
                                                         
   select    @show_payment_type= permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/PaymentType'                                                            
   AND user_group_code = @user_group_code                                     
      
--------Mati ------ Added Reimburse Group rule      
   select    @show_reimburse_check = permission_status     FROM pdm_rule_group                                                          
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/Reimburse'                                                            
   AND user_group_code = @user_group_code                               
                                                         
   select   @show_tax_code = permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/TaxCode'                                                            
   AND user_group_code = @user_group_code                                                    
                                                       
   select   @Allow_CreditCard_Report = permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'CompanyRules/TimeandExpense/ExpenseReport/AllowAMEXReport'                                                            
   -- AND user_group_code = @user_group_code                                                    
                                                       
                                                       
   select   @Copy_cc_comments = permission_status     FROM pdm_rule_group                                                       
 WHERE   path like 'CompanyRules/TimeandExpense/ExpenseReport/CopyCCCommentsToTransaction'                                                            
   -- AND user_group_code = @user_group_code                                                     
                                                       
   select   @Allow_submit = permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/AllowSubmit'                                                          
   AND user_group_code = @user_group_code                                                       
                                                       
   select   @show_org_unit = permission_status     FROM pdm_rule_group                                                            
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                                            
   AND user_group_code = @user_group_code                                                    
                                                       
   select   @show_location = permission_status     FROM pdm_rule_group                                                  
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/Location'                                                            
   AND user_group_code = @user_group_code                                                    
        
                 
    /* hamad  20151106 multi_currency_flag get from sp pds_mc_exists*/                   
                                               
   --select @is_mc = multi_currency_flag from pdm_company                                            
   --where company_code = @company_code                           
                       
     EXECUTE pds_mc_exists  @company_code,1 ,@is_mc output                   
                       
     /*  end  */                         
                             
  --decimal places                          
     select   @number_of_decimal_places = default_code  FROM pdm_rule_group                                                  
 WHERE   path like 'CompanyRules/TimeandExpense/ExpenseReport/NOOfDecimalsForCalculatedField'                                                            
   --AND user_group_code = @user_group_code                 
               
               
               
  -------          
select @time_approval_comment_required_on_rejection =permission_status                                                                          
FROM   pdm_rule_group                                                 
WHERE  path = 'CompanyRules/TimeandExpense/Approvals/TimeSheet/ApprovalCommentRequiredOnRejection'                                                               
--AND @user_group_code = user_group_code              
            
select @expense_approval_comment_required_on_rejection =permission_status           
FROM   pdm_rule_group                                                                                                                                
WHERE  path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/ApprovalCommentRequiredOnRejection'                                                               
--AND @user_group_code = user_group_code              
          
--------Mati ---- Finance Approval Required Company Rule ----------          
 select  @Finance_Approval_Required = case when default_code like '2' then 1 else 0 end  FROM pdm_rule_group                                 
 WHERE path like   'CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'                                                             
     
--------Mati ---- Finance Approval Required Company Rule ----------          
 select  @Create_Voucher_On_Finance_Approval = case when permission_status like '2' then 1 else 0 end  FROM pdm_rule_group                                 
 WHERE path like   'CompanyRules/TimeandExpense/Approvals/ExpenseReport/CreateVoucherOnFinanceApproval'       
    
     
select @Time_Transaction_Editing_Allowed =permission_status                                                                                                                                                                           
FROM   pdm_rule_group                                                                                                                                
WHERE  path = 'Rules/TimeandExpense/Approvals/TimeSheet/TransactionEditingAllowed'                                           
AND @user_group_code = user_group_code             
            
 select @TimeSheet_DefaultView= default_code          
 FROM   pdm_rule_group                                                                                                                                
WHERE  path = 'Rules/TimeandExpense/Approvals/TimeSheet/DefaultView'                                                                
AND @user_group_code = user_group_code           
               
               
                                           
                                  
 --payment_typw                                                        
declare @payment_value char(15), @payment_seq int, @payment_default_code int                                                         
                                                        
select top 1 @payment_default_code =default_code  , @payment_seq = sequence_id    from pdm_rule_group where path like 'Rules/TimeandExpense/ExpenseReport/PaymentType'                                    
        AND user_group_code = @user_group_code                                                             
                                                        
select top 1  @payment_value =value from pdi_rule_master_detail  where path like 'Rules/TimeandExpense/ExpenseReport/PaymentType'                           
  and  code = @payment_default_code                      
                        
select @payment_code = payment_code from pdm_pmt_type                      
where payment_name = @payment_value                                                         
                    
-- HAMZA -- 20151006 -- to handle the default payment type issue,      
-- if there is not payment code defaulted then select the first 1 from the rule list.                    
if @payment_code is null                    
begin                    
 select top 1 @payment_code = code                     
 from pdi_rule_master_detail  md                        
  inner join pdm_rule_group_detail rd on rd.sub_selected_code = md.code                                                        
  inner join pdm_pmt_type t on t.payment_code = md.code                    
 where md.path like 'Rules/TimeandExpense/ExpenseReport/PaymentType' and                    
 rd.path like 'Rules/TimeandExpense/ExpenseReport/PaymentType'       
 and  rd.sequence_id =@payment_seq                    
end                    
                         
  --Tax                             
                                                         
 declare @tax_value char(15), @tax_seq int, @tax_default_code char(15)                                                        
                                                        
select top 1 @tax_default_code =default_code  , @tax_seq = sequence_id                                                            
 from pdm_rule_group where path like 'Rules/TimeandExpense/ExpenseReport/TaxCode'                                                        
        AND user_group_code = @user_group_code                                                            
                                                        
select top 1  @tax_value =value from pdi_rule_master_detail  where path like 'Rules/TimeandExpense/ExpenseReport/TaxCode'                                                    
  and  code = @tax_default_code                                                         
                                                              
                                                      
     select  @TaxCode= default_code  from pdm_rule_group where path like 'Rules/TimeandExpense/ExpenseReport/TaxCode'                                                         
         AND user_group_code = @user_group_code                                                             
                                                               
                                                     
 --org_unit                                                    
                                                         
 declare @org_unit_value char(128), @org_unit_seq int, @org_unit_default_code varchar(255)                                                    
                                                     
 select top 1 @org_unit_default_code =default_code  , @org_unit_seq = sequence_id                                                            
 from pdm_rule_group where path like 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                                        
        AND user_group_code = @user_group_code                                                    
                                                           
                                                     
select top 1  @org_unit_value =value from pdi_rule_master_detail  where path like 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                                         
  and  code = @org_unit_default_code                                                    
                                                      
                                                        
select @org_unit = org_unit   from pdm_org_units                                                        
where org_name = @org_unit_value                                                            
                                                    
 --location                                            
                                                     
 declare @loc_value char(128), @loc_seq int, @loc_default_code varchar(255)                               
                             
 select top 1 @loc_default_code =default_code  , @loc_seq = sequence_id                                                            
 from pdm_rule_group where path like 'Rules/TimeandExpense/ExpenseReport/Location'                          
        AND user_group_code = @user_group_code                                                    
                                            
                     
select top 1  @loc_value =value from pdi_rule_master_detail  where path like 'Rules/TimeandExpense/ExpenseReport/Location'                                                         
  and  code = @loc_default_code                                                    
                                  
                                                        
select @location = location_code   from pdm_locations                                                        
where loc_name = @loc_value                    
                    
             
     
   ------  
     
     
      
 SELECT @filter_approvals_level2_orgunit = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level2/OrgUnit'                                                               
           AND @user_group_code = user_group_code   
 SELECT @filter_approvals_level3_orgunit = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level3/OrgUnit'                                                               
           AND @user_group_code = user_group_code      
 SELECT @filter_approvals_level2_locationcode = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level2/LocationCode'                                                               
           AND @user_group_code = user_group_code      
 SELECT @filter_approvals_level3_locationcode = permission_status                                                                                                                                                                           
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level3/LocationCode'                                                               
           AND @user_group_code = user_group_code      
     
             
 -------------------------------------------------------
 SELECT  @attachment_is_required=permission_status                                                                                                                                                      
    FROM   pdm_rule_group                                                                                                                                
    WHERE  path = 'CompanyRules/TimeandExpense/ExpenseReport/AttachmentIsRequired'                                                               
            
		   
SELECT  @attachment_level=default_code                                                                                                                                                      
    FROM   pdm_rule_group                                                        
    WHERE  path = 'CompanyRules/TimeandExpense/ExpenseReport/AttachmentLevel'  
		             
    select   @show_cc_mark_as = permission_status     FROM pdm_rule_group                                                  
 WHERE   path like 'Rules/TimeandExpense/ExpenseReport/MarkAsPersonal'                                                            
   AND user_group_code = @user_group_code                    
                                                    
                                   
     ;with cte_parent as                                                                          
                 (                                                      
                        
    select                                  
    ISNULL(@approvers_based_on, 1) - 1 approvers_based_on,                            
    ISNULL(@expense_report_name, 0) expense_report_name,                              
  isnull(@is_Customfields_By_ExpanseGroup, 1) - 1 is_Customfields_By_ExpanseGroup,             
  isnull(@exp_currencyCode_rule, 1) - 1 exp_currencyCode_rule,                                       
  isnull(@number_Of_Days_Prior_Allowed, 1) number_Of_Days_Prior_Allowed,                                   
  isnull(@OverrideApprovals, 1) OverrideApprovals,                                              
  isnull(@ShowBillable , 2) - 1 ShowBillable,                    
  ISNULL(@Receipt, 1) Receipt,                                              
  isnull(@TaxCode, '') TaxCode,                                              
  isnull(@payment_code,'')  payment_code,                          
  ISNULL(@show_payment_type, 1) - 1 show_payment_type,                                              
  ISNULL(@show_tax_code, 1) - 1 show_tax_code,                                              
  ISNULL(@Allow_CreditCard_Report, 1) - 1  Allow_CreditCard_Report,                                              
  ISNULL(@Copy_cc_comments, 1) - 1  Copy_cc_comments,                                                    
  ISNULL(@Allow_submit, 1) - 1 Allow_submit,                        
  ISNULL(@org_unit, '')  org_unit,                                                    
  ISNULL(@show_org_unit, 1) - 1 show_org_unit,                                                    
  ISNULL(@location, '')  location,                                                 
  ISNULL(@show_location, 1) - 1 show_location,                                            
  ISNULL(@is_mc, 0) is_mc  ,                                
  ISNULL(@filter_level2_orgunit_time,1) - 1 filter_level2_orgunit_time,                                
  ISNULL(@filter_level2_orgunit_exp,1) - 1 filter_level2_orgunit_exp,                                
  ISNULL(@filter_level3_orgunit_time,1) - 1 filter_level3_orgunit_time,                                
  ISNULL(@filter_level3_orgUnit_exp,1) - 1 filter_level3_orgUnit_exp,                                    
  ISNULL(@filter_level2_locationcode_time,1) - 1 filter_level2_locationcode_time,                                
  ISNULL(@filter_level2_locationcode_exp,1) - 1 filter_level2_locationcode_exp,                                
  ISNULL(@filter_level3_locationcode_time,1) - 1 filter_level3_locationcode_time,                                
  ISNULL(@filter_level3_locationcode_exp,1) - 1 filter_level3_locationcode_exp,                           
  isnull(@number_of_decimal_places,2) number_of_decimal_places,            
  isnull(@time_approval_comment_required_on_rejection,1)-1 ApprovalCommentRequiredOnRejection_time,            
  isnull(@expense_approval_comment_required_on_rejection,1)-1 ApprovalCommentRequiredOnRejection_expense ,          
  isnull(@Time_Transaction_Editing_Allowed,2)-1 Time_Transaction_Editing_Allowed ,          
  isnull(@TimeSheet_DefaultView,0) TimeSheet_DefaultView ,      
  isnull(@Finance_Approval_Required, 1) FinanceApprovalRequired ,      
  ISNULL(@show_reimburse_check, 1) - 1 ShowReimburseCheck ,    
  isnull(@Create_Voucher_On_Finance_Approval, 1) CreateVoucherOnFinanceApproval,  
  isnull(@filter_approvals_level2_orgunit,1)-1 filter_approvals_level2_orgunit,  
  isnull(@filter_approvals_level3_orgunit,1) -1filter_approvals_level3_orgunit ,  
  isnull(@filter_approvals_level2_locationcode,1)-1 filter_approvals_level2_locationcode ,  
  isnull(@filter_approvals_level3_locationcode,1)-1 filter_approvals_level3_locationcode,
  isnull(@attachment_is_required,1)-1 attachment_is_required,
  isnull(@attachment_level,1)-1 attachment_level,          
  ISNULL(@show_cc_mark_as,2) -1 show_cc_mark_as                                  
  --case when @show_payment_type = 1 then 0 when @show_payment_type = 2 then 1 when @show_payment_type = 3 then 2 else 1 end show_payment_type,                                                      
  -- case when @show_tax_code = 1 then 0 when @show_tax_code = 2 then 1 when @show_tax_code = 3 then 2 else 1 end show_tax_code                 -- @show_tax_code, 1 show_tax_code                                                      
  , null [key]                                                    
             ) ,                                                         
cte_child                                                   
 as(                                 
 select rd.path, 1 as child, cast(payment_code as char(15)) code,                                  
 (isnull(md.value,'')+'~'+(cast(isnull(t.payment_category,0) as varchar(16))+'~'+isnull(t.vendor_code,''))) value                                    
   from pdi_rule_master_detail  md                                                         
 inner join pdm_rule_group_detail rd on rd.sub_selected_code = md.code                                                        
  inner join pdm_pmt_type t on t.payment_code = md.code                    
 where md.path like 'Rules/TimeandExpense/ExpenseReport/PaymentType' and                    
 rd.path like 'Rules/TimeandExpense/ExpenseReport/PaymentType'                    
 and  rd.sequence_id =@payment_seq                    
  union                                                        
  select rd.path, 1 as child, md.code code, md.code value  from pdi_rule_master_detail  md                                                         
  inner join pdm_rule_group_detail rd on rd.sub_selected_code = md.code                                                      
  where md.path like 'Rules/TimeandExpense/ExpenseReport/TaxCode' and                                     
  rd.path like 'Rules/TimeandExpense/ExpenseReport/TaxCode'                           
  and  rd.sequence_id =@tax_seq                                                     
    union                                                        
   select rd.path, 1 as child,CAST(org_unit AS CHAR(18)) code, md.value value from pdi_rule_master_detail  md                                                         
  inner join pdm_rule_group_detail rd on rd.sub_selected_code = md.code                                                  
  INNER JOIN pdm_org_units T ON T.org_unit=MD.code                                                             
  where md.path like 'Rules/TimeandExpense/ExpenseReport/OrgUnit' and                                                        
  rd.path like 'Rules/TimeandExpense/ExpenseReport/OrgUnit'                                                        
  and  rd.sequence_id =@org_unit_seq                                                    
                                                      
   union                                                        
   select rd.path, 1 as child, CAST(location_code AS CHAR(18)) code, md.value   from pdi_rule_master_detail  md                                                         
  inner join pdm_rule_group_detail rd on rd.sub_selected_code = md.code                                                  
  INNER JOIN pdm_locations T ON T.location_code=MD.code                                                             
  where md.path like 'Rules/TimeandExpense/ExpenseReport/Location' and                                                        
  rd.path like 'Rules/TimeandExpense/ExpenseReport/Location'                                              
  and  rd.sequence_id =@loc_seq                                                    
                                                         
                                                         
    )                                                        
                                                            
    select  row_number() over (partition by 1 order by [key]) id , * from cte_parent p full outer join  cte_child c on c.path = p.[key]                                                        
                                                            
                                                                              
                                                     
                                                     
    
END 



GO
