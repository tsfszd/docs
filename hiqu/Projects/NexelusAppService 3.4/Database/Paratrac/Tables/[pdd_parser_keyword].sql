/****** Object:  Table [dbo].[pdd_level1]    Script Date: 06/11/2015 12:31:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdd_parser_keyword]') AND type in (N'U'))
DROP TABLE [dbo].[pdd_parser_keyword]
GO

/****** Object:  Table [dbo].[pdd_level1]    Script Date: 06/11/2015 12:31:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[pdd_parser_keyword](
	[keyword] [varchar] (32) NOT NULL,
	[token] [varchar] (32) NOT NULL,
	[priority] [int] NOT NULL,
	[create_date] [datetime] NOT NULL,
	[create_id] [varchar] (64) NOT NULL,
	[modify_date] [datetime] NULL,
	[modify_id] [varchar] (64) NULL
 CONSTRAINT [PK_PDD_PARSER_KEYWORD] PRIMARY KEY CLUSTERED 
(
	[keyword] ASC,
	[token] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO