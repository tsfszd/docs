if exists(select 1 from sys.procedures where name ='pls_mc_Apps_exists')
begin 
drop procedure pls_mc_Apps_exists
end
go   



CREATE PROCEDURE [dbo].[pls_mc_Apps_exists] (   
@company_code int = 0   
,@action int = 0   
   
   
,@mc_exists int = 0 OUTPUT   
)   
AS   
/* ****************************************************************** *   
* Copyright 1996 - 1999 Paradigm Software Technologies, Inc.          *   
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
*         Name: pds_mc_exists                                         *   
*       Module:                                                       *   
* Date created: 11/18/2015                                              *   
*           By: hamad safder                                          *   
*      Version: 1.00                                                  *   
*      Comment: inherited from pds_mc_exists								  *   
*                                                                     *   
* Date revised:                                                       *   
*           By:                                                       *   
*      Comment:                                                       *   
*                                                                     *   
*                                                                     *   
********************************************************************  */   
  
   
   
SET NOCOUNT ON   
   
   
   
SELECT @mc_exists =   
IsNull(   
(SELECT 1   
FROM plv_company   
WHERE company_code = @company_code   
AND multi_currency_flag = 1)   
,0)   
   
if @mc_exists is null select @mc_exists = 0   
   
   
   
IF @action = 0 SELECT @mc_exists   
   
RETURN  





go