
drop PROC plsW_exptrx_hdr_set 
go
CREATE PROC plsW_exptrx_hdr_set                   
@action_flag       tinyint,  /* 1 - insert new row, 2 - update row, 3 - delete row */                     
@company_code      int                  ,                     
@report_name       varchar(32)          ,                     
@resource_id       varchar(16)          ,                     
@record_id         varchar(16)          ,                     
@comments          varchar(252)         ,                     
@date_from         datetime  ,                     
@date_to        datetime  ,                     
@expense_num       varchar(16)          ,                     
@amount         float    ,                     
@TS          binary(8) = null ,                     
@override_flag     tinyint = 0,                     
@create_id varchar(32) = null,                     
@modify_id varchar(32) = null,                     
@approver_id varchar(32)= null,                     
@print_format varchar(50)= null  ,    
@source varchar(64)=null                   
                   
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
*         Name: plsW_exptrx_hdr_set                             *                 
*       Module:                                                 *                 
* Date created: 12/14/99                                        *                 
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
                  
                  
DECLARE                     
@create_date       smalldatetime ,                     
@modify_date       smalldatetime ,                     
@ts_current        BINARY(8)                    
  /*                
Temporary change                
*/                
if @date_to>'12/31/2999'                
begin                
declare                
@yearSuffix varchar(2)='00',                
@month varchar (4) = 0,             
@day varchar (4) = 0,                
@string varchar(12)=''                
                
set @yearSuffix= RIGHT(YEAR(@date_to),2)                
set @month= month(@date_to)                
set @day= DAY(@date_to)                
set @string='20'+@yearSuffix+'/'+@month+'/'+@day                
set @date_to=@string                
                
end                
/*                
Temporary change                
*/                 
                     
WHILE  (SELECT CHARINDEX('"', @comments)) != 0                     
BEGIN                     
SELECT @comments = STUFF(@comments, CHARINDEX('"', @comments), 1, '''')                     
END                     
                    
if @action_flag = 1                     
BEGIN                     
if exists(select 1 from pld_transactions_hdr where company_code = @company_code and record_id = @record_id )                     
BEGIN                     
select '1001_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Duplicate Report' ERROR_DESCRIPTION,                     
report_name, comments, expense_num, amount, date_from, date_to, timestamp,approver_id,print_format                     
FROM pld_transactions_hdr                     
WHERE company_code = @company_code and record_id = @record_id                     
RETURN (0)                     
END                     
END                     
if @action_flag = 1                     
BEGIN                     
SELECT @create_date   = GETDATE()                     
INSERT   pld_transactions_hdr (                     
company_code       ,                     
report_name        ,                     
resource_id        ,                     
record_id          ,                     
comments    ,                     
date_from    ,                     
date_to            ,                     
expense_num        ,                     
modify_date   ,                     
modify_id          ,                     
                     
create_date        ,                     
create_id    ,                     
amount,                     
approver_id,                     
print_format,    
[source] )                     
VALUES (                     
@company_code,        
@report_name,        
@resource_id,        
@record_id,        
@comments,                     
@date_from,        
@date_to,        
@expense_num,        
null      ,/* modify_date */        
null      ,/* modify_id  */        
@create_date,        
@create_id,        
@amount,        
@approver_id,        
@print_format,    
@source        
)                     
                     
IF @@error = 0        
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION,                     
report_name, comments, expense_num, amount, date_from, date_to, timestamp,approver_id,print_format                     
FROM pld_transactions_hdr                     
WHERE company_code = @company_code and record_id = @record_id                     
ELSE                     
SELECT '1002_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Insert Failed' ERROR_DESCRIPTION, 0x0 TS,            
null as report_name, null as comments, null as expense_num, null as amount, null as date_from,             
null as date_to, null as timestamp, null as approver_id, null as print_format                
RETURN (0)                     
END                     
IF @action_flag = 2                     
BEGIN                     
SELECT @modify_date = GETDATE()                     
SELECT @ts_current=0x0                     
SELECT  @ts_current=CONVERT(BINARY(8), TIMESTAMP)                     
FROM  pld_transactions_hdr WHERE record_id = @record_id and company_code=@company_code                     
                     
IF @ts_current=0x0                     
BEGIN                     
SELECT '1003_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Report was Deleted' ERROR_DESCRIPTION, 0x0 TS,            
null as report_name, null as comments, null as expense_num, null as amount, null as date_from,             
null as date_to, null as timestamp, null as approver_id, null as print_format        /* record was deleted */                     
RETURN (0)                     
END                     
                     
IF @override_flag = 0 and @TS is not null                     
BEGIN                     
IF @ts_current<>@TS                     
BEGIN                     
/* record was changed */                     
SELECT '1004_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Report was Changed' ERROR_DESCRIPTION,                     
report_name, comments, expense_num, amount, date_from, date_to, timestamp,approver_id,print_format                     
FROM pld_transactions_hdr                     
WHERE company_code = @company_code and record_id = @record_id       
RETURN (0)                     
END                     
END                     
UPDATE pld_transactions_hdr                     
SET                     
report_name          = @report_name ,                     
comments             = @comments         ,                     
date_from            = @date_from        ,                     
date_to              = @date_to      ,                     
expense_num          = @expense_num      ,                     
modify_id            = @modify_id        ,                     
modify_date  = @modify_date   ,                     
amount           = @amount,                     
approver_id   = @approver_id,                     
print_format         = @print_format,    
[source]=@source                     
WHERE                     
company_code = @company_code AND                     
record_id = @record_id                     
IF @@error = 0                     
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION,                     
report_name, comments, expense_num, amount, date_from, date_to, timestamp,approver_id,print_format                     
FROM pld_transactions_hdr                     
WHERE company_code = @company_code and record_id = @record_id                     
ELSE                     
SELECT '1005_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Update Failed' ERROR_DESCRIPTION, 0x0 TS,            
null as report_name, null as comments, null as expense_num, null as amount, null as date_from,             
null as date_to, null as timestamp, null as approver_id, null as print_format                         
RETURN (0)                     
END                     
IF @action_flag = 3                     
BEGIN                     
DELETE pld_transactions_hdr                     
WHERE                     
company_code = @company_code AND                     
record_id = @record_id                     
IF @@error = 0                     
SELECT 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION,         
null as report_name, null as comments, null as expense_num, null as amount, null as date_from,             
null as date_to, null as timestamp, null as approver_id, null as print_format                         
ELSE                     
SELECT '1006_H' ERROR_CODE, @report_name + ', ' + @record_id + ': Delete Failed' ERROR_DESCRIPTION,            
null as report_name, null as comments, null as expense_num, null as amount, null as date_from,             
null as date_to, null as timestamp, null as approver_id, null as print_format                         
RETURN (0)                     
END                     
RETURN (0) 