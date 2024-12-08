/****** Object:  StoredProcedure [dbo].[Pdsw_apps_level2_List_get]    Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pdsw_apps_level2_List_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Pdsw_apps_level2_List_get]
GO

/****** Object:  StoredProcedure [dbo].[Pdsw_apps_level2_List_get]   Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





create PROCEDURE [dbo].[Pdsw_apps_level2_List_get]                
                
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
*         Name: Pdsw_apps_level2_List_get                                  *                    
*       Module:         *                                                         
* Date created: Aug 03 2015            *             
*           By: Rabia Shamim     *          
*      Comment:   *  
* Date revised:    *          
*         By:   *                                                                        
*  Comment:                                         *                                                                                 
*                                                *                                                                                         
*                                            *                                   
                                
 @keys = '<keys>                                
  <key>                                
    <level2_key>832015</level2_key>                                
    <level3_key>006</level3_key>                                
  </key>                                
  <key>                                
    <level2_key>360I001-15-073</level2_key>                                
    <level3_key>001</level3_key>                                
  </key>                                
</keys>'                                
                                
                                                                       
********************************************************************* */                                                                                                                                 
-- CHANGE ID # 01 -- HAMZA 20151109 MultiCurrency changes                                                                                                                            
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
declare @count_to_return int = 500                   
                
SELECT   T.c.value('./level2_key[1]', 'nvarchar(64)') level2_key,                                 
T.c.value('./level3_key[1]', 'nvarchar(64)') level3_key   into #level23_xml                                      
                FROM     @keys.nodes('/keys/key') T ( c )                
   
   select distinct level2_key ,approved_flag ,trx_approval_required_flag,level_category_code,level2_status
   into #level2_trans
from pdd_level2       
where company_code = @company_code       
and trx_approval_required_flag in (1,2)  
and level2_key in (select distinct level2_key from #level23_xml)

ALTER TABLE #level2_trans ADD manager_id varchar(16)

update #level2_trans
set manager_id=res.resource_id
from #level2_trans l2 INNER JOIN pdd_level2_resource res on l2.level2_key=res.level2_key
where res.position_category_code=1

--   IF ( (SELECT Count(*)                                                     
--          FROM   pdd_approval_chain_header                                                                                                                    
--          WHERE  company_code = @COMPANY_CODE                                                            
--        AND approval_module_path =                                                                
--                     'CompanyRules/Multi-LevelApproval/Level2')                                                                                                                                                                                 
--            > 0 )                                                                             
--      BEGIN                                                                                                                                                                        
--          DELETE FROM #level2_trans                                                                                                                                
--          WHERE isnull(approved_flag,'')=''
--delete from #level23_xml where level2_key in(select level2_key from pdd_level2 WHERE isnull(approved_flag,'')='')

--   END

   UPDATE #level2_trans
   set level2_status = 0
   WHERE isnull(approved_flag,'')=''

   

   create table #level3_trans
   (level2_key varchar(32),level3_key varchar(64),trx_approval_flag int,level_category_code char(16))
 
 
 insert into #level3_trans
SELECT    distinct    
level2_key ,level3_key,trx_approval_flag,null 
FROM pdd_level3 L3       
WHERE company_code = @company_code       
AND trx_approval_flag In (1,2)       
AND EXISTS (       
SELECT 1 FROM #level2_trans       
WHERE #level2_trans.level2_key = L3.level2_key       
)  
 
 insert into #level3_trans
  SELECT    distinct    
null level2_key ,level3_key,trx_approval_flag,level_category_code 
FROM pdd_generic_level3       
WHERE company_code =@company_code       
--AND trx_approval_flag = 1 
AND trx_approval_flag In (1,2)         
AND level3_key NOT IN (       
SELECT level3_key       
FROM pdd_level3       
WHERE company_code = @company_code    
)     

   

 SELECT DISTINCT       
company_code,resource_id,level2_key ,level3_key ,record_id ,submitted_flag,upload_flag ,approval_flag ,finalise_flag 
into #pld_transactions
FROM pdv_pld_transactions pl  
 where exists(    
SELECT 1 FROM #level3_trans       
WHERE #level3_trans.level2_key = pl.level2_key and #level3_trans.level3_key= pl.level3_key     
)


create Table #valid_level2       
(       
level2_key varchar(32),       
level3_key varchar(64),       
isPM int       
)       
       
SELECT distinct level2_key into #pm_level2 FROM plv_level2_resource a       
WHERE a.company_code = @company_code 
AND a.position_category_code = 1       
and resource_id = @resource_id  
and isnull(active_flag,0)=1
AND EXISTS (       
SELECT 1 FROM #level2_trans       
WHERE #level2_trans.level2_key = a.level2_key       
)       
       
SELECT resource_id into #supervisor FROM plv_resource_all plv_r       
WHERE plv_r.company_code=@company_code       
and isnull(reports_to,'')= @resource_id       

insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
select       
d.level2_key,       
d.level3_key,       
1       
FROM #level3_trans join #pld_transactions d       
on d.Level3_key = #level3_trans.level3_key       
Where  #level3_trans.level2_key Is not Null       
AND  #level3_trans.level2_key = d.level2_key       
AND #level3_trans.trx_approval_flag = 1       
and #level3_trans.level2_key in (SELECT level2_key FROM #pm_level2)     
       
insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
d.level2_key,       
d.level3_key,       
1       
FROM #level2_trans join #pld_transactions d       
on #level2_trans.level2_key = d.level2_key     
join #level3_trans       
on #level2_trans.level_category_code = #level3_trans.level_category_code       
Where #level3_trans.level2_key Is Null       
AND #level2_trans.level_category_code is not null       
AND #level2_trans.trx_approval_required_flag = 1       
and #level2_trans.level2_key in (SELECT level2_key FROM #pm_level2)       
      
insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
select       
d.level2_key,       
d.level3_key,       
0       
FROM #level3_trans join #pld_transactions d       
on d.Level3_key = #level3_trans.level3_key       
Where  #level3_trans.level2_key Is not Null       
AND  #level3_trans.level2_key = d.level2_key       
AND #level3_trans.trx_approval_flag = 2       
and resource_id in (SELECT resource_id FROM #supervisor)       
       
       
insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
d.level2_key,       
d.level3_key,       
0       
FROM #level2_trans join #pld_transactions d       
on #level2_trans.level2_key = d.level2_key       
join #level3_trans       
on #level2_trans.level_category_code = #level3_trans.level_category_code       
Where #level3_trans.level2_key Is Null       
AND #level2_trans.level_category_code is not null       
AND #level2_trans.trx_approval_required_flag = 2       
and resource_id in (SELECT resource_id FROM #supervisor)       
 
      
insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
d.level2_key,       
d.level3_key,       
2    
FROM #level3_trans l3 inner join #pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
inner join  pdv_pld_transactions_hdr h       
ON h.record_id=d.record_id       
AND h.company_code=d.company_code 
AND isnull(h.approver_id, '')=@resource_id     
       

insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
d.level2_key,       
d.level3_key,       
3   
FROM #level3_trans l3 inner join #pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
where isnull(resource_id , '')=@resource_id     

/*todo add remaining level3s  NABBASI08252018*/

insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
pm.level2_key,       
pm.level3_key,       
0   


from #level23_xml d 
inner join pdd_level3 pm on  d.level3_key=pm.level3_key 
where not exists (select * from #valid_level2 where level2_key =pm.level2_key and level3_key =pm.level3_key)
/*----End----*/
  
declare @user_group_code varchar(32)
 SELECT                                                                
   @user_group_code = user_group_code                                                                
  FROM pdm_group_user_link                                                                
 WHERE company_code = @company_code                                        
   AND resource_id = @resource_id                                                              
   AND preferred_group_flag = 1  

declare @permission_status_fin int
select @permission_status_fin =permission_status from pdm_rule_group where path='Security/ESM_FO/Forms/APL_APP/PEND_FIN_APP'
and user_group_code=@user_group_code

if @permission_status_fin=2
begin 

insert into #valid_level2       
(       
level2_key,       
level3_key,       
isPM       
)       
       
SELECT       
d.level2_key,       
d.level3_key,       
4  
FROM #level3_trans l3 inner join #pld_transactions d       
on l3.level2_key = d.level2_key and l3.level3_key=d.level3_key
where 
ISNULL(d.submitted_flag,0) =1
AND ISNULL(d.upload_flag,0) =(0)       
AND isnull(d.approval_flag,9) in (1,4 )       
AND isnull(d.finalise_flag,9) in (0,9)       

end   





   declare @reports_to varchar (16)                  
  select @reports_to=reports_to from pdd_resources where resource_id=@resource_id                                           
                                       
declare @entity_id int                 
 if @include_level3 = 0                
  begin                                         
SELECT         
  ( ROW_NUMBER() OVER(ORDER BY plv2.level2_key DESC)) id,                             
  plv2.level2_key,                                                                                             
  Isnull(plv2.level2_description, '') AS level2_description,                                                         
  plv2.level2_status,                              
  plv2.date_opened level2_opendate,                                
  plv2.date_closed level2_closedate,                                                                                                          
  null level3_key ,                                                                                                                                      
  null  AS level3_description,                                                    
  null level3_status,                                                                              
  null labor_flag,                                                                                      
  pl2c.customer_code                                                                                                                                                
  ,pl2c.customer_name                                                                                                                                
  ,null as open_date                                                                                               
  ,null as closed_date                                                                                                     
  ,plv2.task_type                                                                                                                         
  ,plv2.billable_flag                                                                                  
  ,comments_for_time_required_flag                                                
  ,comments_for_expense_required_flag              
  ,plv2.org_unit as l2_org_unit              
  ,plv2.location_code as l2_location_code    
  ,case when l2mc.expcost_xrate_type = -1 then l2mc.expcost_xrate_type_name else CONVERT(varchar, expcost_xrate_type) end as l2_rate_type -- CHANGE ID # 01              
  ,0 self_approver
  ,0 finance_approval 
  ,0 header_approver 
   ,trx_approval_required_flag 
   -- max(transaction_order) transaction_order 
   ,plv2.approved_flag  
   ,isnull(o.parent_unit,plv2.org_unit ) l2_parent_org_unit                                            
  into #l2_data                                                                              
  FROM pdd_level2 plv2 left outer join pdd_level2_customer pl2c                                                                  
         ON  pl2c.level2_key=plv2.level2_key                          
         AND pl2c.company_code=plv2.company_code    
      -- CHANGE ID # 01    
      LEFT OUTER JOIN pdd_level2_mc l2mc 
   ON plv2.level2_key = l2mc.level2_key  
    left join pdm_org_units o on o.org_unit= plv2.org_unit     
  where plv2.level2_key in (select level2_key from #level23_xml x where x.level2_key  = plv2.level2_key)             
  -- HAMZA -- 20150828 --  ADDED THE ACTIVE FLAG AND APPROVAL FLAG CHECKS            
  -- and isnull(plv2.approved_flag, 0) = 1 and plv2.level2_status = 1            
                                  
                                  
  group by                                                
   plv2.level2_key,                                                                      
  plv2.level2_description,         
  plv2.level2_status,                                         
  plv2.date_opened,                                                             
  plv2.date_closed,     
  pl2c.customer_code                                             
  ,pl2c.customer_name                                                                                                      
  ,plv2.task_type                                                                             
  ,plv2.billable_flag                                         
  ,comments_for_time_required_flag                                                                
  ,comments_for_expense_required_flag              
  ,plv2.org_unit              
  ,plv2.location_code    
  ,case when l2mc.expcost_xrate_type = -1 then l2mc.expcost_xrate_type_name else CONVERT(varchar, expcost_xrate_type) end    -- CHANGE ID # 01            
  ,trx_approval_required_flag
  ,plv2.approved_flag
  ,o.parent_unit  
  ORDER  BY 1   
---------------------------------------------------------------------
---------------------------------------------------------------------  

  UPDATE #l2_data
  set level2_status = 0 
  WHERE ISNULL(approved_flag,'')=''

--FS20180222
  ALTER TABLE #l2_data ADD manager_id varchar(16),trx_approval_flag int

	update #l2_data
	set manager_id=res.resource_id
	from #l2_data l2 INNER JOIN pdd_level2_resource res on l2.level2_key=res.level2_key
	where res.position_category_code=1 

	update l2
	set l2.trx_approval_flag=CASE WHEN l2.trx_approval_required_flag=0 THEN 0 ELSE res.trx_approval_flag END
	from #l2_data l2 INNER JOIN pdd_level3 res on l2.level2_key=res.level2_key
	



---------------------------------------------------------------------
---------------------------------------------------------------------
  ----****self approver****-----              

  update l2l3                
  set self_approver=1 
 FROM #l2_data l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #valid_level2 where isPM in (0,1,2))

  update l2l3                
  set finance_approval=1
 FROM #l2_data l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #valid_level2 where isPM in (4))																		

--ALTER TABLE #l2_data ADD l2_parent_org_unit char(16),l3_parent_org_unit  char(16)

--update a
--set l2_parent_org_unit
--from #l2_data a inner join pdm_org_units on a.



 
 ----****self approver****-----    
                                            
  if @subscriber_id is null                                                         
    begin                     
  select * from  #l2_data                                                       
  ORDER  BY 1                                                        
    end                                           
  else                                                         
   begin                                      
    select TOP (@count_to_return) * from  #l2_data ORDER by level2_key                                                        
                                                            
    DELETE    #l2_data                                                          
    where id in ( select TOP (@count_to_return) id from  #l2_data ORDER  BY  level2_key     )                                            
                                                          
                         
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
        
        
                                                
  SELECT                        
  ( ROW_NUMBER() OVER(ORDER BY plv2.level2_key DESC)) id,                             
  plv2.level2_key,                                         
  Isnull(plv2.level2_description, '') AS level2_description,                                                                       
  plv2.level2_status,                                      
  plv2.date_opened level2_opendate,                                                                                                                                 
  plv2.date_closed level2_closedate,                                                                                                          
  l3.level3_key ,                                                      
  ISNULL(l3.level3_description,'')  AS level3_description,      
  -- HAMZA -- 20151030 -- If the level2, for which the level3 is being get, is closed then send the level3 as closed                                                                              
  case when plv2.level2_status = 0 then 0 else  l3.level3_status end level3_status,                                                                              
  l3.labor_flag,                                      
  pl2c.customer_code                                                                                                                    
  ,pl2c.customer_name                                                                                  
  ,l3.date_opened  as open_date                                                                                               
  ,l3.date_closed  as closed_date                                                       
  ,l3.task_type                                                                                                                                
  ,l3.billable_flag                                             
  ,l3.cost_type                                                                                 
  ,comments_for_time_required_flag                                                
  ,comments_for_expense_required_flag                                                                                 
  ,l3.org_unit                                                
  , l3.location_code                                                
  , case when (l3.expense_flag = 1  and isnull(temp.search_media_flag,0)<>1)  then 1 else 0 end expense_flag        
  , l3.date_due                                                
  , l3.rate_table1                                                
  , l3.rate_table2              
  ,plv2.org_unit as l2_org_unit              
  ,plv2.location_code as l2_location_code   
  ,0 self_approver
  ,0 finance_approval 
  ,0 header_approver  
  ,CASE WHEN plv2.trx_approval_required_flag=0 THEN 0 ELSE l3.trx_approval_flag END trx_approval_flag           
  ,plv2.approved_flag
    
into #l2l3_data                              
FROM pdd_level2 plv2 left outer join pdd_level2_customer pl2c                                                                   
  ON  pl2c.level2_key=plv2.level2_key                          
     AND pl2c.company_code=plv2.company_code                
INNER JOIN pdd_level3 l3 on l3.level2_key= plv2.level2_key                      
INNER JOIN pdm_budget_template temp on l3.budget_template_code=temp.budget_template_code                                            
where plv2.level2_key in (select level2_key from #level23_xml x where x.level2_key  = plv2.level2_key and x.level3_key=l3.level3_key)  
  --and ( l3.labor_flag = 1  or (l3.expense_flag = 1  and isnull(temp.search_media_flag,0)<>1))                          
  -- HAMZA -- 20150828 --  ADDED THE ACTIVE FLAG AND APPROVAL FLAG CHECKS            
  and isnull(plv2.approved_flag, 0) = 1           
  --and plv2.level2_status = 1            
                               
                                    
   -- isnull(plv2.level2_key , '')= isnull(isnull(@level2_key, plv2.level2_key)  , '')                                  
   --and isnull(plv2.level3_key, '') = isnull(isnull(@level3_key, plv2.level3_key)   , '')                                        
    group by                                                
  plv2.level2_key,                                                                          
  plv2.level2_description ,                                                                                       
  plv2.level2_status,     
  plv2.date_opened,                                                                                                                                                 
  plv2.date_closed,                                                                                                                          
  l3.level3_key ,                              
  l3.level3_description ,                                                                               
  l3.level3_status,                                                                                              
  l3.labor_flag,                                                                               
  pl2c.customer_code                                                              
  ,l3.cost_type                                                                                                                                     
  ,pl2c.customer_name                                        
  ,l3.date_opened                                                                                                               
  ,l3.date_closed                                                                                                                                           
  ,l3.task_type                                                                                                                                                
  ,l3.billable_flag                                                                                                  
  ,comments_for_time_required_flag                              
  ,comments_for_expense_required_flag                                         
  ,l3.org_unit                                                                
   , l3.location_code                                                                
   ,  l3.expense_flag                                                                
   , l3.date_due                                          
   , l3.rate_table1                                                                
   , l3.rate_table2              
   ,plv2.org_unit    
   ,plv2.location_code              
   ,temp.search_media_flag  
   ,CASE WHEN plv2.trx_approval_required_flag=0 THEN 0 ELSE l3.trx_approval_flag END             
   ,plv2.approved_flag
   order by 1                 
   
 ---------------------------------------------------------------------
---------------------------------------------------------------------  
alter table #l2l3_data add   l2_parent_org_unit char(16),  l3_parent_org_unit char(16)

update l
set l2_parent_org_unit=isnull(nullif(o.parent_unit,''),l.l2_org_unit) 
from #l2l3_data l inner join pdm_org_units o on o.org_unit=l.l2_org_unit


update l
set l3_parent_org_unit=isnull(nullif(o.parent_unit,''),l.org_unit) 
from #l2l3_data l inner join pdm_org_units o on o.org_unit=l.org_unit


  
  UPDATE #l2l3_data
  set level2_status = 0 
  WHERE ISNULL(approved_flag,'')=''

--FS20180222
  ALTER TABLE #l2l3_data ADD manager_id varchar(16)

	update #l2l3_data
	set manager_id=res.resource_id
	from #l2l3_data l2 INNER JOIN pdd_level2_resource res on l2.level2_key=res.level2_key
	where res.position_category_code=1 



---------------------------------------------------------------------
---------------------------------------------------------------------

   ----****self approver****-----              

  update l2l3                
  set self_approver=1 
 FROM #l2l3_data l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #valid_level2 where isPM in (0,1))

  update l2l3                
  set finance_approval=1
 FROM #l2l3_data l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #valid_level2 where isPM in (4))																		
  update l2l3                
  set header_approver=1
 FROM #l2l3_data l2l3 
 where ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) in (select distinct ltrim(rtrim(level2_key))+ltrim(rtrim(isnull(level3_key,0))) 
																		from #valid_level2 where isPM in (2))		


 
 ----****self approver****-----   
   
   
         
    if @subscriber_id is null                   
   begin                                                        
   select * from  #l2l3_data                         
   ORDER  BY 1                                                        
   end                                                
    else                                                         
  begin                                                        
                                                 
  select  * from  #l2l3_data    where level2_key in ( select   top (@count_to_return) level2_key from  #l2l3_data                            
  group by level2_key ORDER  BY   level2_key       )                                            
   DELETE    #l2l3_data                                                          
   where level2_key in ( select top (@count_to_return) level2_key  from #l2l3_data group by level2_key ORDER  BY  level2_key )                                                        
                                                           
                                                           
                                                                  
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
                                       
                                       
                    
                
                
End 



go