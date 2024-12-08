go

if exists(select * from sys.procedures where name='pdsw_apps_delete_subscriber_data'
)
begin 
drop proc pdsw_apps_delete_subscriber_data
end
go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pdsw_apps_delete_subscriber_data
@subscriber_id int
AS

DELETE 
FROM pdd_event_notification
where subscriber_id=@subscriber_id



go