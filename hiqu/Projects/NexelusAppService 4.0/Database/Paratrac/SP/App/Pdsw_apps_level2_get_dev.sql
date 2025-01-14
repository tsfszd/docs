drop  PROCEDURE [dbo].[Pdsw_apps_level2_get_dev]
go
CREATE  PROCEDURE [dbo].[Pdsw_apps_level2_get_dev]    
                                                                                                                                         
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
* Date created: Nov 20 2014                  *                                    
*           By: Sohail Nazir   *                            
*      Comment:                          *                                                           
* Date revised: Decmber 4 2014                  *                                                                 
*         By: Arif Hasan   *                                                                    
*  Comment: Optimization                                        *                                                                             
*                                                *                                                                                     
*                                            *                               
                            
 @keys = '<keys>                            
  <key>                            
    <level2_key>level2_key 1</level2_key>                            
    <level3_key>level3_key 1</level3_key>                            
  </key>                            
  <key>                            
    <level2_key>level2_key 2</level2_key>                            
    <level3_key>level3_key 2</level3_key>                            
  </key>                            
</keys>'                            
                            
                                                                   
********************************************************************* */                                                                                                                             
                                                                              
                                                                                                                          
                                                                                                                          
@company_code INT,                                                                                                    
@customer_code VARCHAR(32)='',                                                                                                        
                                                                                                                   
@level2_key  VARCHAR(32) = null,                                                                                                                     
@level3_key  VARCHAR(64) = null,                                                                                                                           
@include_level3 tinyint=0,                                                                                                                                    
@count int,                          
@resource_id CHAR(16),                                                                                                  
@mode tinyint =0,    -- 0=normal , 1= sync                                                                                                         
@last_sync_date DATETIME= NULL ,                             
@subscriber_id int = null  ,                             
@keys xml = null                                                                             
WITH RECOMPILE                                                                                                                                                                                 
AS                                                                                                         
                                                                            
BEGIN                            
                    
declare @count_to_return int = 500                    
            
            
if @keys is not null            
 begin            
 exec Pdsw_apps_level2_List_get            
 @company_code ,                                                   
 @customer_code ,                            
 @level2_key  ,                  
 @level3_key ,                        
 @include_level3 ,                                   
 @count ,                          
 @resource_id ,                                                                                                  
 @mode ,    -- 0=normal , 1= sync                                                                                                         
 @last_sync_date  ,                             
 @subscriber_id   ,                             
 @keys             
             
 return            
 end            
            
                
-- TEMP                
SET @count = 500                
                            
SELECT   T.c.value('./level2_key[1]', 'nvarchar(64)') level2_key,                             
T.c.value('./level3_key[1]', 'nvarchar(64)') level3_key   into #level23_xml                                  
                       FROM     @keys.nodes('/keys/key') T ( c )                             
                                                                                                             
       --  set @count = 150                                                  
    DECLARE --@source int ,                             
   @permission_status INT=NULL,                                                                                                                                             
            @org_unit1         CHAR(16),                                                                                
            @location_code1    CHAR(16),                                                                                                     
            @user_group        VARCHAR(16),                       
                                        
            @source_text varchar(30)  ='TimeSheet'                             
                                                     
                                
    --        if @source =1                                      
    --        begin                                      
    --set  @source_text  ='ExpenseReport'                                         
    --        end                                       
      set @level2_key =nullif(@level2_key, '')                                                                                                                     
      set @level3_key   =nullif(@level3_key, '')                                    
                                              
                                 
                                                                                                                                                  
                                                                                                               
    CREATE TABLE #level2                                                                                                                                             
      (                                                                                                                                             
         level2_key CHAR(32)                                      
      )                                                                                                     
                                                                                                                         
    CREATE TABLE #Level2Level3                                                                                                                                             
 (                                      
 id int identity (1, 1) ,                                                                                                                         
  level2_key    CHAR(32),       
  level2_description VARCHAR(128),                                                                          
  level2_status tinyint,                                                            
  level2_opendate    DATETIME,                                                                                                           
  level2_closedate   DATETIME,                                                                       
  level3_key         CHAR(64),                                                                     
  level3_description VARCHAR(64),                                               
  level3_status tinyint,                                                                                                
  level3_opendate  DATETIME,                                                                                              
  level3_closedate   DATETIME,                                                                                                                                             
  parent_level3_key  CHAR(64),                                                                                                                                             
  horder             INT,                                                                               
  customer_code    VARCHAR(16),                                                                                
  customer_name      VARCHAR(64),                                                             
  expense_flag       TINYINT,                                                                                      
  labor_flag         TINYINT,                                                                             
  read_flag          TINYINT,                                                                                                                                             
  l2_org_unit   CHAR(16),                                                                                               
  l2_location_code   CHAR(16),                                                              
  l3_org_unit      CHAR(16),                                                                                                                                             
  l3_location_code   CHAR(16),                                                                                                                          
  cost_type          INT ,                                                                
  modify_date     Datetime,                                                                               
  -- HAMZA -- 20142312 -- Added the below columns for level3                                                                     
  task_type   int,                                              
  billable_flag  int,                                                         
  Level2_modify_date     datetime     ,                                                
  transaction_order int default(0)                                                      
 )                                                                                               
                                     
                                                                                                                   
                                                                                                                                                    
    SELECT @location_code1 = location_code    , @org_unit1 = org_unit                                                                                                                          
      FROM   pdd_resources                                       
      WHERE  company_code = @company_code                                            
     AND resource_id = @resource_id                     
                                                     
                                                                                                                             
                                                          
    SELECT @user_group = user_group_code                                                                                                                                             
    FROM   pdm_group_user_link                                                                                                       
 WHERE  resource_id = @resource_id                                             
           AND preferred_group_flag = 1                                                                        
                                                                                                              
    -- select @org_unit1, @location_code1, @user_group                                                                         
                                                                                                                     
    CREATE TABLE #valid_customers                                            
      (                                                                                                                                             
         level2_key    CHAR(32),                                                    
         customer_code VARCHAR(16),                                                                                                                                             
         customer_name VARCHAR(64)                                                                        
      )                                                                                                                                             
                                                                                                               
    IF @customer_code = ''                                                           
      BEGIN                                                                         
INSERT #valid_customers                                                                                                                 
            (level2_key,                                                                                                                                             
                  customer_code,                    
                  customer_name)                                                                                                                                             
     SELECT level2_key,                                                   
                 customer_code,                                                                                                                                            
                 customer_name                                                                                       
          FROM   pdd_level2_customer                                                                     
     ORDER  BY level2_key,                                                                                                                                             
                    customer_code                                                             
                                                             
         --   select 'OK', * from #valid_customers                                            
                                                                                                                                                        
 --???                                                            
  INSERT #valid_customers        
    (level2_key,                                                                                                                
     customer_code,                                                                                  
     customer_name)                                                                                                        
          SELECT DISTINCT level2_key,                                                                                   
       NULL,                                                                                                                             
       NULL                                      
          FROM   pdd_level2 l2                                                                                                                                             
   WHERE  l2.level2_key NOT IN (SELECT level2_key                                                                                                                                             
            FROM  #valid_customers)                                                                                                                         
           AND l2.level2_status = 1                                                                                                                                             
                 AND EXISTS (SELECT l3.level2_key                                                                                     
  FROM   pdd_level3 l3                                                                                                                                             
                             WHERE  l2.company_code = l3.company_code                                                                                                                      
       AND l2.level2_key = l3.level2_key                                                                                                                                             
--  AND       (l3.labor_flag = 1  or l3.expense_flag = 1  )                            
  and  (l3.labor_flag = 1  or (l3.expense_flag = 1  and  l3.cost_type in (select cost_type from pdd_cost_codes  where expense_report_flag = 1)  ))      
      
 --(                                
 -- (                                
 --  (l3.labor_flag = 1  and @source = 0)                                 
 --  or                                 
 --  (l3.expense_flag=1 and @source = 1)                                
 -- )                        
 --   or                                 
 -- (                                 
 --  isnull(@level2_key, '') !=''                                 
 --  and                                 
 --  (l3.labor_flag = 1  or l3.expense_flag = 1  )                                 
 -- )                                  
   -- )                   
                                   
      AND l3.level3_status = 1)                                                                                                                                    
      END                                                     
ELSE                                                                                                                         
      BEGIN                          
          INSERT #valid_customers                                                                                                  
                 (level2_key,                                                                                                                             
                  customer_code,                                               
                  customer_name)               
          SELECT level2_key,                                                                                                            
 customer_code,                                                                      
                 customer_name                                                                               
          FROM   pdd_level2_customer                        
          WHERE  customer_code LIKE Rtrim(@customer_code)  + '%'        
          ORDER  BY level2_key,                                                                                                                          
                    customer_code                                                                                                                                             
END           
                                                                                                                  
                                                                                                               
                                                          
       if  @include_level3 =1                                                                                                                            
       begin                                                                                                                          INSERT #Level2Level3                                                                                                    


  
    
      
        
          
                                         
   (                                                                                                        
    level2_key,                                               
    level2_description,                                                                        
    level2_status,                                                                                                                                              
    level2_opendate,                                                                                                            
    level2_closedate,                                                                                                                                         
    level3_key,                                                                                                                                             
    level3_description,                                                                        
    level3_status,                                                                                                                                              
    level3_opendate,                   
    level3_closedate,                                                                                 
    parent_level3_key,                                                                                                
    horder,                            
    customer_code,                                                                                                                                     
    customer_name,                              
    expense_flag,                                                                                                                               
    labor_flag,                                                                       
    l2_org_unit,                                                                                                                                             
    l2_location_code,                                                                                                                                             
    l3_org_unit,                                                            
    l3_location_code,                                                                   
    read_flag,                                                           
    cost_type,                                                         
    modify_date,                                                                                                                          
    task_type,                                                                                                                          
   billable_flag,                                      
    Level2_modify_date          
   )                                               
  SELECT Distinct l2.level2_key,                                                                                                                                             
      Isnull(l2.level2_description, '') AS level2_description,                                                                         
      l2.level2_status,                                                                                                                
      l2.date_opened    AS level2_OpenDate,                                                                                                                                
      l2.date_closed                      AS level2_CloseDate,                                                                                                 
      l3.level3_key,                                                                                                                                
      Isnull(l3.level3_description, '') AS level3_description,                          
      l3.level3_status,                                                                                                                                
      l3.date_opened                      AS level3_opendate,                                                                                                     
   l3.date_closed AS level3_closedate,                                                                                                                                             
      l3.parent_level3_key,                                                                                                                                             
      l3.horder,                                                                                                                               
      c.customer_code,                                                                                                                                             
      c.customer_name,                                                                                        
      l3.expense_flag,                                                                                                                                             
      l3.labor_flag,                                                                        
      l2.org_unit,                                                                                                                                           
      l2.location_code,                                                                                                                                             
  l3.org_unit,                                                                                                                             
      l3.location_code,                                 
      0,                                                                                                       
      l3.cost_type,                                                                                                      
      isnull(l3.modify_date,l3.create_date),                                                                                                                          
      l3.task_type,                      
      l3.billable_flag,              
      isnull(l2.modify_date, l2.create_date)                                                                                 
  FROM   pdd_level2   l2                                                                                                                     
      INNER JOIN pdd_level3   l3                                                                        
  ON  l2.level2_key = l3.level2_key                                                                                          
      INNER JOIN #valid_customers c                                                                             
  ON l2.level2_key = c.level2_key                                                 
  WHERE  l2.company_code = @company_code                                                                                                      
      AND l3.company_code = @company_code                                  
      AND l2.level2_status = 1                                                                                  
      AND l3.level3_status = 1                                 
      and                                
      (l3.labor_flag = 1  or l3.expense_flag = 1  )                                                                                                                                        
  --    (                                
  --(                    
  -- (l3.labor_flag = 1  and @source = 0)                                 
  -- or                                 
  -- (l3.expense_flag=1 and @source = 1)                                
  --)                                        
  --  or                                 
  --(                                 
  -- isnull(@level2_key, '') !=''                                 
  -- and                                 
  -- (l3.labor_flag = 1  or l3.expense_flag = 1  )                                 
  --)                                  
  --    )                                
                                      
      AND (@mode=0 or @last_sync_date < isnull(dateadd(mi, 10, l3.modify_date), dateadd(mi, 10, l3.create_date)) )                                                                                                
                                                                                              
     end                                                                                                                     
     else                                                                                             
      begin                                       
  INSERT #Level2Level3                                                                                                                                             
   (                                                                                                                            
    level2_key,                                                                                                                                             
level2_description,                                                                         
    level2_status,                                                                                                                       
    level2_opendate,                                                        
    level2_closedate,                                                                                                                                             
    level3_key,                                                                                                                                             
    level3_description,                                                                
    level3_status,                                                                         
    level3_opendate,                                
    level3_closedate,                 
    parent_level3_key,                                                                               
    horder,                                                    
    customer_code,                                                                                                                                             
    customer_name,                                        
    expense_flag,                                                                         
    labor_flag,                                                                     
 l2_org_unit,                                                                                                                                             
    l2_location_code,                                      
    l3_org_unit,                                                                                        
    l3_location_code,                                                                                                                                             
    read_flag,                                                                                                                                        
    cost_type,                                                                                     
    modify_date ,                                                         
    task_type,                                                                                                                          
    billable_flag,                   
    Level2_modify_date                                                                                                 
   )                                                                                                                                             
  SELECT                                                                                                                     
      l2.level2_key,                                                                                      
      Isnull(l2.level2_description, '') AS level2_description,                                                                           
      l2.level2_status,                                                                                            
      l2.date_opened     AS level2_OpenDate,                                                                                                             
      l2.date_closed                      AS level2_CloseDate,                                                                                                                                             
     null  level3_key,                                                                                                          
      null AS level3_description,                                                                          
      l3.level3_status,                                                                                                                                           
      null                   AS level3_opendate,                                                                                                                                             
      null AS level3_closedate,                                                                                                                
      null,                                                                           
      null,                                                                  
      c.customer_code,                                                                                                                                             
      c.customer_name,                                                                                                
      max(l3.expense_flag),        
      max(l3.labor_flag),                                    
  l2.org_unit,                                                                                                                                             
      l2.location_code,                                                                                   
      null,                                                                        
     null,                                                                                                
      0,                                                                                         
      null,                                                    
      isnull(l2.modify_date, l2.create_date),                                                                  
      null,                                                                                                                          
      null,                                                
      isnull(l2.modify_date, l2.create_date)                                                                                     
   FROM   pdd_level2   l2                                                              
    INNER JOIN pdd_level3   l3                                                                                                                          
  ON  l2.level2_key = l3.level2_key                                                                          
  and l3.level3_status =1                                                  
      INNER JOIN #valid_customers c                                                                                                             
  ON l2.level2_key = c.level2_key                                                                                                          
  WHERE  l2.company_code = @company_code                                                                                                      
      AND l3.company_code = @company_code                                                                                                              
      AND l2.level2_status = 1                                                                    
      AND l3.level3_status = 1                                                                                                                                             
      AND  ( l3.labor_flag = 1  or l3.expense_flag = 1  )                            
                                      
      AND (@mode=0 or @last_sync_date < isnull(dateadd(mi, 10, l2.modify_date), dateadd(mi, 10, l2.create_date)) )                                                                           
     group by                                                                          
  l2.level2_key,                                                                                                                                             
   l2.level2_description   ,                                                                           
  l2.level2_status,                                                                                            
  l2.date_opened     ,                                                                                                             
  l2.date_closed ,                                                                                                                                             
  l3.level3_status,                                                                                                                                           
  c.customer_code,                                                                                          
  c.customer_name,                                                                                                                           
  l2.org_unit,                          
  l2.location_code,                                                                                               
   l2.modify_date,                            
   l2.create_date  ,                              
   l2.modify_date,                             
   l2.create_date                     
                                                                                               
                                     
     end                                                                                                                 
                                                                
                                                               
 if ISNULL(@level2_key, '') <> ''                                                                                                                
  delete From #Level2Level3 where level2_key not like rtrim(@level2_key) + '%'                                                                                                       
                               
                               
                                               
 if ISNULL(@level3_key, '') <> '' and  @include_level3 =1                            
  delete From #Level2Level3 where level3_key not like rtrim(@level3_key) + '%'                                                                                                    
                                                         
                                              
  declare @counter int =0                                            
   while (@counter !=2)                                           
 begin                            
             set @counter = @counter + 1                                 
                                                                     
    SELECT @permission_status = permission_status                                                                                                                                             
    FROM   pdm_rule_group                                                                                                  
    WHERE  path = 'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level2/OrgUnit'                                 
           AND @user_group = user_group_code                                                                                                                                             
                                   
    IF @permission_status = 2                                 
       BEGIN                              
                                   
                                   
       update #Level2Level3                             
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                             
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end                             
     WHERE  l2_org_unit <> @org_unit1                                                                                                                                             
                                 
      END                                                                           
                                               
                                               
                                                                                                    
    SELECT @permission_status = permission_status                                                                    
    FROM   pdm_rule_group                                                                                                                    
    WHERE  path =                                                                                                                                             
   'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level2/LocationCode'      
           AND @user_group = user_group_code                                                                                                                           
                                                                                                
   IF @permission_status = 2                                         
       BEGIN                                  
     update #Level2Level3                             
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                             
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end                             
                             
          WHERE  l2_location_code <> @location_code1                                                                                                                              
     END                                                                                           
                                     
                                                
                                                                                                                                        
    SELECT @permission_status = permission_status                                                                                                                                             
    FROM pdm_rule_group                                                                                                                                             
    WHERE  path = 'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level3/OrgUnit'                                                                   
           AND @user_group = user_group_code                                                                                                                                            
                                                                                                                    
 IF @permission_status = 2                                                           
       BEGIN                                                                                                                                             
  update #Level2Level3                             
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                             
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end                             
                             
          WHERE  l3_org_unit <> @org_unit1 --                                                                                                      
      END                                                                         
                                                                                                             
    SELECT @permission_status = permission_status                                                                                                                                             
    FROM   pdm_rule_group                                                                                                                                      
    WHERE  path =                                     
    'Rules/TimeandExpense/'+@source_text+'/DataFilter/Level3/LocationCode'                                                                                                                                     
           AND @user_group = user_group_code                                                                                                                                             
                                                                                                                                            
    IF @permission_status = 2                                             
       BEGIN                                                                    
    update #Level2Level3                             
   set expense_flag = case when @source_text  ='ExpenseReport'  then 0 else expense_flag   end ,                             
     labor_flag = case when @source_text  ='TimeSheet'  then 0 else  labor_flag   end                             
   WHERE  l3_location_code <> @location_code1--                                                                                                                                             
      END                                         
       set @source_text  ='ExpenseReport'                             
  end -- while loop for data filters                                
                                  
                                                                                                                                            
    INSERT #level2                                          
           (level2_key)                                                                                                                       
    SELECT level2_key                                         
FROM   #Level2Level3                                                                                                                                             
    WHERE  level2_key IN (SELECT level2_key                                                                                                                                             
                          FROM   pdd_level2              
       WHERE  validate_resource = 0)                                                                                                                                             
    UNION --all                                                                                                                       
    SELECT level2_key                                                                    
    FROM   #Level2Level3                                                                                                                                             
    WHERE  level2_key IN (SELECT level2_key                 
            FROM   pdd_level2                                                                                                                                             
                          WHERE  validate_resource IN ( 1, 3 )                                                                                                          
                             AND res_group_id = (SELECT res_group_id                                                                                                                                             
                                                     FROM   pdd_resources                                              
                                     WHERE                                                                                                                                             
                                     resource_id = @resource_id                                                                                                                                             
AND res_category_code = 'EMPL')                                                                                                           
                  )                                                                  
    UNION --- all                                                                                                                          
  SELECT level2_key                                                                                                                                             
    FROM   #Level2Level3   
    WHERE  level2_key IN (SELECT level2_key                                                   
      FROM   pdd_level2                                                                                                                                             
                          WHERE  validate_resource IN ( 3, 2 )                                                                                                                                             
                                 AND level2_key IN (SELECT level2_key         
                                       FROM   pdd_level3_schedule                                
                                                    WHERE                                                                                                                                             
                                     resource_id = @resource_id))                           
                                                                                                             
    IF ( (SELECT Count(*)                                                                                                                 
          FROM   pdd_approval_chain_header                                                                                
          WHERE  company_code = @COMPANY_CODE                                                                                             
                 AND approval_module_path =                            
                     'CompanyRules/Multi-LevelApproval/Level2')                                                                                                                                             
            > 0 )                                         
      BEGIN                                                                                                                                    
          DELETE FROM #level2                                                                                                                                             
          WHERE  level2_key IN (SELECT DISTINCT level2_key                                                                                                                            
                                FROM   pdd_level2                                                                  
     WHERE  ( approved_flag IS NULL                                                                                                                                       
                                          OR approved_flag = 0 ))                                                                                   
      END                     
                                                          
                                                                                                            
    DELETE FROM #Level2Level3                                                                                                                                             
    WHERE  level2_key NOT IN (SELECT level2_key                                                                                                                                             
      FROM   #level2)                                                                                                                                             
                                              
                                                                        
    select  top (@count) level2_key,  max(modify_date) modify_date                                                       
 into #cte_distinct_level2                                                       
    from #Level2Level3                                                  
    group by level2_key                                                 
    order by max(Level2_modify_date) desc                                  
   
                                          
                                          
    delete #Level2Level3                                                                                                                
where level2_key not in                                                                                                    
    (select level2_key from #cte_distinct_level2)                                                                                                                    
                                               
                                
                                
 if (isnull(@customer_code, '')='' and  isnull(@level2_key, '')='')                                                
 begin                                                   
  print 'include trx level2'                                                                                            
  insert into #Level2Level3                                                                 
   (                                                                            
 level2_key,                                                                                                                                             
 level2_description,                        
 level2_status,                                                                        
    level2_opendate,                                                                                                                           
    level2_closedate,                                                                                               level3_key ,                                                                    
    level3_description,                                                    
    level3_status,                                                    
    customer_code                                                                                                                                          
    ,customer_name                                                                         
    ,labor_flag        
    ,expense_flag                                          
    ,level3_opendate                                                  
    ,level3_closedate                                                
    ,task_type                               
    ,billable_flag                                      
 ,transaction_order                                                                                                            
)                                                                                                                  
  SELECT distinct                                                                       
    plt.level2_key,                                                                                                            
    level2_description,                                                                        
    plv2.level2_status,                                                     
    plv2.date_opened,                                                                        
    plv2.date_closed,                                                                                                          
    case when @include_level3=1 then plt.level3_key else null end,                                               
    case when @include_level3=1 then level3_description else null end,                                                                           
    case when @include_level3=1 then plv3.level3_status else null end,                                                
    customer_code,         
    customer_name,                                                
    case when @include_level3=1 then plv3.labor_flag else null end as labor_flag,        
    case when @include_level3=1 then plv3.expense_flag else null end as expense_flag,                       
    case when @include_level3=1 then plv3.date_opened else null end as level3_opendate,                                                                                                            
    case when @include_level3=1 then plv3.date_closed else null end as level3_closedate,                                                
    case when @include_level3=1 then plv3.task_type else null end,                                                                                
    case when @include_level3=1 then plv3.billable_flag  else null end   ,                                               
    row_number () over (partition by 1 order by plt.create_date) transaction_order                                                                               
   FROM pdv_pld_transactions plt                                                                       
    LEFT OUTER JOIN pdd_level2_customer pl2c                                                                                                                            
     ON plt.company_code=pl2c.company_code                                                                                                                            
      AND plt.level2_key = pl2c.level2_key                                                                                                                            
    JOIN pdd_level2 plv2                                                              
     ON  plt.level2_key=plv2.level2_key                      
      AND plt.company_code=plv2.company_code                                                      
    LEFT OUTER JOIN pdd_level3 plv3                 
     ON plt.level3_key=plv3.level3_key                                                                              
      AND plt.level2_key=plv3.level2_key                                                                                                         
      AND plt.company_code=plv3.company_code                                                      
   WHERE                                                                                                                            
     plt.company_code = @company_code AND                                                                                                                            
     plt.resource_id = @resource_id AND                        
     plt.trx_level in (0, 3) AND                                                           
     plt.units <> 0 AND                                                                                                          
   --  plv2.level2_status = 1 AND                                                                                  
     DATALENGTH(rtrim(line_id)) < 4                                                                         
  --   and plv3.level3_status=1                                                                        
  and (@mode =0  or plt.create_date >= @last_sync_date)                                                                     
     --and plv3.labor_flag = 1 -- hamza -- even if the level3 is not labor and the transaction exists, include it.                                                
 -- uncommented the following check, as we are getting the duplicate records.                                                
     and plv2.level2_key not in                                                                     
     (select distinct level2_key from #Level2Level3)                       
                         
                                                                      
 end                                                           
                                                                                     
           declare @entity_id int                                                                                                    
  if @include_level3 = 0                        
  begin                                     
   SELECT                             
 max(l23.id) id,                         
 L23.level2_key,                                                                                                                                               
    Isnull(L23.level2_description, '') AS level2_description,                                                     
    L23.level2_status,                                                                          
    L23.level2_opendate,                   
    L23.level2_closedate,                                                                                                      
    L23.level3_key ,  
    l2.org_unit as l2_org_unit,  
    l2.location_code as l2_location_code,  
    ISNULL(L23.level3_description,'')  AS level3_description,                                                
    L23.level3_status,                                                                          
    L23.labor_flag,        
    L23.expense_flag,                                                    
    L23.customer_code                                                                                                                                            
    ,L23.customer_name                                                                                                                            
    ,L23.level3_opendate as open_date                                                                                           
    ,L23.level3_CloseDate as closed_date                                                                                                 
    ,L23.task_type                                                                               
,L23.billable_flag                                                                              
    ,comments_for_time_required_flag                                            
    ,comments_for_expense_required_flag                                        
  ,max(transaction_order) transaction_order                                           
   into #l2_data                                                                          
   FROM   #Level2Level3  L23                                        
                                            
   INNER JOIN pdd_level2 l2 on l2.level2_key= l23.level2_key                                      
   where                            
   (@keys is null or exists (select * from #level23_xml x where x.level2_key  = L23.level2_key))                            
    --and ( l23.labor_flag = 1  or l23.expense_flag = 1  )                            
    --isnull(L23.level2_key , '')= isnull(isnull(@level2_key, L23.level2_key)  , '')                                  
    -- and isnull(L23.level3_key, '') = isnull(isnull(@level3_key, L23.level3_key)   , '')          
    and l2.level2_key = 'matte001-15-011'                        
                                
                                
    group by                                            
     L23.level2_key,                                                                                                                                               
    L23.level2_description,                                                                                   
    L23.level2_status,                                                                   
    L23.level2_opendate,                 
    L23.level2_closedate,                                                                                                                      
    L23.level3_key ,                                                                                                                                                  
    L23.level3_description,                                                                                          
    L23.level3_status,                                           
    L23.labor_flag,        
    L23.expense_flag,                                                                            
    L23.customer_code                                                                                                                
    ,L23.customer_name                                                                                                                        
    ,L23.level3_opendate                                                                                                            
    ,L23.level3_CloseDate                                              
    ,L23.task_type                                                                                                                                            
    ,L23.billable_flag                                                                                             
    ,comments_for_time_required_flag                                                            
    ,comments_for_expense_required_flag,  
    l2.org_unit,  
    l2.location_code                                        
   ORDER  BY 1                                                    
                                       
    if @subscriber_id is null                                                     
   begin                                        
    select * from  #l2_data ORDER  BY isnull(transaction_order, 0) desc                                                    
    --ORDER  BY 1                                                    
      end                                       
   else                                                     
  begin                                                    
   select TOP (@count_to_return) * from  #l2_data ORDER  BY isnull(transaction_order, 0) desc, level2_key                                                    
                                                       
   DELETE    #l2_data                                                      
   where id in ( select TOP (@count_to_return) id from  #l2_data ORDER  BY isnull(transaction_order, 0) desc, level2_key     )                                        
                                                     
                                                           
   select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level2'                                                    
                                                      
   insert into pdd_event_notification                                                          
   (primary_key,                                                         
   company_code,                                                         
   entity_action_id,                                                        
   entity_type_id,                                                        
   subscriber_id,                                                         
   create_id,                                                         
   create_date)                                                                        
   select convert(varchar, @company_code) + '~-~' + level2_key   ,                                           
   @company_code,                                    
   2,                                                         
   @entity_id,                                                         
   @subscriber_id  ,                                                        
   null,                                                         
   GETDATE()              
   from #l2_data                                                       
                                                    
  end                                     
                                      
                                        
  end       
 else                                           
 begin                                          
  SELECT                         
 max(l23.id) id,                         
 L23.level2_key,                                                                                                                                               
    Isnull(L23.level2_description, '') AS level2_description,                                                                   
    L23.level2_status,                                                                          
    L23.level2_opendate,                                                                                                                             
    L23.level2_closedate,                                                                                                      
    L23.level3_key,  
    l2.org_unit as l2_org_unit,  
    l2.location_code as l2_location_code,  
    ISNULL(L23.level3_description,'')  AS level3_description,                                                                          
    L23.level3_status,                                                                          
    L23.labor_flag,                                 
    L23.customer_code                                                                                                                                            
    ,L23.customer_name                                                                                                                            
    ,L23.level3_opendate as open_date                                                                                           
    ,L23.level3_CloseDate as closed_date                                                                                                                           
    ,L23.task_type                                                                                                                            
    ,L23.billable_flag                                         
    ,L23.cost_type                                                                             
    ,comments_for_time_required_flag                                            
    ,comments_for_expense_required_flag                                                                             
    ,l3.org_unit                                            
  , l3.location_code                                            
  , l23.expense_flag                                            
  , l3.date_due                                            
  , l3.rate_table1                                            
  , l3.rate_table2   ,                                     
  max(transaction_order) transaction_order                                            
          into #l2l3_data                                           
                                              
   FROM   #Level2Level3  L23                                             
   INNER JOIN pdd_level2 l2 on l2.level2_key= l23.level2_key                                          
   INNER JOIN pdd_level3 l3 on l3.level2_key= l23.level2_key and l3.level3_key= l23.level3_key                   
   INNER JOIN pdm_budget_template temp on l3.budget_template_code=temp.budget_template_code                                    
    where                             
      (@keys is null or exists (select * from #level23_xml x where x.level2_key  = L23.level2_key and x.level3_key  = L23.level3_key))                            
   and ( l23.labor_flag = 1  or (l23.expense_flag = 1  and isnull(temp.search_media_flag,0)<>1)   )                      
   and l2.level2_key = 'matte001-15-011'                         
                               
     -- isnull(L23.level2_key , '')= isnull(isnull(@level2_key, L23.level2_key)  , '')                              
     --and isnull(L23.level3_key, '') = isnull(isnull(@level3_key, L23.level3_key)   , '')                                    
   group by                                            
 L23.level2_key,                                                                      
    L23.level2_description ,                  
    L23.level2_status,                                                                                 
    L23.level2_opendate,                                                                                                                                             
    L23.level2_closedate,                                         
    L23.level3_key ,                                                                                                                                                  
    L23.level3_description ,                                                                           
    L23.level3_status,                                                                                          
    L23.labor_flag,                                                                           
    L23.customer_code                                                          
    ,L23.cost_type                                                                                                                                 
    ,L23.customer_name                                                                                  
    ,L23.level3_opendate                                                                                                           
    ,L23.level3_CloseDate                                                                                                                                          
    ,L23.task_type                                                        
    ,L23.billable_flag                                                                                              
    ,comments_for_time_required_flag                                                            
    ,comments_for_expense_required_flag                                     
    ,l3.org_unit                                                            
  , l3.location_code                                                            
  ,  l23.expense_flag                                                            
  , l3.date_due                                      
  , l3.rate_table1                                                            
  , l3.rate_table2,  
  l2.org_unit,  
  l2.location_code  
          
          
                                      
                                             
   if @subscriber_id is null                                                     
  begin           
  select * from  #l2l3_data                     
  ORDER  BY 1                                                    
  end                                                    
   else                                                     
    begin                                                    
                                            
    select  * from  #l2l3_data    where level2_key in ( select   top (@count_to_return) level2_key from  #l2l3_data                          
    group by level2_key ORDER  BY   max(isnull(transaction_order, 0))  desc, level2_key       )                                        
  DELETE    #l2l3_data                                                      
  where level2_key in ( select top (@count_to_return) level2_key  from #l2l3_data group by level2_key ORDER  BY  max(isnull(transaction_order, 0))  desc, level2_key )                                                    
                                           
                                                      
                                                             
  select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level3'                                                     
            
   insert into pdd_event_notification                                                          
 (                                        
  primary_key,                                                         
  company_code,                                                         
entity_action_id,                                                        
  entity_type_id,                                                     
  subscriber_id,                                                         
  create_id,                                                         
  create_date                                        
 )                                                                     
 select convert(varchar, @company_code) + '~-~' + level2_key  + '~-~' + level3_key  ,                                                      
 @company_code,                                                         
 2,                                                         
 @entity_id,                                                         
 @subscriber_id ,                                                      
 null,     
 GETDATE()                                                          
   from #l2l3_data                                                        
                                                   
                                                   
                                                   
        end                                                    
                                                                    
 end             
         
         
                                                                                                      
                                                                                                                                                      
END 