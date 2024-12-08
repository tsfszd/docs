
drop PROC [dbo].[plsW_exptrx_set]                    
go
CREATE PROC [dbo].[plsW_exptrx_set]                    
@action_flag tinyint,       /* 1 - insert new row, 2 - update row, 3 - delete row,  4 - update file attached flag*/                                                    
@company_code      int                  ,                                                    
@level2_key        varchar(32) =  null         ,                                                    
@level3_key        varchar(16) =  null         ,                                                    
@transaction_id_inp    varchar(18) =  null         ,                                                    
@applied_date      datetime =  null     ,                                                    
@org_unit          varchar(16)=  null           ,                                                    
@location_code      char(16)  =  null          ,                                                    
@resource_id       varchar(16)  =  null        ,                                                    
@comments          varchar(3000) =  null        ,                                                    
@submitted_flag    tinyint =  null     ,                                                    
@trx_type          int  =  null        ,                                                    
@res_type      int     =  null     ,                                                    
@vendor_id     varchar(16)  =  null    ,                                                    
@payment_code      int       =  null   ,                                                    
@payment_name      varchar(16) =  null     ,                                                    
@pmt_vendor_code   varchar(16)  =  null    ,                                                    
@currency_code     varchar(8)   =  null    ,                                                    
@currency_conversion_rate float  =  null   ,                                                    
@allocation_prc    float  =  null      ,                                                    
@amount        float    =  null    ,                                                    
@amount_home       float  =  null      ,                                                    
@amount_billable   float  =  null      ,                                                    
@receipt_flag      tinyint   =  null   ,                                                    
@reimbursment_flag tinyint  =  null    ,                                                    
@trx_level     float        =  null    ,                                                    
@parent_id     varchar(16) =  null     ,                                                    
@line_id       varchar(16) =  null     ,                                                    
@record_id     varchar(16)  =  null    ,                                                    
@tax_code      varchar(8) =  null    ,                                                    
@tax_amount    float = 0        ,                                                    
@net_amount        float = 0        ,                                                    
@res_usage_code    varchar(16) = '' ,                                                    
@mileage_units     float = -1       ,                                                    
@TS            binary(8) = null ,                                                    
@override_flag     tinyint = 0,                                                    
@approval_flag     tinyint = 0          ,                                                    
@approval_comment  varchar(255) = null,                                                    
@nonbill_flag      tinyint = 0,                                                    
@create_id varchar(32) = null,                                                    
@modify_id varchar(32) = null,                                                    
@extra_param_1 varchar(255) =null,                                                    
@extra_param_2 varchar(255) =null,                                                  @business_reason  varchar(255) = null,                                                    
@finalise_flag  tinyint = null,                                                    
@finalised_by  varchar(12)= null,                                                    
@finalised_date  datetime = null,                                                   
@text1  varchar(255) =  null,                            
@text2  varchar(255) =  null,                                                    
@text3  varchar(255) =  null,                                                    
@text4  varchar(255) =  null,                                     
@text5  varchar(255) =  null,                                                    
@text6  varchar(255) =  null,                                                    
@text7  varchar(255) =  null,                      
@text8  varchar(255) =  null,                                                    
@text9  varchar(255) =  null,                                        
@text10  varchar(255) =  null,                                                    
@number11 float =  null,                                          
@number12 float =  null,                                                    
@number13 float = null,                                                    
@number14 float =  null,                                                    
@number15 float =  null,                                      
@number16 float =  null,                                                    
@number17 float =  null,                                                    
@number18 float = null,                                                    
@number19 float =  null,                                                    
@number20 float =  null,                                                    
@cc_exp_id int=NULL,                                                    
@cc_num  varchar(32)=null ,                                            
@validate tinyint = 1                                       
,@Is_file_attached  tinyint=0 --RS20150528      
,@is_image_changed tinyint = 0    
,@source varchar(64) =null      
                                                    
                                                    
                                                    
                                                    
/* ****************************************************************** *                                                    
* Copyright 1996 Paradigm Technologies, Inc.                          *                                                    
* All Rights Reserved                                                 *                                                    
*                                                                     *                                                
* This Media contains confidential and proprietary information of     *                                                    
* Paradigm Technologies, Inc.  No disclosure or use of any portion *                                                    
* of the contents of these materials may be made without the express  *                                                    
* written consent of Paradigm Technologies, Inc.                      *                                                    
*                                                                     *                                                    
* Use of this software is restricted and governed by a License        *                                                    
* Agreement.  This software contains confidential and proprietary     *                                                    
* information of Paradigm Technologies, Inc. and is protected by      *                                                    
* copyright, trade secret and trademark law.                          *     
*                   *                                                    
* ******************************************************************* *                         
*                                                                     *                                                    
*           Name: plsW_exptrx_set                                  *                                            
*         Module:                                                 *                                                    
*   Date created: 12/09/99                          *                                                    
*             By: Alex Peker       *                                                    
*        Version:                                    *                                                    
*        Comment:            *                                                    
*                                                 *                                                    
*   Date revised: 11/05/2004                                                 *                        
*             By: Shamim Zafar                                            *                                                    
*        Comment: To handle more than 16 char transaction id                                            *                                                    
*                                                                     *                                                    
*   Date revised: 08/18/2005                                                 *                                                    
*             By: Nauman Khan                                            *                                                
*        Comment: Added two new fields extra param(s)                                                      
              *                                                    
*   Date revised: 08/31/2015                                               *                                                    
*             By: Hamad  Safder                                           *                                                    
*        Comment: Added image flage                         
                                                    
******************************************************************** */                                                    
                                                    
AS                                          
                                
----------------------------------Fahim Tufail-------------------------------------                                                    
declare                                         
 @level2_status int,                                                    
 @level3_status int,                                                    
 @level2_sysname varchar(32),                                                
 @level3_sysname varchar(32),                                                    
 @Cost_Code_Name_sysname varchar(32),                                                    
 @date_opened datetime,                                                    
 @date_closed datetime,                                                  
 @expense_flag tinyint,                                                    
 @report_name varchar(32),                                                    
 @rtype_name varchar(16),                                                    
 @similar_line_message varchar(1000),                                                    
 @level_category_code varchar(16)                                                    
                                                     
--select @amount = round(@amount,2) -- AS111009 Penny issue resolution                                                        
--select @amount_home = round(@amount_home,2) -- AS111009 Penny issue resolution      
--select @amount_billable = round(@amount_billable,2) -- AS111009 Penny issue resolution                                                         
                                                     
-- AS20110428 -- AS20110415 QUICK AND DIRTY FIX TO COVER UP .NET DEVELOPERS NEGLIGANCE                                                     
-- AS20110428 if (select isnull(cc_exp_id, 0) from pld_transactions where transaction_id = @transaction_id_inp) <> 0 -- AS20110415                                                   
-- AS20110428 begin                                                  
-- AS20110428  select @cc_exp_id = cc_exp_id, @cc_num = cc_num from pld_transactions where transaction_id = @transaction_id_inp                                                  
-- AS20110428 end                         
/*  -- AS20110513 Its fixed from application                                              
-- AS20110506 THIS IS QUICK AND DIRTY FIX FOR THE ISSUE. IT MUST BE FIXED FROM THE APPLICATION                                                  
if (select org_unit from plv_resource where resource_id = @resource_id) <> @org_unit                                                
select @org_unit = org_unit from plv_resource where resource_id = @resource_id                                                  
                  
if (select location_code from plv_resource where resource_id = @resource_id) <> @location_code                                                
select @location_code = location_code from plv_resource where resource_id = @resource_id                 
-- AS20110506 END                                                
*/                                                
                                                    
select @level2_sysname=display_name from plv_sysnames where field_name='Level2_descr' and company_code=@company_code                     
select @level3_sysname=display_name from plv_sysnames where field_name='Level3_descr' and company_code=@company_code                                                    
select @Cost_Code_Name_sysname=display_name from plv_sysnames where field_name='Cost_Code_Name' and company_code=@company_code                                     
                                      
                                      
  DECLARE                                                    
        @create_date       smalldatetime    ,                                                    
        @modify_date       smalldatetime    ,                                                   
        @submitted_date    datetime         ,                                                    
        @upload_flag       tinyint          ,                                                    
        @upload_date       datetime     ,                                                    
        @ts_current BINARY(8),                                                    
        @transaction_id varchar(16)                                    
                                      
                                
                                
  ----------------------------------------------------------------------------------------------------                                      
                                      
if @action_flag = 4                                                    
begin                                                   
        SELECT  @modify_date   = GETDATE()                                                    
        SELECT  @ts_current=0x0                                                    
        SELECT  @ts_current=CONVERT(BINARY(8), TIMESTAMP)                                                    
        FROM    pld_transactions WHERE transaction_id = @transaction_id_inp and company_code=@company_code                                                    
                                                    
        if @ts_current=0x0                                                    
        BEGIN                      
         select 1003 ERROR_CODE, @transaction_id_inp +' Transaction Was Deleted' ERROR_DESCRIPTION,0x0 TIMESTAMP                                 
                RETURN(0)                                                    
        END                                                    
                               
        if @override_flag = 0 and @TS is not null                                                    
        BEGIN                                                    
            if @ts_current<>@TS                                                    
            BEGIN                                   
                    /* record was changed */                       
             select 1004 ERROR_CODE, @transaction_id_inp +' Transaction Was Changed' ERROR_DESCRIPTION,@ts_current TIMESTAMP                                                     
                    RETURN(0)                                                    
            END                                                    
 END                                                    
                                             
                                              
 UPDATE pld_transactions                                                    
 SET                                                                 
 --modify_id       = @modify_id            ,                                                    
 --modify_date     = @modify_date      ,                                                   
  Is_file_attached=@Is_file_attached --RS20150528      
 ,is_image_changed = case when @Is_file_attached = 1 then @is_image_changed else 0 end    
 ,[source]=@source    
                                                          
WHERE  company_code = @company_code  AND transaction_id = @transaction_id_inp                                                    
                    
                    
--if  @Is_file_attached=0                    
-- begin                    
--  exec plsw_set_image_changed_flag @company_code, @transaction_id_inp, @record_id, 0                        
-- end                    
--else if @Is_file_attached=1                    
-- begin                     
--  -- select 'OK', @company_code, @transaction_id_inp, @resource_id                    
--  exec plsw_set_image_changed_flag @company_code, @transaction_id_inp, @record_id, 1                   
-- end                    
                    
 IF @@error = 0                                                    
   BEGIN                                                  
    select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION, timestamp TIMESTAMP,@similar_line_message SIMILAR_LINE_MESSAGE                                                    
    from pld_transactions                                                     
    where transaction_id=@transaction_id_inp and company_code=@company_code                                         
   END                                                  
 ELSE                                                    
   select 1005 ERROR_CODE, @transaction_id_inp +' Update Failed' ERROR_DESCRIPTION,0x0 TIMESTAMP                                                     
 RETURN(0)                                                    
end                                         
                                      
                      
                                      
                                      
                                      
                                                   
----------------------------------------------------------------------------------------------------                                     
              
---RS20150904 Delete logic moved HERE before validation               
              
              
if @action_flag = 3                                                    
 begin              
   Select @transaction_id = left(@transaction_id_inp,16)                                          
             
   DELETE pld_transactions_exp                                        
   WHERE   company_code = @company_code AND                                                    
  transaction_id = @transaction_id AND                                                    
  transaction_id in (                                                    
  SELECT  transaction_id                                                    
  FROM  pld_transactions                  
   WHERE   company_code = @company_code AND                                                    
  transaction_id = @transaction_id AND                                                    
  upload_flag = 0                                                    
  )                                                    
                                                      
   DELETE pld_transactions                                                    
   WHERE   company_code = @company_code AND             
   transaction_id = @transaction_id AND                                                    
   upload_flag = 0                           
                                                     
  IF @@error = 0                                 
   select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION,0x0 TS                                                     
  ELSE                                                    
   select 1006 ERROR_CODE, @transaction_id +' Delete Failed' ERROR_DESCRIPTION,0x0 TIMESTAMP                                                     
  RETURN(0)                                  
end                           
               
              
              
              
--------------------------------------------Validation start here-----------------------------------              
                                      
                                      
                                      
                                      
 if isnull(@level2_key, '') = ''  or  isnull(@level3_key, '') = ''                                         
Begin                                         
    select -12 ERROR_CODE, 'Cannot Save or Delete any Transaction because iether value of ' + @level2_sysname+ ' or '  +  @level3_sysname + ' is not provided.'                                        
    return (0)                                                          
End                                           
                                      
                                                 
-------------------------------------------------------------------------------------                                                    
select @level2_status = level2_status,@level_category_code=level_category_code from plv_level2                     
                        where level2_key  =  @level2_key                                                                     
IF   @level2_status <> 1                                                    
Begin                                   
    select -2 ERROR_CODE, 'Cannot Save or Delete any Transaction for this '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + ' is not active'   ERROR_DESCRIPTION                                             
  
    
      
       
    return (0)                                                    
End                                                    
---------------------------------------------------------------------------------------                                                    
IF ( @action_flag = 1 or @action_flag = 2)                                                    
Begin                                                    
    select @date_opened  = date_opened from plv_level2                                                     
                           where level2_key  =  @level2_key                                                     
    select @date_closed  = date_closed from plv_level2                                                     
                           where level2_key  =  @level2_key                                
                                      
  If ISNULL(@org_unit,'')=''                                        
    Begin                                        
    select @org_unit=org_unit                                         
    from plv_resource                              
    where resource_id=@resource_id                                        
    End                                         
                                            
    If ISNULL(@location_code,'')=''                                 
    Begin                                        
    select @location_code=location_code                                         
    from plv_resource                              
    where resource_id=@resource_id                                        
    End                                              
                                      
    IF                                                     
    (                                                    
     --(@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or                  
     /*(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or                                                     
     (@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/                                                    
  @date_opened is not null and @applied_date < @date_opened                                                    
    )                                                     
    Begin                                                    
 select -3 ERROR_CODE, 'Cannot Save Transaction for the '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + '(s) is not valid earlier than ' ERROR_DESCRIPTION, @date_opened error_date                        
  
    
       
       
         
                  
                    
                      
                        
                         
                            
                              
                                
                                   
                                   
        return (0)                                                    
    End                                                    
                                                    
    IF                            
    (                                                    
     /*(@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or                                                     
     --(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or                                                     
     (@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/                                                    
 @date_closed IS NOT NULL and @applied_date > @date_closed                                                    
    )                                                     
    Begin                                                    
        select -4 ERROR_CODE, 'Cannot Save Transaction for the '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + '(s) is not valid later than '  ERROR_DESCRIPTION , @date_closed error_date                  
  
    
      
       
          
            
              
                
                   
                    
                      
                        
                          
                            
                              
                                
                                  
        return (0)                                                    
    End                                                    
                                                  
 if @validate = 1 and not exists(select 1                              
  from plv_resource_types b, plv_cost_codes a, plv_level3 c                                              
  where a.company_code = b.company_code                                              
  and a.company_code = c.company_code                                              
  and a.company_code = @company_code                                              
  and b.company_code = @company_code                                              
  and c.company_code = @company_code                                              
  and a.res_type = b.res_type                                              
  and b.res_category_code = 'EXP'                                              
  and a.cost_type = c.cost_type                                              
  and c.level2_key = @level2_key                                              
  and c.level3_key = @level3_key                                              
  and a.res_type = @res_type                       
  and a.expense_report_flag = 1                
  and a.effective_date<= @applied_date                                         
  ) -- AS20120402 to check if invalid res_type is passed from application                                              
    begin                                           
        select -11 ERROR_CODE, 'Cannot Save Transaction for the invalid '+ rtrim(ltrim(@Cost_Code_Name_sysname)) +' for '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) + '(s)'  ERROR_DESCRIPTION           
   
    
      
        
          
            
              
                
                  
                    
                     
                         
                          
                            
                              
                                
                                  
        return (0)                                                    
    end                                              
End                                                    
--------------------------------------------------------------------------------------------                                                    
IF exists ( select 1 from plv_level3  where level2_key =   @level2_key and level3_key  =  @level3_key  )                                
Begin                                                    
    select @level3_status = level3_status from plv_level3                                                     
                            where  level2_key =  @level2_key                                                      
    and  level3_key  =  @level3_key                                                                             
    IF   @level3_status <> 1                                                    
    Begin                                             
        select -5 ERROR_CODE, 'Cannot Save or Delete any Transaction for this '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname))+ ' - ' +rtrim(ltrim(@level3_sysname))+':'+rtrim(ltrim(@level3_key))+'.'+ rtrim( 
  
    
     
         
          
            
             
                 
                  
                    
                      
                       
ltrim(@level3_sysname)) + ' is not Open'   ERROR_DESCRIPTION                                                  
        return (0)                                    
    End                                                    
                                                    
    IF ( @action_flag = 1 or @action_flag = 2)                                                    
    Begin                                                    
  select @date_opened  = date_opened from plv_level3                                                     
                              where  level2_key =   @level2_key                                                      
    and  level3_key  =  @level3_key                                                    
       select @date_closed  = date_closed from plv_level3                                                     
                              where  level2_key =   @level2_key                                                      
    and  level3_key  =  @level3_key                            IF                                                     
       (                                                    
        --(@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or                                                     
   /*(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or                                                     
        (@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/                                                    
  @date_opened is not null and @applied_date < @date_opened                                                    
       )                                                     
       Begin                                                    
         select -6 ERROR_CODE, 'Cannot Save Transaction for the '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) +' - '+rtrim(ltrim(@level3_sysname))+':'+rtrim(ltrim(@level3_key))+'.'                  
         + rtrim(ltrim(@level3_sysname)) + '(s) is not valid earlier than ' ERROR_DESCRIPTION , @date_opened error_date                                                  
                                              
         return (0)                       
       End                                                    
                                                    
   IF                                                     
     (                                                    
       /*(@date_opened IS NULL and  @date_closed IS NOT NULL and (@applied_date > @date_closed)) or                                               
       --(@date_closed IS NULL and @date_opened IS NOT NULL and  (@applied_date < @date_opened)) or                                                     
        (@date_opened IS NOT NULL and @date_closed IS NOT NULL and (@applied_date not between @date_opened and @date_closed))*/                                                    
 @date_closed IS NOT NULL and @applied_date > @date_closed                                                    
       )                                                     
       Begin          
         select -7 ERROR_CODE, 'Cannot Save Transaction for the '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname)) +' - ' +rtrim(ltrim(@level3_sysname))+':'+rtrim(ltrim(@level3_key))+'.'                  
         + rtrim(ltrim(@level3_sysname)) + '(s) is not valid later than ' ERROR_DESCRIPTION , @date_closed error_date                                                              
         return (0)                                                    
       End                                                    
------------------------------------------------------------------------------------                                                    
 select @expense_flag  = expense_flag from plv_level3                                                     
                              where  level2_key =   @level2_key                               
    and level3_key  =  @level3_key                                                 
                                                        
 IF @expense_flag = 0                                                     
 Begin                                                    
 select -8 ERROR_CODE, 'Cannot Save Transaction for this '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname))+' - ' +rtrim(ltrim(@level3_sysname))+':'+rtrim(ltrim(@level3_key))+'.'+ rtrim(ltrim(@level3_sysname) 
  
   
      
        
           
            
             
    
                   
                    
                      
                        
                          
                            
                              
                                
                                   
                                     
)                                        
 + ' is not valid for the Expense Entry'  ERROR_DESCRIPTION                                                  
        return (0)                                 
 END                                                   
------------------------------------------------------------------------------------------                                                     
    End                                                    
End                                                    
                                                    
ELSE IF exists ( select 1 from plv_generic_level3                                                    
    where level3_key  =  @level3_key  )                                                     
BEGIN                                                    
  IF ( @action_flag = 1 or @action_flag = 2)                                                    
 BEGIN                                                    
  select @expense_flag  = expense_flag from plv_generic_level3                                                     
                               where level3_key  =  @level3_key                                                     
     and level_category_code=@level_category_code                                                     
  IF @expense_flag = 0                                                     
   Begin                                                    
   select -9 ERROR_CODE, 'Cannot Save Transaction for this '+rtrim(ltrim(@level2_sysname))+':'+rtrim(ltrim(@level2_key))+'.'+ rtrim(ltrim(@level2_sysname))+ ' - ' +rtrim(ltrim(@level3_sysname))+':'+rtrim(ltrim(@level3_key))+'.'                  
   + rtrim(ltrim(@level3_sysname)) + ' is not valid for the Expense Entry'  ERROR_DESCRIPTION                                                  
                                              
          return (0)                                                    
   END                                                    
  END                                                    
END                                                    
--------------------------------Fahim Tufail-------------------------------------                                                    
SET NOCOUNT ON                                                    
                                                        
                                                    
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
                                                    
                        if @submitted_flag <> 0 SELECT @submitted_date = GETDATE() ELSE SELECT @submitted_date = NuLL                                                    
----------------------------------------------------------------------------------------------------                                                    
    if @action_flag = 1                                                    
    begin                                                    
    if exists(                                                    
        select 1 from pld_transactions                                                    
        where company_code = @company_code                                                    
        and resource_id = @resource_id       
        and transaction_id = @transaction_id                                                    
       )                                                    
        begin                                                    
            select 1001 ERROR_CODE, @transaction_id +' Duplicate Transaction Control Number' ERROR_DESCRIPTION,0x0 TIMESTAMP                                   
            RETURN(0)                                                
        end                                                   
                                                           
    end                                                    
----------------------------------------------------------------------------------------------------                                                    
                                                   
 IF ( @action_flag = 1 or @action_flag = 2)                                                    
 BEGIN                                                    
   if (@validate = 1 and exists(                   
  select 1 from pld_transactions                                                    
  where company_code = @company_code                                                    
  and resource_id = @resource_id                                                    
  and level2_key  = @level2_key                                                     
  and level3_key  = @level3_key                                                     
  and res_type  = @res_type                                    
  and applied_date  = @applied_date                                                    
  and amount        = @amount                                                    
  and transaction_id <> @transaction_id                                                    
  and isnull(comments,'')=isnull(@comments,'')                                                    
  and trx_type between 2000 and 2999                                                    
                                                      
  ))                                                    
  begin                                                    
   select @report_name  = report_name                                         
   from pld_transactions_hdr                                                
   where record_id in (  select record_id from pld_transactions                                                    
             where company_code = @company_code                                                    
             and resource_id = @resource_id                                                    
             and level2_key  = @level2_key                                                     
             and level3_key  = @level3_key                                                     
             and res_type  = @res_type                                                    
             and applied_date  = @applied_date                                                    
             and amount        = @amount                              
     and isnull(comments,'')=isnull(@comments,'')                                                    
             and transaction_id <> @transaction_id                                                    
             and trx_type between 2000 and 2999                              
   )                                                    
                                                       
   SELECT @rtype_name=rtype_name                                                    
   FROM plv_resource_types                                                    
   WHERE res_type=@res_type                                                    
   AND res_category_code='EXP'                                                    
 select 1001 ERROR_CODE, ' Duplicate line exists in report '+char(39)+ rtrim(ltrim(@report_name))+char(39)+' on '+ rtrim(ltrim(convert(varchar,@applied_date,101)))+ ' for '+rtrim(ltrim(@level2_sysname))+' '+rtrim(ltrim(@level2_key))+' and its '           
 
     
     
        
 +rtrim(ltrim(@level3_sysname))+' '+ rtrim(ltrim(@level3_key))+' and '+rtrim(ltrim(@Cost_Code_Name_sysname))+' '+rtrim(ltrim(@rtype_name))+' for '+rtrim(ltrim(convert(varchar,@amount))) ERROR_DESCRIPTION,0x0 TIMESTAMP                                      
  
    
      
       
          
            
   RETURN(0)                                                    
  end                                                   
  else if exists(                                             
  select 1 from pld_transactions                                                    
  where company_code = @company_code                                                    
  and resource_id = @resource_id                                                    
  and level2_key  = @level2_key                                                     
  and level3_key  = @level3_key                                                     
  and res_type  = @res_type                                                   
  and applied_date  = @applied_date                                                    
  and amount        = @amount                                                    
  and transaction_id <> @transaction_id                             
  and trx_type between 2000 and 2999                                                    
                                                      
  )                                                    
  begin                                                    
   select @report_name  = report_name                                                     
   from pld_transactions_hdr                                                 
   where record_id in (  select record_id from pld_transactions                                                    
             where company_code = @company_code                                                    
             and resource_id = @resource_id                                                    
             and level2_key  = @level2_key                                                     
             and level3_key  = @level3_key                                                     
             and res_type  = @res_type                                                    
             and applied_date  = @applied_date                                                    
             and amount        = @amount                                                    
             and transaction_id <> @transaction_id                                                    
      and trx_type between 2000 and 2999                                                    
   )                                                    
                                                       
   SELECT @rtype_name=rtype_name                                                    
   FROM plv_resource_types                                                    
   WHERE res_type=@res_type                                                    
   AND res_category_code='EXP'                                   
                                                    
   select @similar_line_message='A similar line exists in report '+char(39)+ rtrim(ltrim(@report_name))+char(39)+' on '+ rtrim(ltrim(convert(varchar,@applied_date,101)))+ ' for '+rtrim(ltrim(@level2_sysname))+' '+rtrim(ltrim(@level2_key))+' and its '    
   
   
       
        
         
            
              
   +rtrim(ltrim(@level3_sysname))+' '+ rtrim(ltrim(@level3_key))+' and '+rtrim(ltrim(@Cost_Code_Name_sysname))+' '+rtrim(ltrim(@rtype_name))+' for '+rtrim(ltrim(convert(varchar,@amount)))+ ' but with different comments, The line will still be saved.'     
  
    
      
        
          
            
              
              
                           
                    
                      
                        
                          
                            
                              
                               
                                   
                                    
                                      
                                       
  end                                                    
                                                                                                          
 END                                                    
                                                    
 if exists ( select 1 from plv_pmt_types                                                     
   where company_code = @company_code                                                    
   and payment_code = @payment_code                                                    
   and payment_category = 1 )                                                    
 select @pmt_vendor_code = '*COMP*'                                                    
                                       
-- AS20100510 IILLC payment code handling                                                     
-- AS20100510 IILLC payment code handling                                                           
if isnull(@cc_exp_id,0) <> 0                    
begin                                                          
                                         
                                             
 declare @payment_code_w1 int                                                          
 declare @payment_name_w1 varchar(16)                                                          
                                                       select @payment_code_w1 = null                                                          
 select @payment_name_w1 = null                                           
                                                        
 select @payment_code_w1 = payment_code, @payment_name_w1 = payment_name from pld_cc_exp where company_code = @company_code and cc_exp_id = @cc_exp_id                                                           
 if isnull(@payment_code_w1,0) <> 0                                                          
 begin                                            
  select @vendor_id = vendor_code from plv_pmt_types where payment_name = @payment_name_w1                                            
  select @payment_code=@payment_code_w1                                        
  select @payment_name=@payment_name_w1                                        
 end                
    print 'here'                                                  
                                        
 -- AS20130422 The issue is resolved in DLL but not deployed                                        
 if @nonbill_flag = 0 -- Billable                                         
 begin                                          
  -- Billabl_flag 1 means non billable in level2 and level3                                        
  -- if level2 or level3, any one of them has value 0, then it is billable                                        
  if (select billable_flag from plv_level3 where company_code = @company_code and level2_key = @level2_key and level3_key = @level3_key) = 1 -- Non billable                                        
  or (select billable_flag from plv_level2 where company_code = @company_code and level2_key = @level2_key) = 1 -- Non billable                                        
  begin                                        
   select @nonbill_flag = 1, @amount_billable = 0                                        
  end                                        
 end                                       
 -- RS20140724 Quick fix for amount & applied date mismatch, comments                                      
 select @amount = amount, @applied_date = applied_date from pld_cc_exp where company_code = @company_code and cc_exp_id = @cc_exp_id                                      
                                       
end                                                    
-- AS20100510 IILLC payment code handling ends here                                                    
                                        
-- AS20130712                                        
declare                                         
@vendor_name varchar(40),                                        
@cc_type_id tinyint                                        
            
select @vendor_name = null, @cc_type_id = null             
                                        
if isnull(@cc_num, '') != ''                                        
begin                                        
 select @vendor_name = vendor_name, @cc_type_id = cc_type_id from pld_cc_exp where company_code = @company_code and cc_exp_id = @cc_exp_id                                                     
end                                        
                                              
if @action_flag = 1                                                    
begin                                                    
 SELECT @create_date   = GETDATE()                                                    
---- AS112609 To avoid conversion issue. At times the conversion was not taking place.                                                      
---- This is to check if the conversion rate is not 1 and @amount and @net_amount are same                                                    
---- Force the conversion before saving data                                                    
--if @currency_conversion_rate <> 1 and @amount = @net_amount -- AS112609                                                    
--begin                                                    
--select @net_amount = round(@amount * @currency_conversion_rate,2) -- AS112609          --select @amount_home = round(@amount * @currency_conversion_rate,2) -- AS112609                                                    
--end                                                      
                                                    
INSERT pld_transactions (                                                    
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
 create_date    ,                        
 modify_id       ,                          
 modify_date     ,                                                    
 trx_type   ,                             
 res_type        ,                                                    
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
 business_reason,                                                    
 finalise_flag,                             finalised_by,                                                    
 finalised_date,                                                    
 cc_exp_id,                                                    
 cc_num                                        
 ,vendor_name                                        
 ,cc_type_id                                       
 ,Is_file_attached --RS20150528      
 ,is_image_changed    
 ,[source]    
 )                                                    
                                                     
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
 0           , /* upload_flag */                                                    
 NULL            , /* upload_date */                                                  
 @create_id      ,                                                    
 @create_date        ,                                                   
 NULL            , /* modify_id */                                                    
 NULL            , /* modify_date */                                                    
 @trx_type     ,                                 
 @res_type       ,                                                    
 @vendor_id      ,                                                    
 @payment_code       ,                                                    
 @payment_name       ,                                                    
 @pmt_vendor_code    ,                                                    
 @currency_code      ,                                               
 @currency_conversion_rate ,                                                    
 @allocation_prc     ,                                                    
 @amount         ,                                               
 @amount_home        ,                                                    
 @amount_billable    ,                                                    
 @receipt_flag       ,                                        
 @reimbursment_flag  ,                                                    
 @parent_id      ,                                                    
 @trx_level      ,                                                    
 @res_usage_code     , /* res_usage_code */                                                    
 @mileage_units      , /* units */                                                    
 @nonbill_flag         , /* nonbill_flag */                                                    
 @line_id        ,            
 @record_id      ,                                                    
 @tax_code       ,                                                    
 @tax_amount     ,                                                    
 @net_amount     ,                                                    
 @approval_flag,                                                    
 @approval_comment,                                                    
 @extra_param_1,                                                    
 @extra_param_2,                                                
 @business_reason,                 
 @finalise_flag,                                                    
 @finalised_by,                                                    
 @finalised_date,                                                    
 @cc_exp_id,                                                    
 @cc_num                                        
 ,@vendor_name                                        
 ,@cc_type_id                                        
 ,@Is_file_attached --RS20150528           
 ,@is_image_changed    
 ,@source                                 
 )                                                    
                                                     
                                                     
 IF @@error = 0                                                    
 begin                                                     
  Insert into pld_transactions_exp (                                                    
  company_code,                                                    
  transaction_id,                                                  record_id,                                                    
  text1,                                                    
  text2,                                                    
  text3,                                                    
  text4,                                                    
  text5,                                                    
  text6,                                                    
  text7,                                                    
  text8,                                                    
  text9,                                                    
  text10,                                                    
  number11,                          
  number12,                                                    
  number13,                                                    
  number14,                                                    
  number15,                                                    
  number16,                                                    
  number17,                                                    
  number18,                                                    
  number19,                                                    
  number20,                                                    
  create_id,                    
  create_date,    
  [source]    
  )                                                    
                                                      
  Values (                                                 
  @company_code,                                                    
  @transaction_id,                                                    
  @record_id,                                                    
  @text1,                                                    
  @text2,                      
  @text3,                                                    
  @text4,                                                    
  @text5,                                                    
  @text6,                                                    
  @text7,                                                    
  @text8,                                                    
  @text9,                                                    
  @text10,                                                    
  @number11,                                                    
  @number12,                                                    
 @number13,                                
  @number14,               
  @number15,                                                    
  @number16,                                                    
  @number17,                                                    
  @number18,                                                    
  @number19,                                                    
  @number20,                                                    
  @create_id,                                                    
  @create_date,    
  @source    
  )                                                     
                                             
                                 
  select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION, timestamp TIMESTAMP,@similar_line_message SIMILAR_LINE_MESSAGE                   
  from pld_transactions                                                     
  where transaction_id=@transaction_id and company_code=@company_code                                                     
 END                                                    
 ELSE                                                    
  select 1002 ERROR_CODE, @transaction_id +' Insert Failed' ERROR_DESCRIPTION,0x0 TIMESTAMP                                                    
                                                  
 ---- AS111009 Following 3 lines are to resolve penny difference issue                                                        
 --select @amount = 0                                                        
 --select @amount = sum(round(amount_home,2)) from pld_transactions where company_code = @company_code AND record_id = @record_id                                                         
 --UPDATE pld_transactions_hdr SET amount = @amount WHERE company_code = @company_code AND record_id = @record_id                                         
                                                  
                                 
 RETURN(0)                                                    
end                                                    
----------------------------------------------------------------------------------------------------                                                    
if @action_flag = 2                                                    
 begin                                                    
   SELECT  @modify_date   = GETDATE()                                                    
   SELECT  @ts_current=0x0                                                    
   SELECT  @ts_current=CONVERT(BINARY(8), TIMESTAMP)                                                    
   FROM    pld_transactions WHERE transaction_id = @transaction_id and company_code=@company_code                                                    
                                                     
   if @ts_current=0x0                            
   BEGIN                                                    
    select 1003 ERROR_CODE, @transaction_id +' Transaction Was Deleted' ERROR_DESCRIPTION,0x0 TIMESTAMP                                                     
     RETURN(0)                                                    
   END                                                    
                                                     
   if @override_flag = 0 and @TS is not null                                                    
   BEGIN                                                    
    if @ts_current<>@TS                                                    
    BEGIN                                                    
      /* record was changed */                                          
     select 1004 ERROR_CODE, @transaction_id +' Transaction Was Changed' ERROR_DESCRIPTION,@ts_current TIMESTAMP                                                     
      RETURN(0)                                                    
    END                                                    
   END                                                    
                                                     
  SELECT @create_date = @modify_date                                                    
 ---- AS112609 To avoid conversion issue. At times the conversion was not taking place.                                                      
 ---- This is to check if the conversion rate is not 1 and @amount and @net_amount are same                                                    
 ---- Force the conversion before saving data                                                    
 --if @currency_conversion_rate <> 1 and @amount = @net_amount -- AS112609                                                    
 --begin                                                    
 --select @net_amount = round(@amount * @currency_conversion_rate,2) -- AS112609                                                    
 --select @amount_home = round(@amount * @currency_conversion_rate,2) -- AS112609                                                    
 --end                                                       
                                               
  UPDATE pld_transactions                                                    
  SET         level2_key      = @level2_key       ,                                                    
  level3_key      = @level3_key           ,                                                    
  applied_date    = @applied_date     ,                                                    
  org_unit        = @org_unit             ,                          
  location_code   = @location_code        ,                                                    
  comments        = @comments             ,                                                    
  submitted_flag  = @submitted_flag       ,                                                    
  submitted_date  = @submitted_date       ,                                                    
  modify_id       = @modify_id            ,                                                    
  modify_date     = @modify_date      ,                                    
  trx_type    = @trx_type         ,                                                    
  res_type    = @res_type     ,                                                    
  vendor_id   = @vendor_id        ,                                                    
  payment_code    = @payment_code     ,                                                    
  payment_name    = @payment_name     ,                                                    
  pmt_vendor_code = @pmt_vendor_code  ,                
  currency_code   = @currency_code    ,                                                    
  currency_conversion_rate = @currency_conversion_rate ,                                                    
  allocation_prc  = @allocation_prc   ,                                                    
  amount      = @amount       ,                                                    
  amount_home = @amount_home      ,                                                    
  amount_billable = @amount_billable  ,                                                    
  receipt_flag    = @receipt_flag     ,                                             
  reimbursment_flag = @reimbursment_flag  ,                                                    
  line_id     = @line_id      ,                                                 
  gst_tax_code = @tax_code     ,                                                    
  gst_tax_amt = @tax_amount       ,                                                    
  net_amount  = @net_amount       ,                                                    
  res_usage_code  = @res_usage_code   ,                                                    
  units       = @mileage_units    ,                                                    
  nonbill_flag = @nonbill_flag,                                                    
  approval_flag = @approval_flag,                                             
  approval_date = null,                                                    
  parent_id=@parent_id,                                                    
  extra_param_1=@extra_param_1,                                                    
  extra_param_2=@extra_param_2,                                       
  business_reason = @business_reason,                                                    
  finalise_flag = @finalise_flag,                                                    
  finalised_by = @finalised_by,                                                    
  finalised_date = @finalised_date,                                                    
  cc_exp_id=@cc_exp_id,                                               
  cc_num = @cc_num                                        
  ,vendor_name = @vendor_name                                        
  ,cc_type_id = @cc_type_id                                      
  ,Is_file_attached=@Is_file_attached --RS20150528      
  ,is_image_changed = @is_image_changed     
  ,[source]=@source                                                        
 WHERE  company_code = @company_code  AND transaction_id = @transaction_id                                                    
 IF @@error = 0                                                    
   BEGIN                    
    IF exists ( select 1 from pld_transactions_exp                                                     
    where transaction_id=@transaction_id and company_code=@company_code)                                                     
    BEGIN                                                    
     Update pld_transactions_exp                                                       
     set record_id = @record_id,                                                   
  text1 = @text1,                                                    
     text2 = @text2,                                                    
    text3 = @text3,                                                    
     text4 = @text4,                                                    
     text5 = @text5,                                                    
     text6 = @text6,                                                    
     text7 = @text7,                       
     text8 = @text8,                                                    
  text9 = @text9,                                                    
     text10 = @text10,                                                    
     number11 = @number11,                                    
     number12 = @number12,             
     number13 = @number13,                                                    
     number14 = @number14,                                                    
     number15 = @number15,                                                    
     number16 = @number16,                                                    
     number17 = @number17,                                                    
     number18 = @number18,                                                    
     number19 = @number19,                                                    
     number20 = @number20,                                                    
     modify_id = @create_id,                                                    
     modify_date = @create_date ,    
     [source] =@source    
      WHERE  company_code = @company_code                                                      
     AND transaction_id = @transaction_id                                                    
    END                                                    
   ELSE                                                    
   BEGIN                                                    
   Insert into pld_transactions_exp (                                                    
   company_code,                                                    
   transaction_id,                                             
  record_id,                                                    
   text1,                                                    
   text2,                                                    
   text3,                                                    
   text4,                                                    
   text5,         
   text6,                                        
   text7,                                                    
   text8,                                                    
   text9,                                                    
   text10,                                                    
   number11,                                                    
   number12,                                                    
   number13,                                                
   number14,                                                    
   number15,                                
   number16,                                                    
   number17,                                                    
   number18,                                                    
   number19,                                                    
   number20,                                                    
   create_id,                                                    
   create_date,    
   [source])                                                    
                                                  
   Values (                                                    
   @company_code,                                                    
   @transaction_id,                                                    
   @record_id,                                                    
   @text1,                                                    
   @text2,                                                    
   @text3,                                                    
   @text4,                                                    
   @text5,                                                    
   @text6,                                                    
   @text7,                                
   @text8,                                                    
   @text9,                                                    
   @text10,                                                    
   @number11,                                                    
   @number12,                                                    
   @number13,                                                    
   @number14,                                       
   @number15,                                                    
   @number16,                                               
   @number17,                                                    
   @number18,                                                    
   @number19,                                                    
   @number20,                                                    
   @create_id,                                                    
   @create_date,    
   @source)                                                     
   END                                                    
                                                      
   select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION, timestamp TIMESTAMP,@similar_line_message SIMILAR_LINE_MESSAGE                                
   from pld_transactions                                                     
   where transaction_id=@transaction_id and company_code=@company_code                                                     
  END                                                    
 ELSE                                                    
  select 1005 ERROR_CODE, @transaction_id +' Update Failed' ERROR_DESCRIPTION,0x0 TIMESTAMP                                                     
 ---- AS111009 Following 3 lines are to resolve penny difference issue                                                        
 --select @amount = 0                                                        
 --select @amount = sum(round(amount_home,2)) from pld_transactions where company_code = @company_code AND record_id = @record_id                                                         
 --UPDATE pld_transactions_hdr SET amount = @amount WHERE company_code = @company_code AND record_id = @record_id                                                         
                                                  
 RETURN(0)                                                    
end                                                    
----------------------------------------------------------------------------------------------------                                                    
-------------added image flage ---hamad 08-31/2015                        
--RS20150904 delete logic Moved above before validation               
/*               
begin                         
                         
---------------------------------------                        
if @action_flag = 3                                                    
 begin                                                    
  DELETE pld_transactions_exp                                                    
   WHERE   company_code = @company_code AND                                                    
  transaction_id = @transaction_id AND                                                    
  transaction_id in (                                                    
  SELECT  transaction_id                                                    
  FROM  pld_transactions                                                    
   WHERE   company_code = @company_code AND                                                    
  transaction_id = @transaction_id AND                                                    
  upload_flag = 0                                                    
  )                                                    
                                                      
   DELETE pld_transactions                                                    
   WHERE   company_code = @company_code AND                                          
  transaction_id = @transaction_id AND                                                    
  upload_flag = 0                           
                                                     
  IF @@error = 0                                 
   select 0 ERROR_CODE, 'NONE' ERROR_DESCRIPTION,0x0 TS                                                     
  ELSE                                                    
   select 1006 ERROR_CODE, @transaction_id +' Delete Failed' ERROR_DESCRIPTION,0x0 TIMESTAMP                     
  RETURN(0)                                  
 end                           
          
                                     
                                                   
RETURN(0)                         
                        
end*/

