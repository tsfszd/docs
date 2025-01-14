IF EXISTS (SELECT * from sys.procedures where name='plsW_apps_cc_exp_save') 
begin
drop procedure plsW_apps_cc_exp_save
end
go
CREATE PROCEDURE [dbo].[plsW_apps_cc_exp_save]
@company_code int ,     
@xml_transaction XML,
@xml_split_amounts XML=NULL,
@action_flag VARCHAR(32)=NULL ,
@create_id VARCHAR(32)    
as  

SELECT T.c.value('./cc_exp_id[1]', 'int') cc_exp_id,
		T.c.value('./amount[1]', 'FLOAT') amount,
		T.c.value('./TS[1]', 'varchar(max)') timestamp
	INTO #Transactions
	FROM  @xml_transaction.nodes('/transactions/transaction') T (c)


SELECT DISTINCT ext_reference_no INTO #ext_reference_no FROM pld_cc_exp WHERE cc_exp_id IN (SELECT DISTINCT cc_exp_id FROM #Transactions)

IF EXISTS(SELECT 1 FROM pld_transactions pl iNNER JOIN #Transactions p
			 ON  company_code = @company_code and  pl.cc_exp_id = p.cc_exp_id 
			)
			BEGIN


				SELECT -1 error_code,'Transaction(s) have been changed by some other user' ERROR_DESCRIPTION
			 ,pl.[timestamp], [company_code], pl.[cc_exp_id], [resource_id], [comments], [applied_date],   
			 pl.[amount], pl.[ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
			 [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
			 [payment_name], vendor_name
			 FROM pld_cc_exp pl iNNER JOIN #ext_reference_no p
			 ON  company_code = @company_code and  pl.ext_reference_no = p.ext_reference_no 
			 RETURN

			END


IF EXISTS(SELECT 1 FROM pld_cc_exp pl iNNER JOIN #Transactions p
			 ON  company_code = @company_code and  pl.cc_exp_id = p.cc_exp_id 
			 where pl.timestamp<>CONVERT(VARBINARY(MAX),p.timestamp,1))
			BEGIN

			

			 SELECT -1 error_code,'Transaction(s) have been changed by some other user' ERROR_DESCRIPTION
			 ,pl.[timestamp], [company_code], pl.[cc_exp_id], [resource_id], [comments], [applied_date],   
			 pl.[amount], pl.[ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
			 [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
			 [payment_name], vendor_name
			 FROM pld_cc_exp pl iNNER JOIN #ext_reference_no p
			 ON  company_code = @company_code and  pl.ext_reference_no = p.ext_reference_no 
			 RETURN
			END

DECLARE @resource_id VARCHAR(16),@comments VARCHAR(400),@applied_date DATETIME,@amount FLOAT,@ext_reference_no VARCHAR(32),
			@company_or_personal_flag INT,@cc_num VARCHAR(32),@cc_type_id INT,@cc_exp_id INT

declare @payment_code int 
declare @payment_name varchar(16)

CREATE TABLE #error_message(error_code INT,error_message VARCHAR(512),cc_exp_id INT)

IF @action_flag = 'Remove'
BEGIN
	
	UPDATE exp
	SET   split_flag = 1,
		  modify_id = @create_id,
		  modify_date = GETDATE()
	FROM pld_cc_exp exp 
	INNER JOIN #Transactions t 
	ON exp.company_code=@company_code AND exp.cc_exp_id=t.cc_exp_id
	
	SELECT 0 ERROR_CODE,'Successfully saved the CC Expense Transaction(s)' ERROR_DESCRIPTION
	,[timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
     [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
     [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
     [payment_name], vendor_name
	FROM pld_cc_exp WHERE company_code=@company_code AND cc_exp_id IN (SELECT cc_exp_id FROM #Transactions)
	
	RETURN
END
ELSE IF @action_flag = 'MarkAsPersonal'
BEGIN
	UPDATE exp
	SET   company_or_personal_flag = 1,
		  modify_id = @create_id,
		  modify_date = GETDATE()
	FROM pld_cc_exp exp 
	INNER JOIN #Transactions t 
	ON exp.company_code=@company_code AND exp.cc_exp_id=t.cc_exp_id

	SELECT 0 ERROR_CODE,'Successfully saved the CC Expense Transaction(s)' ERROR_DESCRIPTION
	,[timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
     [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
     [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
     [payment_name], vendor_name
	FROM pld_cc_exp WHERE company_code=@company_code AND cc_exp_id IN (SELECT cc_exp_id FROM #Transactions)
	RETURN
END
ELSE IF @action_flag = 'MarkAsPending'
BEGIN
	UPDATE exp
	SET   company_or_personal_flag = 0,
		  modify_id = @create_id,
		  modify_date = GETDATE()
	FROM pld_cc_exp exp 
	INNER JOIN #Transactions t 
	ON exp.company_code=@company_code AND exp.cc_exp_id=t.cc_exp_id

	SELECT 0 ERROR_CODE,'Successfully saved the CC Expense Transaction(s)' ERROR_DESCRIPTION
	,[timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
     [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
     [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
     [payment_name], vendor_name
	FROM pld_cc_exp WHERE company_code=@company_code AND cc_exp_id IN (SELECT cc_exp_id FROM #Transactions)
	RETURN
END
ELSE IF @action_flag ='Merge'
BEGIN
	UPDATE exp
	SET   split_flag = 1,
		  modify_id = @create_id,
		  modify_date = GETDATE()
	FROM pld_cc_exp exp 
	INNER JOIN #Transactions t 
	ON exp.company_code=@company_code AND exp.cc_exp_id=t.cc_exp_id

	
	
	SELECT TOP 1 @cc_exp_id= cc_exp_id FROM #Transactions
	SELECT   @resource_id=resource_id,@comments=comments,@applied_date=applied_date,@ext_reference_no=ext_reference_no,
	@company_or_personal_flag=company_or_personal_flag,@cc_num=cc_num,@cc_type_id=cc_type_id 
	FROM pld_cc_exp	WHERE cc_exp_id=@cc_exp_id

	SELECT  @amount = SUM(amount) FROM #Transactions
	 
	INSERT INTO #error_message(error_code,error_message,cc_exp_id)
	EXEC plsW_cc_exp_save @company_code=@company_code
	,@cc_exp_id=0
	,@resource_id=@resource_id
	,@comments= @comments
	,@applied_date=@applied_date
	,@amount=@amount
	,@ext_reference_no=@ext_reference_no
	,@create_id=@create_id
	,@split_flag=0
	,@company_or_personal_flag=@company_or_personal_flag
	,@cc_num=@cc_num
	,@cc_type_id=@cc_type_id

	IF NOT EXISTS (select 1 from #error_message where error_code < 0)
	BEGIN
		SELECT   cc_exp_id INTO #ids
		FROM #Transactions
		UNION
		SELECT  cc_exp_id from #error_message
		
		SELECT 0 ERROR_CODE,'Successfully saved the CC Expense Transaction(s)' ERROR_DESCRIPTION
		,[timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
		 [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
		 [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
		 [payment_name], vendor_name
		FROM pld_cc_exp WHERE company_code=@company_code AND cc_exp_id IN (select cc_exp_id FROM #ids)
		RETURN
	END
	ELSE
	BEGIN
		SELECT error_code,error_message,cc_exp_id from #error_message
		RETURN
	END

END
ELSE IF @action_flag='Split'
BEGIN

	
	SELECT  
		T.c.value('./amount[1]', 'FLOAT') amount 
	INTO #Amounts
	FROM  @xml_split_amounts.nodes('/amounts/amt') T (c)

	 
	
	UPDATE exp
	SET   split_flag = 1,
		  modify_id = @create_id,
		  modify_date = GETDATE()
	FROM pld_cc_exp exp 
	INNER JOIN #Transactions t 
	ON exp.company_code=@company_code AND exp.cc_exp_id=t.cc_exp_id

	DECLARE @total_amount FLOAT

	SELECT TOP 1 @cc_exp_id= cc_exp_id FROM #Transactions
	SELECT   @resource_id=resource_id,@comments=comments,@applied_date=applied_date,@ext_reference_no=ext_reference_no,
	@company_or_personal_flag=company_or_personal_flag,@cc_num=cc_num,@cc_type_id=cc_type_id ,@total_amount=amount
	FROM pld_cc_exp	WHERE cc_exp_id=@cc_exp_id

	INSERT INTO #Amounts
	SELECT @total_amount-SUM(amount) FROM #Amounts
	 
	 
	 select @payment_name = null    
	 select top 1 @payment_name = payment_name from pld_cc_exp where ext_reference_no = @ext_reference_no and payment_code is not null    
	 if @payment_name is not null     
	 begin    
	  select @payment_code = payment_code, @payment_name = payment_name from plv_pmt_types where payment_name = @payment_name    
	 end
	 SELECT @cc_exp_id=isnull(max(cc_exp_id),0)  from pld_cc_exp WHERE company_code= @company_code

	 insert into pld_cc_exp(company_code,cc_exp_id,resource_id,comments,applied_date,amount,     
	  ext_reference_no,create_id,create_date,     
	  split_flag,company_or_personal_flag,cc_num    
	  ,payment_code, payment_name, cc_type_id)
	  SELECT @company_code,
			@cc_exp_id + ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY amount)
		   ,@resource_id,@comments,@applied_date,amount,     
			@ext_reference_no,@create_id,GETDATE(),     
			0,@company_or_personal_flag,@cc_num    
			,@payment_code, @payment_name, @cc_type_id FROM #Amounts WHERE amount > 0.0
		
		
		

		SELECT   cc_exp_id INTO #exp_ids
		FROM #Transactions
		UNION 
		SELECT  @cc_exp_id + ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY amount) cc_exp_id FROM #Amounts

		 

		SELECT 0 ERROR_CODE,'Successfully saved the CC Expense Transaction(s)' ERROR_DESCRIPTION
		,[timestamp], [company_code], [cc_exp_id], [resource_id], [comments], [applied_date],   
		 [amount], [ext_reference_no], [create_id], [create_date], [modify_id], [modify_date],  
		 [split_flag], [company_or_personal_flag], [cc_num], cc_type_id, [payment_code],        
		 [payment_name], vendor_name
		  FROM pld_cc_exp WHERE cc_exp_id IN (SELECT cc_exp_id FROM #exp_ids)
		RETURN
END





GO


