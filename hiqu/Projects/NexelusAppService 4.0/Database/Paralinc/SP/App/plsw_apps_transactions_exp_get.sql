/****** Object:  StoredProcedure [dbo].[plsw_apps_transactions_exp_get]Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plsw_apps_transactions_exp_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[plsw_apps_transactions_exp_get]
GO

/****** Object:  StoredProcedure [dbo].[plsw_apps_transactions_exp_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create PROCEDURE   plsw_apps_transactions_exp_get    
  @company_code int                            
  ,@resource_id varchar(64)                
  ,@transaction_id char(16)=null                           
  ,@record_id char(16)=null                      
  ,@last_sync_date datetime = null,                  
 @subscriber_id int = null,         
@keys xml = null        
---- plsW_apps_exptrx_hdr_get 10,'EMP000228','02/02/1966','02/02/2006',4                                
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
*   Date revised: 4th june 2015            *                    
*             By: arif hasan            *                    
*        Comment:               *                    
*                   *                    
* [plsW_apps_exptrx_hdr_get] 2, 451           *          
      
'<keys>        
 <key>        
  <transaction_id>21042015</transaction_id>       
          
 </key>        
 <key>         
  <transaction_id>002</transaction_id>        
 </key>        
</keys>'                 
***********************************************************************/                                
AS                               
 begin       
        
 select      
 T.c.value('./transaction_id[1]', 'varchar(64)') transaction_id      
             into #transaction               
                       FROM     @keys.nodes('/keys/key') T ( c )        
                             
                                    
 CREATE TABLE #pld_transaction_hdr(                      
   [report_name] [varchar](32) NOT NULL,                      
   [record_id] [char](16) NOT NULL,                      
   [comments] [varchar](252) NOT NULL,                      
   [date_from] [datetime] NOT NULL,                  
   [date_to] [datetime] NOT NULL,                      
   [expense_num] [varchar](16) NULL,                      
   [amount] [float] NOT NULL,                      
   [timestamp] [binary](8) NULL,      
   [submitted_flag] [tinyint] NOT NULL,                      
   [home_amount] [float] NOT NULL,                      
   [reimburse_home_amount] [float] NOT NULL,                      
   [upload_flag] [tinyint] NULL,                      
   [approval_flag] [tinyint] NULL,     
   [finalise_flag] [tinyint] NULL,                      
   [summary_flag] [tinyint] NULL,                      
   [approver_id] [varchar](32) NULL,                      
   [print_format] [varchar](50) NULL,                      
   [approver_name] [varchar](70) NULL,                      
   [re_approval_flag] [tinyint] NULL                      
 )                       
                
 insert into #pld_transaction_hdr                      
                        
 exec [plsW_exptrx_hdr_get]                   
    @company_code = @company_code                        
   ,@resource_id  = @resource_id                          
   ,@date_from = null                            
   ,@date_to      = null                
   ,@filter_flag = 0                         
   ,@record_id  = ''              
                 
   -- select * from #pld_transaction_hdr where record_id = 'm8d26701021bcd90'              
 delete t        
 from #pld_transaction_hdr T INNER JOIN pld_transactions_hdr P                 
  ON P.record_id = t.record_id                        
 where  create_date < DATEADD(week,  -10, GETDATE())                    
                 
 select c.* into #data         
 from pld_transactions_exp c inner join #pld_transaction_hdr hdr                
  on c.record_id = hdr.record_id                
 where (@last_sync_date is null or (isnull(c.modify_date, c.create_date) > @last_sync_date))        
 and c.transaction_id = ISNULL(@transaction_id, c.transaction_id)                           
 and c.record_id = ISNULL(@record_id,  c.record_id)       
 and (@keys is null or exists (select * from #transaction t where t.transaction_id = c.transaction_id)  )               
                
               
 if @subscriber_id is null              
   begin              
   select * from #data              
   end              
  else              
   begin              
   select top 100 * from #data order by  transaction_id             
   delete top (100) #data              
   where transaction_id in              
   (select top 100  transaction_id from #data order by transaction_id)              
                 
                 
 declare @entity_id int                 
 select @entity_id  =entity_type_id from  [plv_entity_type] where entity_type_desc = 'TransactionExpense'                
              
  alter table #data add resource_id nvarchar(30)            
              
  update d            
 set resource_id = i.resource_id            
  from #data d inner join pld_transactions i on i.transaction_id = d.transaction_id            
              
              
 insert into plv_event_notification                
 (primary_key, company_code, entity_action_id,entity_type_id,subscriber_id, create_id, create_date)                              
  select    convert(varchar, @company_code) + '~-~' + transaction_id  ,    d.company_code, 2, @entity_id, subscriber_id,  i.resource_id, GETDATE()                
 from #data  d inner join plv_apps_subscriber_info i on i.resource_id = d.resource_id                 
 where      is_active = 1     and     subscriber_id  = @subscriber_id          
               
   end                 
end              
    


             
go        


