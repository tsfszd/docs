/****** Object:  StoredProcedure [dbo].[Plsw_Apps_Transaction_Get]    Script Date: 02/04/2015 12:12:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Plsw_Apps_Transaction_Get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Plsw_Apps_Transaction_Get]
GO

/****** Object:  StoredProcedure [dbo].[Plsw_Apps_Transaction_Get]    Script Date: 02/04/2015 12:12:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Plsw_Apps_Transaction_Get]                                    
                              
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
*         Name: Pdrw_Apps_Transaction_Get                                 *                                                                                                       
*       Module:                                                       *                                                                                                       
* Date created: Nov 20 2014                                           *                                                                                                       
*   By: Sohail Nazir                                          *                                                                                                       
*      Comment:                                                       *         
* Date revised: Decmber 4 2014                                        *                                                                                                       
*           By: Arif Hasan                    *          
*      Comment: Optimization           * 
*                         *                           
*            *                                       
<keysd>                         
 <key>                                        
  <transaction_id>21042015</transaction_id>                                     
                                          
 </key>                                        
 <key>                                         
  <transaction_id>002</transaction_id>                                        
 </key>                                   
</keys>'                                                                        
********************************************************************* */                                          
                                                    
@company_code int,                                                            
@resource_id char(16),                                                                          
@start_date datetime = NULL,                                                                          
@end_date datetime = null,                                        
@transaction_id varchar(32) = null,                                               
@last_sync_date datetime = null,     --20141222   @last_sync_date parameter is added                                             
@subscriber_id int = null,                                         
@keys xml = null,
@notification_id int=null                                        
WITH RECOMPILE                                                  
AS                                                                          
                                                                          
BEGIN                                                                        
                        
  set @start_date = DATEADD(week,  -10, GETDATE())                        
  
  if ISNULL(@notification_id,0)<>0
  BEGIN
	SET @keys=(SELECT transaction_id FROM pdd_apps_notification WHERE batch_id=@notification_id AND ISNULL(record_id,'')=''
	FOR XML RAW ('key'), ROOT ('keys'), ELEMENTS)
  END
            
 	              
  SELECT                                        
          T.c.value('./transaction_id[1]', 'varchar(64)') transaction_id                                      
             into #transaction                                               
                       FROM     @keys.nodes('/keys/key') T ( c )                                           
                                                                       
  CREATE TABLE #transaction_get (                                                                                  
         company_code int                                                                               
         ,level2_key char(32)                                                                                  
         ,level3_key varchar(64)                                                                                 
         ,line_id        varchar(16)                                                             
         ,transaction_id char(16)                                                                                  
         ,applied_date datetime                                                                                  
         ,org_unit char(16) 
		 ,org_unit_name char(16)                                                                                 
         ,location_code char(16) 
		 ,location_name varchar(16)                                                                                  
         ,resource_id char(16)           
      ,task_code char(16)                                                                                  
         ,res_usage_code char(16)                                                 
   ,comments varchar(3000)                        
         ,units float                        
        ,nonbill_flag tinyint                    
         ,submitted_flag tinyint                            
         ,submitted_date datetime                                                                               
     ,trx_type int                                      
         ,level2_description varchar(128)                                                                                  
    ,level3_description varchar(64)                 
         ,timestamp    binary(8)                                                                                  
         ,upload_date datetime                                                                            
         ,upload_flag tinyint                         
         ,approval_flag int                                 
          ,approval_comment varchar(255)                                                                        
         ,approved_by varchar(33)                                   
         ,approval_date datetime                                                                                  
         ,mail_date datetime                                                                    
         ,extra_param_1 varchar(255)                                                                 
         ,extra_param_2 varchar(255)                                                                                  
         ,customer_code varchar(16)                                                                                  
         ,customer_name varchar(64)                                                                       
    ,is_valid int                                                                        
         ,task_description varchar(64)                                                             
         ,resource_schedule_exist int                                                                        
         ,validate_resource tinyint                                                                        
         ,outlook_entry_id varchar(255)                                    
         ,res_usage_description varchar(64)                                                                      
         ,create_date datetime                                                                      
         ,modify_date datetime                       
         ,name_last varchar (32) null                      
         ,name_first varchar (32)    null 
         ,l2_billable_flag int    
		 ,l3_billable_flag int    
		 ,comments_required int                                                               
)                                                                          
            print '2'                                                                   
   INSERT INTO #transaction_get                       
   (company_code                                                                                
         ,level2_key                                                                                
         ,level3_key                                                                                 
         ,line_id                                                                     
         ,transaction_id                                                                                  
         ,applied_date                                                                  
         ,org_unit
		 ,org_unit_name                                                                                 
         ,location_code 
		 ,location_name         
         ,resource_id  
      ,task_code           
         ,res_usage_code                                                                                
       ,comments    
         ,units                            
         ,nonbill_flag     
         ,submitted_flag      
         ,submitted_date               
   ,trx_type                
         ,level2_description                                          
         ,level3_description                                                                                
,timestamp                                                                                
         ,upload_date                                                                                   
         ,upload_flag                                                             
         ,approval_flag                                  
          ,approval_comment                                                                                
         ,approved_by                                          
         ,approval_date                                                                                   
         ,mail_date                                       
         ,extra_param_1                                                                 
         ,extra_param_2                                                                                       
         ,customer_code                                                                                 
         ,customer_name                                                                      
    ,is_valid                                                                
         ,task_description                                                           
         ,resource_schedule_exist                                                                         
         ,validate_resource                                                          
         ,outlook_entry_id                                   
         ,res_usage_description                                                                      
         ,create_date                                                                   
         ,modify_date 
         ,l2_billable_flag     
		 ,l3_billable_flag     
		 ,comments_required                       
                         
   )                                                                  
   EXEC plsW_timetransactions_get2                                                                       
  @company_code = @company_code,                                            
        @resource_id = @resource_id,                                                                        
        @startdate = @start_date,                                                                        
        @enddate = @end_date,                                                                        
        @l2_org_unit = '',                                                                        
        @l2_location_code = '',                                                                        
        @l3_org_unit = '',                                                                        
        @l3_location_code = ''                                                                          
          
   -----RS20170224*****bug fixes reported by EMAN****----                      
                
                    print '3'  
					
					
SELECT resource_id INTO #resources FROM pdd_resources where (termination_date is null or  termination_date >  dateadd(year, -1, getdate()))
--select * from #resources
        
INSERT INTO #transaction_get               
   (company_code                                                                                
         ,level2_key                                   
         ,level3_key                                
    ,line_id                                                      
     ,transaction_id     
         ,applied_date                                                            
         ,org_unit                       
         ,location_code                 
      ,resource_id                    
,task_code                      
  ,res_usage_code                                                            
       ,comments                           
         ,units                  
         ,nonbill_flag                           
         ,submitted_flag                                                                                   
         ,submitted_date                                                                             
         ,trx_type                                                                                   
         ,level2_description                                                           
         ,level3_description                                                                                
         ,timestamp                                                                                
         ,upload_date                                                                                   
         ,upload_flag                                                                                   
         ,approval_flag                                             
         ,approval_comment                                                                                
    ,approved_by                                                                                 
         ,approval_date                                                                                   
         ,mail_date                                                                                   
         ,extra_param_1                                                            
         ,extra_param_2                                                                                  
         ,customer_code                                                                                 
         ,customer_name                          
    ,is_valid                                                                                                                                                        
         ,validate_resource                                                                         
         ,outlook_entry_id                                                                              
         ,create_date                                                                   
         ,modify_date
		,l2_billable_flag     
		,l3_billable_flag     
		,comments_required                        
   )                        
                        
  SELECT                              
plt.company_code,plt.level2_key,plt.level3_key,plt.line_id,plt.transaction_id,plt.applied_date,plt.org_unit,                              
plt.location_code,plt.resource_id,plt.task_code,plt.res_usage_code,plt.comments,plt.units,plt.nonbill_flag,                              
plt.submitted_flag,plt.submitted_date,plt.trx_type,plv2.level2_description,plv3.level3_description,         
CONVERT(BINARY(8),plt.timestamp),plt.upload_date,plt.upload_flag,plt.approval_flag,plt.approval_comment,plt.approved_by,                              
plt.approval_date,plt.mail_date,plt.extra_param_1,plt.extra_param_2,pl2c.customer_code,pl2c.customer_name,1,                            
plv2.validate_resource,plt.outlook_entry_id               
,plt.create_date, plt.modify_date
,plv2.billable_flag
,plv3.billable_flag     
,plv2.comments_for_time_required_flag            
FROM pld_transactions plt                              
LEFT OUTER JOIN plv_level2_customer pl2c                              
ON plt.company_code=pl2c.company_code                           
AND plt.level2_key = pl2c.level2_key                              
JOIN plv_level2 plv2                     
ON  plt.level2_key=plv2.level2_key      
AND plt.company_code=plv2.company_code 
LEFT OUTER JOIN plv_level3 plv3                 
ON plt.level3_key=plv3.level3_key                              
AND plt.level2_key=plv3.level2_key                     
AND plt.company_code=plv3.company_code                              
WHERE                     
plt.company_code = @company_code AND    
plt.resource_id in(select resource_id from plv_resource_all where reports_to=@resource_id) AND                            
plt.trx_level = 0 AND                              
plt.units <> 0 AND                            
plt.applied_date BETWEEN IsNuLL(@start_date, '01/01/1917') AND IsNuLL(@end_Date, '01/01/2037')                              
and DATALENGTH(rtrim(line_id))<4 -- temporarily!!                      
and plv3.trx_approval_flag=2                           
and  plt.transaction_id not in (select distinct transaction_id from #transaction_get)  
AND plt.resource_id IN (select distinct resource_id from #resources)                        
AND ISNULL(plt.upload_flag,0)=0
ORDER BY plt.level2_key, plt.level3_key, plt.applied_date                              
--   ORDER BY CONVERT(int, line_id), applied_date                           

-----FS20180612
select plt.transaction_id,plt.company_code,plt.level2_key,plt.level3_key,plt.line_id,plt.applied_date,plt.org_unit,                              
plt.location_code,plt.resource_id,plt.task_code,plt.res_usage_code,plt.comments,plt.units,plt.nonbill_flag,                              
plt.submitted_flag,plt.submitted_date,plt.trx_type,     
CONVERT(BINARY(8),plt.timestamp) timestamp,plt.upload_date,plt.upload_flag,plt.approval_flag,plt.approval_comment,plt.approved_by,                              
plt.approval_date,plt.mail_date,plt.extra_param_1,plt.extra_param_2,plt.outlook_entry_id                          
,plt.create_date, plt.modify_date ,plt.trx_level 
into #pld from PLd_transactions plt 
where trx_type between 1001 and 2000 
--and  trx_level=0 and  units <> 0 
and company_code=@company_code
--and DATALENGTH(rtrim(line_id))<4 
     -- and   p.transaction_id not in (select distinct transaction_id from #transaction_get)
	           
  select * into #plv_level3 from plv_level3 where trx_approval_flag=1

INSERT INTO #transaction_get                       
   (company_code                                                                                
         ,level2_key                                                                                
         ,level3_key                                                                      
         ,line_id                                                                     
         ,transaction_id                                                                                  
         ,applied_date                                                                                   
         ,org_unit                                                                                 
         ,location_code                                                                                
         ,resource_id                                                                                  
      ,task_code                                                                                  
         ,res_usage_code                                                                                
       ,comments                                                                              
         ,units                                                                                   
         ,nonbill_flag                                                                                   
         ,submitted_flag                                                                                   
         ,submitted_date                                 
         ,trx_type        
         ,level2_description                                                  
         ,level3_description                                
         ,timestamp                      
         ,upload_date                             
         ,upload_flag         
         ,approval_flag                                             
         ,approval_comment                    
         ,approved_by               
         ,approval_date            
         ,mail_date                   
         ,extra_param_1                                                                 
         ,extra_param_2                    
     ,customer_code     
         ,customer_name                                                                    
    ,is_valid          
         ,validate_resource   
         ,outlook_entry_id                          
         ,create_date                                                
      ,modify_date
         ,l2_billable_flag     
		,l3_billable_flag     
		,comments_required                        
   )                        
                        
SELECT                              
plt.company_code,plt.level2_key,plt.level3_key,plt.line_id,plt.transaction_id,plt.applied_date,plt.org_unit,                              
plt.location_code,plt.resource_id,plt.task_code,plt.res_usage_code,plt.comments,plt.units,plt.nonbill_flag,                              
plt.submitted_flag,plt.submitted_date,plt.trx_type,plv2.level2_description,plv3.level3_description,                            
                              
CONVERT(BINARY(8),plt.timestamp),plt.upload_date,plt.upload_flag,plt.approval_flag,plt.approval_comment,plt.approved_by,                              
plt.approval_date,plt.mail_date,plt.extra_param_1,plt.extra_param_2,pl2c.customer_code,pl2c.customer_name,1,                            
plv2.validate_resource,plt.outlook_entry_id                        
-- HAMZA -- 20142312 -- added below two columns for the app.                          
,plt.create_date, plt.modify_date
,plv2.billable_flag
,plv3.billable_flag     
,plv2.comments_for_time_required_flag                                
FROM #pld plt                              
                           
JOIN plv_level2 plv2                               
ON  plt.level2_key=plv2.level2_key                              
AND plt.company_code=plv2.company_code                              

LEFT OUTER JOIN plv_level2_customer pl2c                              
ON plt.company_code=pl2c.company_code                              
AND plt.level2_key = pl2c.level2_key 

LEFT OUTER JOIN #plv_level3 plv3                              
ON plt.level3_key=plv3.level3_key                              
AND plt.level2_key=plv3.level2_key                              
AND plt.company_code=plv3.company_code                              
WHERE                              
plt.company_code = @company_code AND                                
plt.trx_level = 0 AND                              
plt.units <> 0  
and plv3.trx_approval_flag=1                        
and 
DATALENGTH(rtrim(line_id))<4 -- temporarily!!                           
and  plt.transaction_id not in (select distinct transaction_id from #transaction_get)                    
and exists(select level2_key from plv_level2_resource r where r.level2_key=plt.level2_key --and r.level3_key=plt.level3_key                      
           and r.resource_id=@resource_id and r.position_category_code=1)                      
AND ISNULL(plt.upload_flag,0)=0
--and not exists (select distinct transaction_id from #transaction_get g where g.transaction_id=plt.transaction_id)                       

ORDER BY plt.level2_key, plt.level3_key, plt.applied_date                              
--   ORDER BY CONVERT(int, line_id), applied_date                                 
                      
      
	/*  
	  plt.company_code = @company_code AND                              
plt.resource_id in(select resource_id from plv_resource where reports_to=@resource_id) AND                            
plt.trx_level = 0 AND                              
plt.units <> 0 AND                            
plt.applied_date BETWEEN IsNuLL(@start_date, '01/01/1917') AND IsNuLL(@end_Date, '01/01/2037')                           
and DATALENGTH(rtrim(line_id))<4 -- temporarily!!                      
and plv3.trx_approval_flag=2                           
and  plt.transaction_id not in (select distinct transaction_id from #transaction_get)  
AND plt.resource_id IN (select distinct resource_id from #resources)                        
ORDER BY plt.level2_key, plt.level3_key, plt.applied_date   */               
                       
INSERT INTO #transaction_get                       
   (company_code                                                                                
         ,level2_key                                                                                
         ,level3_key                                                                      
         ,line_id                                                                     
         ,transaction_id                                                                                  
         ,applied_date          
         ,org_unit                                                                                 
         ,location_code                                                              
  ,resource_id                                                             
      ,task_code      
         ,res_usage_code    
       ,comments                                                                              
         ,units                                                                                   
         ,nonbill_flag                                                                                   
         ,submitted_flag                                                                                   
         ,submitted_date                                 
         ,trx_type                                                                                   
         ,level2_description                                                  
         ,level3_description                                
         ,timestamp                      
         ,upload_date                                                                                   
         ,upload_flag                                                                                   
         ,approval_flag                                             
         ,approval_comment                                                                
         ,approved_by               
         ,approval_date            
         ,mail_date                   
         ,extra_param_1                                                                 
         ,extra_param_2                    
         ,customer_code     
         ,customer_name                                                                      
    ,is_valid          
         ,validate_resource                                                                         
         ,outlook_entry_id                                   
         ,create_date                                                                   
         ,modify_date
         ,l2_billable_flag     
		,l3_billable_flag     
		,comments_required                        
   )                        
                         
SELECT                              
plt.company_code,plt.level2_key,plt.level3_key,plt.line_id,plt.transaction_id,plt.applied_date,plt.org_unit,                              
plt.location_code,plt.resource_id,plt.task_code,plt.res_usage_code,plt.comments,plt.units,plt.nonbill_flag,                              
plt.submitted_flag,plt.submitted_date,plt.trx_type,plv2.level2_description,plv3.level3_description,                            
                              
CONVERT(BINARY(8),plt.timestamp),plt.upload_date,plt.upload_flag,plt.approval_flag,plt.approval_comment,plt.approved_by,                              
plt.approval_date,plt.mail_date,plt.extra_param_1,plt.extra_param_2,pl2c.customer_code,pl2c.customer_name,1,                            
plv2.validate_resource,plt.outlook_entry_id                        
-- HAMZA -- 20142312 -- added below two columns for the app.                          
,plt.create_date, plt.modify_date
,plv2.billable_flag
,plv3.billable_flag     
,plv2.comments_for_time_required_flag                                
FROM pld_transactions plt                              
LEFT OUTER JOIN plv_level2_customer pl2c                              
ON plt.company_code=pl2c.company_code                              
AND plt.level2_key = pl2c.level2_key                            
JOIN plv_level2 plv2                               
ON  plt.level2_key=plv2.level2_key                              
AND plt.company_code=plv2.company_code                              
LEFT OUTER JOIN plv_level3 plv3                              
ON plt.level3_key=plv3.level3_key                              
AND plt.level2_key=plv3.level2_key                           
AND plt.company_code=plv3.company_code                              
WHERE     
plt.company_code = @company_code  
 
and DATALENGTH(rtrim(line_id))<4 -- temporarily!!                           
                     
 and  plt.transaction_id  in (select distinct transaction_id from #transaction)                       
 and  plt.transaction_id not in (select distinct transaction_id from #transaction_get)                       
ORDER BY plt.level2_key, plt.level3_key, plt.applied_date                              
--   ORDER BY CONVERT(int, line_id), applied_date                                 
                      

                      
                         
   update #transaction_get                            
set task_description = v.task_description   
from plv_task v                            
where #transaction_get.task_code = v.task_code                            
                    
update #transaction_get                            
SET res_usage_description=plru.res_usage_description                            
FROM #transaction_get tmp          
JOIN plv_res_usage plru                     
ON tmp.res_usage_code=plru.res_usage_code                      
                            
---------------------------                             
update #transaction_get                            
set resource_schedule_exist = 0                            
                            
update #transaction_get                         
set resource_schedule_exist = 1                             
from plv_level3_schedule pls                            
where #transaction_get.level2_key = pls.level2_key                            
--and #temp.level3_key =  pls.level3_key                            
and #transaction_get.resource_id = pls.resource_id                            
and #transaction_get.applied_date between  pls.effective_date and isnull(pls.expiration_date,'12/31/2049')                            
and #transaction_get.validate_resource in (2,3)                            
                            
update #transaction_get                            
set resource_schedule_exist = 1                             
where #transaction_get.validate_resource not in (2,3)                          
                         
                         
   -----RS20170224*****bug fixes reported by EMAN****----                      
                     
                         
   update #transaction_get                                             
    set approval_flag = 1                            
    where upload_flag = 1 and isnull(approval_flag, 0) = 0                                              
                                    
    update #transaction_get                                   
    set applied_date = convert(date , applied_date)                                
                  
    update #transaction_get                           
    set applied_date = dateadd(hour, 12, applied_date)                                
 ---update resource name                      
                       
   update t                      
   set name_last  = v.name_last,                      
       name_first = v.name_first                        
   from   #transaction_get t inner join plv_resource_all v on t.resource_id=v.resource_id                                         
   
--    IF ( (SELECT Count(*)                                                                                                                                                     
--          FROM   pdd_approval_chain_header                                                                                                                    
--          WHERE  company_code = @COMPANY_CODE                                                                    
--        AND approval_module_path =                                                             
--                     'CompanyRules/Multi-LevelApproval/Level2')                                                                    
--        > 0 )                                           
--      BEGIN                                                                                                                                                                        
--          DELETE FROM #transaction_get                                                                                                                                
--          WHERE  level2_key IN (SELECT DISTINCT level2_key                        
--                FROM   pdd_level2                                                            
--WHERE  ( approved_flag IS NULL  OR approved_flag = 0 ))                                                                                                       
--      END          
   
    
	                                                      
   SELECT                              
  trx.transaction_id,                                                                          
  trx.level2_key,                  
  trx.level3_key,                                                                        
  convert(datetime , trx.applied_date) applied_date,                                                                  
  trx.trx_type,                                                                
  trx.resource_id,                                                                       
  trx.task_code,           
  trx.res_usage_code,                                                               
  trx.units,                                                                          
  trx.location_code,                                                                      
  trx.org_unit,                                                                      
  --trx.task_code,                                                                      
  trx.comments,                  
  trx.nonbill_flag,                             
trx.submitted_flag,                                                           
  trx.submitted_date,                    
  trx.approval_flag   as approval_flag,                                                                  
  --case trx.approval_flag when 4 then 1 else trx.approval_flag end as approval_flag,    
  trx.approval_comment as approval_comments,                                               
 pld.Line_Id,                                               
  pld.Res_type,                                               
  pld.Payment_code,                                               
  pld.Payment_name,                                               
  pld.Currency_code,     
  pld.Currency_conversion_rate,                   
  pld.Amount,                                              
  trx.timestamp  ,     
  trx.name_first,                  
  trx.name_last ,            
  trx.upload_flag
,l2_billable_flag     
,l3_billable_flag     
,comments_required,
0 is_approver,
0 is_finance_approver                                          
  into #data                                                    
   FROM #transaction_get trx                                                                          
 inner join pld_transactions pld on pld.transaction_id=trx.transaction_id   and   pld.company_code = @company_code                                              
   WHERE                                         
   (@last_sync_date is null OR                                                     
   (@last_sync_date < ISNULL(DATEADD(mi, 10, trx.modify_date), DATEADD(mi, 10,trx.create_date)) AND isnull(trx.outlook_entry_id,'')=''))                        
 AND trx.transaction_id = ISNULL(@transaction_id, trx.transaction_id)                        
 and (@keys is null or exists (select * from #transaction t where t.transaction_id = trx.transaction_id))         

END                                             
  ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
 --FS20180221
 
 ALTER TABLE #data ADD trx_approval_flag tinyint,reports_to varchar(16),trx_approval_required_flag tinyint
 
 UPDATE d 
 SET trx_approval_required_flag=l2.trx_approval_required_flag
 from #data d 
 inner join pdd_level2 l2 on d.level2_key=l2.level2_key

 UPDATE d 
 SET trx_approval_flag=l3.trx_approval_flag
 from #data d 
 inner join pdd_level3 l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key

 UPDATE d 
 SET d.reports_to=res.reports_to
 from #data d 
 inner join pdd_resources res on d.resource_id=res.resource_id

 Update d
 set is_finance_approver=CASE WHEN l3.position_category_code=5 THEN 1 ELSE 0 END
 from #data d 
 inner join pdd_level3_resource l3 on d.level2_key=l3.level2_key and d.level3_key=l3.level3_key
 where l3.resource_id=@resource_id

 Update d
 set is_approver=CASE isnull(trx_approval_flag,0)
						WHEN 0 then 0  
						WHEN 1 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN l2.position_category_code=1 THEN 1 ELSE 0 END END
						WHEN 2 THEN CASE WHEN d.trx_approval_required_flag=0 THEN 0 ELSE CASE WHEN d.reports_to=@resource_id THEN 1 ELSE 0 END END
						END
 from #data d 
 left join pdd_level2_resource l2  on d.level2_key=l2.level2_key  AND l2.position_category_code=1
 and l2.resource_id=@resource_id
 and l2.active_flag=1



    
                 
 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------                                                        
                                            
 if @subscriber_id is null                                            
  begin                                            
  select * from #data --where transaction_id='8d48bb7cb5b70733'--where level2_key='AARP001-17-020'   and level3_key='004'     
  end                                            
 else               
  begin           
   select top 20 *, is_approver, is_finance_approver from #data order by  transaction_id                                           
   delete top (20) #data                                     
   where transaction_id  in                                            
   (select top 20  transaction_id from #data order by  transaction_id)                                           
                                                 
                                                 
   declare @entity_id int                                               
   select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'Transaction'                                              
if exists (select * from #data  )                               
    begin                  
     insert into plv_event_notification                       
     (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                                            
     select    convert(varchar, @company_code) + '~-~' + transaction_id  ,   @company_code, 2, @entity_id, subscriber_id,  d.resource_id, GETDATE()                                              
     from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id  and  subscriber_id = @subscriber_id                     
     where    is_active = 1             
    end                                            
    end   

   


go
