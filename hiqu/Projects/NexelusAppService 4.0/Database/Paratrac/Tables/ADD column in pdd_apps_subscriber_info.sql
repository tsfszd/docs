IF NOT EXISTS (SELECT * FROM sys.columns  WHERE name = 'device_token' AND OBJECT_NAME(object_id) ='pdd_apps_subscriber_info')
ALTER TABLE pdd_apps_subscriber_info ADD device_token VARCHAR(500)
 GO