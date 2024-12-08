if exists(select 1 from sys.procedures where name='plsw_apps_app_exp_trx_hdr_update')
begin 
drop procedure plsw_apps_app_exp_trx_hdr_update
end
go 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[plsw_apps_app_exp_trx_hdr_update]           
@TS         binary(8) = null,           
@company_code  int  ,           
@record_id       char(16) ,           
@amount               float     ,           
@modify_id      varchar(32)   ,           
@report_name      varchar(32)   ,        
@re_approval_flag int        
        
        
AS        
        
BEGIN         
        
CREATE TABLE  #error_list ( error_code INT , error_description VARCHAR(MAX),report_name varchar(32),timestamp varchar(256))      
         
 INSERT INTO #error_list        
                 
        
EXEC [plsw_app_exp_trx_hdr_update]        
        
@TS         = @TS,           
@company_code  =@company_code  ,           
@record_id    =@record_id ,           
@amount  =@amount,           
@modify_id = @modify_id,           
@report_name = @report_name,        
@re_approval_flag = @re_approval_flag        
        
 DECLARE @r_ts TIMESTAMP         
 SET @r_ts =  (select timestamp from pld_transactions_hdr where record_id = @record_id and report_name = @report_name)       
         
        
 SELECT error_code, error_description, report_name report_name,@r_ts  r_ts FROM #error_list        
        
        
        
end        
        
        
        


    


go