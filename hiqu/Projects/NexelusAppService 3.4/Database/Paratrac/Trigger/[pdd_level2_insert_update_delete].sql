
/****** Object:  Trigger [pdd_level2_insert_update_delete]    Script Date: 07/14/2015 03:27:53 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[pdd_level2_insert_update_delete]'))
DROP TRIGGER [dbo].[pdd_level2_insert_update_delete]
GO


/****** Object:  Trigger [dbo].[pdd_level2_insert_update_delete]    Script Date: 07/14/2015 03:28:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[pdd_level2_insert_update_delete]               
   ON  [dbo].[pdd_level2]              
   AFTER insert, update, delete              
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
*         Name: pltW_transactions_hdr_del                             *                                                                                                                 
*       Module:                                                       *                        
* Date created: June 29 2015            *                                                                                                                 
*           By: Hamza Mughal                                          *                  
*      Comment: Save the change in the change log table               *                                         
*                   *                                                       
*                   *                     
********************************************************************* */              
AS       
BEGIN              
--select * from [pdd_entity_type]  
  DECLARE @permission_status INT=NULL,                                                                                                           
            @org_unit1         CHAR(16),                                                                                                    
            @location_code    CHAR(16),                                                                                                           
            @user_group        VARCHAR(16)   
              
 DECLARE @action int;    
 SET @action = 1; -- Set Action to Insert by default.    
    IF EXISTS(SELECT * FROM DELETED)    
    BEGIN    
        SET @action =     
            CASE    
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 2 -- Set Action to Updated.    
                ELSE 3 -- Set Action to Deleted.           
            END    
    END    
        
     select top 0 d.company_code, rtrim(ltrim(d.level2_key))level2_key,d.org_unit,location_code,  resource_id, subscriber_id,approved_flag into  #data from inserted d, pdd_apps_subscriber_info   
        
if @action = 1     
begin    
insert into #data select d.company_code, rtrim(ltrim(d.level2_key))level2_key, d.org_unit, location_code,resource_id, subscriber_id,approved_flag      
from inserted d, pdd_apps_subscriber_info   
  end    
  else     
  begin    
  insert into #data select d.company_code, rtrim(ltrim(d.level2_key))level2_key,d.org_unit,location_code, resource_id, subscriber_id,approved_flag      from deleted d, pdd_apps_subscriber_info       
  end      
    
  alter table #data add user_group varchar(32), org_permission int,localtion_permission int, org_unit1 CHAR(16), location_code1 char(16)  
    
  update d   
  set user_group = user_group_code   
  from #data d inner join  pdm_group_user_link p  
 on   d.resource_id =  p.resource_id   
  where preferred_group_flag = 1     
    
    
   update d   
  set location_code1 = p.location_code    ,  org_unit1 = p.org_unit  
  from #data d inner join  pdd_resources p  
 on   d.resource_id =  p.resource_id   
    
    
   update d   
  set org_permission = permission_status   
  from #data d inner join  pdm_rule_group p  
 on   d.user_group =  p.user_group_code   
  where  path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/OrgUnit'  
    
   update d   
  set localtion_permission = permission_status   
  from #data d inner join  pdm_rule_group p  
 on   d.user_group =  p.user_group_code   
  where  path = 'Rules/TimeandExpense/TimeSheet/DataFilter/Level2/LocationCode'        
    
   delete d    
   from #data d     
   where org_permission = 2 and org_unit <> org_unit1  
      
   delete d    
   from #data d     
   where localtion_permission = 2 and location_code <> location_code1  
---RS20171227 check for level3     
declare @approved_flag int ,@approved_flag_old int
select @approved_flag=l2.approved_flag, 
       @approved_flag_old=d.approved_flag from pdd_level2 l2 inner join #data d on rtrim(ltrim(d.level2_key))=rtrim(ltrim(l2.level2_key))
if @action=2
begin 
 IF OBJECT_ID('tempdb..#pdd_level3') IS NOT NULL
 DROP TABLE #pdd_level3
 	   
create table #pdd_level3
(level2_key varchar(32),level3_key varchar(64),trx_approval_flag int)	 
insert into #pdd_level3
select distinct l3.level2_key,l3.level3_key,trx_approval_flag
from pdd_level3 l3 inner join #data d on d.level2_key=l3.level2_key    
where (expense_flag=1 or labor_flag=1) and level3_status=1
end
   ---RS20171227 check for level3  
   

    
declare @entity_id int     
select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level2'    
     
 insert into pdd_event_notification    
 (primary_key,   
 company_code,   
 entity_action_id,  
 entity_type_id,  
 subscriber_id,   
 create_id,   
 create_date)                  
 --select convert(varchar, company_code) + '~-~' + level2_key  ,   
 --company_code,   
 --@action,   
 --@entity_id,   
 --subscriber_id ,  
 --null,   
 --GETDATE()    
 --from #data    
 
 select convert(varchar, company_code) + '~-~' + level2_key  ,   
 company_code,   
 @action,   
 @entity_id,   
 subscriber_id ,  
 null,   
 GETDATE()    
 from #data d 
 where not exists 
	(
		select n.primary_key from pdd_event_notification n with(nolock)
		where 
			n.primary_key = convert(varchar, company_code) + '~-~' + level2_key and 
			n.entity_action_id = @action and 
			n.entity_type_id = @entity_id and 
			n.subscriber_id = d.subscriber_id
			
			
	) 
	---RS20171227 check for level3  
if  isnull(@approved_flag,0)=1 and isnull(@approved_flag_old,0)=0 and @action=2
begin 
print 'approval'
--declare @count int
--select @count =count(*) from #pdd_level3
--print @count
select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level3' 
 
   
 insert into pdd_event_notification    
 (primary_key,   
 company_code,   
 entity_action_id,  
 entity_type_id,  
 subscriber_id,   
 create_id,   
 create_date)                  
 select convert(varchar, company_code) + '~-~' + rtrim(ltrim(d.level2_key))  + '~-~' + rtrim(ltrim(l3.level3_key))  ,   
		 company_code,   
		 @action,   
		 @entity_id,   
		 subscriber_id,  
		 null,   
		 GETDATE()    
	 from #data   d inner join #pdd_level3 l3 on rtrim(ltrim(d.level2_key))=rtrim(ltrim(l3.level2_key))     
 where not exists 
	 (
		select  1 from pdd_event_notification n with(nolock)
		where primary_key = convert(varchar, d.company_code) + '~-~' + rtrim(ltrim(d.level2_key))  + '~-~' + rtrim(ltrim(l3.level3_key)) and 
				n.entity_action_id = @action and 
				n.entity_type_id = @entity_id and 
				n.subscriber_id = d.subscriber_id 
		)   
end	
else if isnull(@approved_flag,0)=isnull(@approved_flag_old,0) and @action=2	
begin
print 'any change'
select @entity_id  =entity_type_id from  [pdd_entity_type] where entity_type_desc = 'Level3' 
   
 insert into pdd_event_notification    
 (primary_key,   
 company_code,   
 entity_action_id,  
 entity_type_id,  
 subscriber_id,   
 create_id,   
 create_date)                  
 select convert(varchar, company_code) + '~-~' + rtrim(ltrim(d.level2_key))  + '~-~' + rtrim(ltrim(l3.level3_key))  ,   
		 company_code,   
		 @action,   
		 @entity_id,   
		 subscriber_id,  
		 null,   
		 GETDATE()    
	 from #data   d inner join #pdd_level3 l3 on rtrim(ltrim(d.level2_key))=rtrim(ltrim(l3.level2_key))     
 where not exists 
	 (
		select  1 from pdd_event_notification n with(nolock)
		where primary_key = convert(varchar, d.company_code) + '~-~' + rtrim(ltrim(d.level2_key))  + '~-~' + rtrim(ltrim(l3.level3_key)) and 
				n.entity_action_id = @action and 
				n.entity_type_id = @entity_id and 
				n.subscriber_id = d.subscriber_id 
		) 
  and l3.trx_approval_flag=1

end
	---RS20171227 check for level3  
	  
               
END   
  
  







go 