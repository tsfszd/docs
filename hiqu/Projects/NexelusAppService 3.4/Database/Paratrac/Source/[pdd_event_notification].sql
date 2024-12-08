
/****** Object:  Index [idx]    Script Date: 08/19/2015 02:41:20 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[pdd_event_notification]') AND name = N'idx')
DROP INDEX [idx] ON [dbo].[pdd_event_notification] WITH ( ONLINE = OFF )
GO



/****** Object:  Index [idx]    Script Date: 08/19/2015 02:41:33 ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[pdd_event_notification] 
(
	[primary_key] ASC,
	[entity_action_id] ASC,
	[entity_type_id] ASC,
	[subscriber_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
