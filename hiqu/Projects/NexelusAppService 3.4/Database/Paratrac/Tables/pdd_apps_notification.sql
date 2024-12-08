if not exists(select 1 from sys.tables where name='pdd_apps_notification')
begin 
create table pdd_apps_notification
(
company_code int,
email_id int identity(1,1),
resource_id varchar(32),
subscriber_id varchar(32),
notification_body varchar (8000),
notification_type varchar(256),
delete_flag int,
delete_date datetime,
read_flag int,
read_date datetime,
create_id varchar(32), 
create_date DATETIME, 
modify_id varchar(32), 
modify_date DATETIME,
[source] varchar(32),
record_id varchar(256),
transaction_id varchar(256)
)


end



