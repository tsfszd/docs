if exists(select 1 from sys.procedures where name ='plsW_apps_rate_types_dtl_get')
begin 
drop procedure plsW_apps_rate_types_dtl_get
end
go   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






CREATE PROCEDURE [dbo].[plsW_apps_rate_types_dtl_get]   
/******************************************************************** */   
@company_code int,   
@rate_type varchar(8),   
@to_currency varchar(8)=NULL   
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
*            Name: dbo.pdsW_rate_types_hdr_get                          *   
*          Module:                                                    *   
*    Date created: 11/18/2015                                          *   
*              By: hamad safder                                        *   
*         Version: 1.00                                               *   
*         Comment: inherted from pdsW_rate_types_dtl_get                        *   
*                                                                     *   
*                                                                     *   
*    Date revised:                                                    *   
*              By:                                                    *   
*         Comment:                                                    *   
*                                                                     *   
*                                                                     *   
******************************************************************** */   
   
DECLARE @integration_code tinyint   
,@date_value int   
   
   
DECLARE @GP INT   
   
DECLARE @EPICOR INT   
   
DECLARE @GP_VALUE INT   
   
DECLARE @EPICOR_VALUE INT   
   
SELECT @GP=6   
SELECT @EPICOR=1   
SELECT @GP_VALUE=53500   
SELECT @EPICOR_VALUE=693596   
   
SELECT @integration_code=integration_code from plv_company   
IF (@integration_code=@GP)   
BEGIN   
SELECT @date_value=@GP_VALUE   
END   
ELSE   
BEGIN   
SELECT @date_value=@EPICOR_VALUE   
END   
   
Create Table #CurrencyConversion(   
rate_type varchar(8),   
from_currency varchar(8),   
to_currency varchar(8),   
factor  float,   
effective_date datetime,   
convert_date  int,   
valid_for_days  int,   
divide_flag smallint   
   
)   
   
   
IF ((SELECT multi_currency_flag FROM plv_interfaces where company_code=@company_code)=1)   
BEGIN   
   
 INSERT INTO #CurrencyConversion(rate_type,from_currency,to_currency,factor,   
 convert_date,valid_for_days)   
 SELECT CONVERT(varchar(8), rate_type), from_currency, to_currency,buy_rate,    
 convert_date,valid_for_days   
 FROM plv_mccurtdt   
 where rate_type = @rate_type   
 and from_currency not in ( select  currency_code from plv_currencies where status_flag <> 1 )   
 and to_currency  not in ( select  currency_code from plv_currencies where status_flag <> 1 )   
   
    
 UPDATE #CurrencyConversion   
 SET effective_date=dateadd(day, (convert_date - 700901)+1,'1/1/1920')   
 WHere convert_date <> 0   
   
    
 UPDATE #CurrencyConversion   
 SET effective_date=convert(datetime,'01/01/1900')   
 WHere convert_date = 0   
   
   
 /*    UPDATE #CurrencyConversion   
 SET factor=dt.buy_rate   
 FROM #CurrencyConversion CurConv   
 JOIN pdv_mccurtdt dt   
 ON CurConv.rate_type=dt.rate_type   
 AND CurConv.from_currency=dt.from_currency   
 AND CurConv.to_currency=dt.to_currency   
 AND CurConv.effective_date   
 BETWEEN DATEADD(DD, CurConv.convert_date - @date_value, '01/01/1900')   
 AND DATEADD(DD, CurConv.convert_date - @date_value + CurConv.valid_for_days, '01/01/1900')   
 WHERE EXISTS(select 1 from pdv_mccurtdt   
 WHERE pdv_mccurtdt.rate_type = CurConv.rate_type   
 AND CurConv.from_currency=pdv_mccurtdt.from_currency   
 AND CurConv.to_currency=pdv_mccurtdt.to_currency   
 AND CurConv.effective_date   
 BETWEEN DATEADD(DD, CurConv.convert_date - @date_value, '01/01/1900')   
 AND DATEADD(DD, CurConv.convert_date - @date_value + CurConv.valid_for_days, '01/01/1900')   
 )   
 */ 
UPDATE #CurrencyConversion   
 SET factor=dfrt.default_rate,   
 divide_flag=isnull(dfrt.divide_flag,0)   
 FROM #CurrencyConversion CurConv   
JOIN plv_mccurate dfrt   
 ON CurConv.rate_type=dfrt.rate_type   
 AND CurConv.from_currency=dfrt.from_currency   
 AND CurConv.to_currency=dfrt.to_currency   
 WHERE CurConv.factor IS NULL   
 /*UPDATE #CurrencyConversion   
 SET factor=(SELECT TOP 1 dfrt.default_rate   
    FROM pdv_mccurate dfrt   
    WHERE CurConv.rate_type=dfrt.rate_type   
    AND CurConv.from_currency=dfrt.from_currency   
    AND CurConv.to_currency=dfrt.to_currency   
    order by dfrt.default_rate desc    )   
 FROM #CurrencyConversion CurConv   
 WHERE factor IS NULL   
   
 UPDATE #CurrencyConversion   
 SET divide_flag=(SELECT TOP 1 isnull(dfrt.divide_flag,0)   
    FROM pdv_mccurate dfrt   
    WHERE CurConv.rate_type=dfrt.rate_type   
    AND CurConv.from_currency=dfrt.from_currency   
    AND CurConv.to_currency=dfrt.to_currency   
    order by dfrt.default_rate desc )   
 FROM #CurrencyConversion CurConv   
 WHERE divide_flag IS NULL*/   
   
 UPDATE #CurrencyConversion   
 SET factor=1/factor   
 FROM #CurrencyConversion CurConv   
 WHERE (IsNull( factor, 0) > 0 AND divide_flag = 1) OR (IsNull( factor, 0) < 0)   
    
 UPDATE #CurrencyConversion   
 SET factor=0   
 Where factor is NULL   
    
 UPDATE #CurrencyConversion   
 SET factor=ABS(factor)   
   
END   
ELSE   
BEGIN   
 INSERT INTO #CurrencyConversion(rate_type,from_currency,to_currency,factor,effective_date)   
 SELECT CONVERT(varchar(8), mc_rate_type) rate_type, from_currency, to_currency, factor, effective_date   
 FROM plv_mc_rate_type_dtl   
 where convert(varchar(8),mc_rate_type) = @rate_type   
 and from_currency not in ( select  currency_code from pdm_currencies where status_flag <> 1 )   
 and to_currency  not in ( select  currency_code from pdm_currencies where status_flag <> 1 )   
   
END   
   
IF ((@to_currency is not NULL) and (@to_currency <> ''))   
BEGIN    
 SELECT rate_type,   
 from_currency,   
 to_currency,   
 factor,   
 effective_date   
 FROM #CurrencyConversion   
 Where to_currency=@to_currency   
 AND from_currency <> @to_currency   
END   
ELSE   
BEGIN   
 SELECT rate_type,   
 from_currency,   
 to_currency,   
 factor,   
 effective_date   
 FROM #CurrencyConversion   
END   







go