IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_notifications_get]') AND type in (N'P', N'PC'))
begin
DROP PROCEDURE [dbo].[pdsw_apps_notifications_get]
end
GO
CREATE PROCEDURE pdsw_apps_notifications_get  
@mode int=null,    
@subscriber_id int = null,    
@subscriberIDS XML=NULL    
AS    
BEGIN    
/*    
<nodes>    
<node>555</node>    
</nodes>    
*/    
    
if @mode=2    
begin    
set @subscriberIDS = cast(    
'<nodes>    
<node>'+cast(@subscriber_id as varchar)+'</node>    
</nodes>' as xml)    
    
end     
  
SELECT     T.c.value('.', 'int')   subscriber_id                 
                    INTO #subscribers   FROM     @subscriberIDS.nodes('/nodes/node') T ( c )    
    
    
DECLARE @display_name varchar(32)    
SELECT @display_name=LTRIM(RTRIM(display_name)) FROM pdm_sysnames WHERE field_name = 'TIME_EXP_rejected'    
    
/*Notification Change FS20180919*/    
 UPDATE pdd_apps_notification     
 SET action_flag=case when notification_type = 'TIME APPROVAL' then 'submitted'    
 when notification_type = 'TIME SHEET' and      notification_body like '%'+@display_name+'%' then 'rejected' else 'approved' end    
 where batch_id is null     
 and record_id is null    
    
 select n.*  ,    
name_last + ' ' + name_first resource_name     
 into #time_notification    
from pdd_apps_notification n    
 inner join pdd_resources r on r.resource_id = n.create_id or r.loginid= n.create_id     
  INNER JOIN #subscribers s ON n.subscriber_id=s.subscriber_id     
  where ((@mode=1 and batch_id is null   )   
 or (@mode=2 and ISNULL(n.read_flag,'')='' AND ISNULL(n.delete_flag, '') <> 1 AND n.create_date >= DATEADD(day,-2, GETDATE())  
  ))  
    
    
and record_id is null    
    
    
    
    
  declare @batch_id bigint    
  select @batch_id  = max( batch_id ) from pdd_apps_notification    
  set @batch_id  = isnull(@batch_id  , 0)    
    
SELECT apn.resource_id,     
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
 @batch_id + row_number() over (partition by     
1    
    
 order by apn.resource_id      
 )     
  batch_id    
    ,apn.action_flag  
  into #sumarized_notification    
FROM #time_notification apn     
     
     
     
WHERE ((@mode=1 and ISNULL(apn.write_flag,'')='') OR (@mode=2 and ISNULL(apn.read_flag,'')='')) AND ISNULL(apn.delete_flag, '') <> 1 AND apn.create_date >= DATEADD(day,-2, GETDATE())    
AND ISNULL(record_id,'')=''    
     
group by     
apn.resource_id ,     
 apn.subscriber_id    
,apn.notification_type    
,batch_id    
 ,action_flag    
  ,apn.action_flag  
    
    
    
  UPDATE apn    
 SET apn.batch_id=n.batch_id    
 FROM pdd_apps_notification apn     
 inner join #sumarized_notification n    
 on apn.resource_id  = n.resource_id AND    
 apn.subscriber_id = n.subscriber_id AND    
 apn.notification_type = n.notification_type AND  
 ISNULL(apn.action_flag,'') = ISNULL(n.action_flag,'')  
WHERE apn.batch_id IS NULL AND ISNULL(apn.record_id,'')=''
    
    
 insert into #sumarized_notification    
 select   n.resource_id, n.subscriber_id, n.notification_body, n.notification_type,n.create_id, n.create_date, '', n.record_id, n.transaction_id, n.email_id     
 ,n.action_flag  
 from pdd_apps_notification n    
 INNER JOIN #subscribers s ON n.subscriber_id=s.subscriber_id    
 where record_id is not  null    
 and ((@mode=1 and batch_id is null) OR  @mode=2 )  
 and ((@mode=1 and ISNULL(n.write_flag,'')='') OR (@mode=2 and ISNULL(n.read_flag,'')='')) AND ISNULL(delete_flag, '') <> 1 AND create_date >= DATEADD(day,-2, GETDATE())    
 
   UPDATE apn    
 SET apn.batch_id=apn.email_id    
 FROM pdd_apps_notification apn     
 WHERE apn.batch_id IS NULL AND ISNULL(apn.record_id,'')<>''
 AND (@mode=1 and ISNULL(apn.write_flag,'')='')
    
   /*UPDATE apn    
 SET apn.batch_id=apn.email_id    
 FROM pdd_apps_notification apn     
 inner join #sumarized_notification n    
 on apn.resource_id  = n.resource_id AND    
 apn.subscriber_id = n.subscriber_id AND    
 apn.notification_type = n.notification_type AND  
 ISNULL(apn.action_flag,'') = ISNULL(n.action_flag,'')  
 AND apn.record_id = n.record_id
WHERE apn.batch_id IS NULL AND ISNULL(apn.record_id,'')<>''*/
    
/*Notification Change FS20180919*/    
    
    
    
    
IF @mode=1    
BEGIN    
SELECT     
batch_id email_id    
,apn.resource_id    
,apn.subscriber_id    
,apn.notification_body    
,apn.notification_type    
,apn.create_id    
,apn.create_date    
,apn.source    
,apn.record_id    
,apn.transaction_id    
,apsi.locale    
,apsi.timeZone    
,apsi.device_token    
,CASE WHEN LTRIM(RTRIM(APSI.MAKE))='APPLE' THEN '1' ELSE '2' END DEVICE_TYPE/*CHANGE NABBASI08172018 */    
,batch_id    
FROM #sumarized_notification apn     
--INNER JOIN #subscribers s ON apn.subscriber_id=s.subscriber_id    
INNER JOIN pdd_apps_subscriber_info apsi    
ON apn.subscriber_id=apsi.subscriber_id    
--WHERE ISNULL(apn.write_flag,'')='' AND ISNULL(apn.delete_flag, '') <> 1 AND apn.create_date >= DATEADD(day,-2, GETDATE())    
    
    
    
END    
    
IF @mode=2    
BEGIN    
    
SELECT     
COUNT(*) total_records    
FROM #sumarized_notification apn     
--INNER JOIN pdd_apps_subscriber_info apsi    
--ON apn.subscriber_id=apsi.subscriber_id    
--WHERE ISNULL(apn.read_flag,'')='' AND ISNULL(apn.delete_flag, '') <> 1 AND apn.create_date >= DATEADD(day,-2, GETDATE())    
WHERE apn.subscriber_id = @subscriber_id    
END    
END
GO
