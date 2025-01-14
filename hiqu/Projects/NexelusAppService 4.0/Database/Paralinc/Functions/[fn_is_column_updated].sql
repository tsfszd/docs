drop function fn_is_column_updated
go
CREATE function fn_is_column_updated(@table_name nvarchar(500), @column_name nvarchar(500), @columns_updated varbinary(max) )
returns int
as 
	begin
			
	declare @source_id int
 	declare @source_idx int
 	    
	select @source_id = column_id from sys.columns where object_name(object_id) = @table_name
	 and name=@column_name
	 
 	 
	 
 	 set @source_idx =  power(  2,((@source_id%8)-1))
	   
	  
	 if SUBSTRING(@columns_updated,(@source_id /8+1), 1) & @source_idx   = @source_idx 
	 return  1
	 return 0
	end
	