IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_rule_set]') AND type in (N'P', N'PC'))
begin
DROP PROCEDURE [dbo].[pdsw_apps_rule_set]
end
GO

CREATE PROCEDURE pdsw_apps_rule_set
@resource_id varchar(16),  
@default_code varchar(255) = NULL ,
@company_code int = null
AS 
BEGIN
DECLARE @path varchar(255),@permission_status int,@userID varchar(32),@user_group_code varchar(32)

SET @path='Rules/TimeandExpense/Approvals/TimeSheet/DefaultView'
SET @permission_status= 255
SELECT @userID=loginid FROM pdd_resources WHERE resource_id=@resource_id
SELECT @user_group_code=user_group_code FROM pdm_group_user_link WHERE resource_id = @resource_id

EXEC pdsW_ruleset_set @user_group_code=@user_group_code,@path=@path,@permission_status=@permission_status,@userID=@userID,@defaultCode=@default_code

END



GO