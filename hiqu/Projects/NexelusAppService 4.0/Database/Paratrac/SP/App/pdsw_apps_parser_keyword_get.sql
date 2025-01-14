/****** Object:  StoredProcedure [dbo].[pdsw_apps_parser_keyword_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_parser_keyword_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_parser_keyword_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_parser_keyword_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  


-- =============================================
-- Author:		<Author,,Hamza Mughal>
-- Create date: <Create Date,,11 June 2015>
-- Description:	<Description,,Get the parser keywords>
-- =============================================
CREATE PROCEDURE pdsw_apps_parser_keyword_get
	-- Add the parameters for the stored procedure here
	@last_sync_date datetime = null
AS
BEGIN
	
	SELECT * FROM [pdd_parser_keyword]
	WHERE ISNULL(modify_date, create_date) > isnull(@last_sync_date, '1900-01-01')
END





go