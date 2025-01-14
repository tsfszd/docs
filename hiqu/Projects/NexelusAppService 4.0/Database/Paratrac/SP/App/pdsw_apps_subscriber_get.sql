/****** Object:  StoredProcedure [dbo].[pdsw_apps_subscriber_get] Script Date: 02/04/2015 11:58:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdsw_apps_subscriber_get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pdsw_apps_subscriber_get]
GO

/****** Object:  StoredProcedure [dbo].[pdsw_apps_subscriber_get] Script Date: 02/04/2015 11:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pdsw_apps_subscriber_get]
 @company_code int         
 ,@resource_id nvarchar(15)        
 ,@os_version nvarchar(500)      
 ,@model nvarchar(500)         
 ,@make nvarchar(500)        
 ,@product_number nvarchar(500)         
  , @locale  nvarchar(100)       
 , @timeZone  NVARCHAR(500)
 , @app_version nvarchar(10) = null
 as         
begin        
        
declare @subscriber_id int = null         
select @subscriber_id =  subscriber_id  from pdd_apps_subscriber_info     
where  resource_id = @resource_id  and  product_number = @product_number  and company_code = @company_code    


-----------------------------BEGIN--NABBASI20182008

/*declare @app_version  nvarchar(10)*/

declare @error_code int =null
declare   @error_description varchar(10)=null

if convert(float,isnull(@app_version,0)) <3.3

begin

SELECT -1 ERROR_CODE, 'A new version of this application has been released. Please upgrade to latest version.' ERROR_DESCRIPTION 

RETURN
end

else

SELECT @error_code= 0, @error_description='' 

----------------------------END---NABBASI20182008


        
if @subscriber_id  is null        
 begin        
 insert into  pdd_apps_subscriber_info        
  (        
   company_code        
  ,resource_id        
  ,os_version        
  ,model        
  ,make        
  ,product_number        
  ,is_active        
  ,locale           
  ,timeZone       
  ,last_access_date        
  ,create_date        
  ,modify_date        
  ,app_version
  )        
  values         
  (        
  @company_code          
  ,@resource_id          
  ,@os_version          
  ,@model          
  ,@make          
  ,@product_number          
  ,1        
  ,@locale         
  ,@timeZone       
  ,getdate()         
  ,getdate()        
  ,getdate()
  ,@app_version
  )        
          
          
  SELECT @subscriber_id = SCOPE_IDENTITY() 
  
          
 end        
else        
 begin        
  update         
   pdd_apps_subscriber_info        
   set         
     os_version = @os_version         
    ,is_active =1        
    ,last_access_date = getdate()        
    ,modify_date = case when os_version = @os_version and (is_active = 1 or  locale = @locale or timeZone = @timeZone or app_version = @app_version)  then modify_date else  getdate() end
    where subscriber_id = @subscriber_id         
 end        
         
 select @subscriber_id subscriber_id   ,@error_code ERROR_CODE  , @error_description   ERROR_DESCRIPTION          
         
end  
  




go
