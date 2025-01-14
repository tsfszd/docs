

if exists(select * from sys.procedures where name='plsw_apps_set_image_changed_flag'
)
begin 
drop proc plsw_apps_set_image_changed_flag
end
go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create procedure plsw_apps_set_image_changed_flag
  @company_code int,  
  @transaction_id char(16),  
  @record_id char(16),  
  @is_image_changed  int  

  AS  
  
    

  create table #data
(
error_flag tinyint
,error_code tinyint
,error_description varchar(32)
,timestamp	binary(8)
,transaction_id	varchar(16)
,level2_key	varchar(32)
,level3_key	varchar(64)
,applied_date1	datetime
,applied_date2	datetime
,trx_type	int
,resource_id	varchar(16)
,res_usage_code	varchar(16)
,units	float
,location_code	varchar(16)
,org_unit	varchar(16)
,task_code	varchar(16)
,comments	varchar(3000)
,nonbill_flag	tinyint
,submitted_flag	tinyint
,submitted_date	datetime
,approval_flag	int
,line_id	varchar(16)
,res_type	int
,payment_code	int
,payment_name	varchar(16)
,currency_code	varchar(8)
,currency_conversion_rate	float
,amount	float
,amount_home	float
,amount_billable	float
,receipt_flag	tinyint
,reimbursment_flag	tinyint
,record_id	varchar(16)
,gst_tax_code	varchar(8)
,net_amount	float
,cc_exp_id	int
,cc_num	varchar(32)
,cc_type_id	tinyint
,Is_file_attached	tinyint
,approval_comment	varchar(255)
,is_image_changed	int
,text1	varchar(255)
,text2	varchar(255)
,text3	varchar(255)
,text4	varchar(255)
,text5	varchar(255)
,text6	varchar(255)
,text7	varchar(255)
,text8	varchar(255)
,text9	varchar(255)
,text10	varchar(255)
,number11	float
,number12	float
,number13	float
,number14	float
,number15	float
,number16	float
,number17	float
,number18	float
,number19	float
,number20	float
,exp_timestamp binary(8)

  )


  INSERT INTO #data( error_flag
	,error_code
	,error_description
	,timestamp
	,transaction_id
	,level2_key
	,level3_key
	,applied_date1
	,applied_date2 
	,trx_type
	,resource_id
	,res_usage_code
	,units
	,location_code
	,org_unit
	,task_code
	,comments
	,nonbill_flag
	,submitted_flag
	,submitted_date
	,approval_flag
	,line_id
	,res_type
	,payment_code
	,payment_name
	,currency_code
	,currency_conversion_rate
	,amount
	,amount_home
	,amount_billable
	,receipt_flag
	,reimbursment_flag
	,record_id
	,gst_tax_code
	,net_amount
	,cc_exp_id
	,cc_num
	,cc_type_id
	,is_file_attached
	,approval_comment
	,is_image_changed
	,text1
	,text2
	,text3
	,text4
	,text5
	,text6
	,text7
	,text8
	,text9
	,text10
	,number11
	,number12
	,number13
	,number14
	,number15
	,number16
	,number17
	,number18
	,number19
	,number20
	,exp_timestamp)
  exec plsw_set_image_changed_flag @company_code ,@transaction_id ,@record_id ,@is_image_changed  

  SELECT 
	 d.error_flag
	,d.error_code
	,d.error_description
	,d.timestamp
	,d.transaction_id
	,d.level2_key
	,d.level3_key
	,d.applied_date1 applied_date
	,d.applied_date2 applied_date
	,d.trx_type
	,d.resource_id
	,d.res_usage_code
	,d.units
	,d.location_code
	,d.org_unit
	,d.task_code
	,d.comments
	,d.nonbill_flag
	,d.submitted_flag
	,d.submitted_date
	,d.approval_flag
	,d.line_id
	,d.res_type
	,d.payment_code
	,d.payment_name
	,d.currency_code
	,d.currency_conversion_rate
	,d.amount
	,d.amount_home
	,d.amount_billable
	,d.receipt_flag
	,d.reimbursment_flag
	,d.record_id
	,d.gst_tax_code
	,d.net_amount
	,d.cc_exp_id
	,d.cc_num
	,d.cc_type_id
	,d.is_file_attached
	,d.approval_comment
	,d.is_image_changed
	,d.text1
	,d.text2
	,d.text3
	,d.text4
	,d.text5
	,d.text6
	,d.text7
	,d.text8
	,d.text9
	,d.text10
	,d.number11
	,d.number12
	,d.number13
	,d.number14
	,d.number15
	,d.number16
	,d.number17
	,d.number18
	,d.number19
	,d.number20
	,d.exp_timestamp
	,l3.trx_approval_flag
	,l2.trx_approval_required_flag
	,''as approvers /*column added nabbasi07302018*/
   FROM #data d 
  INNER JOIN pdd_level2 l2 ON d.level2_key=l2.level2_key
 INNER JOIN pdd_level3 l3 ON d.level2_key=l3.level2_key AND d.level3_key=l3.level3_key




go
