/****** Object:  StoredProcedure [dbo].[Pdsw_apps_level2_get]    Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pdsw_apps_level2_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Pdsw_apps_level2_get]
GO

/****** Object:  StoredProcedure [dbo].[Pdsw_apps_level2_get]    Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE  PROCEDURE [dbo].[Pdsw_apps_level2_get]                                        
                                                                                                                                                                             
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
*             *                 
* ******************************************************************* *          
*        *                *  Name: Pdsw_apps_level2_get      *                                    
* Module:   *                                     * Date created: Nov 20 2014      *                                                                        
*           By: Sohail Nazir *                                                                
*      Comment:                          *                                                                                               
* Date revised: Decmber 4 2014                  *                                                                                                     
*         By: Arif Hasan   *                                                                                                        
*  Comment: Optimization                                        *                                                                                                                 
*                                                *                                                                                                                         
*                                            *                                                                   
                                                                
 @keys = '<keys>                                                                
  <key>                                                                
    <level2_key>level2_key 1</level2_key>                                                                
    <level3_key>level3_key 1</level3_key>                                                                
  </key>                                                                
  <key>                                                                
    <level2_key>level2_key 2</level2_key>                                                                
    <level3_key>level3_key 2</level3_key>                                                                
  </key>                                                                
</keys>'                                                                
                                                                
                                                                                                       
********************************************************************* */                                                                                                                                                                 
-- CHANGE ID # 01 -- HAMZA 20151109 MultiCurrency Changes                                                                                                                                                         
@company_code INT,                                                                                                                                        
@customer_code VARCHAR(32)='',                                                                                                                                            
                                                                                                                                                       
@level2_key  VARCHAR(32) = null,                                                           
@level3_key  VARCHAR(64) = null,                                                                        
@include_level3 tinyint=0,                                                                                                 
@count int,                                                              
@resource_id CHAR(16),                                                      
@mode tinyint =0,    -- 0=normal , 1= sync                                                                                              
@last_sync_date DATETIME= NULL ,                                                                 
@subscriber_id int = null  ,                                               
@keys xml = null                      
WITH RECOMPILE                         
AS                                      
                         
BEGIN                                         
         
 print '0--->'+convert(varchar,getdate(),109)                                   
declare @count_to_return int = 999999 -- arifhasan 20151006  dont want to send data to event_notification                              
                      
--  if @level2_key is not null
--  begin
--  set @keys='<keys>                                
--  <key>                                
--    <level2_key>'+@level2_key+'</level2_key>                                
--    <level3_key></level3_key>                                
--  </key>                                                                
--</keys>'
--  end                     
                      
if @keys is not null                                                
 begin                                                
 exec Pdsw_apps_level2_List_get                                                
 @company_code ,                                                                                   
 @customer_code ,                                                                
 @level2_key  ,                                                      
 @level3_key ,                                                            
 @include_level3 ,                                                                       
 @count ,                                                              
 @resource_id ,                                                                                                                                      
 @mode ,    -- 0=normal , 1= sync                                                                                                                                             
 @last_sync_date  ,                                                                 
 @subscriber_id   ,                                                                 
 @keys                                                 
                                                 
 return                                                
 end     
 
 select distinct l2.company_code,l2.level2_key   ,level_category_code ,trx_approval_required_flag,
level2_description ,level2_status,date_opened , date_closed,billable_flag ,l2.org_unit , location_code,
l2.modify_date ,validate_resource ,res_group_id,l2.create_date ,approved_flag  ,
comments_for_time_required_flag,comments_for_expense_required_flag,o.parent_unit as parent_org_unit
into #tmp_Level2 from pdd_level2 l2     
inner join pdm_org_units o on o.org_unit=l2.org_unit
where l2.company_code = @company_code       
and (isnull(@level2_key,'')='' or l2.level2_key like @level2_key+'%')
--and res.position_category_code=1
ALTER TABLE #tmp_Level2 ADD manager_id varchar(16)

update #tmp_Level2
set manager_id=res.resource_id
from #tmp_Level2 l2 INNER JOIN pdd_level2_resource res on l2.level2_key=res.level2_key
where res.position_category_code=1


   
   --    IF ( (SELECT Count(*)                                                     
   --       FROM   pdd_approval_chain_header                                               
   --       WHERE  company_code = @COMPANY_CODE                                                            
   --     AND approval_module_path =                                                           
   --                  'CompanyRules/Multi-LevelApproval/Level2')                                                                                                                                                                                 
   --         > 0 )                                                                             
   --   BEGIN                                                        
   --       DELETE FROM #tmp_Level2                                                                        
   --       WHERE isnull(approved_flag,'')=''
   --END
   
    UPDATE #tmp_Level2
   set level2_status = 0
   WHERE isnull(approved_flag,'')=''

 print '1--->'+convert(varchar,getdate(),109)
      
SELECT    distinct    
l3.company_code,l3.level2_key ,level3_key,trx_approval_flag ,level3_status,null level_category_code,level3_description ,cost_type  ,l3.labor_flag,
l3.expense_flag ,l3.date_opened ,l3.date_closed ,task_type ,l3.billable_flag,parent_level3_key ,horder ,l3.org_unit ,l3.location_code ,l3.modify_date,l3.create_date 
,date_due, rate_table1 ,rate_table2 ,l3.budget_template_code ,l2.trx_approval_required_flag ,o.parent_unit as parent_org_unit
into #tmp_Level3          
FROM #tmp_Level2 l2 inner join pdd_level3 L3  on l2.level2_key=l3.level2_key and l2.company_code=l3.company_code     
inner join pdm_org_units o on o.org_unit=l3.org_unit
WHERE l3.company_code = @company_code       
  
--)       
    print '2--->'+convert(varchar,getdate(),109)
     
  print '3--->'+convert(varchar,getdate(),109)                

 print '4--->'+convert(varchar,getdate(),109)
 
 print '5--->'+convert(varchar,getdate(),109)


create Table #tamp_valid_level2       
(       
level2_key varchar(32),       
level3_key varchar(64),       
isPM int       
)       
       
SELECT distinct level2_key into #temp_pm_level2 FROM plv_level2_resource a       
WHERE a.company_code = @company_code 
AND a.position_category_code = 1       
and resource_id = @resource_id  
and  (isnull(@level2_key,'')='' or level2_key like @level2_key+'%')
--and    isnull(active_flag,0)=1      
 print '6--->'+convert(varchar,getdate(),109)  
SELECT distinct resource_id into #temp_sup FROM plv_resource_all plv_r       
WHERE plv_r.company_code=@company_code       
and isnull(reports_to,'')= @resource_id       
 print '7--->'+convert(varchar,getdate(),109)


      
--select  distinct      
--l3.level2_key,       
--l3.level3_key      
--into #self_approver FROM #temp_pm_level2 pm inner join pdd_level3 l3 on pm.level2_key=l3.level2_key
--Where   
-- l3.trx_approval_flag = 1       
--and  (isnull(@level2_key,'')='' or l3.level2_key=@level2_key)  

insert into #tamp_valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
select  distinct      
d.level2_key,       
d.level3_key,       
1       
FROM #temp_pm_level2 pm inner join pdd_level3 l3 on pm.level2_key=l3.level2_key
 inner join pdv_pld_transactions d 
--pdd_level3 l3 inner join pdv_pld_transactions d     
on  d.level2_key= l3.level2_key   and d.Level3_key = l3.level3_key   
Where   
 l3.trx_approval_flag = 1       
--and l3.level2_key in (SELECT distinct level2_key FROM #temp_pm_level2) 
and  (isnull(@level2_key,'')='' or l3.level2_key like @level2_key+'%')     
         
 print '8--->'+convert(varchar,getdate(),109)

insert into #tamp_valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
select distinct       
d.level2_key,       
d.level3_key,       
0       
FROM pdd_level3 l3 inner join pdv_pld_transactions d       
on d.Level3_key = l3.level3_key  AND  l3.level2_key = d.level2_key       
inner join #temp_sup on #temp_sup.resource_id=d.resource_id
Where  l3.trx_approval_flag = 2       
--and resource_id in (SELECT  resource_id FROM #temp_sup)
and  (isnull(@level2_key,'')='' or l3.level2_key like @level2_key+'%')            
       
      print '10--->'+convert(varchar,getdate(),109)


insert into #tamp_valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT  distinct       
d.level2_key,       
d.level3_key,       
2    
FROM #tmp_Level3 l3 inner join pdv_pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
inner join  pdv_pld_transactions_hdr h       
ON h.record_id=d.record_id       
AND h.company_code=d.company_code 
AND isnull(h.approver_id, '')=@resource_id 
 print '11--->'+convert(varchar,getdate(),109)

insert into #tamp_valid_level2       
(       
level2_key, 
level3_key,       
isPM       
)       
       
SELECT   distinct     
d.level2_key,       
d.level3_key,       
3   
FROM pdd_level3 l3 inner join pdv_pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
where isnull(resource_id , '')=@resource_id 
and  (isnull(@level2_key,'')='' or l3.level2_key like @level2_key+'%')         

 print '12--->'+convert(varchar,getdate(),109)

declare @user_group_code varchar(32)
 SELECT                                                                
   @user_group_code = user_group_code                                                     
  FROM pdm_group_user_link                                                                
 WHERE company_code = @company_code                                        
   AND resource_id = @resource_id                
   AND preferred_group_flag = 1  
   --select  @user_group_code  
declare @permission_status_fin int
select @permission_status_fin =permission_status from pdm_rule_group where path='Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP'
and user_group_code=@user_group_code
--select @permission_status
if @permission_status_fin=2
begin 

insert into #tamp_valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT distinct       
d.level2_key,       
d.level3_key,       
4  
FROM #tmp_Level3 l3 inner join pdv_pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
where --isnull(resource_id , '')=@resource_id    
--and d.level2_key not in (select distinct level2)
--AND 
ISNULL(d.submitted_flag,0) =1
AND ISNULL(d.upload_flag,0) =(0)       
AND isnull(d.approval_flag,9) in (1,4 )       
AND isnull(d.finalise_flag,9) in (0,9)       

end  

 print '13--->'+convert(varchar,getdate(),109)
      
		    --return
	                
  select * into #pdd_level2_customer from pdd_level2_customer where level2_key in (select distinct level2_key from #tmp_Level2)                                                  
-- TEMP                                                    
SET @count = 100                   
                                                                
                
    DECLARE --@source int ,                                          
   @permission_status INT=NULL,                                                                                                                                                                                 
            @org_unit1         CHAR(16),                                                                                                                    
            @location_code1    CHAR(16),                                                                
            @user_group        VARCHAR(32),                                                           
             
            @source_text varchar(30)  ='TimeSheet'                             
                                                                                         
                     
      --set @level2_key =nullif(@level2_key, '')                                                                                           
      --set @level3_key   =nullif(@level3_key, '')                 
                              
                                              
                                                                                      
                                                                                                                                               
    CREATE TABLE #level2                            
      (                                     
 level2_key CHAR(32)                        
      )                                                                               
                               
    CREATE TABLE #Level2Level3                                                                                                                                                                              
 (                                           
 id int identity (1, 1) ,                                                                                               
  level2_key    CHAR(32),                                           
  level2_description VARCHAR(128),                            
  level2_status tinyint,                                                                                                
  level2_opendate    DATETIME,                                                                                                                                               
  level2_closedate   DATETIME,                                                                                                           
  level3_key         CHAR(64),                                                                                                         
  level3_description VARCHAR(64),                                                                                   
  level3_status tinyint,                       
  level3_opendate  DATETIME,               
  level3_closedate   DATETIME,                                                                                                                           
  parent_level3_key  CHAR(64),                                                                                                                                                                                 
  horder      INT,                                                                                                                   
  customer_code    VARCHAR(16),                                                                                                                    
  customer_name      VARCHAR(64),                                                                                                 
  expense_flag       TINYINT,            
  labor_flag         TINYINT,                              
  read_flag   TINYINT,                                        
  l2_org_unit   CHAR(16),                                                
  l2_location_code   CHAR(16),                      
  l3_org_unit      CHAR(16),  
l3_location_code   CHAR(16),                                                                                                                                                   
  cost_type          INT ,                                                           
  modify_date     Datetime,                   
  -- HAMZA -- 20142312 -- Added the below columns for level3                                                                                                         
  task_type   int,                                    
  billable_flag  int,                      
  l2_rate_type varchar(16), -- CHANGE ID # 01                                                                
  Level2_modify_date     datetime     ,                         
  transaction_order int default(0),                
  self_approver int  ,
  finance_approval int,
  header_approver int ,
  trx_approval_flag tinyint   ,
  manager_id varchar(16) ,
  l2_parent_org_unit char(16),
  l3_parent_org_unit char(16)                                                                      
 )                                                                                           
                                                                         
                                                                                    
                                         
    SELECT @location_code1 = location_code    , @org_unit1 = org_unit   
      FROM   pdd_resources                                                                                                           
      WHERE  company_code = @company_code                              
     AND resource_id = @resource_id                                                         
                                              
                                                                                        
                               
    SELECT @user_group = user_group_code                                                                       
    FROM   pdm_group_user_link                           
 WHERE  resource_id = @resource_id                                                                                 
     AND preferred_group_flag = 1                                                                                                            
                
                                                                                                                                                         
    CREATE TABLE #valid_customers                            
      (                                                                                                                                                                                 
         level2_key    CHAR(32),                                                                                        
         customer_code VARCHAR(16),                                                        
         customer_name VARCHAR(64)        
      )     
                                                               
IF @customer_code = ''                                
      BEGIN 
	  
	  INSERT #valid_customers                                                               
		(level2_key,                   
		customer_code,                                                        
		customer_name)                                        
	SELECT level2_key,                                                                                       
			customer_code,                                                                                                                
			customer_name                                                             
	FROM   #pdd_level2_customer                                                    
	ORDER  BY level2_key,                                                                                                                                                                                 
	customer_code                                                          
                                                                                                                                                                                                                                                 
	INSERT #valid_customers                                            
		(level2_key,              
		customer_code,                                                                                                                      
		customer_name)                                                                                                                                            
	SELECT DISTINCT 
		l2.level2_key,              
		NULL,                                                                                                            
		NULL                                                                          
	FROM  #tmp_Level2 l2 inner join #tmp_Level3 l3 on l2.level2_key=l3.level2_key and l2.company_code = l3.company_code                                                                                                                             





                          
	WHERE  l2.level2_key NOT IN (SELECT level2_key                          
							FROM #valid_customers)                                    
	AND (@level2_key is not null OR l3.labor_flag = 1  or (l3.expense_flag = 1  and  l3.cost_type in (select cost_type from pdd_cost_codes  where expense_report_flag = 1)  ))        
	--AND l3.level3_status = 1 
	--AND l2.level2_status = 1  
	AND (@level2_key is not null OR l3.level3_status = 1) --FS20180511 level2 check
	AND (@level2_key is not null OR l2.level2_status = 1)  --FS20180511
	                                              
                                                        
      END                   
ELSE                                                 
BEGIN                      
          INSERT #valid_customers                                            
                 (level2_key,                                                                                     
                  customer_code,                                                           
                  customer_name)                                                                                                                                                                                 
			SELECT level2_key,                                                                                                                                                
			customer_code,                                                                                                      
                 customer_name                                                                                                                   
          FROM   #pdd_level2_customer                                                            
          WHERE  customer_code LIKE Rtrim(@customer_code)  + '%'                                            
          ORDER  BY level2_key,                                                                                  
                    customer_code                                                                                                                                                                                 
END                                               
                                                                                                                                                                                                                                                              


























           --select * from #valid_customers 
        print '14--->'+convert(varchar,getdate(),109)                                                                                   
       if  @include_level3 =1                                                                                                                                                                
       begin 
	                                                                                                                                                  
       INSERT #Level2Level3                                                                                                                                                                    
   (              
    level2_key,                                                                                   
    level2_description,     
    level2_status,         
    level2_opendate,                       
    level2_closedate,                                                                                    
    level3_key,                          
    level3_description,                                                        
    level3_status,                                                                      
    level3_opendate,                                    
    level3_closedate,                    
    parent_level3_key,     
   horder,                                                                
  customer_code,  
    customer_name,          
   expense_flag,               
    labor_flag,              
    l2_org_unit,    
    l2_location_code,                                                                                              
    l3_org_unit,                                                                           
    l3_location_code,                                                                                                            
    read_flag,                                                                                               
    cost_type,                                                                                         
    modify_date,                                                                                                                                                              
    task_type,                                                                  
   billable_flag,                                                                          
    Level2_modify_date,
	self_approver,
      trx_approval_flag ,
	  manager_id  ,
	  l2_parent_org_unit,
	  l3_parent_org_unit                                    
   )         
   

              
  SELECT Distinct l2.level2_key,                                                                                                                                                                                 
      Isnull(l2.level2_description, '') AS level2_description,                                                                                                             
      l2.level2_status,                                                                                                                                                    
      l2.date_opened    AS level2_OpenDate,                                                                                                                                                                    
      l2.date_closed                      AS level2_CloseDate,                                                                                                                                     
      l3.level3_key,                                                                                                                                                                    
      Isnull(l3.level3_description, '') AS level3_description,                                                              
      l3.level3_status,                               
      l3.date_opened         AS level3_opendate,                                        
   l3.date_closed AS level3_closedate,                                                   
      l3.parent_level3_key,                    
      l3.horder,                                                                             
      c.customer_code,                 
      c.customer_name,                                             
      l3.expense_flag,                              
l3.labor_flag,                                                                                                            
  l2.org_unit,                                               
      l2.location_code,                                              
 l3.org_unit,                                                       
      l3.location_code,  
      0,                                                 
      l3.cost_type,                        
   isnull(l3.modify_date,l3.create_date),                
      l3.task_type,                                  
      l3.billable_flag,           
      isnull(l2.modify_date, l2.create_date),
	  0,
	  CASE WHEN l2.trx_approval_required_flag=0 THEN 0 ELSE trx_approval_flag END trx_approval_flag
       ,manager_id 
	   ,l2.parent_org_unit 
	   ,l3.parent_org_unit                                                     
  FROM   #tmp_Level2   l2                                              
      INNER JOIN #tmp_Level3   l3                                   
  ON  l2.level2_key = l3.level2_key                                                                            
      INNER JOIN #valid_customers c                                                                                                                 
  ON l2.level2_key = c.level2_key                                                                                     
  WHERE  l2.company_code = @company_code                                                                                                                                          
      AND l3.company_code = @company_code                                               
      AND (@level2_key is not null OR (@mode in (0,3)  ) OR l2.level2_status = 1)           --FS20180511 level2 check                                                                                                       
      AND (@level2_key is not null OR (@mode in (0,3)  ) OR l3.level3_status = 1)                                                          
      and                                           
      (@level2_key is not null OR l3.labor_flag = 1  or l3.expense_flag = 1  )                            
                                                                 
 AND ((@mode = 0 or @mode = 3)or @last_sync_date < isnull(dateadd(mi, 10, l3.modify_date), dateadd(mi, 10, l3.create_date)) ) 
                                                                                                             
     end                                                                                                                                                         
          
  
          
else                                     
 begin                                                          
INSERT #Level2Level3                                                                                                          
   (                                   
    level2_key,                                
level2_description,                                  
    level2_status,                                  
    level2_opendate,                                            
    level2_closedate,                                                      
    level3_key,                                                                                                                                                   
    level3_description,                                                           
    level3_status,                                              
    level3_opendate,          
    level3_closedate,             
    parent_level3_key,                                                                                                                   
    horder,                                                                          
    customer_code,         
    customer_name,               
    expense_flag,         
    labor_flag,                                           
 l2_org_unit,                                                                                                  
    l2_location_code,                                                                          
    l3_org_unit,              
    l3_location_code,      
    read_flag,              
  cost_type,                                                                                                                         
    modify_date ,                                                       
    task_type,          
    billable_flag,               
    Level2_modify_date,                  
    l2_rate_type -- CHANGE ID # 01
	,self_approver
     ,trx_approval_flag 
	 ,manager_id
	,l2_parent_org_unit 
	,l3_parent_org_unit    
  ) 
  SELECT                     
  l2.level2_key,                                                  
      Isnull(l2.level2_description, '') AS level2_description,                                            
      l2.level2_status,                                             
      l2.date_opened     AS level2_OpenDate,                                                                                                                                                 
      l2.date_closed                      AS level2_CloseDate,                                                                                          
     null  level3_key,                                                                   
      null AS level3_description,                                                          
      l3.level3_status,                                                                                                                        
      null                   AS level3_opendate,                                                                                                   
      null AS level3_closedate,                                                                                                                                     
     null,                                                                           
      null,                                                                                                      
      c.customer_code,                                                               
      c.customer_name,                                                                                                                                    
      max(l3.expense_flag),                  
      max(l3.labor_flag),                                                                        
  l2.org_unit,                                                                                                   
      l2.location_code,            
      null,                                                              
     null,                                                             
      0,                         
      null,                                                                            
      isnull(l2.modify_date, l2.create_date),                                                                                                      
      null,      
      l2.billable_flag,--null,                                                                 
      isnull(l2.modify_date, l2.create_date),                      
      case when l2mc.expcost_xrate_type = -1 then l2mc.expcost_xrate_type_name else CONVERT(varchar, expcost_xrate_type) end as l2_rate_type -- CHANGE ID # 01                      
	  ,0
	  ,CASE WHEN l2.trx_approval_required_flag=0 THEN 0 ELSE trx_approval_flag END trx_approval_flag
	  ,manager_id
	  ,l2.parent_org_unit 
	  ,null 
   FROM   #tmp_Level2   l2 
    INNER JOIN #tmp_Level3   l3           
    ON  l2.level2_key = l3.level2_key                  
  and (@level2_key is not null OR l3.level3_status =1 )            --FS20180511 level2 check         
 LEFT OUTER JOIN pdd_level2_mc l2mc                      
ON l2.level2_key = l2mc.level2_key                    
      INNER JOIN #valid_customers c                                              
  ON l2.level2_key = c.level2_key  
  WHERE  l2.company_code = @company_code                                                                     
  AND l3.company_code = @company_code                                                                                                  
      AND (@level2_key is not null OR ( @mode = 0 or @mode = 3)  OR l2.level2_status = 1)       --FS20180511 level2 check   
      AND (@level2_key is not null OR (@mode = 0 or @mode = 3)  OR l3.level3_status = 1)                   
  AND  (@level2_key is not null OR  l3.labor_flag = 1  or l3.expense_flag = 1  )                  
      AND ((@mode = 0 or @mode = 3) or @last_sync_date < isnull(dateadd(mi, 10, l2.modify_date), dateadd(mi, 10, l2.create_date)) )                                                                      
	   
     group by                                                                                                              
  l2.level2_key,   
   l2.level2_description   ,                                                                                
  l2.level2_status,                                                                                        
  l2.date_opened     ,                                                         
  l2.date_closed ,                                                            
  l3.level3_status,                                                                         
  c.customer_code,                                                                                                                              
  c.customer_name,                                           
  l2.org_unit,                                                              
  l2.location_code,                                                                                                                                   
   l2.modify_date,                                                    
   l2.create_date  ,                                                                  
   l2.modify_date,                                                                 
   l2.create_date,    
   l2.billable_flag,                      
   case when l2mc.expcost_xrate_type = -1 then l2mc.expcost_xrate_type_name else CONVERT(varchar, expcost_xrate_type) end
  ,CASE WHEN l2.trx_approval_required_flag=0 THEN 0 ELSE trx_approval_flag END 
   ,manager_id   
   ,l2.parent_org_unit                                                                                                                              
                                   
     end            
 print '15--->'+convert(varchar,getdate(),109)                                                                                 
Create Table #ValidOrgUnit                 
(org_unit varchar(16)         
)        

declare @parent_org_unit char(16)
Select @parent_org_unit=isnull(parent_unit,'') from pdm_org_units where org_unit= @org_unit1                                                                 
 
 if isnull(@parent_org_unit,'')!=''
	BEGIN       
		insert into #ValidOrgUnit     
		SELECT org_unit  from pdm_org_units where parent_unit =@parent_org_unit      
	END  
	          
	insert into #ValidOrgUnit     
	select   @org_unit1 		      
 
                                                                                                         
    SELECT @permission_status = permission_status                                      
    FROM   pdm_rule_group                                                                       
    WHERE  path = 'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level2/OrgUnit'                                                                     
           AND @user_group = user_group_code                                                                                                                                                                                 
                                               
IF @permission_status = 2                                                                  
       BEGIN 
    	update #Level2Level3                                     
		set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                                   
		labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end 
		WHERE  l2_org_unit not in (select org_unit from #ValidOrgUnit)                                                                          
           
      END                                      
                                                                                   
                         
     
    SELECT @permission_status = permission_status                                  
    FROM   pdm_rule_group                                                          
    WHERE  path =                                      
    'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level2/LocationCode'                                          
           AND @user_group = user_group_code                                          
                                   
   IF @permission_status = 2                                         
       BEGIN                                                        
     update #Level2Level3                                                          
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                                   
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end                    
                                                                 
          WHERE  l2_location_code <> @location_code1                                                                                                                                                                  
     END                                                           
                                                                         
                                                  
                                                                                                                                                                            
    SELECT @permission_status = permission_status                                                                                                           
    FROM pdm_rule_group                                                                                                                          
WHERE  path = 'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level3/OrgUnit'                                                                                                       
           AND @user_group = user_group_code                                                                                  
                                                                                                                                                        
 IF @permission_status = 2                                                                                               
       BEGIN                                                                                                                            
  update #Level2Level3                                                                 
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                                                                 
     labor_flag = case when @source_text  ='TimeSheet' then 0 else  labor_flag   end                                                                 
WHERE  l3_org_unit not in (select org_unit from #ValidOrgUnit)                                                                   
          --WHERE  l3_org_unit <> @org_unit1 --                                                   
      END                                                          
                  
    SELECT @permission_status = permission_status                    
    FROM  pdm_rule_group                                               
    WHERE  path =                                        
    'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level3/LocationCode'                    
           AND @user_group = user_group_code   
         
    IF @permission_status = 2        
       BEGIN        
    update #Level2Level3         
   set expense_flag = case when @source_text ='ExpenseReport'  then 0 else expense_flag   end ,                            
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end          
   WHERE  l3_location_code <> @location_code1--                              
      END             
 set @source_text  ='ExpenseReport' 
  --end -- while loop for data filters                                                       
                    
                   

       print '16--->'+convert(varchar,getdate(),109)                                                                                 
                                                                                                                                                                                
    INSERT #level2                                                    
           (level2_key)                                                                                                                          
    SELECT level2_key              
FROM   #Level2Level3                                                                                                                                                                                 
    WHERE  level2_key IN (SELECT level2_key                                  
                          FROM   #tmp_Level2                                                  
       WHERE  validate_resource = 0)                                                                                                                                                                                 
    UNION --all                                                                                                                                                           
    SELECT level2_key                                                                                                        
    FROM   #Level2Level3                                                                                                          
    WHERE  level2_key IN (SELECT level2_key                                                     
            FROM   #tmp_Level2                                                                          
      WHERE  validate_resource IN ( 1, 3 )                                                                                                                                              
                             AND res_group_id = (SELECT res_group_id                                                                      
    FROM   pdd_resources                                            
                                     WHERE                                                         
                         resource_id = @resource_id                                                                                      
AND res_category_code = 'EMPL')  
                  )                                                                                                      
    UNION --- all             
  SELECT level2_key                                                         
    FROM   #Level2Level3      
    WHERE  level2_key IN (SELECT level2_key                
      FROM   #tmp_Level2                                                            
 WHERE  validate_resource IN ( 3, 2 )                                                                 
                                 AND level2_key IN (SELECT level2_key                                             
                      FROM   pdd_level3_schedule               
                                                   WHERE                  
                                     resource_id = @resource_id))                                    
                                
   

 print '17--->'+convert(varchar,getdate(),109)                                                                               
                                       
    DELETE FROM #Level2Level3  
    WHERE level2_key NOT IN (SELECT level2_key      
      FROM   #level2)                                                                                                                                                                     
  print '18--->'+convert(varchar,getdate(),109)                                                                                                                                   
                                                                                                         
    select  top (@count) level2_key,  max(modify_date) modify_date                                                  
 into #cte_distinct_level2                                      
    from #Level2Level3                                                                                      
    group by level2_key                     
    order by max(Level2_modify_date) desc                                                                   
                                                
 print '19--->'+convert(varchar,getdate(),109)                                                                               
                                                                              
    delete #Level2Level3                                   
where level2_key not in                                  
    (select level2_key from #cte_distinct_level2)
 print '20--->'+convert(varchar,getdate(),109)                                   
     
                
           
                                                                     
                 
                                                                    
 if (isnull(@customer_code, '')='' and  isnull(@level2_key, '')='')                                                                                    
 begin   
   
 create table #pld (level2_key varchar(32),level3_key varchar(64),create_date datetime)
     insert into #pld
	 select  level2_key, level3_key , max(create_date) create_date --into #pld
   from pdv_pld_transactions
   where  trx_level in (0, 3) AND 
units <> 0 AND                                                                                                                                
DATALENGTH(rtrim(line_id)) < 4  
and ((@mode = 0 or @mode = 3) or create_date >= @last_sync_date) 
and  ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0)))  in 
(select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #tamp_valid_level2 )
group by level2_key, level3_key                         



insert into #pld 
select level2_key,level3_key,max(start_date)create_date
from pdd_permanent_line --where level2_key='AARP001-17-186'
where resource_id=@resource_id
and  ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) not in 
(select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #pld )

group by level2_key, level3_key     

 insert into #Level2Level3                                                                                                                 
   (   
 level2_key,        
 level2_description,                                               
 level2_status,                
 level2_opendate,                                                                                                                                                                             
 level2_closedate,                   
 level3_key ,                    
level3_description,                                                                   
 level3_status,          
 customer_code                                  
 ,customer_name                                                
 ,labor_flag              
 ,expense_flag                                   
 ,level3_opendate         
 ,level3_closedate                                 
 ,task_type                                                                                 
 ,billable_flag                                                  
 ,transaction_order                                             
 ,cost_type                      
 ,l2_rate_type -- CHANGE ID # 01 
 ,self_approver
 ,trx_approval_flag  
 ,manager_id
 ,l2_parent_org_unit 
 ,l3_parent_org_unit  
 ) 
 SELECT distinct             
    plt.level2_key,                                 
    level2_description,                                                                                                                    
    plv2.level2_status,                                                                                 
    plv2.date_opened,                         
    plv2.date_closed,                                                                       
    case when @include_level3=1 then plt.level3_key else null end level3_key ,                                                                                                                     
	case when @include_level3=1 then level3_description else null end level3_description,                                        
    case when @include_level3=1 then plv3.level3_status else null end level3_status,                                                                                 
    customer_code,                                                       
    customer_name,                     
    case when @include_level3=1 then plv3.labor_flag else null end as labor_flag,                             
    case when @include_level3=1 then plv3.expense_flag else null end as expense_flag,                                                                         
    case when @include_level3=1 then plv3.date_opened else null end as level3_opendate,                                                       
    case when @include_level3=1 then plv3.date_closed else null end as level3_closedate,                                                                               
    case when @include_level3=1 then plv3.task_type else null end task_type,                                                   
    case when @include_level3=1 then plv3.billable_flag  else plv2.billable_flag end   billable_flag,                                                                                                
    row_number () over (partition by 1 order by plt.create_date) transaction_order,                               
    plv3.cost_type,                      
    case when l2mc.expcost_xrate_type = -1 then l2mc.expcost_xrate_type_name else CONVERT(varchar, expcost_xrate_type) end as l2_rate_type -- CHANGE ID # 01                         ,
	,0 self_approver 
    --into #l2_trx    
	,CASE WHEN plv2.trx_approval_required_flag=0 THEN 0 ELSE trx_approval_flag END trx_approval_flag  
	,manager_id
	,plv2.parent_org_unit 
    ,plv3.parent_org_unit  
   FROM #pld plt
   --left join pdv_pld_transactions_hdr hdr on plt.record_id=hdr.record_id                                                                                         
    LEFT OUTER JOIN #pdd_level2_customer pl2c    
     ON plt.level2_key = pl2c.level2_key                                                                                 
   JOIN #tmp_Level2 plv2                                                                             
     ON  plt.level2_key=plv2.level2_key                    
    LEFT OUTER JOIN pdd_level2_mc l2mc                      
ON plv2.level2_key = l2mc.level2_key       
    LEFT OUTER JOIN #tmp_Level3 plv3                                                                   
     ON plt.level3_key=plv3.level3_key                                      
      AND plt.level2_key=plv3.level2_key                                                                                                                               
--   WHERE              
--     plt.company_code = @company_code 
--	 AND plt.trx_level in (0, 3) AND 
--plt.units <> 0 AND                                                                                                                                
--DATALENGTH(rtrim(line_id)) < 4                                                                                                                                                                                
--  and ((@mode = 0 or @mode = 3) or plt.create_date >= @last_sync_date)    
 /*
  CHANGED REVOKED with discussion by NAbbasi07272018
delete from #Level2Level3 where level2_key in (   
select distinct level2_key from #Level2Level3 where isnull(transaction_order,0)<>0)
and isnull(transaction_order,0)=0
    */   
                                                
            
 end 

 print '21--->'+convert(varchar,getdate(),109)                                                                               
     
----****self approver****-----              

  update l2l3                
  set self_approver=1 
 FROM #Level2Level3 l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #tamp_valid_level2 where isPM in (0,1))
 --OR 
 --ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
	--																	from #self_approver )
 

  update l2l3                
  set finance_approval=1
 FROM #Level2Level3 l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #tamp_valid_level2 where isPM in (4))	
																		
  update l2l3                
  set header_approver=1
 FROM #Level2Level3 l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #tamp_valid_level2 where isPM in (2))	
																																							

 

 
 ----****self approver****-----             
 
 print '22--->'+convert(varchar,getdate(),109) 
         
                                                                                                                 
declare @entity_id int                                                                                            
  if @include_level3 = 0                                                    
  begin                                                                         
	SELECT   distinct                                                        
	max(l23.id) id,                                                             
	L23.level2_key,                                    
	Isnull(L23.level2_description, '') AS level2_description,                                                                               
	L23.level2_status,                                                                
	L23.level2_opendate,                                                       
	L23.level2_closedate,   
	L23.level3_key ,  
	--l23.l2_org_unit, 
	--l23.l2_location_code,                                   
	l2.org_unit as l2_org_unit,               
	l2.location_code as l2_location_code,                          
	ISNULL(L23.level3_description,'')  AS level3_description,            
	L23.level3_status,                               
	L23.labor_flag,                                       
	L23.expense_flag,                                           
	L23.customer_code                                                                         
	,L23.customer_name                     
	,L23.level3_opendate as open_date                                                                                           
	,L23.level3_CloseDate as closed_date                 
	,L23.task_type                                            
	,L23.billable_flag                                                                                                                  
	,comments_for_time_required_flag                                                                                
	,comments_for_expense_required_flag        
	,max(isnull(transaction_order,0)) transaction_order                      
	, l2_rate_type -- CHANGE ID # 01                 
	,isnull(self_approver,0) self_approver ,isnull(finance_approval,0) finance_approval, isnull(header_approver,0) header_approver
	-- , trx_approval_flag  
	,manager_id 
	,isnull(nullif(l2_parent_org_unit,''),l2.org_unit) l2_parent_org_unit 
	--,nullif(l3_parent_org_unit,'')    l3_parent_org_unit        
   into #l2_data                                                                                                              
   FROM   #Level2Level3  L23                                                        
                                                                 
   INNER JOIN pdd_level2 l2 on l2.level2_key= l23.level2_key                                          
   --where                                    
   --(@keys is null or exists (select * from #level23_xml x where x.level2_key  = L23.level2_key))                                                                
                                                        
          
               
    group by                                                                                
     L23.level2_key,                        
    L23.level2_description,                                                 
    L23.level2_status,                                                                                                       
    L23.level2_opendate,                        
    L23.level2_closedate,                                                                                                                                                          
    L23.level3_key ,                                           
    L23.level3_description,                                                                                                                              
    L23.level3_status,                                                                                       
    L23.labor_flag,                                            
    L23.expense_flag,                                                                                                                
    L23.customer_code                                                                                                                                                    
    ,L23.customer_name              
    ,L23.level3_opendate                                                                                                                                  
    ,L23.level3_CloseDate           
    ,L23.task_type                                                                                                          
    ,L23.billable_flag                                                                          
    ,comments_for_time_required_flag                                   
    ,comments_for_expense_required_flag,                                     
    l2.org_unit,                                      
    l2.location_code,                      
    l23.l2_rate_type ,       
    self_approver ,finance_approval,header_approver ,manager_id--,trx_approval_flag
	,l2_parent_org_unit 
	--,l3_parent_org_unit 
                 
   ORDER  BY 1                  
                  
                     
                                     
    if @subscriber_id is null            
   begin                                                                            
    select distinct level2_key,level2_description,level2_status,level2_opendate,level2_closedate,
	level3_key ,l2_org_unit,l2_location_code, level3_description,level3_status,--labor_flag,                                       
 --expense_flag
  customer_code,customer_name ,open_date                                                                                                                               
    ,closed_date                 
    ,task_type                                            
,billable_flag                                                                                                                  
    ,comments_for_time_required_flag                                                                                
    ,comments_for_expense_required_flag                             
  , l2_rate_type               
  , self_approver , finance_approval,  header_approver

	,manager_id,l2_parent_org_unit--,l3_parent_org_unit    
	from  #l2_data 
	--where level2_key='AARP001-17-186'        
    
	ORDER  BY level2_key desc--isnull(transaction_order, 0) desc                               
    --ORDER  BY 1                                                                         
   end                                                                   
   else   
  begin                                                                                        
   select distinct TOP (@count_to_return) level2_key,level2_description,level2_status,level2_opendate,level2_closedate,level3_key ,
   l2_org_unit,l2_location_code, level3_description,level3_status,--labor_flag,                                       
-- expense_flag, 
 customer_code,customer_name ,open_date                                                                                                                               
    ,closed_date                 
    ,task_type                                            
,billable_flag                                                                                                                  
    ,comments_for_time_required_flag                                                                                
    ,comments_for_expense_required_flag                             
  , l2_rate_type               
  , self_approver , finance_approval,  header_approver

	,manager_id ,l2_parent_org_unit --,l3_parent_org_unit  
	 from  #l2_data ORDER  BY  level2_key                                                                                        
                                                                           
   DELETE    #l2_data                                                                                
   where id in ( select TOP (@count_to_return) id from #l2_data ORDER  BY  level2_key     )       
                                                                                         
                                                                          
   select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level2'                               
                               
   insert into pdd_event_notification                                           
   (primary_key,                                                                                             
   company_code,                                 
   entity_action_id,                                              
   entity_type_id,                                                                                            
   subscriber_id,                  
   create_id,                      
   create_date)                                                                                 
   select convert(varchar, @company_code) + '~-~' + level2_key   ,                                            
   @company_code,                                                                        
   2,                                                                                        
   @entity_id,                                                                      
   @subscriber_id  ,                                                                                  
   null,                                                                                             
   GETDATE()                               
   from #l2_data                                                                                           
                                                                                        
  end                                                                         
                                                                          
          
  end                                    
 else                                                 
 begin                              
  SELECT distinct                                                             
 max(l23.id) id,                                                             
 L23.level2_key,                                      
    Isnull(L23.level2_description, '') AS level2_description,                                                                                                       
    L23.level2_status,                                                                                                              
    L23.level2_opendate, 
    L23.level2_closedate,  
    L23.level3_key,
	--l2_org_unit, 
	--l2_location_code,  
    l2.org_unit as l2_org_unit,                  
    l2.location_code as l2_location_code,                                      
    ISNULL(L23.level3_description,'')  AS level3_description,                                
    L23.level3_status,  
    L23.labor_flag,                                                                     
    L23.customer_code                                                                                   
    ,L23.customer_name                                                                                                                                  
    ,L23.level3_opendate as open_date                                 
    ,L23.level3_CloseDate as closed_date                                                  
,L23.task_type                                                                                                                                                          
    ,L23.billable_flag                                                                   
    ,L23.cost_type                                                                                                                 
    ,comments_for_time_required_flag                                                                          
    ,comments_for_expense_required_flag
	--,l3_org_unit as org_unit  
	--,l3_location_code   as location_code                            
    ,l3.org_unit                                 
  , l3.location_code                                           
  , case when(l23.expense_flag = 1  and isnull(temp.search_media_flag,0)<>1)   then 1 else 0 end expense_flag                                   
  , l3.date_due                                                                                
  , l3.rate_table1                                                                                
 , l3.rate_table2   ,                                      
  max(isnull(transaction_order,0)) transaction_order ,                
  isnull(self_approver,0) self_approver ,isnull(finance_approval,0) finance_approval, isnull(header_approver,0) header_approver  
   , L23.trx_approval_flag  
	,manager_id  
	,isnull(nullif(l2_parent_org_unit,''),l2.org_unit) l2_parent_org_unit
	,isnull(nullif(l3_parent_org_unit,''),l3.org_unit )  l3_parent_org_unit            
          into #l2l3_data                                                                            
                                                             
   FROM   #Level2Level3  L23                                                                                 
   INNER JOIN pdd_level2 l2 on l2.level2_key= l23.level2_key                                                                
   INNER JOIN pdd_Level3 l3 on l3.level2_key= l23.level2_key and l3.level3_key= l23.level3_key       
   left outer JOIN pdm_budget_template temp on l3.budget_template_code=temp.budget_template_code  
                                                                
    --where                                                                 
      --(@keys is null or exists (select * from #level23_xml x where x.level2_key  = L23.level2_key and x.level3_key  = L23.level3_key))                                                  
 --and 
   --( @level2_key is not null OR l23.labor_flag = 1  or (l23.expense_flag = 1  and isnull(temp.search_media_flag,0)<>1)   )                                                                                                       
   
   group by                      
 L23.level2_key,                                                                                          
    L23.level2_description ,                                                      
    L23.level2_status,                                   
 L23.level2_opendate,      
    L23.level2_closedate,                                                                             
    L23.level3_key ,         
    L23.level3_description ,                                                  
 L23.level3_status,                                                                                     
    L23.labor_flag,                                                                                                               
    L23.customer_code                                                                             
  ,L23.cost_type                                                                                                                                                                     
    ,L23.customer_name                                                
    ,L23.level3_opendate                                                      
    ,L23.level3_CloseDate                                                                                                                                                                              
    ,L23.task_type                        
    ,L23.billable_flag                                                       
    ,comments_for_time_required_flag                                                                                                
    ,comments_for_expense_required_flag               
	,l3.org_unit  
	,l3.location_code                                                                        
  ,  l23.expense_flag                                    
  ,temp.search_media_flag                                       
  , l3.date_due                    
  , l3.rate_table1                                                                     
  , l3.rate_table2                                      
	,l2.org_unit  
	,l2.location_code                  
  ,self_approver ,finance_approval ,header_approver, L23.trx_approval_flag  
	,manager_id
	,l2_parent_org_unit 
	,l3_parent_org_unit 	                                   
                                                                      
   if @subscriber_id is null                          
  begin  
    select distinct * from  #l2l3_data  --*
	--where level2_key='KRAFT001_10719_32838'
	
  ORDER  BY 1                            
  end                                                                                  
   else                                                           
    begin                                     
                                                       
    select distinct  * from  #l2l3_data    where level2_key in ( select   top (@count_to_return) level2_key from  #l2l3_data 
	                                                          
    group by level2_key ORDER  BY   max(isnull(transaction_order, 0))  desc, level2_key       ) 
	     --and level2_key='AARP001-16-004'       
		
                       
  DELETE   #l2l3_data                                            
  where level2_key in ( select top (@count_to_return) level2_key  from #l2l3_data group by level2_key ORDER  BY  max(isnull(transaction_order, 0))  desc, level2_key )                                                                                        













                      
  select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level3'                                                                                         
            
  insert into pdd_event_notification                                                                    
 (                                                              
  primary_key,                                                                         
  company_code,                                      
entity_action_id, 
  entity_type_id,                                      
  subscriber_id,                                                  
  create_id,      
  create_date                                                                            
 )                                                                       
 select convert(varchar, @company_code) + '~-~' + level2_key  + '~-~' + level3_key  ,                                   
 @company_code,                                
 2,                              
 @entity_id,           
 @subscriber_id ,                                                                            
 null,                                         
 GETDATE()                                                                                  
   from #l2l3_data                                                                                            

                                                                                       
                                                                                       
        end                                                                             
                                                                                                 
 end                                                 
 print '23--->'+convert(varchar,getdate(),109)          
                                                                        
--*/                                                                                                            
END      







go