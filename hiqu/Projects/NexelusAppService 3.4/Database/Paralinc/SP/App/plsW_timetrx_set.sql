if exists(select 1 from sys.procedures where name ='plsW_timetrx_set')
begin 
drop procedure plsW_timetrx_set
end
go   


/****** Object:  Stored Procedure dbo.plsW_app_trx_update    Script Date: 06/23/2000 12:39:33 ******/
--DROP PROCEDURE plsW_app_trx_update
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 
  
   
    
CREATE PROC [dbo].[plsW_timetrx_set]    
@action_flag tinyint,       /* 1 - insert new row, 2 - update row, 3 - delete row */       
@company_code      int                  ,       
@level2_key        varchar(32)          ,       
@level3_key        varchar(16)          ,       
@transaction_id_inp    varchar(18)          ,       
@applied_date      datetime     ,       
@org_unit          varchar(16)           ,       
@location_code      char(16)            ,       
@resource_id       varchar(16)          ,       
@comments          varchar(3000)         ,       
@task_code    varchar(16),       
@res_usage_code    varchar(16),       
@submitted_flag    tinyint,       
@trx_type          int,       
@line_id           varchar(16)      ,       
@units             float,       
@nonbill_flag      tinyint,       
@TS            binary(8) = null ,       
@override_flag     tinyint = 0,       
@approval_flag     tinyint = 0          ,       
@approval_comment  varchar(255) = null,       
@create_id varchar(32) = null,       
@modify_id varchar(32) = null,       
@extra_param_1 varchar(255) =null,       
@extra_param_2 varchar(255) =null,       
@outlook_entry_id varchar(255)= null       
       
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
*           Name: plsW_timetrx_set                                  *       
*         Module:                                                 *       
*   Date created: 12/09/99                                        *       
*             By: Alex Peker                                  *       
*        Version:                                                 *       
*        Comment:                                                 *       
*                                                                 *       
*   Date revised: 09/27/2004                                       *       
*             By: Shamim Ahmad Zafar                               *       
*        Comment: To eliminate 0 unit transactions                    *       
*                                                                     *       
*   Date revised: 08/17/2005                                       *       
*             By: Nauman Khan                               *       
*        Comment: Added two new fields extra param(s)                    *       
       
******************************************************************** */       
AS       
       
declare @level2_status int,       
@level3_status int,       
@level2_sysname varchar(32),       
@level3_sysname varchar(32),       
@date_opened datetime,       
@date_closed datetime,       
@labor_flag tinyint       
       
   
if @trx_type is null or @trx_type = '' select @trx_type = trx_type from  plv_resource where company_code = @company_code and resource_id = @resource_id  
  
if @res_usage_code is null or @res_usage_code = '' select @res_usage_code = res_usage_code from  plv_resource where company_code = @company_code and resource_id = @resource_id  
       
select @level2_sysname=display_name from plv_sysnames where field_name='TIME_BASED_Level2_descr' and company_code=@company_code       
select @level3_sysname=display_name from plv_sysnames where field_name='TIME_BASED_Level3_descr' and company_code=@company_code       
       
select @level2_status = level2_status from plv_level2       
where level2_key  =  @level2_key       

if @action_flag <> 3 --Don't check status for Deletion...
begin
	IF   @level2_status <> 1     
	Begin     
		select -2 ERROR_CODE, 'Cannot Save or Delete any Transaction for this '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + ' is not active'   ERROR_DESCRIPTION     
		return (0)     
	End     
end  

    
IF ( @action_flag = 1 or @action_flag = 2)       
Begin       
select @date_opened  = date_opened from plv_level2       
where level2_key  =  @level2_key       
select @date_closed  = date_closed from plv_level2       
where level2_key  =  @level2_key       
IF       
(       
       
/*(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or       
(@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/       
@date_opened is not null and @applied_date < @date_opened       
)       
Begin       
select -3 ERROR_CODE, 'Cannot Save Transaction for the <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'
+ rtrim(ltrim(@level2_sysname)) + '(s) is not valid earlier than '+  convert(varchar,month(@date_opened))+'/'+convert(varchar,day(@date_opened))+'/'+convert(varchar,year(@date_opened))  ERROR_DESCRIPTION           
return (0)                
End       
       
IF       
(       
/*(@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or       
       
(@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/       
 @date_closed IS NOT NULL and @applied_date > @date_closed       
)       
Begin       
select -4 ERROR_CODE, 'Cannot Save Transaction for the <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + '(s) is not valid later than '+ convert(varchar,month(@date_closed))+'/'+
convert(varchar,day(@date_closed))+'/'+convert(varchar,year(@date_closed))  ERROR_DESCRIPTION           
return (0)        
End       
End       
       
IF exists ( select 1 from plv_level3  where level2_key = @level2_key and level3_key  =  @level3_key  )       
Begin       
select @level3_status = level3_status from plv_level3       
where  level2_key =   @level2_key       
    and  level3_key  =  @level3_key       

IF   @level3_status <> 1 and @action_flag <> 3       
Begin  
-- HAMZA -- 20150309 -- Removed the extra level2 sysname from the error message.       
select -5 ERROR_CODE, 'Cannot Save or Delete any Transaction for this <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'. '/*+ rtrim(ltrim(@level2_sysname)) +' '*/ + '<b>' + rtrim(ltrim(@level3_sysname))+'</b>: '+rtrim(ltrim(@level3_k
ey))+'.'+ rtrim(ltrim(@level3_sysname)) + ' is not Open'   ERROR_DESCRIPTION           
return (0)
End       
       
IF ( @action_flag = 1 or @action_flag = 2)       
Begin       
select @date_opened  = date_opened from plv_level3      
where  level2_key =   @level2_key       
    and  level3_key  =  @level3_key       
select @date_closed  = date_closed from plv_level3       
where  level2_key =   @level2_key       
    and  level3_key  =  @level3_key       
IF       
( 
       
       
  /*(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or       
(@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/       
 @date_opened is not null and @applied_date < @date_opened       
)       
Begin       
-- HAMZA -- 20150309 -- Removed the extra level2 sysname from the error message.              
select -6 ERROR_CODE, 'Cannot Save Transaction for the <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'/*+ rtrim(ltrim(@level2_sysname)) +' '*/
+ '<b>' +rtrim(ltrim(@level3_sysname))+'</b>: '+rtrim(ltrim(@level3_key))+'.'+ rtrim(ltrim(@level3_sysname)) + '(s) is not valid earlier than '
+  convert(varchar,month(@date_opened))+'/'+convert(varchar,day(@date_opened))+'/'+convert(varchar,year(@date_opened)) ERROR_DESCRIPTION           
return (0)  
End       
       
IF       
(       
        
/* (@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or       
       
(@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/       
 @date_closed IS NOT NULL and @applied_date > @date_closed       
)       
Begin       
--IK 02112013
-- HAMZA -- 20150309 -- Removed the extra level2 sysname from the error message.     
select -7 ERROR_CODE, 'Cannot Save Transaction for the <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'/*+ rtrim(ltrim(@level2_sysname)) +' '*/+ '<b>' +rtrim(ltrim(@level3_sysname))+'</b>: '+rtrim(ltrim(@level3_key))+'.'+ rtrim(lt
rim(@level3_sysname))  
 + '(s) is not valid later than '+ convert(varchar,month(@date_closed))+'/'+convert(varchar,day(@date_closed))+'/'+convert(varchar,year(@date_closed)) ERROR_DESCRIPTION           
return (0)           
End       
       
 select @labor_flag  = labor_flag from plv_level3       
where  level2_key =   @level2_key       
    and  level3_key  =  @level3_key       
           
 IF @labor_flag = 0       
 Begin       
 --IK 02112013
 -- HAMZA -- 20150309 -- Removed the extra level2 sysname from the error message.     
 select -8 ERROR_CODE, 'Cannot Save Transaction for this <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'/*+ rtrim(ltrim(@level2_sysname)) +' '*/ + '<b>' +rtrim(ltrim(@level3_sysname))+'</b>: '+rtrim(ltrim(@level3_key))+'.'
 + rtrim(ltrim(@level3_sysname)) + ' is not valid for the Time Entry'  ERROR_DESCRIPTION           
return (0)           
 END       
       
End       
End       
ELSE IF exists ( select 1 from plv_generic_level3       
    where level3_key  =  @level3_key  )       
BEGIN       
  IF ( @action_flag = 1 or @action_flag = 2)       
 BEGIN       
  select @labor_flag  = labor_flag from plv_generic_level3       
                               where level3_key  =  @level3_key       
  IF @labor_flag = 0       
   Begin       
   --IK 02112013
    select -9 ERROR_CODE, 'Cannot Save Transaction for this <b>'+rtrim(ltrim(@level2_sysname))+'</b>: '+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname))+' <b>'+rtrim(ltrim(@level3_sysname))+'</b>: '+rtrim(ltrim(@level3_key))+'.'+ rtrim(ltrim(@
level3_sysname)) 
    + ' is not valid for the Time Entry'  ERROR_DESCRIPTION           
    return (0)                 
   END       
  END       
END       
       
       
SET NOCOUNT ON       
-- AS20110428 -- AS20110413 THIS IS QUICK AND DIRTY FIX FOR THE ISSUE. IT HAS BE FIXED FROM THE APPLICATION    
-- AS20110428 if (select res_usage_code from plv_resource where resource_id = @resource_id) <> @res_usage_code    
-- AS20110428 select @res_usage_code = res_usage_code from plv_resource where resource_id = @resource_id    
  
/* -- AS20110518 Fixed from application  
-- AS20110506 THIS IS QUICK AND DIRTY FIX FOR THE ISSUE. IT MUST BE FIXED FROM THE APPLICATION    
if (select org_unit from plv_resource where resource_id = @resource_id) <> @org_unit  
select @org_unit = org_unit from plv_resource where resource_id = @resource_id    
  
if (select location_code from plv_resource where resource_id = @resource_id) <> @location_code  
select @location_code = location_code from plv_resource where resource_id = @resource_id    
-- AS20110506 END  
*/  
    
DECLARE       
@create_date       datetime    ,        
@modify_date       datetime    ,        
@submitted_date    datetime         ,       
@upload_flag       tinyint          ,       
@upload_date       datetime     ,       
@ts_current BINARY(8),       
 @transaction_id varchar(16)       
       
 IF @action_flag = 1       
 BEGIN       
  IF len(rtrim(@transaction_id_inp)) > 16       
   select @transaction_id = right(rtrim(@transaction_id_inp), 16)       
  ELSE       
   Select @transaction_id = left(@transaction_id_inp,16)       
 END       
 ELSE       
  Select @transaction_id = left(@transaction_id_inp,16)       
       
 WHILE  (SELECT CHARINDEX('"', @comments)) != 0       
 BEGIN       
       
  SELECT @comments = STUFF(@comments, CHARINDEX('"', @comments), 1, '''')       
 END       
 WHILE  (SELECT CHARINDEX('"', @approval_comment)) != 0       
 BEGIN       
       
  SELECT @approval_comment = STUFF(@approval_comment, CHARINDEX('"', @approval_comment), 1, '''')       
 END       
       
 WHILE  (SELECT CHARINDEX('~', @comments)) != 0       
 BEGIN       
       
  SELECT @comments = STUFF(@comments, CHARINDEX('~', @comments), 1, '-')       
 END       
       
 WHILE  (SELECT CHARINDEX('~', @approval_comment)) != 0       
 BEGIN       
       
  SELECT @approval_comment = STUFF(@approval_comment, CHARINDEX('~', @approval_comment), 1, '-')       
 END       
        
        
        
 if ((@org_unit is NULL) or (@org_unit=''))       
 BEGIN       
  SELECT @org_unit=org_unit       
  FROM plv_resource       
  WHERE resource_id=@resource_id       
 END        
        
 if ((@location_code is NULL) or (@location_code=''))       
 BEGIN       
  SELECT @location_code=location_code       
  FROM plv_resource       
  WHERE resource_id=@resource_id       
 END        
       
 if @submitted_flag <> 0 SELECT @submitted_date = GETDATE() ELSE SELECT @submitted_date = NuLL       
       
if @action_flag = 1       
begin       
if exists(       
select 1 from pld_transactions       
where company_code = @company_code       
and resource_id = @resource_id       
and transaction_id = @transaction_id       
)       
begin       
select 1001 ERROR_CODE, @transaction_id +'A Duplicate Transaction Control Number' ERROR_DESCRIPTION       
RETURN(0)       
end       
end       
/* Line ID logic is not valid anymore 20020826       
if @action_flag = 1       
begin       
if exists(       
select 1 from pld_transactions       
where company_code = @company_code       
and resource_id = @resource_id       
and level2_key = @level2_key       
and level3_key = @level3_key       
and applied_date = @applied_date       
and line_id = @line_id       
)       
begin       
select 1001 ERROR_CODE, @transaction_id +'B Duplicate Transaction Control Number' ERROR_DESCRIPTION       
RETURN(0)       
end       
end       
*/       
       
if @action_flag = 1       
begin       
if exists(       
select 1 from pld_transactions       
where company_code = @company_code       
and resource_id = @resource_id       
and level2_key = @level2_key       
and level3_key = @level3_key       
and applied_date = @applied_date       
 and trx_type = @trx_type       
 and isnull(task_code, '') = isnull(@task_code, '')       
 and org_unit = @org_unit       
 and location_code = @location_code       
 and res_usage_code = @res_usage_code       
 and nonbill_flag = @nonbill_flag       
 and isnull(comments, '') = isnull(@comments, '')       
 and units = @units       
       
        
)       
begin       
select 1001 ERROR_CODE, 'Duplicate Transaction for <b>' + rtrim(ltrim(@level2_sysname)) + '</b>: '+ rtrim(ltrim(@level2_key)) + ' <b>' 
 + RTRIM(ltrim(@level3_sysname)) + '</b>: '+ rtrim(ltrim(@level3_key)) +' <b>Date</b>: '+Convert(varchar,convert(date, @applied_date))+' <b>Units</b>: '
 +Convert(varchar,@units) ERROR_DESCRIPTION  
 RETURN(0)    
end       
end       
       
       
       
       
 if @action_flag = 1       
 begin       
  if  @units = 0       
  begin       
   select 0 ERROR_CODE, 'This transaction has 0 units and can not be saved' ERROR_DESCRIPTION       
  RETURN(0)       
  end       
 end       
       
       
       
       
if @action_flag = 1       
begin       
SELECT @create_date   = GETDATE()       
INSERT   pld_transactions (       
company_code        ,       
level2_key          ,       
level3_key          ,       
transaction_id      ,       
applied_date        ,       
org_unit            ,       
location_code       ,       
resource_id         ,       
comments            ,       
submitted_flag      ,       
submitted_date      ,       
upload_flag     ,       
upload_date     ,       
create_id       ,       
create_date     ,       
modify_id       ,       
modify_date     ,       
trx_type            ,       
vendor_id       ,       
payment_code        ,       
payment_name        ,       
pmt_vendor_code     ,       
currency_code       ,       
currency_conversion_rate ,       
allocation_prc      ,       
amount          ,       
amount_home     ,       
amount_billable     ,       
receipt_flag        ,       
reimbursment_flag   ,       
parent_id       ,       
trx_level       ,       
res_usage_code      ,       
task_code,       
units           ,       
nonbill_flag        ,       
line_id         ,       
record_id       ,       
gst_tax_code        ,       
gst_tax_amt     ,       
net_amount      ,       
approval_flag                          ,       
approval_comment,       
     extra_param_1,       
     extra_param_2,       
outlook_entry_id )       
VALUES (       
@company_code       ,       
@level2_key         ,       
@level3_key         ,       
@transaction_id     ,       
@applied_date       ,       
@org_unit           ,       
@location_code          ,       
@resource_id        ,       
@comments           ,       
@submitted_flag     ,       
@submitted_date     ,       
0,          
NULL            , /* upload_date */       
@create_id      ,       
@create_date,       
NULL            , /* modify_id */       
NULL            , /* modify_date */       
@trx_type           ,       
'',        
0,         
'',        
'',        
'',        
0,         
0,         
0,         
0,         
0,         
0,         
0,         
'',        
0,         
@res_usage_code,       
@task_code,       
@units,       
@nonbill_flag,       
@line_id,       
'',         
'',         
0,          
0,          
@approval_flag,       
@approval_comment,       
     @extra_param_1,       
     @extra_param_2,       
@outlook_entry_id )       
       
       
IF @@error = 0       
select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION       
ELSE       
select 1002 ERROR_CODE, @transaction_id +' Insert Failed' ERROR_DESCRIPTION       
       
RETURN(0)       
end       
       
if @action_flag = 2       
begin       
SELECT  @modify_date   = GETDATE()       
       
SELECT  @ts_current=0x0       
SELECT  @ts_current=CONVERT(BINARY(8), TIMESTAMP)       
FROM    pld_transactions WHERE transaction_id = @transaction_id and company_code=@company_code       
       
if @ts_current=0x0       
BEGIN       
select 1003 ERROR_CODE, @transaction_id +' Transaction Was Deleted' ERROR_DESCRIPTION       
RETURN(0)       
END       
       

-- HAMZA -- 20170531 -- commented the check "@override_flag = 0 and" in the below IF because @override_flag is always = 1 incase of update trx.

if /*@override_flag = 0 and */@TS is not null       
BEGIN       
if @ts_current<>@TS       
BEGIN       
/* record was changed */       
select 1004 ERROR_CODE, 'Transaction(s) were changed. Please refresh.' ERROR_DESCRIPTION       
RETURN(0)       
END       
END       
 if exists(       
 select 1 from pld_transactions       
         where company_code = @company_code       
         and resource_id = @resource_id       
         and level2_key = @level2_key       
         and level3_key = @level3_key       
         and applied_date = @applied_date       
  and trx_type = @trx_type       
  and isnull(task_code, '') = isnull(@task_code, '')       
  and org_unit = @org_unit       
  and location_code = @location_code       
  and res_usage_code = @res_usage_code       
  and nonbill_flag = @nonbill_flag       
  and isnull(comments, '') = isnull(@comments, '')       
  and units = @units       
  and transaction_id <> @transaction_id       
         
)       
begin       
select 1001 ERROR_CODE, 'Duplicate Transaction for <b>' + rtrim(ltrim(@level2_sysname)) + '</b>: '+ rtrim(ltrim(@level2_key)) + ' <b>' 
 + RTRIM(ltrim(@level3_sysname)) + '</b>: '+ rtrim(ltrim(@level3_key)) +' <b>Date</b>: '+Convert(varchar,convert(date, @applied_date))+' <b>Units</b>: '
 +Convert(varchar,@units) ERROR_DESCRIPTION  
 RETURN(0)
end       
       
       
       
 if  @units = 0       
 begin       
  DELETE pld_transactions       
  WHERE   company_code = @company_code AND       
  transaction_id = @transaction_id AND       
  upload_flag = 0       
       
  select 0 ERROR_CODE, 'This transaction has 0 units and can not be saved' ERROR_DESCRIPTION       
 RETURN(0)       
 end       
       
       
       
       
UPDATE pld_transactions       
SET       
level2_key      = @level2_key       ,       
level3_key      = @level3_key           ,       
applied_date    = @applied_date     ,       
org_unit        = @org_unit             ,       
location_code   = @location_code        ,       
comments        = @comments             ,       
submitted_flag  = @submitted_flag       ,       
submitted_date  = @submitted_date       ,       
modify_id       = @modify_id            ,       
modify_date     = @modify_date      ,       
trx_type        = @trx_type         ,       
line_id         = @line_id      ,       
res_usage_code  = @res_usage_code   ,       
     task_code       = @task_code,       
units           = @units    ,       
nonbill_flag    = @nonbill_flag,       
approval_flag   = null,       
approval_date   = null,       
     extra_param_1=@extra_param_1,       
     extra_param_2=@extra_param_2,       
outlook_entry_id = @outlook_entry_id       
       
WHERE  company_code = @company_code  AND transaction_id = @transaction_id       
IF @@error = 0       
select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION       
ELSE       
select 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION       
RETURN(0)       
end       
       
if @action_flag = 3       
begin      

Insert into pld_transactions_delete_log --SD 20141223    
Select trx.company_code,trx.transaction_id,trx.resource_id,GETDATE()    
from pld_transactions trx    
where trx.company_code=@company_code     
and trx.transaction_id=@transaction_id     
and trx.upload_flag=0 
 
DELETE pld_transactions       
WHERE   company_code = @company_code AND       
transaction_id = @transaction_id AND       
upload_flag = 0       
IF @@error = 0       
select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION       
ELSE       
select 1006 ERROR_CODE, @transaction_id +' Delete Failed' ERROR_DESCRIPTION       
RETURN(0)       
end       
       
RETURN(0)       
    
    
  
  



go