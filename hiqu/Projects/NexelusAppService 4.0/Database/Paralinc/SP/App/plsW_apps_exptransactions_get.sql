/****** Object:  StoredProcedure [dbo].[plsW_apps_exptransactions_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_exptransactions_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_exptransactions_get]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_exptransactions_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROC [dbo].[plsW_apps_exptransactions_get]
             
@company_code int ,                                 
@resource_id varchar(16) ,                                           
@record_id char(16)=null,                 
@transaction_id char(16)=null,                                           
@l2_org_unit char(16)= NULL,                                          
@l2_location_code char(16) = NULL,                                 
@l3_org_unit char(16)= NULL,                                          
@l3_location_code char(16) = NULL      ,                         
@last_sync_date datetime = null  ,                 
@subscriber_id int = null,                 
@keys xml = null,
@login_id varchar(32)=null,
@is_from_header tinyint = null
                           
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
*         Name: plsW_exptransactions_get                        *                              
*       Module:                                                 *                              
* Date created: 11/01/99                                        *                              
*           By: Alex Peker                                      *                              
*      Version:                                                 *                              
*      Comment:                                                 *                              
*                                     *                              
* Date revised:08/18/2005                                                 *                     
*           By:Nauman khan                                         *  
*      Comment:Added two new fields extra param(s)                                                
*                                                                     *                            
* Date revised:        *                              
*           By:     *                              
*      Comment:                                              *                             
                    
   @keys  = '<keys>            
  <key>            
    <transaction_id>21042015</transaction_id>   
  </key>            
  <key>             
    <transaction_id>002</transaction_id>            
  </key>            
</keys>'             
            
              
                    
******************************************************************** */          
WITH RECOMPILE
AS                             
                    
 Begin                           
                     
 CREATE TABLE #temp                             
                     
 (                  
                     
  level2_key char(32)                             
                      
  ,level3_key char(64)                             
                   
  ,transaction_id char(16)                             
                      
  ,applied_date datetime                             
                  
  ,org_unit char(16)                             
                      
  ,location_code char(16)                             
                      
  ,comments varchar(3000)                             
                      
  ,amount  float                             
                      
  ,amount_home     float,                             
                      
  amount_billable float,                             
                      
  submitted_flag  tinyint,                             
                      
  res_type  int,                             
                      
  payment_code  int,                             
                      
  payment_name  varchar(16),                             
                      
  currency_code  char(8),                             
                      
  currency_conversion_rate float ,                             
                      
  allocation_prc float,                             
                      
  receipt_flag tinyint,                             
                      
  reimbursment_flag tinyint,                             
                      
  line_id  varchar(16) ,                             
                      
  gst_tax_code  varchar(8),                             
                      
  gst_tax_amt float,                             
                      
  net_amount float,                             
                      
  level2_description varchar(128) ,                             
                      
  level3_description varchar(64) ,                             
                      
  approval_flag  int ,                             
                      
  approval_comment varchar(255),                             
                      
  approved_by  varchar(33),                        
                      
  approval_date  datetime,                             
                      
  nonbill_flag  tinyint,                             
                      
  timestamp  binary(8),                             
                      
  units  float,                             
                      
  submitted_date  datetime,                             
                      
  mail_date  datetime,                         
                      
  upload_date  datetime,                             
                      
  upload_flag  tinyint,                            
                      
  parent_id char(16),                     
                      
  extra_param_1 varchar(255),                             
                      
  extra_param_2  varchar(255),                             
                      
  is_valid int,                             
                      
  business_reason  varchar(255),                             
 
  finalise_flag  tinyint,                             
                      
  finalised_by  varchar(32),                             
                      
  finalised_date  datetime,                             
                      
  text1  varchar(255),                             
                      
  text2  varchar(255),                         
                      
  text3  varchar(255),                             

  text4  varchar(255),    
                      
text5  varchar(255),     
                      
  text6  varchar(255),     
                      
  text7  varchar(255),                             
                      
  text8  varchar(255),                             
                      
  text9  varchar(255),                             
                      
  text10  varchar(255),                             
                      
  number11 float,                    
                      
  number12 float,                             
                      
  number13 float,                             
                      
  number14 float,                             
                      
  number15 float,                             
                      
  number16 float,                             
      
  number17 float,                             
                      
  number18 float,                             
                      
  number19 float,                             
                      
  number20 float,                             
                      
  cost_type int,                             
                      
  approval_flag_l3 tinyint ,                             
                      
  approval_flag_l2 tinyint,                             
                      
  approval_flag_trx tinyint,                             
                      
  billing_currency_code  varchar(8),                             
                      
  expcost_xrate_type  int,                             
                      
  expcost_xrate_type_name  varchar(16),                             
                      
  l2_date_opened datetime,                             
                      
  l2_date_closed datetime,                             
                      
  l3_date_opened datetime,                             
                      
  l3_date_closed datetime,                             
                      
  cc_exp_id int,                             
                      
  cc_comments varchar(400),                             
                      
  cc_ext_reference_no varchar(32),                             
                      
  cc_num  varchar(32) ,             
  trx_type int,             
  res_usage_code char(16),             
  task_code char(16),             
  cc_type_id tinyint  ,             
  record_id char(16),  
  is_file_attached int,
  is_image_changed int,
  resource_id varchar(16)               
 )                             
                     
                     
         SELECT   T.c.value('./transaction_id[1]', 'nvarchar(64)') transaction_id    into #transactions                  
                       FROM     @keys.nodes('/keys/key') T ( c )             
              
 /*                 
 insert into #temp                             
                     
 SELECT                         
             
   d.level2_key      ,                             
        
   d.level3_key      ,                             
                       
   d.transaction_id  ,                             
                       
   d.applied_date ,                             
                   
   d.org_unit        ,                             
                       
   d.location_code   ,                             
                    
   d.comments        ,          
         
   d.amount          ,                             
                       
   d.amount_home     ,                             
                       
   d.amount_billable ,                             
                       
   d.submitted_flag  ,           
       
   d.res_type ,                             
                       
   d.payment_code ,                
                       
   d.payment_name ,                         
              
   d.currency_code ,   
    
d.currency_conversion_rate ,                             
                       
   d.allocation_prc ,                             
                       
   d.receipt_flag ,                             
                       
   d.reimbursment_flag,                             
                       
   line_id  ,                             
                       
   d.gst_tax_code ,                             
                       
   IsNUll(d.gst_tax_amt,0) gst_tax_amt,                             
                       
   IsNUll(d.net_amount,0) net_amount,                             
                       
   plv2.level2_description  ,                             
                       
   plv3.level3_description  ,                             
                
   d.approval_flag   ,                             
                       
   d.approval_comment,                             
                       
   d.approved_by,                        
                       
   d.approval_date,                             
                       
   d.nonbill_flag,                             
                       
   convert(binary(8),d.timestamp),                             
                       
   d.units,                             
                       
   d.submitted_date,                             
                       
   d.mail_date,                        
                       
   d.upload_date,                             
                       
   d.upload_flag,                             
                       
   d.parent_id,                             
                       
   d.extra_param_1,                             
                       
   d.extra_param_2,                             
                       
   1,                             
                       
   d.business_reason,                             
                       
   d.finalise_flag,                             
                       
   d.finalised_by,                             
                       
   d.finalised_date,                             
                       
   pte.text1,                             
                       
   pte.text2,                             
                       
   pte.text3,                             
                       
   pte.text4,                   
                       
   pte.text5,                             
                       
   pte.text6,                             
                       
   pte.text7,                             
                       
   pte.text8,          
                       
   pte.text9,                             
                       
   pte.text10,                             
                       
   pte.number11,        
                       
   pte.number12,                             
                       
   pte.number13,                             
                       
   pte.number14,        
                       
   pte.number15,                             
                       
   pte.number16,                             
                       
   pte.number17,                             
              
   pte.number18,                             
                       
   pte.number19,                             
                       
pte.number20,          
                       
   plv3.cost_type,                             
                       
   plv3.trx_approval_flag,                             
                       
   plv2.trx_approval_required_flag,                  
                       
   0,                         
                       
   plv2mc.billing_currency_code,    
                       
   plv2mc.expcost_xrate_type,                      
        
   plv2mc.expcost_xrate_type_name  , 
              
   plv2.date_opened,                             
                       
   plv2.date_closed,                             
                       
   plv3.date_opened,                             
       
   plv3.date_closed,                             
                       
   d.cc_exp_id,                             
                       
   pldcc.comments,                             
                       
   pldcc.ext_reference_no,                             
                       
   d.cc_num ,             
   d.trx_type  ,             
   d.res_usage_code  ,             
   d.task_code  ,             
   d.cc_type_id,             
   d.record_id,  
   d.Is_file_attached ,
   d.is_image_changed,
   d.resource_id 
  FROM pld_transactions d  join  plv_level2 plv2             
    ON  d.level2_key=plv2.level2_key                             
                       
    AND d.company_code=plv2.company_code                             
                       
   LEFT OUTER JOIN plv_level3 plv3                             
                     
    ON d.level3_key=plv3.level3_key  AND d.level2_key=plv3.level2_key   AND d.company_code=plv3.company_code                             
                       
   LEFT OUTER JOIN pld_transactions_exp pte                             
                       
    ON pte.record_id = d.record_id  AND pte.transaction_id=d.transaction_id                             
                       
   LEFT OUTER JOIN plv_level2_mc  plv2mc                             
                       
    ON plv2.company_code=plv2mc.company_code AND plv2.level2_key=plv2mc.level2_key                             
                       
   LEFT OUTER JOIN pld_cc_exp  pldcc                             
                       
    ON d.company_code=pldcc.company_code AND d.cc_exp_id=pldcc.cc_exp_id                             
                     
 WHERE  d.company_code = @company_code                             
                      
  AND d.resource_id = @resource_id                             
                      
  AND d.trx_level in (3)              
  AND (@last_sync_date is null or (isnull(d.create_date,d.modify_date) > @last_sync_date))            
  AND  d.transaction_id = isnull(@transaction_id,  d.transaction_id)            
     AND  d.record_id = isnull(@record_id, d.record_id)            
     AND (@keys is NULL or exists (select * from #transactions t where t.transaction_id = d.transaction_id))            
                     
 ORDER BY d.level2_key,d.level3_key,d.applied_date */                            
     
	
	  
 --alter table #temp add resource_id varchar(16)   
   SELECT * INTO #pld_transactions  FROM pld_transactions d
   WHERE  d.company_code = @company_code                             
    
	--for approvers                  
  --AND d.resource_id = @resource_id                             
                      
   AND d.trx_level in (3)
  AND (@last_sync_date is null or (isnull(d.create_date,d.modify_date) > @last_sync_date))            
  AND  d.transaction_id = isnull(@transaction_id,  d.transaction_id)
     AND  d.record_id = isnull(@record_id, d.record_id)
	 AND (@keys is NULL OR (isnull(@is_from_header, 0) = 0 AND  exists (select * from #transactions t where t.transaction_id = d.transaction_id))
	  OR (isnull(@is_from_header, 0) = 1 AND  exists (select * from #transactions t where t.transaction_id = d.record_id))
	 )
	 
	 --AND (isnull(@is_from_header, 0) = 0 and (@keys is NULL or exists (select * from #transactions t where t.transaction_id = d.transaction_id)) )
	 --AND (isnull(@is_from_header, 0) = 1 and (@keys is NULL or exists (select * from #transactions t where t.transaction_id = d.record_id)) )
	 
	 	 

 insert into #temp                             
     
 SELECT                         
     
   d.level2_key      ,                             
        
   d.level3_key      ,           
                       
   d.transaction_id  ,                             
                       
   d.applied_date ,                             
                   
   d.org_unit        ,                             
                       
   d.location_code   ,                             
                    
   d.comments        ,                             
         
   d.amount          ,                             
                       
   d.amount_home     ,                             
                       
   d.amount_billable ,                             
                       
   d.submitted_flag  ,                             
                       
   d.res_type ,   
                       
   d.payment_code ,                
                       
   d.payment_name ,                         
              
   d.currency_code ,       
                       
   d.currency_conversion_rate ,           
   
   d.allocation_prc ,           
                
  d.receipt_flag ,                             
                       
   d.reimbursment_flag,                             
                       
   line_id  ,                             
                       
   d.gst_tax_code ,                             
                       
   IsNUll(d.gst_tax_amt,0) gst_tax_amt,                             
                       
   IsNUll(d.net_amount,0) net_amount,                             
                       
   plv2.level2_description  ,                             
                       
   plv3.level3_description  ,                             
                
   d.approval_flag   ,                             
                       
   d.approval_comment,                             
                       
   d.approved_by,                        
                       
   d.approval_date,                             
                       
   d.nonbill_flag,                             
                       
   convert(binary(8),d.timestamp),                             
                       
   d.units,                             
                       
   d.submitted_date,                             
                       
   d.mail_date,                        
                       
   d.upload_date,                             
                       
   d.upload_flag,                             
                       
   d.parent_id,                             
                       
   d.extra_param_1,                             
                       
   d.extra_param_2,                             
                       
   1,                             
                       
   d.business_reason,                             
                       
   d.finalise_flag,                             
                       
   d.finalised_by,                             
                       
   d.finalised_date,                             
                       
   pte.text1,                             
                       
   pte.text2,                             
                       
   pte.text3,                             
                       
   pte.text4,                   
                       
   pte.text5,                             
                       
   pte.text6,                             
                       
   pte.text7,                             
                       
   pte.text8,          
                       
   pte.text9,                             
                       
   pte.text10,                             
                       
   pte.number11,        
                       
   pte.number12,        
                       
   pte.number13,          
                       
   pte.number14,        
                       
   pte.number15,   
                       
   pte.number16,                             
                       
   pte.number17,                             
              
   pte.number18,                             
                       
   pte.number19,                             
                       
   pte.number20,                             
                       
   plv3.cost_type,                             
                       
   plv3.trx_approval_flag,                             
                       
   plv2.trx_approval_required_flag,  
                       
   0,                         
          
   plv2mc.billing_currency_code,    
                       
   plv2mc.expcost_xrate_type,                      
                      
   plv2mc.expcost_xrate_type_name  ,                     
                       
plv2.date_opened,                             
           
   plv2.date_closed,                  
            
   plv3.date_opened,                             
       
   plv3.date_closed,                             
                       
   d.cc_exp_id,                             
                       
   pldcc.comments,                             
                       
   pldcc.ext_reference_no,                             
                       
   d.cc_num ,             
   d.trx_type  ,             
   d.res_usage_code  ,             
   d.task_code  ,             
   d.cc_type_id,             
   d.record_id,  
   0,--d.Is_file_attached ,--FS20180828
   d.is_image_changed , 
   d.resource_id
  FROM #pld_transactions d  
  join  plv_level2 plv2             
    ON  d.level2_key=plv2.level2_key                             
                       
    AND d.company_code=plv2.company_code                             
                       
   LEFT OUTER JOIN plv_level3 plv3                             
                     
    ON d.level3_key=plv3.level3_key  AND d.level2_key=plv3.level2_key   AND d.company_code=plv3.company_code                             
                       
   LEFT OUTER JOIN pld_transactions_exp pte                             
                       
    ON pte.record_id = d.record_id  AND pte.transaction_id=d.transaction_id                             
                       
   LEFT OUTER JOIN plv_level2_mc  plv2mc                             
                       
    ON plv2.company_code=plv2mc.company_code AND plv2.level2_key=plv2mc.level2_key                             
                       
   LEFT OUTER JOIN pld_cc_exp  pldcc                             
                       
    ON d.company_code=pldcc.company_code AND d.cc_exp_id=pldcc.cc_exp_id                             
                     
 --WHERE  d.company_code = @company_code                             
    
	----for approvers                  
 -- --AND d.resource_id = @resource_id                             
                      
 -- AND d.trx_level in (3)              
 -- AND (@last_sync_date is null or (isnull(d.create_date,d.modify_date) > @last_sync_date))            
 -- AND  d.transaction_id = isnull(@transaction_id,  d.transaction_id)            
 --    AND  d.record_id = isnull(@record_id, d.record_id)            
 --    AND (@keys is NULL or exists (select * from #transactions t where t.transaction_id = d.transaction_id))            
                     
 ORDER BY d.level2_key,d.level3_key,d.applied_date
                     
            --select transaction_id, @transaction_id, case when  transaction_id = @transaction_id then 1 else 0 end  from #temp            
            --return            

--FS20180828
 update t
 set t.is_file_attached=1
 FROM #temp t INNER JOIN pdd_trx_documents_dtl d ON t.transaction_id=d.transaction_id          
 --FS20180828           
                       
                     
 if @l2_org_unit is not null and @l2_org_unit <> ''     
                     
 update #temp                             
                     
 set is_valid = 0                             
                     
 where level2_key  not in  (select level2_key from plv_level2 where org_unit = @l2_org_unit)                             
                     
                              
                     
 if @l2_location_code is not null and @l2_location_code <> ''                             
                   
 update #temp                             
                     
 set is_valid = 0                             
                     
 where level2_key  not in  (select level2_key  from plv_level2 where location_code = @l2_location_code)                             
                     
                      
  
 if @l3_org_unit is not null and @l3_org_unit <> ''               
             
 update #temp                    
      
 set is_valid = 0            
                     
 where level3_key  not in  (select level3_key  from plv_level3 where level2_key=#temp.level2_key and  org_unit = @l3_org_unit)                  
                     
                             
                     
 if @l3_location_code is not null and @l3_location_code <> ''                             
                     
 update #temp                             
                     
 set is_valid = 0                             
                     
 where level3_key  not in  (select level3_key  from plv_level3 where level2_key=#temp.level2_key and  location_code = @l3_location_code)                             
                     
                              
                     
                              
                     
                              
                     
 update #temp                             
                     
  set approval_flag_l3 = trx_approval_flag, level3_description=pgl3.level3_description                             
                     
 from #temp join plv_level2 pdl2 ON #temp.level2_key=pdl2.level2_key                             
                     
    join plv_generic_level3 pgl3             
     ON pgl3.company_code=pdl2.company_code                             
                     
      AND pgl3.level_category_code = pdl2.level_category_code                             
                     
      AND pgl3.level3_key not in             
       (                   
       select level3_key from plv_level3                              
       where level2_key = #temp.level2_key and level3_status = 1            
       )                             
                     
 WHERE pdl2.level2_key=#temp.level2_key and #temp.approval_flag_l3 is null                             
                     
                              
                     
 update #temp set approval_flag_trx = 1                              
 where approval_flag_l2 in (1,2) and approval_flag_l3 in (1,2)                             
                     
                              
                     
                              
   declare @name_first varchar(32), @name_last varchar(32)
  select @name_first=name_first,@name_last=name_last from plv_resource_all where resource_id=@resource_id
    
                     
                              
                     
                              
                     
 SELECT  level2_key      ,        
   level3_key      ,              
   transaction_id  ,              
   applied_date ,                 
   org_unit        ,              
   location_code   ,              
   comments        ,            
   amount          ,              
   amount_home     ,              
   amount_billable ,           
   submitted_flag  ,                             
   
   t.res_type ,                             
                       
   payment_code ,                             
       
   payment_name ,         
                       
   currency_code ,                             
                       
  currency_conversion_rate ,                             
                       
   allocation_prc ,                  
                       
   receipt_flag ,                             
                       
   reimbursment_flag,                             
                       
   line_id  ,                             
          
   gst_tax_code ,                             
                       
   IsNUll(gst_tax_amt,0) gst_tax_amt,                             
                       
   IsNUll(net_amount,0) net_amount,                         
  
   level2_description  ,                             
                       
   level3_description  ,                   
                       
   approval_flag   ,             
     
   approval_comment,                             
              
   approved_by,                             
                  
   approval_date,                 
                       
   nonbill_flag,    
                       
   timestamp,                             
                       
   units,                             
                       
   submitted_date,                             
                       
   mail_date,                             
                       
   upload_date,                             
                       
   upload_flag,                       
                       
   parent_id,                             
                       
   extra_param_1,                             
                       
   extra_param_2,                             
                       
   is_valid,                             
                       
   business_reason ,                             
                       
   finalise_flag,                             
                       
   finalised_by,                             
                       
   finalised_date,                             
                       
   text1,                             
                       
   text2,                             
                       
   text3,                         
                       
   text4,                             
                       
   text5,                             
                       
   text6,                             
                       
   text7,                             
                       
   text8,                             
                       
   text9 ,                             
                       
   text10,                             
                       
   number11,                             
                       
   number12,                             
                       
   number13,                             
                       
   number14,                             
                       
   number15,                             
                       
   number16,                             
                       
   number17,                             
                       
   number18,                             
                       
   number19,                             
                       
   number20,                             
                       
   cost_type,                             
                       
   approval_flag_trx,   
   approval_flag_l3  ,  
   approval_flag_l2 ,                    
                       
   billing_currency_code,                             
                       
   expcost_xrate_type,          
    
   expcost_xrate_type_name,                             
                       
l2_date_opened,                             
                       
   l2_date_closed,                             
          
   l3_date_opened,             
                       
   l3_date_closed,        
                       
   cc_exp_id,                             
                       
   cc_comments,                             
                       
   cc_ext_reference_no,                             
             
   cc_num, v.rtype_name ,             
    trx_type  ,             
    res_usage_code  ,             
    task_code  ,             
    cc_type_id,         
    isnull(resource_id, @resource_id) resource_id,
	@name_last name_last,
	@name_first name_first ,        
    record_id,  
is_file_attached,
    is_image_changed,
	0 is_approver,
	0 is_finance_approver
  into #data           
 from #temp t                
  left outer join plv_resource_types v  on v.res_type = t.res_type and v.res_category_code='EXP' --sarahm 20150612: Expense Report Errors (ESM - 1934) - Duplicate Res Type Issue        
          
  
 --RS20150810       
 update  #data      
 set applied_date = convert(date , applied_date)     
       
 update  #data      
 set applied_date = dateadd(hour, 12,applied_date)         
       
 --RS20150810  
 ----------------------------------------------------------------------------

 declare @supervisor varchar(32)
 select @supervisor=reports_to from pdd_resources where resource_id=@resource_id 
 
 declare @supervisor_name varchar(256)

set @supervisor_name=(select isnull(name_last , '') + ', ' + isnull(name_first , '')  from pdd_resources where resource_id=@supervisor)
 
                     
  
DECLARE @override_path varchar(255),   
		@yes_path varchar(255),
		@default_code varchar(255)

SELECT @override_path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'   
SELECT @yes_path = 'CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'                              
   
SELECT @default_code=default_code   
FROM pdm_rule_group   
WHERE path=@override_path   
and user_group_code is NULL   
                      
    alter table #data add approvers nvarchar(max)
Create table #Approvers   
(  
level2_key varchar(32),
level3_key varchar(64),
approval_flag_l2 int,
approval_flag_l3 int,
resource_id varchar(16),
transaction_id varchar(32),    
--name_last varchar(32),   
--name_first varchar(32)
 approver_name varchar(128)  
)   

IF (@default_code = @yes_path)	
begin
	insert into #Approvers (resource_id)
	SELECT pa.resource_id
	FROM pdd_exprpt_approvers pa
	WHERE pa.company_code=@company_code         
		--select * from #Approvers                    
end 
else
begin

	insert into #Approvers(level2_key,level3_key,approval_flag_l2 ,approval_flag_l3 ,resource_id ,transaction_id)
	select distinct l2.level2_key,l2.level3_key,approval_flag_l2,approval_flag_l3 ,r.resource_id,l2.transaction_id 
	from #data l2 inner join pdd_level2_resource r on l2.level2_key =r.level2_key
	where  approval_flag_l2 in (1,2)
	and approval_flag_l3 in (1)
	and position_category_code=1
	and r.resource_id!=@resource_id

	insert into #Approvers(level2_key,level3_key,approval_flag_l2 ,approval_flag_l3 ,resource_id ,transaction_id)
	select distinct l2.level2_key,l2.level3_key,approval_flag_l2,approval_flag_l3 ,@supervisor,l2.transaction_id 
	from #data l2 
	where  approval_flag_l2 in (1,2)
	and approval_flag_l3 in (2)
	--update #Approvers
	--set resource_id=@supervisor
	--where approval_flag_l2 in (1,2)
	--and approval_flag_l3 in (2)
 end
 
/****************************************/
--FS20190516 dataFilters for mobile App notification Ref: Mobile Support Tickets Assign To DB team
DECLARE @user_group_code varchar(32),                                                                                              
   @permission_status int

if isnull(@user_group_code, '') = ''  
begin  
	select @user_group_code = user_group_code from pdm_group_user_link where company_code = @company_code and resource_id = @resource_id and preferred_group_flag = 1  
   
	if ISNULL(@user_group_code, '') = ''  
		select top 1 @user_group_code = user_group_code from pdm_group_user_link where company_code = @company_code and resource_id = @resource_id  
end 


ALTER TABLE #Approvers ADD org_unit_res varchar(32),location_code_res varchar(32),parent_org_unit_res varchar(32),
org_unit_level2 varchar(32),location_code_level2 varchar(32), org_unit_level3 varchar(32), location_code_level3 varchar(32),
parent_org_unit_level2 VARCHAR(16),parent_org_unit_level3 VARCHAR(16)

UPDATE a
SET org_unit_level2=ISNULL(l2.org_unit,'')
,location_code_level2=ISNULL(l2.location_code,'')
,org_unit_level3=ISNULL(l3.org_unit,'')
,location_code_level3=ISNULL(l3.location_code,'')
FROM #Approvers a INNER JOIN pdd_level2 l2 ON l2.level2_key=a.level2_key 
inner join pdd_level3 l3 on  a.level2_key=l3.level2_key and a.level3_key=l3.level3_key

UPDATE a
SET org_unit_res=r.org_unit
,location_code_res=r.location_code
FROM #Approvers a INNER JOIN pdd_resources r 
ON a.resource_id = r.resource_id

UPDATE a
SET parent_org_unit_res= ISNULL(parent_unit,'')
FROM #Approvers a INNER JOIN pdm_org_units u
ON org_unit_res = org_unit

UPDATE a
SET parent_org_unit_level2= ISNULL(parent_unit,'')
FROM #Approvers a INNER JOIN pdm_org_units u
ON org_unit_level2 = org_unit 

UPDATE a
SET parent_org_unit_level3= ISNULL(parent_unit,'')
FROM #Approvers a INNER JOIN pdm_org_units u
ON org_unit_level3 = org_unit




SELECT @permission_status = permission_status                                      
    FROM   pdm_rule_group                                                                       
    WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level2/OrgUnit'                                                                      
           AND @user_group_code = user_group_code                                                                                                                                                                                 
                                               
    IF @permission_status = 2                                                                  
       BEGIN                                                                       
			DELETE FROM #Approvers WHERE   org_unit_res <> org_unit_level2 AND ((ISNULL(parent_org_unit_res,'')='' AND ISNULL(parent_org_unit_level2,'')='') OR parent_org_unit_res<>parent_org_unit_level2 )
       END                                      
                                                                                   
                         
     
    SELECT @permission_status = permission_status                                  
    FROM   pdm_rule_group                                                          
    WHERE  path =                                      
    'Rules/TimeandExpense/Approvals/DataFilter/Level2/LocationCode'                                          
           AND @user_group_code = user_group_code                                          
                                   
   IF @permission_status = 2                                         
     BEGIN                                                        
       DELETE FROM #Approvers WHERE   location_code_res <> location_code_level2
     END                                                           
                                                                         
                                                  
                                                                                                                                                                            
    SELECT @permission_status = permission_status                                                                                                           
    FROM pdm_rule_group                                                                                                                          
	WHERE  path = 'Rules/TimeandExpense/Approvals/DataFilter/Level3/OrgUnit'                                                                                                       
           AND @user_group_code = user_group_code                                                                                  
                                                                                                                                                        
 IF @permission_status = 2                                                                                               
      BEGIN                                                                                                                            
         DELETE FROM #Approvers WHERE   org_unit_res <> org_unit_level3 AND ((ISNULL(parent_org_unit_res,'')='' AND ISNULL(parent_org_unit_level3,'')='') OR parent_org_unit_res<>parent_org_unit_level3 )
      END                                                          
                  
    SELECT @permission_status = permission_status                    
    FROM  pdm_rule_group                                               
    WHERE  path =                                        
    'Rules/TimeandExpense/Approvals/DataFilter/Level3/LocationCode'                     
           AND @user_group_code = user_group_code   
         
    IF @permission_status = 2        
       BEGIN        
           DELETE FROM #Approvers WHERE   location_code_res <> location_code_level3                       
      END 
	  
 
/******************************************/

update   a
set approver_name= isnull(pr.name_last , '') + ', ' + isnull(pr.name_first , '') 
from #Approvers a inner join pdd_resources pr on pr.resource_id=a.resource_id
                               

IF (@default_code = @yes_path)	
begin
update #data
set  approvers=(select  distinct
				STUFF((Select distinct ';'+approver_name 
				from #Approvers T1 
				FOR XML PATH('')),1,1,'') resources  
				from #Approvers t2)
where submitted_date is null

update t
set  approvers=isnull(r.name_last , '') + ', ' + isnull(r.name_first , '') 
from #data t inner join pld_transactions ts on ts.transaction_id=t.transaction_id inner join pld_transactions_hdr h on ts.record_id=h.record_id
inner join pdd_resources r on r.resource_id =h.approver_id
where (ts.submitted_flag=1 OR (ts.submitted_flag=0 AND ts.approval_flag = 2))

                      
end 
else 
begin                      
update t
set  approvers=a.resources
from #data t inner join 
(select distinct  level2_key,level3_key,
STUFF((Select distinct '; '+approver_name 
from #Approvers T1 
where t1.level2_key=t2.level2_key and t1.level3_key=t2.level3_key        
FOR XML PATH('')),1,2,'') resources  
from #Approvers t2
group by  level2_key,level3_key
)a
on t.level2_key=a.level2_key and t.level3_key=a.level3_key
end     


/*
update #data
set approvers= @supervisor_name
where isnull(approvers,'')=''
--and isnull(approval_flag_l3,0)!=0 
and isnull(approval_flag_l3,0)=1 and exists(select 1 from pdd_level2_resource where level2_key=#data.level2_key and position_category_code=1)
*/



 ----------------------------------------------------------------------------
 --FS20180221

 ALTER TABLE #data ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint,approver_id varchar(32)
 
 UPDATE d 
 SET approver_id=l2.approver_id
 from #data d 
 inner join pld_transactions_hdr l2 
 on d.record_id=l2.record_id 

 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #data d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=ISNULL(l3.trx_approval_flag,0)
 from #data d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 --FS20180611 Expense Approval Change
 UPDATE d
 SET trx_approval_flag=2
 from #data d
 WHERE 0 = (select Count(*) FROm pdd_level2_resource l2  where  d.level2_key=l2.level2_key  AND l2.position_category_code=1 
			AND l2.resource_id != d.resource_id AND l2.active_flag=1)
 --AND d.resource_id=@login_id
 AND d.trx_approval_flag=1
 
 --FS20180611 Expense Approval Change

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #data d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 --Update d
 --set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 --from #data d 
 --left join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key and l3.position_category_code=5
 --and l3.resource_id=@resource_id

 
 
 Update d
 set is_approver=CASE WHEN d.approver_id=@login_id THEN 1 ELSE CASE WHEN ISNULL(d.approver_id,'')!=''  THEN 0  ELSE
						CASE ISNULL(trx_approval_flag ,0)
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 AND d.resource_id!= @login_id THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.reports_to=@login_id THEN 1 ELSE 0 END END
						END
						END
						END
 from #data d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@login_id
 and l2.active_flag=1
  
 
 
  --FS20180820 Expense Approval Change
 UPDATE d
 SET is_approver=0
 from #data d
 WHERE not exists  (select * FROm pdd_level2_resource l2  where  d.level2_key=l2.level2_key  AND l2.position_category_code=1 
			 AND l2.active_flag=1)
 --AND d.resource_id=@login_id
 AND d.approval_flag_l3=1
 
 --FS20180820 Expense Approval Change
                 
 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------  
              
 if @subscriber_id is null               
  begin                
 select distinct *, e.timestamp as exp_timestamp from #data d        --FS20180220        
 LEFT join pld_transactions_exp e on d.transaction_id = e.transaction_id and d.record_id = e.record_id   /*changed inner join to left FS20180829*/     
  end                
 else                
  begin                
  select distinct top 100 * from #data order by  customer_code + customer_name +level2_key     --FS20180220               
delete top (100) #data                
  where customer_code + customer_name +level2_key in                
  (select top 100  customer_code + customer_name +level2_key from #data order by  customer_code + customer_name +level2_key)                
                 
                 
  declare @entity_id int                   
  select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'Transaction'                  
            
  insert into plv_event_notification                  
  (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                
  select    convert(varchar, @company_code) + '~-~' + [transaction_id]  ,    d.company_code, 2, @entity_id, subscriber_id,  d.resource_id, GETDATE()                  
  from #data  d inner join pDd_apps_subscriber_info i on i.resource_id = d.resource_id and  subscriber_id = @subscriber_id                    
  where      is_active = 1                 
               
  end                 
            
 End

go


