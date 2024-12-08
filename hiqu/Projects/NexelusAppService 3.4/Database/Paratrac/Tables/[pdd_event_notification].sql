/****** Object:  Table [dbo].[pdd_event_notification]    Script Date: 07/15/2015 01:22:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdd_event_notification]') AND type in (N'U'))
DROP TABLE [dbo].[pdd_event_notification]
GO



/****** Object:  Table [dbo].[pdd_event_notification]    Script Date: 07/15/2015 01:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[pdd_event_notification](
	[entity_change_id] [bigint] IDENTITY(1,1) NOT NULL,
	[company_code] [int] NULL,
	[primary_key] [varchar](3000) NULL,
	[entity_action_id] [int] NULL,
	[entity_type_id] [int] NULL,
	[subscriber_id] [varchar](64) NULL,
	[create_id] [varchar](64) NULL,
	[create_date] [datetime] NULL,
	[modify_id] [varchar](64) NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_pdd_event_notification] PRIMARY KEY CLUSTERED 
(
	[entity_change_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[pdd_event_notification]  WITH CHECK ADD  CONSTRAINT [FK_pdd_event_notification_pdd_entity_action] FOREIGN KEY([entity_action_id])
REFERENCES [dbo].[pdd_entity_action] ([entity_action_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[pdd_event_notification] CHECK CONSTRAINT [FK_pdd_event_notification_pdd_entity_action]
GO

ALTER TABLE [dbo].[pdd_event_notification]  WITH CHECK ADD  CONSTRAINT [FK_pdd_event_notification_pdd_entity_type] FOREIGN KEY([entity_type_id])
REFERENCES [dbo].[pdd_entity_type] ([entity_type_id])
GO

ALTER TABLE [dbo].[pdd_event_notification] CHECK CONSTRAINT [FK_pdd_event_notification_pdd_entity_type]
GO

ALTER TABLE [dbo].[pdd_event_notification]  WITH CHECK ADD  CONSTRAINT [FK_pdd_event_notification_pdm_company] FOREIGN KEY([company_code])
REFERENCES [dbo].[pdm_company] ([company_code])
GO

ALTER TABLE [dbo].[pdd_event_notification] CHECK CONSTRAINT [FK_pdd_event_notification_pdm_company]
GO
