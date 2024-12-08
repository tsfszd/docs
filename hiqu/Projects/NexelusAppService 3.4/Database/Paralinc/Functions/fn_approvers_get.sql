drop FUNCTION dbo.fn_approvers_get
go 
CREATE FUNCTION dbo.fn_approvers_get(@transaction_id char(16))
RETURNS @approvers TABLE 
   (transaction_id char(16),resource_id char(16)) 

AS 
BEGIN 

declare @level2_key varchar(32),    
  @level3_key varchar(64),    
  @resource_id char(16),    
  @level2_trx_approval_flag int,    
  @level3_trx_approval_flag int,    
  @supervisor char(16)    
  
  
declare @trx_type int     
      
    
select @level2_key=level2_key,@level3_key=level3_key,@resource_id=resource_id  ,@trx_type=trx_type  
from pld_transactions where transaction_id=@transaction_id    
    
select @supervisor=reports_to from plv_resource where resource_id=@resource_id    
    
select @level2_trx_approval_flag= trx_approval_required_flag from plv_level2 where level2_key=@level2_key    
select @level3_trx_approval_flag= trx_approval_flag from plv_level3 where level2_key=@level2_key and level3_key=@level3_key    

declare @overrride_exp_app varchar(255)
SELECT @overrride_exp_app=default_code                 
FROM plv_rule_group                 
WHERE path='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals'                
and user_group_code is NULL    

declare @override_approver varchar(32)
select @override_approver=approver_id from pld_transactions_hdr where record_id=(select top 1 record_id from pld_transactions where transaction_id=@transaction_id )

if (@trx_type > 1999 and @trx_type < 2999) and  @overrride_exp_app='CompanyRules/TimeandExpense/Approvals/ExpenseReport/OverrideApprovals/Yes'   
begin 
insert into @approvers    
  select @transaction_id ,@override_approver  
end
else 
begin
	if @level2_trx_approval_flag<>0    
	begin     
	 if @level3_trx_approval_flag=2    
	 begin    
	  insert into @approvers    
	  select @transaction_id ,@supervisor    
	 end    
	 else    
	 if @level3_trx_approval_flag=1    
	 begin    
	  insert into @approvers    
	  select @transaction_id ,resource_id from plv_level2_resource where level2_key=@level2_key           
                                                   
				   and position_category_code=1    
	 end     

	end
end
RETURN
END


