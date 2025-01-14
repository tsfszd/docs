
/****** Object:  View [dbo].[plv_event_notification]    Script Date: 07/15/2015 01:37:46 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[plv_event_notification]'))
DROP VIEW [dbo].[plv_event_notification]
GO


/****** Object:  View [dbo].[plv_event_notification]    Script Date: 07/15/2015 01:37:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE VIEW [dbo].[plv_event_notification]       
/* ****************************************************************** *       
* Copyright 1996 Paradigm Technologies, Inc.                          *       
* All Rights Reserved                                                 *       
*                                                                     *       
* This Media contains confidential and proprietary information of     *       
* Paradigm Technologies, Inc.  No disclosure or use of any portion    *       
* of the contents of these materials may be made without the express  *       
* written consent of Paradigm Technologies, Inc.                      *       
*                                                                     *       
* Use of this software is restricted and governed by a License        *       
* Agreement.  This software contains confidential and proprietary     *       
* information of Paradigm Technologies, Inc. and is protected by      *       
* copyright, trade secret and trademark law.                          *       
*                                                                     *       
* ******************************************************************* *       
       
*                                                                     *       
*         Name: plv_entity_change_notify                                        *       
*       Module:                                                 *       
* Date created: June 29, 2015                                        *       
*           By: Hamza Mughal                                     *       
*      Version:                                                 *       
       
    
*                                                                     *       
******************************************************************** */       
AS       
       
       
SELECT * from eSM912TE_SIGNUK_AX..pdd_event_notification  
      
GO