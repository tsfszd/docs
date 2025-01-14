IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_subscriber_defince_token_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_subscriber_defince_token_update]
GO

 
CREATE PROCEDURE [dbo].[pdsw_apps_subscriber_defince_token_update]
 @company_code int         
 ,@resource_id nvarchar(15)        
 ,@product_number nvarchar(500)         
 , @device_token VARCHAR(500)
  
 as         
 begin
   update         
   pdd_apps_subscriber_info        
   set         
     device_token  = @device_token  
     
    where  company_code = @company_code    AND resource_id = @resource_id  and  product_number = @product_number   
  



end


go