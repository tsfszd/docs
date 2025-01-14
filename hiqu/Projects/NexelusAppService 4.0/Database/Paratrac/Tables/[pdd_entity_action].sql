

/****** Object:  Table [dbo].[pdd_entity_action]    Script Date: 07/01/2015 10:37:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdd_entity_action]') AND type in (N'U'))
DROP TABLE [dbo].[pdd_entity_action]
GO

/****** Object:  Table [dbo].[pdd_entity_action]    Script Date: 07/01/2015 10:37:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[pdd_entity_action](
	[entity_action_id] [int] NOT NULL,
	[entity_action_desc] [varchar](64) NULL,
 CONSTRAINT [PK_pdd_entity_action] PRIMARY KEY CLUSTERED 
(
	[entity_action_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO