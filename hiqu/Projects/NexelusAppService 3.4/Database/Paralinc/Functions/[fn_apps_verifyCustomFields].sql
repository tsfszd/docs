drop function fn_apps_verifyCustomFields 
go
create function fn_apps_verifyCustomFields (    
    
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
@number13 float =  null,                            
@number14 float =  null,                            
@number15 float =  null,                            
@number16 float =  null,                            
@number17 float =  null,                            
@number18 float =  null,                            
@number19 float =  null,                            
@number20 float =  null,     
@res_type int   =  null,      
@transaction_id  varchar(32) =  null       
) returns int    
as  
begin    

    
declare @custom_field_number int                  
 declare @exp_custom_field_number int        
     
 if @res_type is null    
 begin    
 select @res_type =  res_type from pld_transactions where transaction_id =@transaction_id    
 end                  
 set @custom_field_number = 0                
 set @exp_custom_field_number = 0                
 select  @custom_field_number = @custom_field_number + power(2 , field_number) from plv_exprpt_fields                
 where res_type = @res_type                  
                   
 if (isnull(@text1, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 2                  
 if (isnull(@text2, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 4                  
 if (isnull(@text3, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 8                  
 if (isnull(@text4, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 16                  
 if (isnull(@text5, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 32                  
 if (isnull(@text6, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 64                  
 if (isnull(@text7, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 128                  
 if (isnull(@text8, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 256                  
 if (isnull(@text9, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 512                  
 if (isnull(@text10, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 1024                  
 if (isnull(@number11, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 2048                  
 if (isnull(@number12, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 4096                   
 if (isnull(@number13, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 8192                  
 if (isnull(@number14, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 16384                  
 if (isnull(@number15, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 32768                  
 if (isnull(@number16, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 65536                  
 if (isnull(@number17, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 131072                  
 if (isnull(@number18, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 262144                  
 if (isnull(@number19, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 524288                  
 if (isnull(@number20, '') != '' ) set @exp_custom_field_number = @exp_custom_field_number + 1048576      
    
     
 if @custom_field_number != @exp_custom_field_number       
  begin    
  return 0    
  end    
        
  return 1
end