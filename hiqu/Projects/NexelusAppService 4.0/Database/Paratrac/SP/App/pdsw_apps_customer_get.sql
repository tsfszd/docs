/****** Object:  StoredProcedure [dbo].[pdsw_apps_customer_get]    Script Date: 02/04/2015 11:59:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_customer_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_customer_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_customer_get]    Script Date: 02/04/2015 11:59:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[pdsw_apps_customer_get]      
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
*         Name: Pdsw_apps_level2_get                                  *                                                                   
*       Module:                                                       *                                                                   
* Date created: Nov 20 2014                                           *                                                                   
*           By: Sohail Nazir                                          *                                                                   
*      Comment:                                                       *                                                                   
* Date revised: Decmber 4 2014                                        *                                                                   
*           By: Arif Hasan                                            *                                                       
*      Comment: Optimization                                          *                                                                   
* Date revised: Decmber 22 2014  *                                     
*           By: Hamza Mughal                                          *                                                                   
*      Comment: Added the LastSyncDate *               
*                               
<keyx>        
 <key>        
  <customer_code>21042015</customer_code>         
 </key>        
 <key>         
  <customer_code>002</customer_code>        
 </key>        
</keys>'             *              
*   *                      
[pdsw_apps_customer_get]   2, 'HAMZA.M', null, null, null, null   
********************************************************************* */                          
@company_code int,                          
@login_id char(16),                          
@customer_code varchar(64) = NULL,                          
@last_sync_date datetime = NULL, -- HAMZA -- 20141222 -- Added the LastSyncDate                 
@subscriber_id int = null ,             
@keys xml = null                                           
                 
AS                          
BEGIN                          
                          
  DECLARE @location_code char(16),                          
          @org_unit char(16),                          
@resource_id char(16),                          
          @user_group varchar(16),                          
@permission_org_unit int,                          
          @permission_location_code int                          
                          
SELECT                          
    @resource_id = resource_id,                          
    @location_code = location_code,                          
    @org_unit = org_unit                          
  FROM pdd_resources                          
  WHERE company_code = @company_code                          
  AND loginid = @login_id                          
                          
  SELECT                          
    @user_group = user_group_code                          
  FROM pdm_group_user_link                          
  WHERE resource_id = @resource_id                          
  AND preferred_group_flag = 1                          
                          
  SELECT                          
    @permission_org_unit = permission_status                          
  FROM pdm_rule_group                          
  WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/OrgUnit'                          
  AND @user_group = user_group_code                          
                          
  SELECT                          
    @permission_location_code = permission_status                          
  FROM pdm_rule_group                          
  WHERE path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/LocationCode'                          
  AND @user_group = user_group_code                          
                          
                          
  -- HAMZA -- 20141222 -- Added the LastSyncDate                                          
  --SELECT distinct top 1500 customer_code,                                       
  -- customer_name,                                       
  -- level2_key                                      
  --FROM pdd_level2_customer                                               
  --where level2_key in                                           
  --(                                          
  --select level2_key from pdd_level2                                               
  --where (isnull(@permission_org_unit, 0) !=2 or org_unit = @org_unit ) and                                               
  --         (isnull(@permission_location_code, 0) !=2  or location_code = @location_code )                               
  -- )                                              
  -- and (@last_sync_date is null OR convert(date,@last_sync_date) < ISNULL(convert(date, modify_date), convert(date, create_date)))                             
  -- and (@customer_code is null or customer_code like rtrim(@customer_code) + '%')          
          
           
 SELECT   T.c.value('./customer_code[1]', 'varchar(64)') customer_code    into #customer_code             
                       FROM     @keys.nodes('/keys/key') T ( c )  
					   
--if not exists(select 1 from #customer_code)
--begin 
--set @keys =null
--end					                            
   create table #data    
   ( customer_code varchar(16),    
     customer_name varchar(64),    
     level2_key varchar(32)    
   )    
   insert into  #data    
   (    
   customer_code ,    
   customer_name ,    
   level2_key    
   )                      
  SELECT DISTINCT TOP 1500      
    l2c.customer_code,                          
    l2c.customer_name,                          
    l2.level2_key                  
  FROM  pdd_level2_customer l2c                 
   INNER JOIN pdd_level2 l2                          
    ON l2.company_code = l2c.company_code                          
    AND l2.level2_key = l2c.level2_key                                               
  INNER JOIN pdd_level3 l3                          
    ON l2.company_code = l3.company_code                          
    AND l2.level2_key = l3.level2_key                                              
  WHERE     
  l2.level2_status = 1    
  AND  l3.level3_status = 1                          
  AND (l3.labor_flag = 1 OR l3.expense_flag = 1     )
  AND (ISNULL(@permission_org_unit, 0) != 2   OR l2.org_unit = @org_unit)                          
  AND (ISNULL(@permission_location_code, 0) != 2 OR l2.location_code = @location_code)                          
  AND (@last_sync_date IS NULL OR @last_sync_date < ISNULL(dateadd(mi, 10, l2c.modify_date), dateadd(mi, 10, l2c.create_date)))                          
  AND (@customer_code IS NULL OR l2c.customer_code LIKE RTRIM(@customer_code) + '%')                  
  and (@keys is null or exists (select *  from #customer_code c where c.customer_code = l2c.customer_code)  )    
      
      
   insert into  #data    
   (    
   customer_code ,    
   customer_name ,    
   level2_key    
   )                      
  SELECT DISTINCT TOP 1500                    
    l2c.customer_code,                          
    l2c.customer_name,                          
    l2.level2_key                  
  FROM pdv_pld_transactions plt                                                                   
    LEFT OUTER JOIN pdd_level2_customer l2c                                                                                                                        
     ON plt.company_code=l2c.company_code                                                                                                                        
      AND plt.level2_key = l2c.level2_key                         
      and  plt.resource_id = @resource_id
   INNER JOIN pdd_level2 l2                          
    ON l2.company_code = l2c.company_code                          
    AND l2.level2_key = l2c.level2_key                                               
    where plt.level2_key not in (select distinct level2_key from #data )     
      
          
          
                
  if @subscriber_id is null                
   begin                
   select * from #data                
           
   end                
  else                
   begin                
   select top 100 * from #data order by  customer_code + customer_name +level2_key                
   --delete top (100) #data                
   --where customer_code + customer_name +level2_key in                
   --(select top 100  customer_code + customer_name +level2_key from #data order by  customer_code + customer_name +level2_key)                
                   
                   
 declare @entity_id int                   
 select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level2Customer'                  
                
 insert into pdd_event_notification                  
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                                
  select    convert(varchar, @company_code) + '~-~' + level2_key  + '~-~' +  customer_code  ,    @company_code, 2, @entity_id, subscriber_id,  i.resource_id, GETDATE()                  
 from #data  d inner join pdd_apps_subscriber_info i on i.resource_id = i.resource_id             
 where      is_active = 1  and  subscriber_id = @subscriber_id               
                 
   end                
                         
                          
                          
END   




go