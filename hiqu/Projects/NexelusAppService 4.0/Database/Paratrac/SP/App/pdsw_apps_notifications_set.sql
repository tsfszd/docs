
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_notifications_set]') AND type in (N'P', N'PC'))
begin
DROP PROCEDURE [dbo].[pdsw_apps_notifications_set]
end
GO
CREATE PROCEDURE pdsw_apps_notifications_set
@email_id int,
@read_flag int=null,
@write_flag int=null
AS
BEGIN

IF @read_flag is not null
BEGIN
UPDATE pdd_apps_notification
SET read_flag = @read_flag
--WHERE email_id = @email_id
WHERE batch_id = @email_id
END

IF @write_flag is not null
BEGIN
UPDATE pdd_apps_notification
SET write_flag = @write_flag
--WHERE email_id = @email_id
WHERE batch_id = @email_id
END

END



GO