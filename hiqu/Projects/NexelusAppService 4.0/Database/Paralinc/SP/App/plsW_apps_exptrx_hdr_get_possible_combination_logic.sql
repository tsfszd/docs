go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if exists(select * from sys.procedures where name='plsW_apps_exptrx_hdr_get_possible_combination_logic'
)
begin 
drop proc plsW_apps_exptrx_hdr_get_possible_combination_logic
end
go




CREATE procedure plsW_apps_exptrx_hdr_get_possible_combination_logic
 @company_code int                          
 ,@resource_id  varchar(16)                          
 ,@date_from    datetime=null                          
 ,@date_to      datetime=null                          
 ,@filter_flag tinyint = 0 --- 0 = No Filter, 1 = Drafts only, 2 = Submitted  3 = Rejected 4 =  Approved 5 = Finance Approved                          
 ,@record_id char(16)=''                       
 , @last_sync_date datetime = null,              
 @subscriber_id int = null,         
@keys xml = null

as
  select      
 T.c.value('./record_id[1]', 'varchar(64)') record_id      
             into #transaction               
                       FROM     @keys.nodes('/keys/key') T ( c ) 

CREATE TABLE #tmp_resources_data( resource_id varchar(16), name_last varchar(100), name_first varchar(100), record_id   char(16) ,  summary_flag   tinyint ,flag int )

insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'1',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'0'

update #tmp_resources_data set flag = 1


insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'2',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'0'

update #tmp_resources_data set flag = 2
where isnull(flag,0)=0


insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'3',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'0'

update #tmp_resources_data set flag = 3
where isnull(flag,0)=0


insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'4',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'0'

update #tmp_resources_data set flag = 4
where isnull(flag,0)=0


insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'5',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'1'

update #tmp_resources_data set flag = 5
where isnull(flag,0)=0

insert into #tmp_resources_data (resource_id, name_last, name_first,record_id,summary_flag)
exec plsW_apps_app_res_get @company_code=2,@manager_id=@resource_id,@trx_type=N'1',@Approval_mode=N'4',@l2_org_unit=N'',@l2_location_code=N'',@l3_org_unit=N'',@l3_location_code=N'',@from_fin_menu=N'1'

update #tmp_resources_data set flag = 6
where isnull(flag,0)=0
 
--select distinct record_id from #tmp_resources_data where flag = 4

---****inserted SP logic here


                  
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
 resource_id char(16)                    
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
DECLARE @path varchar(255),        
@default_code varchar(255)        
        
SELECT @path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/FinanceApprovalRequired'        
        
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
 ,date_to                     datetime     not null        
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
WHERE company_code = @company_code        
--AND resource_id = @resource_id  
--AND resource_id in (select distinct resource_id from #tmp_resources_data)
and record_id in (select distinct record_id from #tmp_resources_data)      
AND date_to BETWEEN @date_from AND @date_to        
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
,resource_id       
into #pld_dtl        
from pld_transactions             
WHERE company_code = @company_code        
--AND resource_id = @resource_id 
--AND resource_id in (select distinct resource_id from #tmp_resources_data)  
and record_id in (select distinct record_id from #tmp_resources_data)         
AND trx_type BETWEEN @KEXPENSE_TRANS_CODE_START AND @KEXPENSE_TRANS_CODE_END        
AND pld_transactions.record_id in (select distinct record_id from #plt_trx_hdr)        
------------------------------->>>------------------------------->>>        
 
update t  
set reimbursment_flag= case when payment_category in (0,1) then 1 else 0 end  
from #pld_dtl t inner join plv_pmt_types p on t.payment_code=p.payment_code  
  

  update h 
  set summary_flag=r.summary_flag
  from #plt_trx_hdr h inner join #tmp_resources_data r on ltrim(rtrim(h.record_id))=ltrim(rtrim(r.record_id))


  
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
     IF @filter_flag = 6 -- pending Finance Approved        
   BEGIN        
       
    DELETE FROM #plt_trx_hdr        
    WHERE summary_flag <> 6        
            
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
FROM #plt_trx_hdr      
ORDER BY date_from asc 


---****inserted SP logic here
		 
		 
		 
		 --select '2',* from #pld_transaction_hdr  where report_name='051304test_use'
		 
		 
		 
		 -----*****after SP call*****-----      
 select t.*, p.submitter_id, p.create_date, p.modify_date , p.create_id, p.modify_id            
 into #data           
 from #pld_transaction_hdr T INNER JOIN pld_transactions_hdr P             
  ON P.record_id = t.record_id                   
 where (@last_sync_date is null OR (ISNULL(p.modify_date, p.create_date) > @last_sync_date))              
 --and create_date > DATEADD(week,  -10, GETDATE())          
    and (@keys is null or exists (select * from #transaction c where t.record_id = c.record_id)  )          
    
    
		 --select '3',* from #data  
     update #data     
     set date_from = convert(date , date_from)  
        ,date_to = convert(date , date_to)    
       
       
       
     update #data     
     set date_from = dateadd(hour, 12,date_from)  
        ,date_to = dateadd(hour, 12,date_to)  
  
 if @subscriber_id is null          
   begin          
   select * from #data          
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
  select    convert(varchar, @company_code) + '~-~' + [record_id]  ,    @company_code, 2, @entity_id, subscriber_id,  d.resource_id, GETDATE()            
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id    and  subscriber_id =@subscriber_id           
 where      is_active = 1           
           
   end      
   
   return    
                    




go