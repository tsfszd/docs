---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='plsW_apps_app_res_get')
begin 
drop procedure plsW_apps_app_res_get
end
go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






CREATE PROCEDURE [dbo].[plsW_apps_app_res_get]    
                 
@company_code int,                 
@manager_id varchar(16),                  
@sort_by int = 0,                 
@trx_type int = 0,                 
@Approval_Mode int = 1,                 
/*                 
1 - unsubmitted  : submit = 0                 
2 - pending approval (submitted) : submit = 1 && app = null                 
3 - rejected : app = 2                 
4 - approved : (app = 1 || app = 4) && upload = 0                 
5 - Finance_approved                 
*/                 
@search_value varchar(100)='',                 
@l2_org_unit  char(16)= NULL,                 
@l2_location_code     char(16) = NULL,                 
@l3_org_unit  char(16)= NULL,                 
@l3_location_code     char(16) = NULL,                 
@from_fin_menu  int=NULL                  
                 
/* WITH RECOMPILE */                 
AS                 
/********************* Copyright 1996 Paradigm Technologies, Inc.*********************************                 
* All Rights Reserved                                                               *                 
*                                                                                       *                 
* This Media contains confidential and proprietary information of               *                 
* Paradigm Technologies, Inc.  No disclosure or use of any portion            *                 
* of the contents of these materials may be made without the express            *                 
* written consent of Paradigm Technologies, Inc.                                  *                 
*** Use of this software is restricted and governed by a License                  *                 
* Agreement.  This software contains confidential and proprietary               *                 
* information of Paradigm Technologies, Inc. and is protected by              *                 
* copyright, trade secret and trademark law.                                      *                 
*                                                                                       *                 
* *********************************************************************************************                 
*                                                                     *                 
*         Name:                                                       *                 
*       Module:Approvals                                              *                 
* Date created:4/2/98                                                 *
* By:WayneT                                           *                 
*      Version:                                                       *                 
*      Comment:                                                       *                 
*                                *                 
* Date revised:                                                       *                 
*           By:                                                       *                 
*      Comment:                                       *                 
*                                                                     *                 
*                                                                     *                 
***********************************************************************/                 
IF (@from_fin_menu is NULL)                 
SELECT @from_fin_menu=0                 
if @sort_by  = 0       
 set @sort_by =2                   
DECLARE                 
@trx_type_form INT,               
@trx_type_to INT,                 
@app1 int,                 
@app2 int,                 
@app3 int,                 
@app4 int,                 
@app5 int,                 
@upload1 int,                 
@upload2 int,   
@submit1 int,                 
@submit2 int                 
,@napp1 int                 
,@napp2 int                 
,@napp3 int                 
,@napp4 int                 
,@napp5 int,                 
@finalise1 int,                 
@finalise2 int                 
                 
                 
                
            
DECLARE @path varchar(255),                 
@override_path varchar(255),                 
@override_yes_path varchar(255),                 
@default_code varchar(255),                 
@overrride_default_code varchar(255)                 
               
SELECT @path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'                 
SELECT @override_path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'                 
SELECT @override_yes_path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'                 
                 
                
                 
SELECT @default_code=default_code                 
FROM plv_rule_group                 
WHERE path=@path                 
and user_group_code is NULL                 
                 
SELECT @overrride_default_code=default_code                 
FROM plv_rule_group                 
WHERE path=@override_path                 
and user_group_code is NULL                 
                 
                 
               
                 
                 
                 
CREATE TABLE #tmp_resources                 
( resource_id char(16),                 
name_first  varchar(32) ,                 
name_last   varchar(32),                 
level2_key  varchar(32),                 
level3_key  varchar(64),                 
/*  trx_type    int         */                 
record_id   char(16) Null,                 
transaction_id char(16) NULL,                 
summary_flag   tinyint,                 
approval_flag  int Null,                 
submitted_flag int Null,                 
upload_flag    int Null,                 
finalise_flag  int Null                 
                    
)                 

CREATE UNIQUE CLUSTERED INDEX Idx1 ON #tmp_resources(resource_id,level2_key,level3_key,record_id,transaction_id);       

                 
Create Table #ValidForRule                 
(record_id char(16))                 
                 
CREATE TABLE #tmp_Level2                 
( level2_key varchar(32) null ,level3_key varchar(64) null,level_category_code varchar(16) null,trx_approval_required_flag tinyint null)                 
                 
CREATE TABLE #tmp_Level3                 
( company_code int null                 
,level2_key varchar(32) null                 
,level3_key varchar(64) null                 
,trx_approval_flag int null                 
,level3_status int null                 
,level_category_code char(16) Null                 
)                 
 
                 
                 
                 
IF @Approval_Mode = 1                    
BEGIN                 
SELECT                 
@submit1=0                 
,@submit2=0                 
,@app1 = 0                 
,@app2 = 0                 
,@app3 = 0 /* 2 Show in the Rejected records if unsubmitted and rejected */                 
,@app4 = 0                 
,@app5 = 9                  
,@napp1 = 2                 
,@napp2 = 2                 
,@napp3 = 2   
,@napp4 = 2                 
,@napp5 = 2                 
,@upload1 = 0                 
,@upload2 = 9                  
,@finalise1=0                 
,@finalise2=9                 
END                 
IF @Approval_Mode = 2                    
BEGIN                 
SELECT                 
@submit1=1                 
,@submit2=1                 
,@app1 = 0                 
,@app2 = 2                 
,@app3 = 9                 
,@app4 = 9                 
,@app5 = 9   
,@napp1 = 2                 
,@napp2 = 2                 
,@napp3 = 2                 
,@napp4 = 2                 
,@napp5 = 2                 
,@upload1 = 0                 
,@upload2 = 9                  
,@finalise1=0                 
,@finalise2=9                 
END                 
                 
IF @Approval_Mode = 3                    
BEGIN                 
SELECT                 
@submit1=0                 
,@submit2=0 /* 1 */                 
,@app1 = 2                 
,@app2 = 2 /* 2 */                 
,@app3 = 2 /* 2 */                 
,@app4 = 2                 
,@app5 = 2 /* 2 */                 
,@napp1 = -1                 
,@napp2 = -1                 
,@napp3 = -1                 
,@napp4 = -1                 
,@napp5 = -1                 
,@upload1 = 0                 
,@upload2 = 9                  
,@finalise1=0                 
,@finalise2=9                 
END                 
IF @Approval_Mode = 4                    
BEGIN                 
SELECT                 
@submit1=1                 
,@submit2=1                 
,@app1 = 1                 
,@app2 = 4                 
,@app3 = 4                 
,@app4 = 4                 
,@app5 = 4                 
,@napp1 = 0                
,@napp2 = 2                 
,@napp3 = 9                 
,@napp4 = 9                 
,@napp5 = 9                 
,@upload1 = 0                 
,@upload2 = 9                 
,@finalise1=0                 
,@finalise2=9                 
END                 
IF @Approval_Mode = 5                    
BEGIN                 
SELECT                 
@submit1=1                 
,@submit2=1                 
,@app1 = 1                 
,@app2 = 4                 
,@app3 = 4                 
,@app4 = 4                 
,@app5 = 4                 
,@napp1 = 0                 
,@napp2 = 2                 
,@napp3 = 9                 
,@napp4 = 9                 
,@napp5 = 9                 
,@upload1 = 0                 
,@upload2 = 9                 
,@finalise1=1                 
,@finalise2=1                 
END                 
                 
IF @trx_type = 0 /* Time */                 
BEGIN                 
SELECT @trx_type_form = 1000, @trx_type_to = 1999                 
END                 
IF @trx_type = 1 /*Expenses*/                 
BEGIN                 
SELECT @trx_type_form = 2000, @trx_type_to = 2999                 
END                 
                 
create table #temp1(resource_id char(16), record_id char(16), cnt int, cnt2 int, name_first varchar(30), name_last varchar(30))  -- AS20110429                 
                 
IF @from_fin_menu = 1 and @Approval_mode = 4 and @trx_type = 1 and (rtrim(@overrride_default_code)=rtrim(@override_yes_path))                
 BEGIN                
/* AS071709 Incorrect logic incase of partial approvals                
  --Select 'here'                
  SELECT DISTINCT                
   d.resource_id,                
   c.name_first,                
   c.name_last                
   FROM pld_transactions d                
   JOIN plv_resource_all c                
   ON c.resource_id = d.resource_id                
   AND c.company_code = d.company_code                
   JOIN pld_transactions_hdr h                
   ON h.record_id=d.record_id                
   AND h.company_code=d.company_code                
   WHERE d.company_code   = @company_code                
 AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                
   AND isnull(upload_flag,0) = 0                
   AND isnull(approval_flag,0) in (1,4)                
   AND isnull(finalise_flag, 0) = 0                
   AND isnull(approver_id, '') <> ''                
   /*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                
   AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                
   AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                
   AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)*/                
   --AND ((h.approver_id is not NULL) and (h.approver_id <> ''))                
   --AND h.record_id not in (select record_id from #tmp_resources)                
*/                
      
/* -- AS20130118 changed the code to speed up the process. see below                
-- AS071709 instead this logic                
   -- AS20110429 create table #temp1(resource_id char(16), record_id char(16), cnt int, cnt2 int, name_first varchar(30), name_last varchar(30))                
                
   insert #temp1                
   select d.resource_id, d.record_id, count(*), 0, c.name_first, c.name_last                
   from pld_transactions d                 
   JOIN plv_resource_all c                
   ON c.resource_id = d.resource_id                
   AND c.company_code = d.company_code                
   JOIN pld_transactions_hdr h                
   ON h.record_id = d.record_id                
   AND h.company_code = d.company_code                
   WHERE d.company_code   = @company_code            
   -- AND d.trx_type BETWEEN 2000 AND 2999                
AND d.trx_type = 2001              
   AND isnull(d.upload_flag,0) = 0                
   AND isnull(d.approval_flag,0) in (1,4)                
   AND isnull(d.finalise_flag, 0) = 0                
   AND isnull(h.approver_id, '') <> ''                
   group by d.resource_id, d.record_id, c.name_first, c.name_last                
                   
   select d.resource_id, d.record_id, count(*) as cnt2                
   into #temp2                
   from pld_transactions d                
                   
   JOIN plv_resource_all c                
   ON c.resource_id = d.resource_id                
   AND c.company_code = d.company_code                
                   
   JOIN pld_transactions_hdr h                
   ON h.record_id = d.record_id                
   AND h.company_code = d.company_code                
                   
   WHERE d.company_code = @company_code -- 1                
   -- AND d.trx_type BETWEEN 2000 AND 2999                
   AND d.trx_type = 2001              
   AND isnull(upload_flag,0) = 0                
   AND isnull(approval_flag,0) not in (1,4)                
   AND isnull(finalise_flag, 0) = 0                
   AND isnull(approver_id, '') <> ''                
   group by d.resource_id, d.record_id                
*/                   
      
-- AS20130118 to avoid 2 scann to pld_transactions table and speed up the search      
   
 create table #pld_transactions(company_code int, resource_id char(16), record_id char(16), name_first varchar(32), name_last varchar(32), trx_type int, approval_flag int)      
 insert into #pld_transactions (company_code, resource_id, record_id, name_first, name_last, trx_type, approval_flag)    
 select d.company_code, d.resource_id, d.record_id, name_first, name_last, d.trx_type, approval_flag      
 from pld_transactions d      
 JOIN plv_resource_all c ON c.resource_id = d.resource_id AND c.company_code = d.company_code                    
 JOIN pld_transactions_hdr h ON h.record_id = d.record_id AND h.company_code = d.company_code                    
 WHERE d.company_code   = @company_code                
 AND d.trx_type = 2001                  
 AND isnull(d.upload_flag,0) = 0                    
 AND isnull(d.finalise_flag, 0) = 0                    
 AND isnull(h.approver_id, '') <> ''                    
   
 insert #temp1                    
 select d.resource_id, d.record_id, count(*), 0, d.name_first, d.name_last                    
 from #pld_transactions d       
WHERE isnull(d.approval_flag,0) in (1,4)                    
 group by d.resource_id, d.record_id, d.name_first, d.name_last                    
                       
 select d.resource_id, d.record_id, count(*) as cnt2                    
 into #temp2                    
 from #pld_transactions d                    
 WHERE isnull(approval_flag,0) not in (1,4)                    
 group by d.resource_id, d.record_id                    
                   
 update #temp1 set #temp1.cnt2 = #temp2.cnt2                
 from #temp1, #temp2                
 WHERE #temp1.resource_id = #temp2.resource_id                
 and #temp1.record_id = #temp2.record_id                
                   
 select distinct resource_id, name_first, name_last from #temp1 where cnt2 = 0              
order by 3                
 drop table #temp1                
 drop table #temp2                

 RETURN                
                
 END                
                
create table #temp1a(resource_id char(16), record_id char(16), cnt int, cnt2 int, name_first varchar(30), name_last varchar(30))              
              
IF @from_fin_menu <> 1 and @Approval_mode = 2 and @trx_type = 1 and (rtrim(@overrride_default_code)=rtrim(@override_yes_path))              
and @l2_org_unit = '' and @l2_location_code = '' and  @l3_org_unit = '' and @l3_location_code = ''               
              
BEGIN              
              
   insert #temp1a              
   select d.resource_id, d.record_id, count(*), 0, '', ''--c.name_first, c.name_last              
   from pld_transactions d               
   WHERE d.company_code   = @company_code              
   AND d.trx_type = 2001              
   AND isnull(d.upload_flag,0) = 0              
   AND isnull(d.approval_flag,0) = 0              
   AND isnull(d.finalise_flag, 0) = 0              
   AND isnull(d.submitted_flag, 0) = 1              
   group by d.resource_id, d.record_id--, c.name_first, c.name_last              
                 
   insert #temp1              
   select d.resource_id, d.record_id, count(*), 0, c.name_first, c.name_last              
   from #temp1a d               
   JOIN plv_resource_all c              
   ON c.resource_id = d.resource_id              
   JOIN pld_transactions_hdr h              
   ON h.record_id = d.record_id              
   WHERE h.company_code   = @company_code              
   AND  c.company_code   = @company_code              
   AND isnull(h.approver_id, '') = @manager_id              
   group by d.resource_id, d.record_id, c.name_first, c.name_last              
           
   delete #temp1a              
              
   insert #temp1a              
   select d.resource_id, d.record_id, 0, count(*) as cnt2, '', ''              
   from pld_transactions d 
   where d.company_code = @company_code              
   AND d.trx_type = 2001               
   AND isnull(d.upload_flag,0) = 0              
   and isnull(d.approval_flag, 0) not in (0, 1, 4) -- AS20130725 Rejected cases not to be included
   AND isnull(d.finalise_flag, 0) = 0              
   group by d.resource_id, d.record_id              

--   AND isnull(d.approval_flag,0) <> 0           
/* -- AS20130725
   AND (isnull(d.approval_flag,1) <> 1      
   or d.approval_flag <> 4)-- AA20120510              
   AND isnull(d.finalise_flag, 0) = 0              
   group by d.resource_id, d.record_id              
*/

 select d.resource_id, d.record_id, count(*) as cnt2              
   into #temp2a              
   from #temp1a d              
   JOIN plv_resource_all c ON c.resource_id = d.resource_id              
   JOIN pld_transactions_hdr h ON h.record_id = d.record_id              
   WHERE c.company_code = @company_code              
   AND h.company_code = @company_code              
   AND isnull(h.approver_id, '') = @manager_id 
   group by d.resource_id, d.record_id              

  update #temp1 set #temp1.cnt2 = isnull(#temp1.cnt2, 0) + #temp2a.cnt2              
   from #temp1, #temp2a              
   WHERE #temp1.resource_id = #temp2a.resource_id              
   and #temp1.record_id = #temp2a.record_id              

   -- AS20130725 select distinct resource_id, name_last, name_first from #temp1 where cnt2 = 0        -- AA20120423      
   select distinct resource_id, name_first, name_last from #temp1 where cnt > 0 and cnt2 = 0       -- AS20130725        
      order by 3 
   drop table #temp1              
   drop table #temp2a              
   RETURN              
              
END              
                
                
/*Y.Y.20001031 Insert L3's */                 
insert #tmp_Level2 (Level2_key,level_category_code,trx_approval_required_flag)                 
select distinct plv_level2.Level2_key,plv_level2.level_category_code,plv_level2.trx_approval_required_flag                 
 from plv_level2                 
 where plv_level2.company_code = @company_code                 
 and plv_level2.trx_approval_required_flag in (1,2)                 
 --and plv_level2.level2_status = 1         ASIMJAMIL201202 Include every level2        
                 
                 
INSERT INTO #tmp_Level3                 
( company_code                 
,level2_key                 
,level3_key                 
,trx_approval_flag                 
,level3_status                 
)                 
SELECT                 
company_code                 
,Level2_key                 
,level3_key                 
,trx_approval_flag                 
,level3_status                 
FROM plv_level3 L3                 
WHERE company_code = @company_code                 
AND trx_approval_flag In (1,2)                 
--AND level3_status = 1             ASIMJAMIL201202 Include every level3            
AND EXISTS (                 
SELECT 1 FROM #tmp_Level2                 
WHERE #tmp_Level2.level2_key = L3.level2_key                 
)                 
                 
/*Y.Y.20001031 Insert Generic L3's if they do not exist in reg L3 table*/                 
INSERT #tmp_Level3                 
( company_code                 
,level2_key                 
,level3_key                 
,trx_approval_flag                 
,level3_status                 
,level_category_code                 
)               
SELECT                 
company_code                 
,Null Level2_key                 
                 
,level3_key                 
,trx_approval_flag                 
,Null level3_status                 
,level_category_code                 
FROM plv_generic_level3                 
WHERE company_code =@company_code                 
AND trx_approval_flag = 1                 
AND level3_key NOT IN (                 
SELECT level3_key                 
FROM plv_level3                 
WHERE company_code = @company_code                 
--AND level3_status = 1                 ASIMJAMIL201202 Include every level2        
)                 
                 
         Create Table #ValidL2OrgUnit                 
(org_unit varchar(16)                 
)                 
                 
Create Table #ValidL3OrgUnit                 
(org_unit varchar(16)                 
)                 
                 
                 
INSERT INTO #ValidL2OrgUnit(org_unit)                 
SELECT @l2_org_unit                 
                 
INSERT INTO #ValidL3OrgUnit(org_unit)                 
SELECT @l3_org_unit                 
                              
IF ((@from_fin_menu=1) and (@approval_mode in (4,5)) and (@trx_type = 1))                  
 or ((@trx_type=1) and (@overrride_default_code=@override_yes_path))                 
BEGIN                 
 SELECT @l2_org_unit=''                 
 SELECT @l2_location_code=''                 
 SELECT @l3_org_unit=''                 
 SELECT @l3_location_code=''                   
END             
                 
                 
if @l2_org_unit is not null and @l2_org_unit <> ''                 
BEGIN                 
 DELETE FROM #tmp_Level2                 
 where level2_key  not in  (select level2_key from plv_level2 where org_unit in                 
     (SELECT org_unit from #ValidL2OrgUnit)                 
 )                 
                 
 DELETE FROM #tmp_Level3                 
 where level2_key  not in  (select level2_key from plv_level2 where org_unit in                 
     (SELECT org_unit from #ValidL2OrgUnit)                 
 )                 
END                 
                 
if @l2_location_code is not null and @l2_location_code <> ''                 
BEGIN                 
 DELETE FROM #tmp_Level2                 
 where level2_key  not in  (select level2_key  from plv_level2 where location_code = @l2_location_code)                 
                 
 DELETE FROM #tmp_Level3                 
 where level2_key  not in  (select level2_key  from plv_level2 where location_code = @l2_location_code)                 
END                 
                 
if @l3_org_unit is not null and @l3_org_unit <> ''                 
BEGIN                 
 DELETE FROM #tmp_Level3                 
 where level3_key  not in  (select level3_key  from plv_level3 where level2_key=#tmp_Level3.level2_key and                 
   org_unit in (SELECT org_unit from #ValidL3OrgUnit)                 
 )                 
                 
END                 
                 
if @l3_location_code is not null and @l3_location_code <> ''                
BEGIN                 
 DELETE FROM #tmp_Level3                 
 where level3_key  not in  (select level3_key  from plv_level3 where level2_key=#tmp_Level3.level2_key and                 
  location_code = @l3_location_code)                 
END                 
                 
                 
                 
Create Table #temp_optimize                 
(                 
resource_id varchar(16),                 
level2_key varchar(32),                 
level3_key varchar(64)                 
)                 
                 
                 
IF @trx_type = 0                 
BEGIN                 
 SELECT @trx_type_form = 1000, @trx_type_to = 1999                 
                 
 insert into #temp_optimize                 
 (                 
 resource_id ,                 
 level2_key,                 
 level3_key                 
 )                 
 SELECT DISTINCT                 
 d.resource_id                 
 ,d.level2_key                 
 ,d.level3_key                 
 FROM pld_transactions d                 
 WHERE d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
 AND ISNULL(d.submitted_flag,0) in (@submit1, @submit2)                 
 AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
 AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
                  
END                 
Else if @trx_type = 1                 
Begin                 
 SELECT @trx_type_form = 2000, @trx_type_to = 2999                 
                 
 insert into #temp_optimize             
 (                 
 resource_id ,                 
 level2_key,                 
 level3_key                 
 )                 
 SELECT DISTINCT                 
 d.resource_id                 
 ,d.level2_key     
 ,d.level3_key                 
 FROM pld_transactions d                 
 WHERE d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
 AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
 
 /*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
 AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
 AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
 AND isnull(d.finalise_flag,9) in (@finalise1, @finalise2) */                 
                 
END                 
                 
                 
                 
create Table #tamp_valid_level2                 
(            
level2_key varchar(32),                 
level3_key varchar(64),                 
isPM int                  
)                 
            
/*                 
Case ISt: Where level2_key is not null                 
*/                 
Create Table #temp_pm_level2                 
(level2_key varchar(32)                 
)                 
                 
Create Table #temp_sup                 
(resource_id varchar(16)                 
)                 
                 
IF ((@from_fin_menu=1) and (@approval_mode in (4,5)) and (@trx_type = 1))                  
 or ((@trx_type=1) and (@overrride_default_code=@override_yes_path))                 
BEGIN                 
	INSERT into #temp_pm_level2                  
	SELECT level2_key  FROM plv_level2 a                 
	WHERE a.company_code = @company_code --AND a.level2_status = 1         ASIMJAMIL201202 Include every level2             
	              
	INSERT into #temp_sup                 
	SELECT resource_id  FROM plv_resource_all plv_r                 
	WHERE plv_r.company_code=@company_code                 
END                 
ELSE                 
BEGIN                 
	INSERT into #temp_pm_level2                  
	SELECT level2_key FROM plv_level2_resource a                 
	WHERE a.company_code = @company_code 
	--AND a.active_flag = 1                  ak 20150424
	AND a.position_category_code = 1                 
	and resource_id = @manager_id                 
/*	-- AS20131129
	INSERT into #temp_sup                 
	SELECT resource_id FROM plv_resource_all plv_r                 
	WHERE plv_r.company_code=@company_code                 
	and isnull(reports_to,'') = @manager_id                 
*/
	INSERT into #temp_sup                 
	SELECT resource_id FROM plv_resource_all plv_r                 
	WHERE plv_r.company_code=@company_code                 
	and isnull(reports_to,'') = @manager_id       
	 --and (termination_date is null or year(termination_date) = year(getdate()))               
 and (termination_date is null or  termination_date >  dateadd(year, -2, getdate())) /*arif hasan 20150422  the termination date should be in last one year other wise dont show the data email refrence FW: Issues with Time Approvals (ESM-1860)*/  
 
	
END                 
                 
insert into #tamp_valid_level2                 
(             
level2_key,                 
level3_key,                 
isPM                 
)                 
select                 
d.level2_key,                 
d.level3_key,                 
1                 
FROM #tmp_Level3 join #temp_optimize d                 
on d.Level3_key = #tmp_Level3.level3_key                 
Where  #tmp_Level3.level2_key Is not Null                 
AND  #tmp_Level3.level2_key = d.level2_key                 
AND #tmp_Level3.trx_approval_flag = 1                 
and #tmp_Level3.level2_key in (SELECT level2_key FROM #temp_pm_level2)                 
                 
insert into #tamp_valid_level2       
(                 
level2_key,                 
level3_key,                 
isPM                 
)                 
                 
SELECT                 
d.level2_key,                 
d.level3_key,     
1                 
FROM #tmp_Level2 join #temp_optimize d                 
on #tmp_Level2.level2_key = d.level2_key                 
join #tmp_Level3                 
on #tmp_Level2.level_category_code = #tmp_Level3.level_category_code      
Where #tmp_Level3.level2_key Is Null                 
AND #tmp_Level2.level_category_code is not null                 
AND #tmp_Level2.trx_approval_required_flag = 1                 
and #tmp_Level2.level2_key in (SELECT level2_key FROM #temp_pm_level2)                 
                 
insert into #tamp_valid_level2                 
(                 
level2_key,                 
level3_key,                 
isPM                 
)                 
                 
select                 
d.level2_key,                 
d.level3_key,                 
0           
FROM #tmp_Level3 join #temp_optimize d                 
on d.Level3_key = #tmp_Level3.level3_key                 
Where  #tmp_Level3.level2_key Is not Null                 
AND  #tmp_Level3.level2_key = d.level2_key                 
AND #tmp_Level3.trx_approval_flag = 2                 
and resource_id in (SELECT resource_id FROM #temp_sup)                 
                 
                 
insert into #tamp_valid_level2                 
(                 
level2_key,                 
level3_key,                 
isPM                 
)                 
                 
SELECT                 
d.level2_key,                 
d.level3_key,                 
0                 
FROM #tmp_Level2 join #temp_optimize d                 
on #tmp_Level2.level2_key = d.level2_key                 
join #tmp_Level3                 
on #tmp_Level2.level_category_code = #tmp_Level3.level_category_code                 
Where #tmp_Level3.level2_key Is Null                 
AND #tmp_Level2.level_category_code is not null                 
AND #tmp_Level2.trx_approval_required_flag = 2                 
and resource_id in (SELECT resource_id FROM #temp_sup)                 
                 
IF @trx_type = 0 /* Time */                 
BEGIN                 
	                 
	INSERT #tmp_resources (                 
	resource_id,                 
	name_first,                 
	name_last,                 
	record_id,                 
	transaction_id,                  
	level2_key,                 
	level3_key                  
	/* d.trx_type     */                 
	)                 
	SELECT DISTINCT                 
	d.resource_id,                 
	c.name_first,                 
	c.name_last,                 
	                 
	d.record_id,                  
	d.transaction_id,                   
	d.level2_key,                 
	d.level3_key                 
	/* d.trx_type     */               
	-- AS20131129 FROM  plv_resource_all c, pld_transactions d                 
	FROM  plv_resource_all c, pld_transactions d                 
	WHERE c.company_code = d.company_code                 
	AND d.company_code = @company_code                 
	                 
	AND c.resource_id = d.resource_id                 
	AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
	AND ISNULL(d.submitted_flag,0) in (@submit1, @submit2)                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
	AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=1)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=1)                 
	                 
	INSERT #tmp_resources (                 
	resource_id,                 
	name_first,     
	name_last,                 
	record_id,                 
	transaction_id,                   
	level2_key,                 
	level3_key                  
	/* d.trx_type     */                 
	)    
	SELECT DISTINCT                 
	d.resource_id,                 
	c.name_first,                 
	c.name_last,                 
	                 
	d.record_id,                  
	d.transaction_id,                  
	d.level2_key,                 
	d.level3_key                 
	/* d.trx_type     */                 
	-- AS20131129 FROM  plv_resource_all c, pld_transactions d                 
	FROM  plv_resource_all c, pld_transactions d  
	WHERE c.company_code = d.company_code                 
	AND d.company_code = @company_code                 
	                 
	AND c.resource_id = d.resource_id                 
	AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
	AND ISNULL(d.submitted_flag,0) in (@submit1, @submit2)                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
	AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=0)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=0)                 
	AND d.resource_id in (SELECT resource_id FROM #temp_sup)                 
            
END                 
                 
                 
IF @trx_type = 1 /* EXPENSE */                 
BEGIN                 
                   
	/*IF @Approval_Mode = 5   -- finance_approved                 
	BEGIN                 
	IF (@default_code=2)                   
	BEGIN                   

	INSERT #tmp_resources (                 
	resource_id,                 
	name_first,                 
	name_last,                 
	record_id,                 
	transaction_id,                  
	level2_key,                 
	level3_key                  

	)                 
	SELECT DISTINCT                 
	d.resource_id,                 
	c.name_first,                 
	c.name_last,                 
	d.record_id,                 
	d.transaction_id,                  
	d.level2_key,                 
	d.level3_key                  

	FROM plv_resource_all c, pld_transactions d                 
	WHERE d.company_code   = @company_code                 
	AND c.resource_id = d.resource_id                 
	AND c.company_code = d.company_code                 

	AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
	AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
	AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )         
	AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)                 

	END                 
	END                 
	ELSE                 
	BEGIN*/                 

	INSERT #tmp_resources (                 
	resource_id,                 
	name_first,                 
	name_last,                 
	record_id,                 
	transaction_id,                   
	level2_key,                 
	level3_key,                 
	approval_flag,                 
	submitted_flag,                 
	upload_flag,                 
	finalise_flag,                 
	summary_flag                 
	/* d.trx_type     */                 
	)                 
	SELECT DISTINCT                 
	d.resource_id,                 
	c.name_first,                 
	c.name_last,                 
	d.record_id,                 
	d.transaction_id,                   
	d.level2_key,                 
	d.level3_key,                 
	d.approval_flag,                 
	d.submitted_flag,                 
	d.upload_flag,                 
	d.finalise_flag,                 
	0                 
	/* d.trx_type  */                 
	FROM pld_transactions d                 
	JOIN plv_resource_all c                 
	ON c.resource_id = d.resource_id                 
	AND c.company_code = d.company_code      
	JOIN pld_transactions_hdr h                 
	ON h.record_id=d.record_id                 
	AND h.company_code=d.company_code                 
	WHERE d.company_code   = @company_code                 

	AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                  
	/*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
	AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
	AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)*/                 
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=1)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=1)                 
	AND ((h.approver_id is NULL) or (h.approver_id = ''))                 

	INSERT #tmp_resources (                 
	resource_id,                 
	name_first,                 
	name_last,                 
	record_id,                 
	transaction_id,                  
	level2_key,                 
	level3_key,                 
	approval_flag,                 
	submitted_flag,                 
	upload_flag,                 
	finalise_flag,                 
	summary_flag                 
	/* d.trx_type     */                 
	)                 
	SELECT DISTINCT                 
	d.resource_id,                 
	c.name_first,                 
	c.name_last,                 
	d.record_id,                 
	d.transaction_id,                  
	d.level2_key,                 
	d.level3_key,                 
	d.approval_flag,                 
	d.submitted_flag,                 
	d.upload_flag,                 
	d.finalise_flag,                 
	0                 
	/* d.trx_type     */                 
	FROM pld_transactions d                 
	JOIN plv_resource_all c                 
	ON c.resource_id = d.resource_id                 
	AND c.company_code = d.company_code                 
	JOIN pld_transactions_hdr h                 
	ON h.record_id=d.record_id                 
	AND h.company_code=d.company_code                 
	WHERE d.company_code   = @company_code                 

	AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                  
	/*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
	AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
	AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
	AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)*/                 
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=0)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=0)                 
	AND d.resource_id in (SELECT resource_id FROM #temp_sup)                 
	AND ((h.approver_id is NULL) or (h.approver_id = ''))                 

   
	IF ((@from_fin_menu=1) and (@approval_mode in (4,5)))                  
	BEGIN                 
		INSERT #tmp_resources(                 
		resource_id,                 
		name_first,                 
		name_last,                 
		record_id,                 
		transaction_id,                  
		level2_key,                 
		level3_key,                 
		approval_flag,                 
		submitted_flag,                 
		upload_flag,                 
		finalise_flag,                 
		summary_flag                 
		/* d.trx_type     */                 
		 )                 
		SELECT DISTINCT       
		d.resource_id,                 
		c.name_first,                 
		c.name_last,                 
		d.record_id,                 
		d.transaction_id,                  
		d.level2_key,                 
		d.level3_key,                 
		d.approval_flag,                 
		d.submitted_flag,                 
		d.upload_flag,                 
		d.finalise_flag,                 
		0                 
		/* d.trx_type     */                 
		FROM pld_transactions d                 
		JOIN plv_resource_all c                 
		ON c.resource_id = d.resource_id                 
		AND c.company_code = d.company_code                 
		JOIN pld_transactions_hdr h                 
		ON h.record_id=d.record_id                 
		AND h.company_code=d.company_code                 
		WHERE d.company_code   = @company_code                 
		AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
		AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                  
		/*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
		AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
		AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
		AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)*/                 
		                
		AND h.record_id not in (select record_id from #tmp_resources)                 
	END                 
	ELSE                  
	BEGIN                 
		INSERT #tmp_resources(                 
		resource_id,                 
		name_first,                 
		name_last,                 
		record_id,                 
		transaction_id,                  
		level2_key,                 
		level3_key,                 
		approval_flag,                 
		submitted_flag,                 
		upload_flag,                 
		finalise_flag,                 
		summary_flag                 
		/* d.trx_type     */                 
		)                 
		SELECT DISTINCT                 
		d.resource_id,                 
		c.name_first,                 
		c.name_last,                 
		d.record_id,                 
		d.transaction_id,                  
		d.level2_key,                 
		d.level3_key,                 
		d.approval_flag,                 
		d.submitted_flag,                 
		d.upload_flag,                 
		d.finalise_flag,                 
		0                 
		/* d.trx_type     */                 
		FROM pld_transactions d                 
		JOIN plv_resource_all c                 
		ON c.resource_id = d.resource_id                 
		AND c.company_code = d.company_code                 
		JOIN pld_transactions_hdr h                 
		ON h.record_id=d.record_id                 
		AND h.company_code=d.company_code                 
		WHERE d.company_code   = @company_code                 
		AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
		AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                  
		/*AND isnull(d.submitted_flag,0) in (@submit1, @submit2)                 
		AND ISNULL(d.upload_flag,0) in (@upload1, @upload2)                 
		AND isnull(d.approval_flag,9) in (@app1, @app2, @app3, @app4, @app5 )                 
		AND isnull(d.finalise_flag,9) in (@finalise1,@finalise2)*/                 
		AND isnull(h.approver_id,'')=@manager_id                 
		AND h.record_id not in (select record_id from #tmp_resources)                 
	END                   
                 
	IF (@overrride_default_code <> @override_yes_path)                 
	BEGIN                 
                    
		UPDATE #tmp_resources                 
		SET approval_flag=1                 
		FROM #tmp_resources vr       
		WHERE level2_key in (select level2_key from plv_level2 where trx_approval_required_flag=0)                 
		and submitted_flag=1                 
		and isnull(approval_flag,0) != 1                 

		UPDATE #tmp_resources                 
		SET approval_flag=1                 
		FROM #tmp_resources vr                 
		WHERE level2_key in (select level2_key from plv_level2 where trx_approval_required_flag!=0)                 
		and level3_key in (select level3_key from plv_level3 where level2_key=vr.level2_key and trx_approval_flag=0)                 
		and submitted_flag=1                 
		and isnull(approval_flag,0) != 1                 

		UPDATE #tmp_resources                 
		SET approval_flag=1                 
		FROM #tmp_resources vr                 
		WHERE level2_key in (select level2_key from plv_level2 where trx_approval_required_flag!=0)               
		and level3_key not in (select level3_Key from plv_level3 where level2_key=vr.level2_key)                 
		and level3_key in ( select level3_Key from plv_generic_level3 pgl3           
		JOIN plv_level2 plv2                 
		ON plv2.level_category_code=pgl3.level_category_code                 
		where plv2.level2_key=vr.level2_key                 
		and trx_approval_flag=0)                 
		and submitted_flag=1                 
		and isnull(approval_flag,0) != 1                 
	END                   
                 
	UPDATE #tmp_resources                 
	SET  summary_flag = 3                  
	WHERE record_id IN (                 
	Select #tmp_resources.record_id                 
	FROM #tmp_resources                  
	WHERE IsNull(#tmp_resources.approval_flag,9) = 2 /*Rejected*/                 
	AND IsNull(#tmp_resources.submitted_flag,0) = 0 /*Unsubmitted*/                 
	AND IsNull(#tmp_resources.upload_flag,0) =0                 
	AND IsNull(#tmp_resources.finalise_flag,0) =0                 
	)                 
	              
	UPDATE #tmp_resources                 
	SET  summary_flag = 1                 
	WHERE record_id IN (                 
	Select #tmp_resources.record_id                 
	FROM #tmp_resources                  
	WHERE IsNull(#tmp_resources.approval_flag,9) IN (0,9) /*Unsubmitted*/                 
	AND IsNull(#tmp_resources.submitted_flag,0) = 0 /*Unsubmitted*/                 
	AND IsNull(#tmp_resources.upload_flag,0) =0                 
	AND IsNull(#tmp_resources.finalise_flag,0) =0                 
	)                 
	AND summary_flag != 3                 
	              
	UPDATE #tmp_resources                 
	SET  summary_flag = 2                  
	WHERE record_id IN (                 
	Select DISTINCT #tmp_resources.record_id                 
	FROM #tmp_resources                  
	WHERE IsNull(#tmp_resources.approval_flag,9) in (0,2,9) /*Pending*/                 
	AND IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	AND IsNull(#tmp_resources.upload_flag,0) =0                 
	AND IsNull(#tmp_resources.finalise_flag,0) =0                 
	)                 
	AND summary_flag NOT IN (1,3)                 
	              
	UPDATE #tmp_resources                 
	SET  summary_flag = 4                  
	WHERE record_id IN (                 
	Select #tmp_resources.record_id                 
	FROM #tmp_resources                  
	WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	AND IsNull(#tmp_resources.approval_flag,9) IN (1,4) /*Approved*/                 
	AND IsNull(#tmp_resources.upload_flag,0)=0                 
	AND IsNull(#tmp_resources.finalise_flag,0) =0                 
	)                 
	AND summary_flag NOT IN (1,2,3)                 
              
	IF (@default_code=2)                   
	BEGIN                 
		UPDATE #tmp_resources                 
		SET  summary_flag = 5                  
		WHERE record_id IN (                 
		Select #tmp_resources.record_id                 
		FROM #tmp_resources                   
		WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
		AND IsNull(#tmp_resources.approval_flag,9) IN (1,4) /*Approved*/                 
		AND IsNull(#tmp_resources.upload_flag,0)=0         
		AND IsNull(#tmp_resources.finalise_flag,0) in (1)                 
		)                 
		AND summary_flag NOT IN (1,2,3,4)                 
	END  
	
	
	UPDATE #tmp_resources                 
		SET  summary_flag = 6
		where  summary_flag NOT IN (1,2,3,5)  
		and        @from_fin_menu=1        
	                 
	DELETE FROM #tmp_resources                 
	WHERE ((summary_flag is NULL) or (summary_flag=0))                 
	                 
	IF @Approval_Mode = 1                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 1                 
	END                 
	              
	IF @Approval_Mode = 1  AND (rtrim(@overrride_default_code)=rtrim(@override_yes_path))                          
	BEGIN                       
		DELETE FROM #tmp_resources                      
	END                 
	                 
	IF @Approval_Mode = 2                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 2                 
	END                 
	                 
	IF @Approval_Mode = 3                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 3                 
	END                 
	                 
	IF @Approval_Mode = 4     and @from_fin_menu=0               
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 4                 
	END  
	
		IF @Approval_Mode = 4     and @from_fin_menu=1               
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 6                 
	END                      
	                 
	                  
	IF @Approval_Mode = 5                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 5                 
	END                 
                 
END                 
                 
IF ((@search_value is not NULL) and (@search_value <> ''))                 
BEGIN                 
	SELECT @search_value = char(39)+'%'+@search_value+'%'+char(39)                 
	                  
	IF @sort_by = 1                  
	BEGIN                 
		SELECT DISTINCT                 
		#tmp_resources.resource_id                 
		,RTRIM(#tmp_resources.name_last) as name_last                 
		,RTRIM(#tmp_resources.name_first) as name_first 
			,record_id
	,summary_flag                 
		FROM #tmp_resources                  
		Where resource_id like @search_value                 
		ORDER BY resource_id                 
	END                 
	                  
	IF @sort_by = 2                  
	BEGIN                 
		SELECT DISTINCT                 
		#tmp_resources.resource_id                 
		,RTRIM(#tmp_resources.name_last) as name_last                 
		,RTRIM(#tmp_resources.name_first) as name_first
			,record_id
	,summary_flag                  
		FROM #tmp_resources                  
		Where name_last like @search_value                  
		ORDER BY name_last, resource_id                 
	END                 
	RETURN                 
END                 
                 
IF @sort_by = 1                  
BEGIN                 
	SELECT DISTINCT                 
	#tmp_resources.resource_id                 
	,RTRIM(#tmp_resources.name_last) as name_last                 
	,RTRIM(#tmp_resources.name_first) as name_first 
	,record_id
	,summary_flag                
	FROM #tmp_resources                  
	ORDER BY resource_id                 
END                 
                 
IF @sort_by = 2                  
BEGIN                 
	SELECT DISTINCT                 
	#tmp_resources.resource_id                 
	,RTRIM(#tmp_resources.name_last) as name_last                 
	,RTRIM(#tmp_resources.name_first) as name_first 
	,record_id
	,summary_flag                
	FROM #tmp_resources                  
	ORDER BY name_last, resource_id                 
END                 
   
RETURN                  






go