/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_hdr_set]Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_exptrx_hdr_set]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_exptrx_hdr_set]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_hdr_set] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[plsW_apps_exptrx_hdr_set]      
@action_flag       tinyint,  /* 1 - insert new row, 2 - update row, 3 - delete row 5- submit */                                                                                                                               
@company_code      int,                                                                                                                               
@report_name       varchar(32),                                                                                                                               
@resource_id       varchar(16),                                                                                                                               
@record_id         varchar(16),                                                                                                                               
@comments          varchar(252),                                                                                                                               
@date_from         datetime,                                                                                                                               
@date_to     datetime,                                                                                                                               
@expense_num       varchar(16),                                                                                                                               
@amount      float,                                                                                                                               
@TS binary(8) = null ,                                                                                                                               
@override_flag     tinyint = 0,                                                                                                                               
@create_id     varchar(32) = null,                                                                                                                               
@modify_id varchar(32) = null,                                                                                                                               
@approver_id varchar(32)= null,                                                                                                                               
@print_format varchar(50)= null,                                                                                                   
@report_name_prefix   nvarchar(10) = null,                                                        
@subscriber_id varchar(64) = null                                
                                                        
  
                                                                                                                             
/* ****************************************************************** *                                                         
* Copyright 1996 Paradigm Technologies, Inc.                          *                                                                                                                           
* All Rights Reserved                                                 *                                                                                                                           
* *                                                                                                                           
* This Media contains confidential and proprietary information of     *                                                         
* Paradigm Technologies, Inc.  No disclosure or use of any portion    *                             
* of the contents of these materials may be made without the express  *              
* written consent of Paradigm Technologies, Inc.                      *                               
*                   *                                                                                     
* Use of this software is restricted and governed by a License        *                                                                            
* Agreement.  This software contains confidential and proprietary     *                                              
* information of Paradigm Technologies, Inc. and is protected by      *                                                     
* copyright, trade secret and trademark law.        *                                                                                            
*                   *                                                              
* ******************************************************************* *                                                                  
*         Name: plsW_exptrx_hdr_set           *                                                                                       
*       Module:                *                                                                                                            
* Date created: 15/06/2015                                            *                                                                          
*    Create by: Arif hasan             *                                                                                                                      
                                                                                 
* Date revised: 02 July 2015            *                                                                                                                 
*           By: Hamza Mughal            *                                                                                                                 
*      Comment: Added a few validation checks                         *                                                                                                        
                                                                                                                           
*         Name: plsW_apps_exptrx_hdr_set                              *                                                                                               
*       Module:                                                       *                                       
                                                                                       
* Date revised: 07/28/2015                                                                                                                          
*  Create by: Hamad Safder            *                                                                                      
* Date revised:                *                                  
*           By:                *                                          
*    Comment: included functionality for submit if action flag = 1  *     
  
* Date revised: 12/14/2015                                                                                                                          
*    Create by: Hamad Safder     *                                                                                                                          
* Date revised:                *                                                                                                                     
*           By:                *                                                     
*      Comment: updated multi currency check        *                                                                             
*                   *                                                                                                                         
********************************************************************* */                                                                                                                              
          
AS                                                                                                                               
begin                                                                                                       
--SELECT 1 ERROR_FLAG, '-1004' ERROR_CODE, 'Report already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save                   
--RETURN                                                              
        
if  @report_name_prefix is not null         
begin        
 select @report_name_prefix = cc_prefix from pld_cc_type        
end        
                                                              
                                   
create table #trx_hdr_set_rtrn                        
(                                     
  ERROR_FLAG int,                                      
  ERROR_CODE varchar(max),                                    
  ERROR_DESCRIPTION varchar(max),                                                                                                                   
  [timestamp] binary(8),                                                  
  record_id varchar(64),                                                                                                                  
  report_name varchar(32),                                                                                          
  comments varchar(252),                                                          expense_num varchar(16),                                                   
  amount float,                                                                                          
  date_from datetime,                                                     
  date_to datetime,                                                                                          
  approver_id varchar(32),                                                                                          
  print_format varchar(32)                                                                                          
)                                                                          
DECLARE @old_comments varchar(252),                                                                                  
  @old_date_from datetime,                                                                                                                               
  @old_date_to datetime,                                                             
  @old_expense_num varchar(16),  
  @old_amount float,                                                               
  @KDRAFT int = 1,                                                                                
  @KSUBMITTED int = 2,                                      
  @KREJECTED int = 3,                                                                                
  @KAPPROVED int = 4,                                                             
  @KFINANCE_APPROVED int = 5                                                                                
                                                              
------------------------------------------ VALIDATIONS ------------------------------------------                 
-- TO SEE IF THE TRANSACTION ALREADY HAS BEEN UPDATED FROM ESM.                                                                                
IF /* (@action_flag = 2 OR @action_flag = 5 OR @action_flag = 3) AND */(@TS is not null AND @TS <> 0x0000000000000000)                                                                                
 AND @TS <> (select timestamp from pld_transactions_hdr where record_id = @record_id)             
BEGIN                                                               
print 'f'                                                                            
  IF (@action_flag = 5 OR @action_flag = 3)      
BEGIN      
SELECT 1 ERROR_FLAG, '-1004' ERROR_CODE, 'Report already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save      
RETURN      
END      
select @old_comments = comments, @old_date_from = date_from, @old_date_to = date_to, @old_expense_num = expense_num,      
@old_amount = amount      
from pld_transactions_hdr      
where record_id = @record_id      
if @old_comments <> @comments      
OR isnull(convert(date, @old_date_from), '1999-01-01') <> ISNULL(convert(date, @date_from), '1999-01-01')      
OR ISNULL(convert(date, @old_date_to), '2050-12-31') <> ISNULL(convert(date, @date_to), '2050-12-31')      
OR @old_expense_num <> @expense_num      
OR @old_amount <> @amount      
begin      
SELECT 1 ERROR_FLAG, '-1001' ERROR_CODE, 'Report already updated from application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save      
RETURN      
end      
-- HAMZA -- 20151116 -- If the header's parameters are same then do not check for the report change.      
else      
begin      
set @TS = (select timestamp from pld_transactions_hdr where record_id = @record_id)      
end                                                             
END                                                    
                                                                         
                                                        
                                                  
                                                                              
-- TO SEE IF TRANSACTION THAT IS TO BE CHANGED IS ALREADY DELETED FROM THE ESM.                                                                                                                  
if (@action_flag = 2 OR @action_flag = 5) and exists                                                   
 (select 1 from plv_event_notification with(nolock) where  primary_key like '%' + @record_id + '%' and entity_action_id=3 and entity_type_id = 4 and subscriber_id = ISNULL(@subscriber_id,''))                                                               







  
     
     
        
        
        
          
            
              
                 
begin                                                                                   
 SELECT 1 ERROR_FLAG, '-1002' ERROR_CODE, 'Report already deleted from the Application. Please refresh.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save                                  


  
    
      
        
        
        
 RETURN                                                                    
end                                                      
                                                 
                                         
--RS20150904 To check if any transaction's level3 open date is greater than the applied date                                                   
if  @action_flag=5                                                  
begin                                                  
declare                                                   
@level2_key char(32),                                                  
@level3_key varchar(64),                                                  
@amount_due float (8),                         
@level3_open_date datetime,                                              
@level3_closed_date datetime,                                                  
@Applied_date datetime,                                                 
@Resource_Type varchar(16),                                                  
@Level2_descr varchar(32),                                                  
@Level3_descr varchar(32),                 
@Resource_Type_descr varchar (32),                                                  
@level2_open_date datetime,                                                  
@level2_closed_date datetime,                                                  
@expense_flag tinyint,                                              
 @org_unit   char(16),                                              
 @location_code char(16)                      
                                               
                                             
DECLARE @location_code_sysname varchar(64),                                                    
   @org_unit_sysname varchar(64),                                                 
   @user_group_code varchar(64),                                                    
   @sequence_id int,                           
   @org_unit_for_check varchar(64),                                            
   @location_code_for_check varchar(64),                                            
   @Cost_Code_Name_sysname varchar(64),                                            
   @res_type_for_check varchar(64),                                            
   @applied_date_for_check datetime                                                  
                                                  
select @Level2_descr=display_name from plv_sysnames where field_name='Level2_descr'                                                    
select @Level3_descr=display_name from plv_sysnames where field_name='Level3_descr'                        
                            
                                         
select @Resource_Type_descr=display_name from plv_sysnames where field_name='Cost_Code_Name'                                          
select @Cost_Code_Name_sysname = display_name from plv_sysnames where field_name='Cost_Codes' and company_code=@company_code                                                              
                            
create table #pld_transactions_return                                                  
(transaction_id char(16),                                                  
record_id char(16),                                                  
 level2_key char(32),                                                  
 level3_key varchar(64),                                                 
 level3_open_date date,                                                  
 applied_date date,                                                  
 amount float (8),                                                  
 res_type int,                                                  
 res_type_desc varchar(64), --change from 16 to 64 TL 20190530                                             
 level2_status tinyint,                            
 level3_status tinyint,                                                  
 level2_closed_date datetime,     
 level3_closed_date datetime,                                                  
 level2_open_date date,                                                  
 expense_flag tinyint,                                              
 org_unit   char(16),                                              
 location_code char(16),                                    
 comments varchar(3000)                          
 )                                                  
                                                  
  insert into #pld_transactions_return                                                  
  select transaction_id,record_id,pld.level2_key,pld.level3_key,l3.date_opened,pld.applied_date,pld.amount,                                                  
  pld.res_type,rt.rtype_name,level2_status,level3_status,l2.date_closed,l3.date_closed,l2.date_opened,l3.expense_flag     
   ,pld.org_unit,pld.location_code, pld.comments                             
  from pld_transactions pld     
  inner join plv_level3 l3 on pld.company_code=l3.company_code                                            
                           and pld.level2_key=l3.Level2_key                                            
                           and pld.level3_key=l3.level3_key                                            
  inner join plv_level2 l2 on l3.level2_key=l2.level2_key                                            
                           and l3.company_code=l2.company_code                                            
  inner join plv_resource_types rt on pld.company_code=rt.company_code                                            
                                and pld.res_type=rt.res_type                                            
  where pld.company_code=@company_code                                            
  and record_id=@record_id                                            
  and isnull(submitted_flag, 0)  = 0               
                                       
   select @user_group_code = user_group_code from plv_group_user_link where resource_id = @resource_id and preferred_group_flag = 1                                         
   select @location_code_sysname = display_name from plv_sysnames where Field_Name = 'location_descr'                                 
   select @org_unit_sysname = display_name from plv_sysnames where Field_Name = 'org_unit'                                                     
                                                 
if  exists(select 1 from #pld_transactions_return where level2_status<>1)                                                  
 begin                                                  
 select top 1 @level2_key=level2_key                                                  
 from  #pld_transactions_return  where level2_status<>1                                                  
                                                   
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
 'Cannot Submit any Transaction for this '+rtrim(ltrim(@Level2_descr))+' :"'+rtrim(ltrim(@level2_key))+'".'+ rtrim(ltrim(@Level2_descr)) + ' is not active.'  ERROR_DESCRIPTION,                                                  
 @TS [timestamp], 1 is_after_save                                                   
 Return                                                   
 end                                        
                      
declare @transaction_id varchar(64)                                  
 select @transaction_id =p.transaction_id  
  from pld_transactions  p                               
   inner join pld_transactions_exp e on e.transaction_id = p.transaction_id and p.record_id = e.record_id and e.record_id = @record_id        
 where                                   
  dbo.fn_apps_verifyCustomFields                                   
 (                                  
   e.text1  ,                                                                                
   e.text2  ,                                           
   e.text3  ,                                                                                
   e.text4  ,                                                                        
   e.text5  ,                                                                                
   e.text6  ,                                                    
   e.text7  ,                                                                                
   e.text8  ,                    
   e.text9  ,                                                          
   e.text10  ,                                                          
   e.number11,                                                          
   e.number12,                                                          
   e.number13,                                          
   e.number14,   
   e.number15,                                                          
   e.number16,                                                          
   e.number17,                      
   e.number18,                                                          
   e.number19,                  
   e.number20,                                   
    p.res_type,                                   
     null                                  
  ) = 0                          
                        
  -- ADDED CHECK WITH MC_CHECK_SP  hamad 20151214                  
declare @is_mc int                  
EXECUTE pls_mc_Apps_exists  @company_code,1 ,@is_mc output                   
  
---------------------                        
 if @transaction_id  is not null                                 
 begin                                             
                         
 select  @amount_due=amount, @level3_key= level3_key, @level2_key =  level2_key from pld_transactions where transaction_id = @transaction_id                       
                        
                           
                              
                                 
                  
  SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
  'Custom field(s) have been changed from application. Please save the transaction after refresh For: '                                                  
  +CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10 )                      
   --+ @Resource_Type_descr+': '+@Resource_Type+CHAR(10)                    
   +'Amount: '+convert(varchar(10),@amount_due)                       
   ERROR_DESCRIPTION,                                             
                        
                          
                           
   @TS [timestamp], 1 is_after_save                                   
    RETURN                                                  
 end                                                 
                                                  
if  exists(select 1 from #pld_transactions_return where   applied_date<level2_open_date)                       
begin                                                     
 select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level2_open_date=level2_open_date,                                                  
 @Applied_date= applied_date                                                   
,@Resource_Type=res_type_desc                                          
 from  #pld_transactions_return  where   applied_date<level2_open_date                                                   
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
 'Applied date "'+convert(varchar,@applied_date,111)+'" can not be earlier than '+@Level2_descr+' open date "'+convert(varchar,@level2_open_date,111)+'" For ; '                                                  
+CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10)+@Resource_Type_descr+': '+@Resource_Type+CHAR(10)+'Amount: '+convert(varchar(10),@amount_due) ERROR_DESCRIPTION,                        








   
   
       
       
        
         
         
            
              
                 
                 
                    
                       
                   
                         
 @TS [timestamp], 1 is_after_save                                                                                              
 RETURN                                                                                                    
end                                                    
                                                   
if exists(select 1 from #pld_transactions_return where   applied_date>level2_closed_date)                                    
begin                                                     
 select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level2_closed_date=level2_closed_date,                                                  
 @Applied_date= applied_date                                                   
,@Resource_Type=res_type_desc                                                  
 from  #pld_transactions_return  where   applied_date>level2_closed_date                                                   
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
 'Applied date "'+convert(varchar,@applied_date,111)+'" can not be later than '+@Level2_descr+' closed date "'+convert(varchar,@level2_closed_date,111)+'" For ; '                                                  
+CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10)+@Resource_Type_descr+': '+@Resource_Type+CHAR(10)+'Amount: '+convert(varchar(10),@amount_due) ERROR_DESCRIPTION,                        









   
    
      
        
        
        
        
            
              
                
                  
                    
                      
                        
                         
 @TS [timestamp], 1 is_after_save                         
 RETURN                                                                                                                  
end                                                     
                                                   
                                                   
if  exists(select 1 from #pld_transactions_return where level3_status<>1)                                                  
begin                                                  
select top 1 @level2_key=level2_key,@level3_key=level3_key                                                  
from  #pld_transactions_return  where level3_status<>1                                                  
                                                  
SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
'Cannot Submit any Transaction for this '+rtrim(ltrim(@Level2_descr))+' :"'+rtrim(ltrim(@level2_key))+'".'+ rtrim(ltrim(@Level2_descr))+ ' - ' +rtrim(ltrim(@Level3_descr))+':'+rtrim(ltrim(@level3_key))+'.'+ rtrim(ltrim(@Level3_descr))                     







  
    
     
         
        
        
          
            
              
                
                  
                    
+ ' is not Open.' ERROR_DESCRIPTION,                                                  
  @TS [timestamp], 1 is_after_save                               
Return                                                   
end         
                    
                                                  
if exists(select 1 from #pld_transactions_return where   applied_date<level3_open_date)                                                
begin                                                     
 select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level3_open_date=level3_open_date,                                                  
 @Applied_date= applied_date                                                   
,@Resource_Type=res_type_desc                                                  
 from  #pld_transactions_return  where   applied_date<level3_open_date                                                   
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
 'Applied date "'+convert(varchar,@applied_date,111)+'" can not be earlier than '+@Level3_descr+' open date "'+convert(varchar,@level3_open_date,111)+'" For ; '                                                  
+CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10)+@Resource_Type_descr+': '+@Resource_Type+CHAR(10)+'Amount: '+convert(varchar(10),@amount_due) ERROR_DESCRIPTION,                        







 

  
    
      
        
        
        
          
           
               
                
                  
                    
                      
                       
                          
 @TS [timestamp], 1 is_after_save                                                                                                         
 RETURN                                                                        
end                                                    
                                                  
                                                  
                                                  
if exists(select 1 from #pld_transactions_return where applied_date>level3_closed_date)                                                  
begin                                                  
                                                  
select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level3_closed_date=level3_closed_date,                                                  
 @Applied_date= applied_date                                                   
,@Resource_Type=res_type_desc                          
from  #pld_transactions_return  where  applied_date>level3_closed_date                                                  
                                                  
SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
'Applied date "'+convert(varchar,@applied_date,111)+'" can not be later than '+@Level3_descr+' closed date "'+convert(varchar,@level3_closed_date,111)+'" For ; '                                                  
+CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10)+@Resource_Type_descr+': '+@Resource_Type+CHAR(10)+'Amount: '+convert(varchar(10),@amount_due) ERROR_DESCRIPTION,                
 @TS [timestamp], 1 is_after_save                          
Return                                                   
             
end                                                    
                                                  
                                                  
                                                  
                                                  
if  exists(select 1 from #pld_transactions_return where expense_flag=0)                                                  
begin                                                  
           
select top 1 @level2_key=level2_key  ,@level3_key=level3_key                                                  
from  #pld_transactions_return  where  expense_flag=0                                                  
                                                  
SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                               
'Cannot Submit Transaction for this '+rtrim(ltrim(@Level2_descr))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@Level2_descr))+' - ' +rtrim(ltrim(@Level3_descr))+':'+rtrim(ltrim(@level3_key))+'.'+ rtrim(ltrim(@Level3_descr))                 
+ ' is not valid for the Expense Entry.'  ERROR_DESCRIPTION                                                    
 ,@TS [timestamp], 1 is_after_save                                                   
Return                                                   
                                                  
end                                                    
                                                
                       
  -----20150911                                              
 if exists (select 1 from #pld_transactions_return where isnull(comments, '') = '')                                      
 begin                                      
 set @level2_key = (select top 1 level2_key from #pld_transactions_return where ISNULL(comments, '') = '')                                 
  if (select comments_for_expense_required_flag from plv_level2 where level2_key=@level2_key)=1                                                   
  begin                                        
  select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level3_closed_date=level3_closed_date,                                                  
   @Applied_date= applied_date                         
  ,@Resource_Type=res_type_desc                                                  
  from  #pld_transactions_return  where  isnull(comments, '') = ''                                      
                                                    
  SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                                  
  'Comments are required, please enter comments and then submit. For: '                                                  
  +CHAR(10)+@Level2_descr+': '+ltrim(rtrim(@level2_key))+CHAR(10)+@Level3_descr+': '+ltrim(rtrim(@level3_key))+CHAR(10)+@Resource_Type_descr+': '+@Resource_Type+CHAR(10)+'Amount: '+convert(varchar(10),@amount_due) ERROR_DESCRIPTION,                       







 
    
      
         
        
        
         
             
             
                 
                  
                    
                      
                        
                         
                            
   @TS [timestamp], 1 is_after_save                                           
  Return                                                                               
  end                                        
 end                                     
                                               
if exists (select 1 from #pld_transactions_return trx where location_code not in (select location_code from plv_locations))                            
begin                                            
 select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level2_open_date=level2_open_date,                                              
 @Applied_date= applied_date                                    
,@Resource_Type=res_type_desc                                              
 from  #pld_transactions_return where location_code not in (select location_code from plv_locations)                                    
                                     
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                              
 'Cannot Save for this Transaction :' + CHAR(10) + @Level2_descr +': ' + rtrim(ltrim(@level2_key)) +                                               
+ CHAR(10) + @Level3_descr+ ': ' + ltrim(rtrim(@level3_key)) + CHAR(10) + @Resource_Type_descr + ': ' + @Resource_Type                                             
+ CHAR(10) + 'Amount: ' + convert(varchar(10),@amount_due) + CHAR(10) + @location_code_sysname + ' is not valid.' ERROR_DESCRIPTION,                                              
 @TS [timestamp], 1 is_after_save                                           
 return                                             
end                                                   
                                                
---- HAMZA -- 20150909                                                            
if exists (select 1 from #pld_transactions_return trx where org_unit not in (select org_unit from plv_org_units))                                            
begin                                            
 select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level2_open_date=level2_open_date,                                              
 @Applied_date= applied_date                                            
,@Resource_Type=res_type_desc                   
 from  #pld_transactions_return where org_unit not in (select org_unit from plv_org_units)                                          
                                                
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                              
 'Cannot Save for this Transaction :' + CHAR(10) + @Level2_descr +': ' + rtrim(ltrim(@level2_key)) +                                               
+ CHAR(10) + @Level3_descr+ ': ' + ltrim(rtrim(@level3_key)) + CHAR(10) + @Resource_Type_descr + ': ' + @Resource_Type                                             
+ CHAR(10) + 'Amount: ' + convert(varchar(10),@amount_due) + CHAR(10) + @org_unit_sysname + ' is not valid.' ERROR_DESCRIPTION,                                              
 @TS [timestamp], 1 is_after_save                                             
 return                                           
end                                     
                                             
if exists             
(select * from #pld_transactions_return trx where res_type not in            
 (            
  select res_type from plv_cost_codes where COST_TYPE in            
  (            
   select COST_TYPE from plv_level3 where level2_key = trx.level2_key and level3_key = trx.level3_key            
  )            
  and trx.applied_date >= effective_date            
 ))                              
begin                                        
select top 1 @level2_key=level2_key  ,@level3_key=level3_key,@amount_due=amount,@level2_open_date=level2_open_date,                                              
 @Applied_date= applied_date                                            
,@Resource_Type=res_type_desc                                              
 from #pld_transactions_return trx where res_type not in                            
 (select res_type from plv_cost_codes where COST_TYPE in                            
 (select COST_TYPE from plv_level3 where level2_key = trx.level2_key and level3_key = trx.level3_key) and trx.applied_date >= effective_date)                                       
        
 SELECT 1 ERROR_FLAG, '-1005' ERROR_CODE,                                              
 'Cannot Save for this Transaction :' + CHAR(10) + @Level2_descr +': ' + rtrim(ltrim(@level2_key)) +                                               
+ CHAR(10) + @Level3_descr+ ': ' + ltrim(rtrim(@level3_key)) + CHAR(10) + @Resource_Type_descr + ': ' + @Resource_Type                                             
+ CHAR(10) + 'Amount: ' + convert(varchar(10),@amount_due) + CHAR(10) + @Resource_Type_descr + ' is not valid.' ERROR_DESCRIPTION,                                      
 @TS [timestamp], 1 is_after_save     
                            
return                                           
end                        
            
                                            
END                                       
                                                  
--RS20150904 To check if any transaction's level3 open date is greater than the applied date                                                   
                                                                            
--  CHECK TO SEE IF THE RESOURCE IS ACTIVE OR NOT (plv_resource only gets the active resource)                                                                                                      
IF not exists (select 1 from plv_resource where resource_id = @resource_id and company_code = @company_code)                                                                               
begin                                                                                            
 SELECT 1 ERROR_FLAG, '-1003' ERROR_CODE, 'Resource does not exist or is not active.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save                                                                                                         
 RETURN                     
end                                                            
                                                         
                                        
-- HAMZA -- 20150901 -- DO NOT SET THE APPROVER IF IT IS INACTIVE                                                          
                                                        
if isnull(@approver_id  , '') != ''  and                                                     
 not exists (select 1 from plv_resource_all where resource_id = @approver_id and active_flag = 1)                                                    
 and @action_flag = 5                                                         
begin                                                          
 SELECT 1 ERROR_FLAG, '-1006' ERROR_CODE, 'Approver is not active.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save                                                          
 RETURN                                                          
end                                                          
                                                      
  --Arif 20150903                                                      
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
  insert into #Approvers                                               
        exec [plsW_apps_exprpt_approvers_get] @company_code= @company_code, @resource_id=@resource_id                                           
  --Arif 20150903                                                  
--if not exists (select 1 from plv_resource_all where resource_id = @approver_id and active_flag = 1)                                                      
 if not exists (select 1 from #Approvers where resource_id = @approver_id  )                                                      
 and @action_flag = 5                                                      
 and isnull(@approver_id  , '') != ''                                             
begin                                                    
 SELECT 1 ERROR_FLAG, '-1006' ERROR_CODE, 'Approver does not exists in Approver List.' ERROR_DESCRIPTION, @TS [timestamp], 1 is_after_save                                        
 RETURN                                                      
end                                                          
                                                                                    
------------------------------------------ VALIDATIONS ENDS ------------------------------------------                                                                      
                                                     
                                                             
-- HAMZA -- 201850821 -- Delete the transactions first prior to deleting the header.                                                      
if @action_flag = 3 and exists (select 1 from pld_transactions where record_id = @record_id)                                                                          
begin


                                                                           
 delete from pld_transactions                                                                    
 where record_id = @record_id  
end           
                                                                                           
                                                                          
if @action_flag = 5                                                                
begin          
 -- print 'in for submit'          
 -- HAMZA -- MANAGER REAPPROVAL CHECK                                                                              
  exec [plsW_re_approval_check] @record_id = @record_id, @company_code = @company_code, @source = 'APP EXP'                        
 
 
 /*FS20180828*/
 declare @totalAmt float
 if exists (select 1 from pld_transactions where record_id = @record_id)                                                                    
 begin          
 
   select   amount , amount_home  into #pldTransaction             
   from pld_transactions  where  record_id = @record_id                                  
              
                  
 if(@is_mc=1)                  
 begin                                      
 select @totalAmt = sum(amount_home)                                                 
 from #pldTransaction                                
 end                     
 else                  
 begin                  
 select @totalAmt = sum(amount)
 from #pldTransaction                     
 end   
             
   update pld_transactions_hdr                                                           
   set amount = @totalAmt,               
    source = 'APP EXP'              
   where company_code = @company_code                                               
   and record_id = @record_id          
    end  
 
 
 
                                                                                                  
  /* code for submit */                                                                                          
  insert into #trx_hdr_set_rtrn                                                                                          
  (ERROR_CODE, ERROR_DESCRIPTION)                                                                                          
  exec [plsW_submit_exp]                                
    @company_code=@company_code,                                                                                                  
    @resource_id=@resource_id,                                                                                         
    @report_name=@report_name,                                                                                                   
    @approver_id=@approver_id,                                                                                                  
    @record_id  = @record_id ,                                                                                                
    @submitter_id=@resource_id,                        
    @source = 'APP EXP',                        
    @user_id = @modify_id
    
	update pdd_apps_notification
	set [source]='APP EXP'
	where record_id  = @record_id
	           
     -- HAMZA 20150923 -- During submission the date was not bieng set correctly,           
        -- recalculated the date after the submission.          
                                                                             
    DECLARE @date_to_temp datetime,                                                                                      
    @date_from_temp datetime                                                                                      
           
                                                    
 if exists (select 1 from pld_transactions where record_id = @record_id)                                                                    
 begin          
  -- print 'in for update in submit'          
  --arifhasan 20150922 used temp table to optimize the query and avoid the deadlock        
  /* hamad  20151214 added home amt*/  
   select   amount ,  applied_date, amount_home  into #pld_transactions             
   from pld_transactions  where  record_id = @record_id                                  
                                            
             
   --select @totalAmt = sum(amount), @date_to_temp = max(applied_date), @date_from_temp = MIN(applied_date)                                  
   --from #pld_transactions          
     
  -- ONLY WHEN MC IS NOT ACTIVE    hamad 20151415                   
 if(@is_mc=1)                  
 begin                                      
 select /*@totalAmt = sum(amount_home),*/ @date_to_temp = max(applied_date), @date_from_temp= MIN(applied_date)                                                    
 from #pld_transactions                                 
 end                     
 else                  
 begin                  
 select/* @totalAmt = sum(amount), */@date_to_temp = max(applied_date), @date_from_temp= MIN(applied_date)                                                    
 from #pld_transactions                     
 end   
             
   update pld_transactions_hdr                                                           
   set /*amount = @totalAmt,   */                                         
    date_to = @date_to_temp,                                                                        
    date_from = @date_from_temp,              
    source = 'APP EXP'              
   where company_code = @company_code                                               
   and record_id = @record_id          
    end              
                                                                                       
  update #trx_hdr_set_rtrn                                                                                          
  set ERROR_FLAG = 1                          
  where ERROR_CODE > 0                                                                                          
            
 select *, 1 as is_after_save                                                                                     
 from #trx_hdr_set_rtrn err                                                                                          
 /* end code for submit */          
 return          
end          
else -- SP Call is not for submit          
begin          
 set @approver_id = null          
end          
                                                                                                           
                                                                                                    
DECLARE @path varchar(255),                                                                                               
@default_code varchar(255)                                                                                                                      
                                                                    
SELECT @path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'                                                                                                                      
                                                                                                      
SELECT @default_code=default_code                                                                                                                       
FROM plv_rule_group                                                                                                                       
WHERE path=@path                                                                  
and user_group_code is NULL         
                                                              
 if not exists (select 1 from pld_transactions_hdr where record_id = @record_id) and @action_flag = 2                                          
 begin                    
  SET @action_flag = 1                                                                                       
 end                                           
                                            
                                                                        
-- IF THE ACTION FLAG IS 1 AND THE TRANSACTION ALREADY EXISTS THEN UPDATE IT.                                                                                                                  
 -- USE THE SAME VALUES THAT ARE ALREADY IN THE TABLE (ONLY WHICH ARE NOT EDITABLE BY THE APP)                                                                                                                  
IF (@action_flag = 1 or @action_flag = 2)                            
 and exists (select 1 from pld_transactions_hdr where record_id = @record_id)                                                                                                               
BEGIN                                                                                                                  
 IF @action_flag = 1                                                             
  SET @action_flag = 2                             
                                      
 SELECT @company_code = company_code,                                                                          
     @report_name = report_name,                                                                                                                  
     @resource_id = resource_id,                                                                                                                  
     @record_id = record_id,                                                                        
     @expense_num = expense_num,                                                                                                                  
     @TS = timestamp,           @create_id = create_id,                                                        
     @modify_id = @resource_id,                                    
     @approver_id = approver_id,                                                                                          
     @print_format = print_format                                                                                                                  
 FROM pld_transactions_hdr                                                                                                                  
 WHERE record_id = @record_id                                                                                                   
                                                                                         
END                                                                                                                  
                                                                                                                  
------------------------------------------------- REPORT NAME LOGIC ------------------------------------------------                                                                                                                  
if @action_flag = 1                                                                                                       
 begin                                                                                                      
                                                                         
 ------------ADD CHECK 08-24-2015                                                                           
 declare @default_code1 varchar(max)                                                   
 set @default_code1 =(select top 1 default_code from plv_rule_group where path = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName')                                          
                                        
 if ISNULL(@default_code1, '') <> '' and @default_code1 = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName/Custom'                   
 BEGIN                                                                        
  DECLARE @mask_count int,                                                       
    @user_count int,                                                                                                         
    @report_name_custom varchar(max),                                                                                                                  
    @login_id varchar(max) = (select loginid from plv_resource_all where resource_id = @resource_id),                                                                                                                  
    @custom_rep_name_rule_path varchar(max) = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName/Custom'                                   
                                                                                                       
  IF (select default_code from plv_rule_group where path = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName') = @custom_rep_name_rule_path                           
   begin                                   
   set @mask_count = (select default_code from plv_rule_group where path = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName/Custom/CoMask')                                                                                                       







  
    
      
        
        
        
          
           
   set @user_count = (select default_code from plv_rule_group where path = 'CompanyRules/TimeandExpense/ExpenseReport/ExpenseReportName/Custom/LoginID')                                                                                                       







  
    
      
        
        
        
          
           
                                                                                                    
   exec plsW_expreport_number_get @company_code, @report_name_custom output                                                              
                                                        
   if LEN(@report_name_custom) > @mask_count                                                                                                                  
    begin                                             set @report_name                                                                                                       
    = SUBSTRING(@report_name_custom, 0, LEN(@report_name_custom) - @mask_count)                                                                                                                  
    end                                                          
   else                                                                                                           
    begin                                                                                                  
    set @report_name = @report_name_custom                                                                                                                  
    end                              
                                                                                                                      
   if LEN(@login_id) > @user_count                                                                                                                  
    begin                                                                          
    set @report_name = @report_name + SUBSTRING(@login_id, 1, @user_count)                                                         
    end                                                                                   
   else                                                       
    begin                                                           
    set @report_name = @report_name + @login_id                                                                      
    end                                                  
    set @report_name = rtrim(ltrim(isnull(@report_name_prefix, ''))) + @report_name                                                                     
   end                                             
 END                                                                                                     
 end                                                  
---------------------------------------------- REPORT NAME LOGIC ENDS ----------------------------------------------                                                                                                                  
                                                                        
insert into #trx_hdr_set_rtrn                              
 (ERROR_CODE, ERROR_DESCRIPTION, report_name, comments, expense_num, amount, date_from, date_to, [timestamp],approver_id,print_format)                                                                       
exec plsW_exptrx_hdr_set                                         
  @action_flag,  
  @company_code,                                                                                                           
  @report_name,                                           
  @resource_id,                                                                                     
  @record_id,                                                                                                      
  @comments,                                                                                                                      
  @date_from,                                                                                                                
  @date_to,                                                           
  @expense_num,                                                 
  @amount,                
  @TS,                                                                                                                      
  @override_flag,                                                                                  
  @create_id,                                                                                                                      
  @modify_id,                                                                                                         
  @approver_id,                                                                                
  @print_format,                                 
  @source='APP EXP'                                                                              
                                                                                
                                                                                  
                                                                                                                  
-- select * from #trx_hdr_set_rtrn                                                                                                               
                                         
update #trx_hdr_set_rtrn                                                                                                           
set record_id = @record_id                                                                                                                  
                
update #trx_hdr_set_rtrn                                                                                            
set ERROR_FLAG = 1                                                               
where isnull(ERROR_DESCRIPTION, 'NONE') <> 'NONE'                 
                                                           
                                                                              
select *, 1 as is_after_save                                                                                                                
from #trx_hdr_set_rtrn err                                                                                          
                                         
end           








go
