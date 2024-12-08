
/****** Object:  Table [dbo].[pdd_apps_subscriber_info]    Script Date: 07/15/2015 01:20:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdd_apps_subscriber_info]') AND type in (N'U'))
DROP TABLE [dbo].[pdd_apps_subscriber_info]
GO



/****** Object:  Table [dbo].[pdd_apps_subscriber_info]    Script Date: 07/15/2015 01:20:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[pdd_apps_subscriber_info](
	[subscriber_id] [int] IDENTITY(1,1) NOT NULL,
	[company_code] [int] NULL,
	[resource_id] [nvarchar](15) NULL,
	[os_version] [nvarchar](500) NULL,
	[model] [nvarchar](500) NULL,
	[make] [nvarchar](500) NULL,
	[product_number] [nvarchar](500) NULL,
	[is_active] [bit] NULL,
	[last_access_date] [datetime] NULL,
	[create_date] [datetime] NULL,
	[modify_date] [datetime] NULL,
	[locale] [nvarchar](100) NULL,
	[timeZone] [nvarchar](500) NULL,
 CONSTRAINT [PK_pdd_entity_type2] PRIMARY KEY CLUSTERED 
(
	[subscriber_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pdd_event_notification_pdd_entity_action]') AND parent_object_id = OBJECT_ID(N'[dbo].[pdd_event_notification]'))
ALTER TABLE [dbo].[pdd_event_notification] DROP CONSTRAINT [FK_pdd_event_notification_pdd_entity_action]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pdd_event_notification_pdd_entity_type]') AND parent_object_id = OBJECT_ID(N'[dbo].[pdd_event_notification]'))
ALTER TABLE [dbo].[pdd_event_notification] DROP CONSTRAINT [FK_pdd_event_notification_pdd_entity_type]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pdd_event_notification_pdm_company]') AND parent_object_id = OBJECT_ID(N'[dbo].[pdd_event_notification]'))
ALTER TABLE [dbo].[pdd_event_notification] DROP CONSTRAINT [FK_pdd_event_notification_pdm_company]
GO
