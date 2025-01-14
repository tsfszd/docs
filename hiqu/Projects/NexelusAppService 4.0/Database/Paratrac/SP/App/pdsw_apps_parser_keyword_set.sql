/****** Object:  StoredProcedure [dbo].[pdsw_apps_parser_keyword_set] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_parser_keyword_set]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_parser_keyword_set]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_parser_keyword_set] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
-- =============================================
-- Author:		<Author,,Hamza Mughal>
-- Create date: <Create Date,,11 June 2015>
-- Description:	<Description,,To set the parser_keyword>
-- =============================================
CREATE PROCEDURE pdsw_apps_parser_keyword_set
	-- Add the parameters for the stored procedure here
	@keyword varchar(32),
	@token varchar(32),
	@priority int
AS
BEGIN
	if exists (select 1 from pdd_parser_keyword where keyword = @keyword and token = @token)
	begin
		update pdd_parser_keyword
		set priority = @priority,
			modify_date = GETDATE(),
			modify_id = 'sa'
		where keyword = @keyword and
			  token = @token
	end
	else
	begin
		insert into pdd_parser_keyword
			([keyword],[token],[priority], [create_id], [create_date])
		values (@keyword, @token, @priority, 'sa', GETDATE())
	end
END





go