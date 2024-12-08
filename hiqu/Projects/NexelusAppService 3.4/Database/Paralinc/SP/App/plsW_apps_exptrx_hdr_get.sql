/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_hdr_get]Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsW_apps_exptrx_hdr_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsW_apps_exptrx_hdr_get]
GO

/****** Object:  StoredProcedure [dbo].[plsW_apps_exptrx_hdr_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [plsW_apps_exptrx_hdr_get]    
  @company_code int                          
 ,@resource_id  varchar(16)                          
 ,@date_from    datetime=null                          
 ,@date_to      datetime=null                          
 ,@filter_flag tinyint = 0 --- 0 = No Filter, 1 = Drafts only, 2 = Submitted  3 = Rejected 4 =  Approved 5 = Finance Approved                          
 ,@record_id char(16)=''                       
 , @last_sync_date datetime = null,              
 @subscriber_id int = null,         
@keys xml = null,
@from_fin_menu int
                            
---- plsW_apps_exptrx_hdr_get 10,'EMP000228','02/02/1966','02/02/2006',4                          
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
*   Date revised: 4th june 2015                      
*             By: arif hasan                                  *                          
*        Comment:                       
                    
[plsW_apps_exptrx_hdr_get] 2, 451         
      
'<keys>        
 <key>        
  <record_id>21042015</record_id>        
 </key>        
 <key>         
  <record_id>002</record_id>        
 </key>        
</keys>'                 
******************************************************************** */                          
WITH RECOMPILE
AS                         
 begin            
 IF ISNULL(@record_id,'')<>''
BEGIN
SET @keys ='<keys>        
 <key>        
  <record_id>'+@record_id+'</record_id>        
 </key>                
</keys>'
END
                 
if @keys is not null                                                
 begin  
 print '111'                                              
 exec plsW_apps_exptrx_hdr_List_get                                               
@company_code                   
 ,@resource_id                
 ,@date_from                   
 ,@date_to            
 ,@filter_flag     
 ,@record_id        
 , @last_sync_date 
 ,@subscriber_id 
,@keys  
,@from_fin_menu                                 
                                                 
 return                                                
 end     

       
  select      
 T.c.value('./record_id[1]', 'varchar(64)') record_id      
             into #transaction               
                       FROM     @keys.nodes('/keys/key') T ( c ) 



----*****get resources***-----

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
     
CREATE TABLE #tmp_trx                 
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
finalise_flag  int Null ,
from_fin_menu  int null ,
approved int null ,
approved_id varchar(16) ,
approved_by varchar(32)
           
                    
)    


                 
CREATE TABLE #tmp_fin_resources                 
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
finalise_flag  int Null ,
from_fin_menu  int null              
                    
)                              

CREATE UNIQUE CLUSTERED INDEX Idx1 ON #tmp_trx(resource_id,level2_key,level3_key,record_id,transaction_id,from_fin_menu);       

                 
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
         
select level2_key INTO #managers_level2 FROm pdd_level2_resource l2  
WHERE   l2.position_category_code=1 						 AND l2.active_flag=1

declare @trx_type_form int,@trx_type_to int
SELECT @trx_type_form = 2000, @trx_type_to = 2999 

create table #temp1(resource_id char(16), record_id char(16), cnt int, cnt2 int, name_first varchar(30), name_last varchar(30))  -- AS20110429                 
   
create table #temp1a(resource_id char(16), record_id char(16), cnt int, cnt2 int, name_first varchar(30), name_last varchar(30)) 


insert #tmp_Level2 (Level2_key,level_category_code,trx_approval_required_flag)                 
select distinct plv_level2.Level2_key,plv_level2.level_category_code,plv_level2.trx_approval_required_flag                 
 from plv_level2                 
 where plv_level2.company_code = @company_code                 
 --and plv_level2.trx_approval_required_flag in (1,2)          include  all level2 FS20180518           
 --and plv_level2.level2_status = 1        ASIMJAMIL201202 Include every level2        
                 
    
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
--AND trx_approval_flag In (1,2)      include  all level2 FS20180518    
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
 
               
Create Table #temp_optimize                 
(                 
resource_id varchar(16),                 
level2_key varchar(32),                 
level3_key varchar(64)                 
)                

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
 AND ISNULL(d.upload_flag,0) in (0, 9)                 
                 
  
             
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
                 

IF (@overrride_default_code=@override_yes_path)             
BEGIN     
print 'yes'            
	INSERT into #temp_pm_level2                  
	SELECT level2_key  FROM plv_level2 a                 
	WHERE a.company_code = @company_code --AND a.level2_status = 1         ASIMJAMIL201202 Include every level2             
	              
	INSERT into #temp_sup                 
	SELECT resource_id  FROM plv_resource_all plv_r                 
	WHERE plv_r.company_code=@company_code        
END                 
ELSE                 
BEGIN 
print 'NO'                
	INSERT into #temp_pm_level2                  
	SELECT level2_key FROM plv_level2_resource a                 
	WHERE a.company_code = @company_code 
	--AND a.active_flag = 1                  ak 20150424
	AND a.position_category_code = 1                 
	and resource_id = @resource_id   

	INSERT into #temp_sup                 
	SELECT resource_id FROM plv_resource_all plv_r    
	WHERE plv_r.company_code=@company_code             
	and isnull(reports_to,'') = @resource_id                     
 and (termination_date is null or termination_date >  dateadd(year, -2, getdate())) /*arif hasan 20150422  the termination date should be in last one year other wise dont show the data email refrence FW: Issues with Time Approvals (ESM-1860)*/  
 
	
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
                 
     --select 'Nonchargeable',* from #tmp_trx where level2_key='ADMIN_360i_0000' and level3_key='Nonchargeable'            
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




insert into #tamp_valid_level2            --FS20180517 Include all level3 
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
and #tmp_Level3.level2_key in (SELECT level2_key FROM #temp_pm_level2) 
AND not exists (select * from #tamp_valid_level2 l2 where d.level2_key=  l2.level2_key AND d.level3_key =l2.level3_key)         
------------------------------------------
insert into #tamp_valid_level2            --FS20180517 Include all level3 
(             
level2_key,                 
level3_key,                 
isPM                 
)  
select DISTINCT r.level2_key,
l3.level3_key,
0
--INTO #level2_keys
from pdd_level2_resource r
INNER JOIN #temp_sup s
ON r.resource_id=s.resource_id AND r.position_category_code=1 AND r.active_flag=1
INNER JOIN pdd_level3 l3 ON r.level2_key=l3.level2_key AND l3.trx_approval_flag=1
WHERE r.level2_key IN 
(
select level2_key from pdd_level2_resource
where position_category_code=1 AND active_flag=1
group by level2_key
having count(*) =1
)
AND r.level2_key NOT IN (select level2_key from #tamp_valid_level2)

--select distinct * from #level2_keys



--insert into #tamp_valid_level2                 
--(                 
--level2_key,                 
--level3_key,                 
--isPM                 
--)                 
                 
--SELECT                 
--d.level2_key,                 
--d.level3_key,                 
--0                 
--FROM #tmp_Level2 join #tmp_Level3
--on #tmp_Level2.level2_key =#tmp_Level3.level2_key 
-- join #temp_optimize d        
--on d.Level3_key = #tmp_Level3.level3_key                 
--Where  #tmp_Level3.level2_key Is not Null                 
--AND  #tmp_Level3.level2_key = d.level2_key               
----AND #tmp_Level2.level_category_code is not null                 
--AND #tmp_Level2.trx_approval_required_flag = 1                
--and resource_id in (SELECT resource_id FROM #temp_sup)
--AND d.level2_key NOT IN (select level2_key from #tamp_valid_level2)
----select * from #tamp_valid_level2 where level2_key='AUS005301'


--return




INSERT #tmp_trx (                 
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
	summary_flag ,
	approved_id  ,
	approved_by,
	approved              
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
	0   ,
	h.approver_id ,
	approved_by,
	1             
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
	AND ISNULL(d.upload_flag,0) in (0, 9)                                
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=1)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=1)                 
	--AND ((h.approver_id is NULL) or (h.approver_id = ''))                 
	 --select '333',* from #tmp_trx where record_id='y8d03672d0ec7a4c'-- level2_key='ADMIN_360i_0000' and level3_key='Nonchargeable'
	
	
	

	 
	INSERT #tmp_trx (                 
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
	summary_flag ,
	approved_id ,
	approved_by,
	approved               
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
	0 , 
	h.approver_id,
	approved_by,
	1               
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
	AND ISNULL(d.upload_flag,0) in (0, 9)                                
	AND d.level2_key in (SELECT level2_Key from #tamp_valid_level2 where isPM=0)                 
	AND d.level3_key in (SELECT level3_Key from #tamp_valid_level2 where level2_key=d.level2_key and isPM=0)                 
	AND d.resource_id in (SELECT resource_id FROM #temp_sup)     
	--AND ((h.approver_id is NULL) or (h.approver_id = '')) 
	--SELECT resource_id FROM #temp_sup  where resource_id='202763'
	--select 1,* from #tmp_trx where record_id='o8d24583fa23be20'  
	--return
	---owner transactions
	
	INSERT #tmp_trx (                 
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
	summary_flag ,
	approved_id ,
	approved_by,
	approved               
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
	0 , 
	h.approver_id,
	approved_by,
	1               
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
	--AND ISNULL(d.upload_flag,0) in (0, 9)                                             
	AND d.resource_id =@resource_id 
   AND h.record_id not in (select record_id from #tmp_trx)           
	--AND ((h.approver_id is NULL) or (h.approver_id = ''))   
	----owner transactions  
           

--select * from #tamp_valid_level2 where level2_key='ADMIN_360i_0000' and level3_key='Nonchargeable' 
 --select '1111',* from #tmp_trx where record_id='y8d03672d0ec7a4c'-- level2_key='ADMIN_360i_0000' and level3_key='Nonchargeable'
 	
	if @from_fin_menu=1
	begin 
INSERT #tmp_trx(                 
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
		summary_flag ,
		approved_id,
		approved_by,
		approved

		               
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
		0 ,
		h.approver_id,
		approved_by,
		1 
		             
		/* d.trx_type     */                 
		FROM pld_transactions d                 
		JOIN plv_resource_all c                 
		ON c.resource_id = d.resource_id                 
		AND c.company_code = d.company_code                 
		JOIN pld_transactions_hdr h                 
		ON h.record_id=d.record_id                 
		AND h.company_code=d.company_code                 
		WHERE d.company_code = @company_code 
		AND d.trx_type BETWEEN @trx_type_form AND @trx_type_to                 
		AND ISNULL(d.upload_flag,0) in (0, 9)                 
		AND h.record_id not in (select record_id from #tmp_trx)
--else
end

else
begin 

INSERT #tmp_trx(                 
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
		summary_flag,
		approved_id ,
		approved_by ,
		approved              
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
		0 ,
		h.approver_id ,
	    approved_by ,
		1          
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
		AND ISNULL(d.upload_flag,0) in (0, 9)                                  
		AND isnull(h.approver_id,'')=@resource_id                 
		AND h.record_id not in (select record_id from #tmp_trx)    

end
 
 select distinct record_id into #reocrds from #tmp_trx

 

	SELECT DISTINCT                 
		d.resource_id resource_id,                 
		c.name_first name_first,                 
		c.name_last name_last,                 
		d.record_id record_id,                 
		d.transaction_id transaction_id,                  
		d.level2_key level2_key,                 
		d.level3_key level3_key,                 
		d.approval_flag approval_flag,   
		d.submitted_flag submitted_flag,                 
		d.upload_flag upload_flag,                 
		d.finalise_flag finalise_flag,                 
		0 summary_flag,
		h.approver_id approver_id ,
	    approved_by  approved_by,
		1  approved,
		h.approver_id approved_id        
		/* d.trx_type     */    
		INTO #tmp_resources             
		FROM pld_transactions d                 
		JOIN plv_resource_all c                 
		ON c.resource_id = d.resource_id                 
		AND c.company_code = d.company_code                 
		JOIN pld_transactions_hdr h                 
		ON h.record_id=d.record_id                 
		AND h.company_code=d.company_code                 
		WHERE d.company_code   = @company_code                 
		AND h.record_id   in (select record_id from #tmp_trx) 

	--SELECT * FROM #tmp_resources WHERE from_fin_menu IN (2,3)
	--SELECT * FROM #tmp_resources WHERE from_fin_menu IN (1)
update #tmp_resources
set approved=0
where approved is null


--FS20180528
update t
set t.approval_flag=CASE WHEN l2.trx_approval_required_flag =0 OR l3.trx_approval_flag = 0 THEN 1 ELSE t.approval_flag END
from #tmp_resources t inner join pdd_level2 l2 ON t.level2_key=l2.level2_key
INNER JOIN pdd_level3 l3 ON t.level2_key=l3.level2_key AND t.level3_key=l3.level3_key
WHERE ISNULL(approved_id,'')='' AND IsNull(submitted_flag,0) = 1

--FS20180609
--update t
--set t.approval_flag=1--CASE WHEN l2.trx_approval_required_flag =0 OR l3.trx_approval_flag = 0 THEN 1 END--ELSE t.approval_flag END
--from #tmp_resources tm inner join pld_transactions t  ON tm.record_id=t.record_id
--INNER JOIN pld_transactions_hdr hdr ON t.record_id=hdr.record_id
--inner join pdd_level2 l2 ON t.level2_key=l2.level2_key
--INNER JOIN pdd_level3 l3 ON t.level2_key=l3.level2_key AND t.level3_key=l3.level3_key
--WHERE ISNULL(hdr.approver_id,'')='' AND IsNull(t.submitted_flag,0) = 1
--and isnull(t.approval_flag,0)=0
--and (l2.trx_approval_required_flag =0 or l3.trx_approval_flag = 0)
/*
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
  
  
  ---fin


    
END

*/


 

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
	--and record_id not in (
	--Select #tmp_resources.record_id                 
	--FROM #tmp_resources            
	--WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	--AND IsNull(#tmp_resources.approval_flag,9) in ( 0,1,3,4,5,6,9)
	--AND IsNull(#tmp_resources.upload_flag,0)=0                 
	--AND IsNull(#tmp_resources.finalise_flag,0) =0 

	
	
	--)       
	
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
	--		and record_id not in (
	--Select #tmp_resources.record_id                 
	--FROM #tmp_resources                
	--WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	--AND IsNull(#tmp_resources.approval_flag,9) in (1,2,3,4,5,6)   
	--AND IsNull(#tmp_resources.upload_flag,0)=0                 
	--AND IsNull(#tmp_resources.finalise_flag,0) =0 

	
	
	--)                 
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
	--	and record_id not in (
	--Select #tmp_resources.record_id                 
	--FROM #tmp_resources                  
	--WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	--AND IsNull(#tmp_resources.approval_flag,9) in (1,3,4,5,6)           
	--AND IsNull(#tmp_resources.upload_flag,0)=0                 
	--AND IsNull(#tmp_resources.finalise_flag,0) =0 

	
	
	--)                  
	AND summary_flag NOT IN (1,3)                 
	--select 'o8d4d9550ed915b0',* from #tmp_resources where record_id='o8d4d9550ed915b0'

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
	--and record_id not in (
	--Select #tmp_resources.record_id                 
	--FROM #tmp_resources                  
	--WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
	--AND IsNull(#tmp_resources.approval_flag,9) IN (0,2,3,5,6,9) /*Approved*/ 
	--AND IsNull(#tmp_resources.upload_flag,0)=0                 
	--AND IsNull(#tmp_resources.finalise_flag,0) =0 

	
	
	--)                
	AND summary_flag NOT IN (1,2,3)  
--=7
----------------------------------------------FS20180517
IF exists (select 1 FROM #tmp_resources where  IsNull(#tmp_resources.approval_flag,9) = 2 /*Rejected*/    
	AND IsNull(#tmp_resources.submitted_flag,0) = 0 /*Unsubmitted*/                 
	AND IsNull(#tmp_resources.upload_flag,0) =0                 
	AND IsNull(#tmp_resources.finalise_flag,0) =0)
	BEGIN
		if exists (select 1 FROM #tmp_resources tmp
			WHERE IsNull(tmp.submitted_flag,0) = 1
			AND IsNull(tmp.approval_flag,9) IN (0,9)
			AND IsNull(tmp.upload_flag,0)=0
			AND IsNull(tmp.finalise_flag,0) =0)
		begin
		
		select distinct record_id INTO #recordID FROM #tmp_resources tmp
			WHERE (tmp.summary_flag=3 OR IsNull(tmp.submitted_flag,0) = 1)
			AND IsNull(tmp.approval_flag,9) IN (0,2,9)
			AND IsNull(tmp.upload_flag,0)=0
			AND IsNull(tmp.finalise_flag,0) =0
			
		SELECT * INTO #tmp FROM pld_transactions WHERE record_id IN (select Distinct record_id FROM #recordID)
			--FS20180529
			Alter table #tmp add approver_id varchar(16)
			update t
			set t.approver_id = l2.approver_id
			from #tmp t inner join pld_transactions_hdr l2 ON t.record_id=l2.record_id

			update t
			set t.approval_flag=CASE WHEN l2.trx_approval_required_flag =0 OR l3.trx_approval_flag = 0 THEN 1 ELSE t.approval_flag END
			from #tmp t inner join pdd_level2 l2 ON t.level2_key=l2.level2_key
			INNER JOIN pdd_level3 l3 ON t.level2_key=l3.level2_key AND t.level3_key=l3.level3_key
			WHERE ISNULL(approver_id,'')='' AND ISNULL(submitted_flag,0)=1
		


		
		Select tmp.record_id,l2.trx_approval_required_flag,l3.trx_approval_flag ,approval_flag
		,r.resource_id manager,res.reports_to supervisor,tmp.finalise_flag finalise_flag,tmp.resource_id,tmp.level2_key --dfsdf
		INTO #tmpL
			FROM #tmp tmp
			INNER JOIN pdd_level2 l2 ON tmp.level2_key=l2.level2_key
			INNER JOIN pdd_level3 l3 ON tmp.level2_key=l3.level2_key AND tmp.level3_key=l3.level3_key
			LEFT JOIN pdd_level2_resource r ON r.level2_key=l2.level2_key AND r.position_category_code=1 
			AND r.active_flag=1 AND r.resource_id != tmp.resource_id AND r.resource_id=@resource_id
			INNER JOIN pdd_resources res ON tmp.resource_id=res.resource_id
		
		 --FS20180818 Expense Approval Change
			 UPDATE d
			 SET trx_approval_flag=0
			 from #tmpL d
				LEFT OUTER JOIN #managers_level2 l2 ON l2.level2_key = d.level2_key  
			 WHERE d.trx_approval_flag=1 AND l2.level2_key IS null


			UPDATE d
			 SET trx_approval_flag=2
			 from #tmpL d
			 WHERE 0 = (select Count(*) FROm pdd_level2_resource l2  where  d.level2_key=l2.level2_key  AND l2.position_category_code=1 
						AND l2.resource_id != d.resource_id AND l2.active_flag=1)
			 --AND d.resource_id=@login_id
			 AND d.trx_approval_flag=1
		  
		   --FS20180818 Expense Approval Change

		UPDATE #tmp_resources 
		SET summary_flag=7
		WHERE   record_id IN (select distinct record_id from #tmpL m  --partial approval is not required In override approval AS discussed with Mati 20180606
								WHERE --EXISTS ( 
								--select * from #tmp_resources where record_id =  m.record_id AND ISNULL(approved_id,'')<>'' 
								--AND EXISTS (select * from #tmp_resources WHERE IsNull(approval_flag,9) NOT IN (0,1,3,4,9)  AND record_id =  m.record_id)
								--AND EXISTS (select * from #tmpL WHERE IsNull(approval_flag,9) IN (2) AND record_id =  m.record_id)
								--) OR
								(ISNULL(approved_id,'')='' AND (((NOT EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND (IsNull(approval_flag,9) NOT IN (0,9) )
									  AND record_id = m.record_id ))
									  OR (EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND IsNull(approval_flag,9)  IN (1,4) AND record_id = m.record_id)
									  AND EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND IsNull(approval_flag,9) IN (0,9) AND record_id = m.record_id)
									  AND NOT EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND IsNull(approval_flag,9) IN (2) AND record_id = m.record_id)
									  )
									  
									  )
									  AND EXISTS (select * from #tmpL WHERE (IsNull(approval_flag,9) IN (2) 

									  )
									 
									  AND record_id = m.record_id ) ))
									  )

		
			 --FS20180720
		--UPDATE #tmp_resources 
		--SET summary_flag= 4
		--WHERE   record_id IN (select distinct record_id from #tmpL m  
		--						WHERE
		--					resource_id <> @resource_id AND	(ISNULL(approved_id,'')='' AND (NOT EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
		--							  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
		--							  AND IsNull(approval_flag,9) NOT IN (1,4)
		--							  AND record_id = m.record_id )
		--							  AND EXISTS (select * from #tmpL WHERE (IsNull(approval_flag,9) IN (2) AND record_id = m.record_id)
		--							  ))
		--							  ) 	)
		
		
		UPDATE  tr
		SET tr.summary_flag= 10
		from #tmp_resources tr
		WHERE   record_id IN (select distinct record_id from #tmpL m  
								WHERE
							/*resource_id = @resource_id AND*/	(ISNULL(approved_id,'')='' AND (NOT EXISTS (select * from #tmpL WHERE (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND IsNull(approval_flag,9) NOT IN (1,4)
									  AND record_id = m.record_id )
									  AND EXISTS (select * from #tmpL WHERE (IsNull(approval_flag,9) IN (2) AND record_id = m.record_id)
									  )
									  AND NOT EXISTS (select * from #tmpL WHERE (IsNull(finalise_flag,0) = 1 AND record_id = m.record_id)


									  ))
									  ) 	)
     									  AND NOT EXISTS (select * from #tmpL WHERE (IsNull(approval_flag,9) = 9 AND record_id = tr.record_id))/*change NABBASI08252018*/
			--FS20180720
		

		end


	END
--=8
IF EXISTS(select 1 FROM #tmp_resources where  IsNull(#tmp_resources.approval_flag,9) != 2
	AND IsNull(#tmp_resources.submitted_flag,0) = 1
	AND IsNull(#tmp_resources.upload_flag,0) = 0             
	AND IsNull(#tmp_resources.finalise_flag,0) =0)
BEGIN
	IF EXISTS (select 1 from #tmp_resources where summary_flag=4)
		BEGIN 
			IF EXISTS (select 1 FROM #tmp_resources tmp
			WHERE IsNull(tmp.submitted_flag,0) = 1
			AND IsNull(tmp.approval_flag,9) IN (0,9)
			AND IsNull(tmp.upload_flag,0)=0
			AND IsNull(tmp.finalise_flag,0) =0 )
				BEGIN
					select Distinct record_id INTO #RecordIds FROM #tmp_resources tmp
			WHERE IsNull(tmp.submitted_flag,0) = 1
			AND IsNull(tmp.approval_flag,9) IN (0,1,9)
			AND IsNull(tmp.upload_flag,0)=0
			AND IsNull(tmp.finalise_flag,0) =0

			SELECT * INTO #tempR FROM pld_transactions WHERE record_id IN (select Distinct record_id FROM #RecordIds)
			--FS20180529
			Alter table #tempR add approver_id varchar(16)
			update t
			set t.approver_id = l2.approver_id
			from #tempR t inner join pld_transactions_hdr l2 ON t.record_id=l2.record_id

			update t
			set t.approval_flag=CASE WHEN l2.trx_approval_required_flag =0 OR l3.trx_approval_flag = 0 THEN 1 ELSE t.approval_flag END
			from #tempR t inner join pdd_level2 l2 ON t.level2_key=l2.level2_key
			INNER JOIN pdd_level3 l3 ON t.level2_key=l3.level2_key AND t.level3_key=l3.level3_key
			WHERE ISNULL(approver_id,'')=''  AND ISNULL(submitted_flag,0)=1


			Select l2.level2_key,tmp.record_id,tmp.transaction_id,l2.trx_approval_required_flag,l3.trx_approval_flag,approval_flag
			,r.resource_id manager,res.reports_to supervisor,tmp.resource_id INTO #tempRe
			FROM #tempR tmp
			INNER JOIN pdd_level2 l2 ON tmp.level2_key=l2.level2_key
			INNER JOIN pdd_level3 l3 ON tmp.level2_key=l3.level2_key AND tmp.level3_key=l3.level3_key
			LEFT JOIN pdd_level2_resource r ON r.level2_key=l2.level2_key AND r.position_category_code=1 
			AND r.active_flag=1 AND r.resource_id != tmp.resource_id AND r.resource_id=@resource_id
			INNER JOIN pdd_resources res ON tmp.resource_id=res.resource_id
			
			  
			UPDATE d
			 SET trx_approval_flag=0
			 from #tempRe d
				LEFT OUTER JOIN #managers_level2 l2 ON l2.level2_key = d.level2_key  
			 WHERE d.trx_approval_flag=1 AND l2.level2_key IS null


			UPDATE d
			 SET trx_approval_flag=2
			 from #tempRe d
			 WHERE 0 = (select Count(*) FROm pdd_level2_resource l2  where  d.level2_key=l2.level2_key  AND l2.position_category_code=1 
						AND l2.resource_id != d.resource_id AND l2.active_flag=1)
			 --AND d.resource_id=@login_id
			 AND d.trx_approval_flag=1
		  
		   --FS20180818 Expense Approval Change

		UPDATE tr 
		SET summary_flag=8
		from #tmp_resources tr
		WHERE record_id IN (select distinct record_id from #tempRe m  --partial approval is not required In override approval AS discussed with Mati 20180606
								WHERE --EXISTS ( 
								--select * from #tempRe where record_id =  m.record_id AND ISNULL(approved_id,'')<>'' 
								--AND EXISTS (select * from #tempRe WHERE IsNull(approval_flag,9) IN (0,9,3)  AND record_id =  m.record_id)
								--AND EXISTS (select * from #tempRe WHERE IsNull(approval_flag,9) IN (1,4) AND record_id =  m.record_id)
								--) OR 
								(ISNULL(approved_id,'')='' AND (NOT EXISTS (select * from #tempRe WHERE  (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') =@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')=@resource_id))) ) 
									  AND IsNull(approval_flag,9) NOT IN (1,4)
									  AND record_id = m.record_id )
									  AND EXISTS ( select * from #tempRe WHERE  (trx_approval_required_flag = 0 OR
									  ((trx_approval_flag = 1 AND (ISNULL(manager,'') !=@resource_id) OR (trx_approval_flag=2 AND ISNULL(supervisor,'')!=@resource_id))) ) 
									  AND IsNull(approval_flag,9) IN (0,9)
									  AND record_id = m.record_id   --select * from #tempRe WHERE (IsNull(approval_flag,9) IN (0,9)  )

									  
									  AND record_id = m.record_id )
									  ) )
									  )
            and  exists(select record_id from 	pld_transactions where record_id=tr.record_id and IsNull(approval_flag,9) IN (1,4) )/*CHANGE NABBASI08252018*/

		--UPDATE #tmp_resources 
		--SET summary_flag=8
		--WHERE record_id IN (select distinct record_id from #tempRe m
		--						WHERE EXISTS (select * from #tempRe WHERE trx_approval_required_flag <> 0
		--							  AND trx_approval_flag <>0
		--							  AND ((ISNULL(manager,'') =@resource_id OR ISNULL(supervisor,'')=@resource_id)) 
		--							  AND IsNull(approval_flag,9) IN (1,4)
		--							  AND record_id = m.record_id )
		--							  AND EXISTS (select * from #tempRe WHERE trx_approval_required_flag <> 0
		--							  AND trx_approval_flag <>0
		--							  AND ((ISNULL(manager,'') =@resource_id OR ISNULL(supervisor,'')=@resource_id)) 
		--							  AND IsNull(approval_flag,9) IN (0,9)
		--							  AND record_id = m.record_id )) 

		--UPDATE tmp                 
		--	SET  summary_flag = ISNULL(CASE WHEN t.trx_approval_required_flag <> 0 THEN CASE WHEN t.trx_approval_flag <>0 THEN 
		--										CASE WHEN  (ISNULL(manager,'') =@resource_id OR ISNULL(supervisor,'')=@resource_id) AND IsNull(tmp.approval_flag,9) IN (0,9) THEN 2 
		--										ELSE CASE WHEN  (ISNULL(manager,'') =@resource_id OR ISNULL(supervisor,'')=@resource_id) AND IsNull(tmp.approval_flag,9) IN (1,4) THEN 8
		--										END END END	END   ,tmp.summary_flag)             
		--from #tmp_resources tmp
		--inner join pld_transactions_hdr hdr on tmp.record_id=hdr.record_id 
		--inner join #tempRe t on tmp.record_id=t.record_id 


				END
		END

END

---Summary_flag=9
SELECT r.*,h.approver_id apprv_id 
INTO #reports 
FROM #tmp_resources r 
INNER JOIN pld_transactions_hdr h on r.record_id=h.record_id 
WHERE ISNULL(r.submitted_flag,0)=1
AND NOT EXISTS (select 1 from #tmp_resources where  #tmp_resources.record_id=r.record_id and ISNULL(#tmp_resources.approval_flag,0)=2)

Select tmp.record_id,tmp.transaction_id,tmp.apprv_id,l2.trx_approval_required_flag,l3.trx_approval_flag INTO #tempReports
			FROM #reports tmp
			INNER JOIN pdd_level2 l2 ON tmp.level2_key=l2.level2_key
			INNER JOIN pdd_level3 l3 ON tmp.level2_key=l3.level2_key AND tmp.level3_key=l3.level3_key
	--select * from #tempReports where record_id='obile12af22093e'		
UPDATE #tmp_resources        
			SET  summary_flag = 9
		WHERE record_id IN (select distinct record_id from #tempReports m
								WHERE NOT EXISTS (select * from #tempReports WHERE record_id = m.record_id  AND
												 (ISNULL(apprv_id,'')<>'' OR  (trx_approval_flag <> 0 AND trx_approval_required_flag <> 0 ) )
													   ) 
									  AND EXISTS (select * from #tempReports WHERE record_id = m.record_id  AND
												 ISNULL(finalise_flag,0)=0
													   ))

----------------------------------------------FS
      
  declare @resource_id_loginid varchar(32)
  select @resource_id_loginid=ltrim(rtrim(loginid)) from pdd_resources where resource_id=@resource_id


	
  
 
  
    --select '1',* from #tmp_resources     where record_id='o8ceda2d5726549d'     
  update  #tmp_resources    
  set approved=0
  where summary_flag <> 4  --and  isnull(approved_by,'')=@resource_id_loginid          

	      
		UPDATE #tmp_resources                 
		SET  summary_flag = 5                  
		WHERE record_id IN (                 
		Select #tmp_resources.record_id                 
		FROM #tmp_resources                   
		WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
		AND (IsNull(#tmp_resources.approval_flag,9) IN (1,4) /*Approved*/                 
		OR IsNull(#tmp_resources.upload_flag,0)=1 )   
		AND NOT EXISTS (Select *                 
			FROM #tmp_resources r where r.record_id=#tmp_resources.record_id AND IsNull(r.finalise_flag,0) <>1 )
		            
		)                 
		AND summary_flag NOT IN (1,2,3,4)                 

		

		--if @from_fin_menu=1
		--begin 
		--UPDATE #tmp_resources                 
		--SET  summary_flag = 6                  
		--WHERE record_id IN (       
		--Select #tmp_resources.record_id               
		--FROM #tmp_resources                   
		--WHERE IsNull(#tmp_resources.submitted_flag,0) = 1 /*Submitted*/                 
		--AND (IsNull(#tmp_resources.approval_flag,9) IN (1,4) /*Approved*/                 
		--OR IsNull(#tmp_resources.upload_flag,0)=1 )   
		--AND IsNull(#tmp_resources.finalise_flag,0) in (1)
            
		--)       
		--AND summary_flag NOT IN (1,2,3,4,5)   
		--end              

 if @from_fin_menu=1
 begin 
	 UPDATE #tmp_resources                 
	SET  summary_flag = 6   
	--,approved=1               
	WHERE summary_flag=4  
	
	delete from #tmp_resources where summary_flag not in (5,6)              
end
else
begin
UPDATE #tmp_resources                 
	SET  summary_flag = 6   
	--,approved=1               
	WHERE summary_flag=4 
end	

--SELECT 'summary_flag',* FROM #tmp_resources where summary_flag=2
--select '#tmp_resources',* from #tmp_resources



	     
	DELETE FROM #tmp_resources                 
	WHERE ((summary_flag is NULL) or (summary_flag=0))    

	IF @filter_flag = 1              
	BEGIN                 
		DELETE FROM #tmp_resources        
		WHERE summary_flag <> 1                 
	END                 
	                               
	                 
	IF @filter_flag = 2                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 2 
	END                 
	              
	IF @filter_flag = 3             
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 3                 
	END                 
	                 
	IF @filter_flag = 4                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 4                 
	END                 
	                 
          
	IF @filter_flag = 5                    
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 5        
	END 

		IF @filter_flag = 6                  
	BEGIN                 
		DELETE FROM #tmp_resources                 
		WHERE summary_flag <> 6         
	END 



	                 
	--SELECT DISTINCT                 
	--#tmp_resources.resource_id                 
	--,RTRIM(#tmp_resources.name_last) as name_last                 
	--,RTRIM(#tmp_resources.name_first) as name_first              
	--FROM #tmp_resources                  
	--ORDER BY name_last, resource_id         

	 
----above
             
   
create TABLE #pld_transaction_hdr(                    
 [report_name] [varchar](32) NOT NULL,                    
 [record_id] [char](16) NOT NULL,                    
 [comments] [varchar](252) NOT NULL,              
 [date_from] [datetime] NOT NULL,              
 [date_to] [datetime] NOT NULL,                    
 [expense_num] [varchar](16) NULL,       
 [amount] [float] NOT NULL,                    
 [timestamp] [binary](8) NULL,                    
 [submitted_flag] [tinyint] NOT NULL,                    
 [home_amount] [float] NOT NULL, 
[reimburse_home_amount] [float] NOT NULL,                    
 [upload_flag] [tinyint] NULL,                    
 [approval_flag] [tinyint] NULL,                    
 [finalise_flag] [tinyint] NULL,                    
 [summary_flag] [tinyint] NULL,                    
 [approver_id] [varchar](32) NULL,                    
 [print_format] [varchar](50) NULL,    
 [approver_name] [varchar](70) NULL,         
 [re_approval_flag] [tinyint] NULL,
 resource_id char(16) ,
 approved int null 
  ,name_first varchar(32)
 ,name_last varchar(32)
                        
)                     
   /*      
  insert into #pld_transaction_hdr                    
                 
exec [plsW_exptrx_hdr_get]       
  @company_code = @company_code                      
 ,@resource_id  = @resource_id                        
 ,@date_from    = @date_from                          
 ,@date_to      = @date_to                  
 ,@filter_flag = @filter_flag                       
 ,@record_id  =@record_id                       
         
		 
*/

---****inserted SP logic here

DECLARE        
 @KDRAFT int,        
 @KSUBMITTED int,        
 @KREJECTED int,        
 @KAPPROVED int,        
 @KFINANCE_APPROVED int,        
 @KEXPENSE_TRANS_CODE_START int,        
 @KEXPENSE_TRANS_CODE_END int        
      
 select @KEXPENSE_TRANS_CODE_START = 2000        
 select @KEXPENSE_TRANS_CODE_END = 2999        
 select @KDRAFT=1        
 select @KSUBMITTED=2        
 select @KREJECTED=3        
 select @KAPPROVED=4        
 select @KFINANCE_APPROVED=5     
-----------------------------------------------        
--DECLARE @path varchar(255),        
--@default_code varchar(255)        
        
--SELECT @path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'        
        
SELECT @default_code=default_code         
FROM plv_rule_group      
WHERE path=@path        
and user_group_code is NULL        
-----------------------------------------------        
        
if ((@date_from is null) or (@date_from=''))        
BEGIN        
 Select @date_from='1/1/1900'        
END        
        
if ((@date_to is null) or (@date_to=''))        
BEGIN        
 Select @date_to='12/31/2999'        
END   
        
        
SET NOCOUNT ON        
CREATE TABLE #plt_trx_hdr     
(        
  report_name                 varchar(32)  not null       
 ,record_id      char(16)     not null        
 ,comments                    varchar(252) not null        
 ,date_from       datetime     not null        
 ,date_to              datetime     not null        
 ,expense_num                 varchar(16)  null        
 ,amount                      float        not null        
 ,timestamp                   BINARY(8)    null        
 ,company_code                int       not null      
 ,resource_id                 char(16)  not null        
 ,submitted_flag              tinyint   not null        
 ,upload_flag                 tinyint   ---not null        
 ,approval_flag               tinyint   ---not null        
 ,finalise_flag        tinyint   ---not null        
 ,summary_flag                tinyint   ---not null  - 1 = Draft, 2 = Submitted, 3 = Rejected, 4 = Approved        
 ,reimburse_home_amount       float     not null        
 ,home_amount                 float     not null        
 ,approver_id        varchar(32) null        
 ,print_format               varchar(50) null        
 ,approver_name        varchar(70) null         
 , re_approval_flag tinyint
 ,approved int null

)    
INSERT #plt_trx_hdr        
(        
  report_name        
,record_id        
 ,comments        
 ,date_from        
 ,date_to        
 ,expense_num        
 ,amount   
 ,timestamp        
 ,company_code        
 ,resource_id        
 ,approval_flag        
 ,finalise_flag        
 ,submitted_flag        
 ,summary_flag        
 ,reimburse_home_amount 
 ,home_amount        
 ,approver_id        
 ,print_format        
 ,approver_name      
 ,re_approval_flag        
)        
SELECT        
  report_name        
 ,record_id        
 ,comments        
 ,date_from        
 ,date_to        
 ,expense_num        
 ,amount        
 ,CONVERT(binary(8), timestamp)        
 ,company_code        
 ,resource_id    
 ,0 ---approval_flag        
 ,0   ---finalise_flag        
 ,0  /* submitted_flag    */ ---?.00         
 ,0    /* summar_flag */        
 ,0.00 /* reimburse_home_amount */        
 ,0.00 /* home_amount           */        
 ,approver_id        
 ,print_format        
 ,''       
 ,re_approval_flag       
FROM pld_transactions_hdr h        
WHERE (company_code = @company_code        
 
--AND resource_id in (select distinct resource_id from #tmp_resources)
and (record_id in (select distinct record_id from #tmp_resources)     
--ak 20171005 should return his own transaction
 or resource_id = @resource_id  )
AND date_to BETWEEN @date_from AND @date_to)   
  
ORDER BY date_from, isnull(report_name,'')      
     
	 
	 
    
------dtl        
        
select         
record_id        
,level2_key        
,level3_key        
,'reimbursment_flag' = isnull(reimbursment_flag,0)        
,'submitted_flag' = isnull(submitted_flag,0)        
,'upload_flag' = isnull(upload_flag,0)        
,'approval_flag' = isnull(approval_flag,0)        
,'finalise_flag' = isnull(finalise_flag,0)        
,'amount_home' = isnull(amount_home,0) 
,'payment_code'=isnull(payment_code,0)    
into #pld_dtl        
from pld_transactions             
WHERE company_code = @company_code        
--AND resource_id = @resource_id 
--AND resource_id in (select distinct resource_id from #tmp_resources)  
and record_id in (select distinct record_id from #tmp_resources)         
AND trx_type BETWEEN @KEXPENSE_TRANS_CODE_START AND @KEXPENSE_TRANS_CODE_END        
AND pld_transactions.record_id in (select distinct record_id from #plt_trx_hdr)        
------------------------------->>>------------------------------->>>        
 
update t  
set reimbursment_flag= case when payment_category in (0,1) then 1 else 0 end  
from #pld_dtl t inner join plv_pmt_types p on t.payment_code=p.payment_code  
  
--select * from plv_pmt_types  
 IF (@overrride_default_code <> @override_yes_path)         
 BEGIN         
           
  UPDATE #pld_dtl         
  SET approval_flag=1         
  FROM #pld_dtl vr         
  WHERE level2_key in (select level2_key from plv_level2 where trx_approval_required_flag=0)         
  and submitted_flag=1    
  and isnull(approval_flag,0) != 1 
       
  UPDATE #pld_dtl         
  SET approval_flag=1         
  FROM #pld_dtl vr         
  WHERE level2_key in (select level2_key from plv_level2 where trx_approval_required_flag!=0)         
  and level3_key in (select level3_key from plv_level3 where level2_key=vr.level2_key and trx_approval_flag=0)         
  and submitted_flag=1         
  and isnull(approval_flag,0) != 1         
          
  UPDATE #pld_dtl         
  SET approval_flag=1         
  FROM #pld_dtl vr         
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
 
    --select * from #tmp_resources     where report_name='051913Andre'     
  update h 
  set summary_flag=r.summary_flag,approved=r.approved
  from #plt_trx_hdr h inner join #tmp_resources r on h.record_id=r.record_id

  
	 
	DELETE FROM #plt_trx_hdr                 
	WHERE ((summary_flag is NULL) or (summary_flag=0))  


  --  update h 
  --set approved=r.approved
  --from #plt_trx_hdr h inner join #tmp_resources r on h.record_id=r.record_id and h.summary_flag=6
  
  
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.submitted_flag = (SELECT ISNULL(MAX(#pld_dtl.submitted_flag),0)        
 from #pld_dtl        
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 )        
        
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.upload_flag = (SELECT ISNULL(MAX(#pld_dtl.upload_flag),9)        
 from #pld_dtl        
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 )        
        
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.approval_flag = (SELECT ISNULL(MAX(#pld_dtl.approval_flag),9)        
 from #pld_dtl  
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 )        
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.finalise_flag = (SELECT ISNULL(MAX(#pld_dtl.finalise_flag),9)        
 from #pld_dtl        
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 )     
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.home_amount = (SELECT ISNULL(SUM(#pld_dtl.amount_home),0)        
 from #pld_dtl        
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 )        
        
UPDATE #plt_trx_hdr        
SET #plt_trx_hdr.reimburse_home_amount = (SELECT ISNULL(SUM(amount_home),0)        
 from #pld_dtl        
 WHERE #pld_dtl.record_id = #plt_trx_hdr.record_id        
 AND #pld_dtl.reimbursment_flag=1        
 )        

------------------------------->>>------------------------------->>>        
        
/******MNKHAN 08152005 MMDDYYYY****/        
--To Get only one report        
IF ((@record_id is not null) and (@record_id <> ''))        
BEGIN  
 DELETE FROM #plt_trx_hdr        
 WHERE record_id <> @record_id        
END         
/******MNKHAN 08152005 MMDDYYYY****/        
ELSE        
BEGIN        
 IF @filter_flag <> 0        
 BEGIN        
         
  IF @filter_flag = 3 -- Rejected        
  BEGIN        
   DELETE FROM #plt_trx_hdr        
   WHERE summary_flag <> @KREJECTED        
        
  END        
        
  IF @filter_flag = 1 -- Drafts        
  BEGIN        
  
   DELETE FROM #plt_trx_hdr     
   WHERE summary_flag <> @KDRAFT        
           
  END        
         
 IF @filter_flag = 2 -- Submitted        
  BEGIN        
         
        
   DELETE FROM #plt_trx_hdr        
   WHERE summary_flag <> @KSUBMITTED        
          
  END        
         
  IF @filter_flag = 4 -- Approved        
  BEGIN        
      
       
   DELETE FROM #plt_trx_hdr        
   WHERE summary_flag <> @KAPPROVED        
            
  END        
          
  --Finance Approval Required           
  IF (@default_code=2) --Yes        
  BEGIN        
          
   IF @filter_flag = 5 -- Finance Approved        
   BEGIN   
       
    DELETE FROM #plt_trx_hdr        
    WHERE summary_flag <> @KFINANCE_APPROVED        
            
   END        
  END        
 END        
END 

	        
        
UPDATE #plt_trx_hdr        
SET approver_name=res.name_last+', '+res.name_first        
FROM #plt_trx_hdr hdr        
JOIN plv_resource res        
ON hdr.approver_id=res.resource_id        
 
  insert into #pld_transaction_hdr        
SELECT        
  report_name        
 ,record_id        
 ,comments        
 ,date_from     ,date_to        
 ,expense_num        
 ,amount        
 ,timestamp        
 ,submitted_flag        
 ,home_amount        
 ,reimburse_home_amount        
 ,upload_flag        
,approval_flag        
 ,finalise_flag        
 ,summary_flag        
 ,approver_id       
,print_format       
 ,approver_name       
 ,re_approval_flag
 ,resource_id  
 ,approved 
 ,null
 ,null       
FROM #plt_trx_hdr  
ORDER BY date_from asc 


---****inserted SP logic here
		 
		 
		 
DECLARE @DATE_START datetime,         
@DATE_END datetime         
         
SELECT @DATE_START = CONVERT(DATETIME,         
DATENAME(MM ,GetDate()) + ' '         
+DATENAME(DD ,GetDate()) + ', '         
+DATENAME(YY ,GetDate())         
)         
         
         
SELECT @DATE_START = DATEADD(YEAR,-1,@DATE_START)         
SELECT @DATE_START = DATEADD(MONTH,1,@DATE_START)         
SELECT @DATE_START = DATEADD(DAY,-DATEPART(DAY,@DATE_START)+1,@DATE_START)         
         
SELECT @DATE_END = @DATE_START         
SELECT @DATE_END = DATEADD(YEAR,1,@DATE_END)         
SELECT @DATE_END = DATEADD(DAY,-1,@DATE_END)         
SELECT @DATE_END = DATEADD(SS,60*60*24-1,@DATE_END)
		 
		 
		 
		 -----*****after SP call*****-----      
 select t.*, p.submitter_id, p.create_date, p.modify_date , p.create_id, p.modify_id       
 into #data           
 from #pld_transaction_hdr T INNER JOIN pld_transactions_hdr P             
  ON P.record_id = t.record_id                   
 where (@last_sync_date is null OR (ISNULL(p.modify_date, p.create_date) > @last_sync_date))    
 and ( (p.date_to > DATEADD(week,  -8, GETDATE()) AND p.date_to <= @DATE_END) or summary_flag in (1,2)          
  --and ( isnull(modify_date, create_date ) > DATEADD(week,  -8, GETDATE()) or summary_flag in (1,2) 
  or ((p.date_to BETWEEN @DATE_START AND @DATE_END) and summary_flag IN (3,7)))         
    and (@keys is null or exists (select * from #transaction c where t.record_id = c.record_id)  )
    
	------------------------------------------------------------
	ALTER TABLE #data ADD currency_code varchar(8)

	update d
	set d.currency_code = r.currency_code
	from #data d inner join pdd_resources r
	on d.resource_id=r.resource_id
    ------------------------------------------------------------
		 --select '3',* from #data  
     update #data     
     set date_from = convert(date , date_from)  
        ,date_to = convert(date , date_to)    
       
       
       
     update #data     
     set date_from = dateadd(hour, 12,date_from)  
        ,date_to = dateadd(hour, 12,date_to)  


		     update d     
     set name_first =r.name_first
        ,name_last = r.name_last
		from plv_resource_all r inner join  #data d on d.resource_id=r.resource_id

	------------------------------------------------
IF (@overrride_default_code=@override_yes_path)  AND @from_fin_menu = 0           
BEGIN 
	DELETE FROM #data
	WHERE summary_flag = 1
	AND resource_id <> @resource_id 

	

	DELETE FROM #data
	WHERE summary_flag  IN (2,8)
	AND resource_id <> @resource_id AND approver_id<> @resource_id

	DELETE FROM #data
	WHERE summary_flag IN (3,7,10)
	AND resource_id <> @resource_id AND approver_id <> @resource_id

END
	

	------------------------------------------------
  
 if @subscriber_id is null      
begin         
   select * from #data   --where summary_flag=5--where report_name='005717apantale'     
   end          
  else  
   begin   
   select top 100 * from #data order by  [record_id]          
   delete top (100) #data          
   where record_id in          
   (select top 100  record_id from #data order by  [record_id])          
             
             
 declare @entity_id int             
 select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'TransactionHeader'            
          
 insert into plv_event_notification            
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                          
  select    convert(varchar, @company_code) + '~-~' + [record_id] ,    @company_code, 2, @entity_id, subscriber_id,  d.resource_id, GETDATE()            
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id    and  subscriber_id =@subscriber_id           
 where      is_active = 1           
           
   end          
     
 end 

go

