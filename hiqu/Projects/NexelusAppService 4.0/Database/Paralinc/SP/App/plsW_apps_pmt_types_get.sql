IF EXISTS(SELECT * FROM sys.procedures where name ='plsW_apps_pmt_types_get')
begin
DROP PROCEDURE plsW_apps_pmt_types_get
end
GO
/****** Object:  Stored Procedure dbo.plsW_pmt_types_get    Script Date: 11/20/2000 19:54:48 ******/ 
/****** Object:  Stored Procedure dbo.plsW_pmt_types_get    Script Date: 06/23/2000 12:39:33 ******/ 
CREATE PROC plsW_apps_pmt_types_get 
@company_code      int 
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
*         Name: plsW_pmt_types_get                              * 
*       Module:                                                 * 
* Date created: 11/02/99                                        * 
 
*           By: Alex Peker                                      * 
*      Version:                                                 * 
*      Comment:                                                 * 
*                                                               * 
* Date revised:                                                 * 
*           By:                                         * 
*      Comment:                                         * 
*                                                                     * 
*                                                                     * 
******************************************************************** */ 
AS 
exec plsW_pmt_types_get @company_code

GO

