
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if exists(select * from sys.procedures where name='pdsw_apps_resources_notification_get'
)
begin 
drop proc pdsw_apps_resources_notification_get
end
go
CREATE procedure pdsw_apps_resources_notification_get
@company_code int,
@resource_id varchar(32),
@subscriber_id varchar(32),
@mode char(8)	= 'ShowList',	--ShowList, OpenMail, SetDel
--@notification_id varchar(500) = NULL		-- Multiple email_ids in case of 
@notification_id xml = NULL		-- Multiple email_ids in case of 
as

select  
 T.c.value('./key[1]', 'int') notification_id  
             into #keys           
                       FROM     @notification_id.nodes('/keys') T ( c )   


if isnull(@mode,'') = ''
		SELECT @mode = 'ShowList'


if @mode = 'ShowList'
BEGIN

--/*Notification Change FS20180919*/
--UPDATE pdd_apps_notification
--SET batch_id=NULL
--WHERE ISNULL(record_id,'')='' 
--AND isnull(delete_flag,0) <> 1 and
--isnull(read_flag,0) <> 1 and
--isnull(write_flag,0) <> 0
--AND resource_id=@resource_id
--AND subscriber_id=@subscriber_id

 --UPDATE pdd_apps_notification 
 --SET action_flag=case when notification_type = 'TIME APPROVAL' then 'submitted'
 --when notification_type = 'TIME SHEET' and      notification_body like  '%'+@display_name+'%' then 'rejected' else 'approved' end
 --where batch_id is null 
 --and record_id is null

 select n.*  ,
name_last + ' ' + name_first resource_name 
 into #time_notification
from pdd_apps_notification n
	inner join pdd_resources r on r.resource_id = n.create_id or r.loginid= n.create_id 
		 where   subscriber_id=@subscriber_id
				and record_id is null and
				isnull(write_flag,0) <> 0 


DECLARE @display_name varchar(32)
SELECT @display_name=LTRIM(RTRIM(display_name)) FROM pdm_sysnames WHERE field_name = 'TIME_EXP_rejected'

  declare @batch_id bigint
  select @batch_id  = max( batch_id ) from pdd_apps_notification
  set @batch_id  = isnull(@batch_id  , 0)

SELECT 
apn.company_code,
apn.resource_id, 
 apn.subscriber_id
 ,case when action_flag = 'submitted' then 'Timesheet(s) for following employee(s) has been submitted for your approval: ' 
	  
		when action_flag = 'approved'  then 'Your Time Transaction(s)  has been Approved by '
		when action_flag = 'rejected'  then 'Time Transaction(s) has been '+@display_name+' by '
	end
	+ 
	stuff( (
	 select ', ' + resource_name from 
	 (select distinct resource_name from #time_notification where apn.resource_id = resource_id and apn.subscriber_id = subscriber_id and apn.action_flag = action_flag )
	 a
	 for xml path('')
	 ), 1, 1, '')
  notification_body
 ,apn.notification_type
 ,CAST('' as varchar(16))create_id
 , CAST('' as DATETIME)  create_date
 ,CAST('' as varchar(16)) source
 ,CAST('' as varchar(16)) record_id
 ,CAST('' as varchar(16)) transaction_id
 
 ,
 --@batch_id + row_number() over (partition by 
 --1
 --order by apn.resource_id  
 --) 
  batch_id,
  read_flag,
  delete_flag
  
  into #sumarized_notification
FROM #time_notification apn 
WHERE ISNULL(record_id,'')='' 
AND isnull(delete_flag,0) <> 1 and
isnull(read_flag,0) <> 1 and
isnull(write_flag,0) <> 0 

 
group by 
apn.company_code,
apn.resource_id , 
 apn.subscriber_id
,apn.notification_type
,batch_id
 ,action_flag
, read_flag,
  delete_flag







 insert into #sumarized_notification
 select  company_code, resource_id, subscriber_id, notification_body, notification_type,create_id, create_date, '', record_id, transaction_id, email_id  ,
  read_flag,
  delete_flag
 from pdd_apps_notification where record_id is not  null
 
 AND subscriber_id=@subscriber_id
 AND isnull(delete_flag,0) <> 1 and
isnull(read_flag,0) <> 1 and
isnull(write_flag,0) <> 0

  UPDATE apn
 SET apn.batch_id=n.batch_id
 FROM pdd_apps_notification apn 
 inner join #sumarized_notification n
 on apn.resource_id  = n.resource_id AND
 apn.subscriber_id = n.subscriber_id AND
 apn.notification_type = n.notification_type
WHERE apn.batch_id IS NULL
/*Notification Change FS20180919*/

		
select 
 company_code
,batch_id email_id
,resource_id
,subscriber_id
,notification_body
,notification_type
,read_flag
,delete_flag
,[source]
,record_id
,transaction_id
from #sumarized_notification
--where 
--subscriber_id=@subscriber_id and 
--isnull(delete_flag,0) <> 1 and
--isnull(read_flag,0) <> 1 and
--isnull(write_flag,0) <> 0
order by create_date desc

end

if @mode = 'Open'
BEGIN
	update pdd_apps_notification
	set read_flag=1,read_date=getdate()
	where batch_id in (select notification_id from #keys)--email_id=@notification_id

	select
	 company_code
	,batch_id email_id
	,resource_id
	,subscriber_id
	,notification_body
	,notification_type
	,read_flag
	,delete_flag
	,[source]
	,record_id
	,transaction_id
	from pdd_apps_notification
	--where email_id in (select notification_id from #keys)--email_id=@notification_id
	where batch_id in (select notification_id from #keys)
END

if @mode = 'Delete'
BEGIN
	update pdd_apps_notification
	set delete_flag=1,delete_date=getdate()
	--where email_id in (select notification_id from #keys)--email_id=@notification_id
	where batch_id in (select notification_id from #keys)

	select
	 company_code
	,batch_id email_id
	,resource_id
	,subscriber_id
	,notification_body
	,notification_type
	,read_flag
	,delete_flag
	,[source]
	,record_id
	,transaction_id
	from pdd_apps_notification
	--where email_id in (select notification_id from #keys)--email_id=@notification_id
	where batch_id in (select notification_id from #keys)
END

if @mode = 'Get notification'
BEGIN
select 
	batch_id email_id,
	notification_body,
	record_id,
	transaction_id
	from pdd_apps_notification
	--where email_id in (select notification_id from #keys)--email_id=@notification_id
	where batch_id in (select notification_id from #keys)
END

go

