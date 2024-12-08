if exists(select 1 from sys.procedures where name='pdsw_validate_authentication_key')
begin 
drop procedure pdsw_validate_authentication_key
end
go
CREATE PROCEDURE [dbo].[pdsw_validate_authentication_key]   
 @auth_key varchar(32)          
with recompile        
AS        
BEGIN        
    if(not exists(select 1 from pdi_company_sites where auth_key = @auth_key ))     
	begin
		SELECT -1 error_code,'The authentication key is not valid' error_description 
		Return
	end
	
 select    
	auth_key
  ,authentication_mode    
  ,source_field
  ,mapped_field
 from pdi_company_sites        
 where auth_key = @auth_key        
        
         
END        


go 