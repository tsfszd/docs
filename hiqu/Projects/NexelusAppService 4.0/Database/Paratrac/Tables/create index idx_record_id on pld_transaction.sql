if not exists(select * from sys.indexes where name='idx_record_id') 
begin
CREATE NONCLUSTERED INDEX idx_record_id
ON [dbo].[pld_transactions] ([record_id])
INCLUDE ([company_code],[level2_key],[level3_key],[transaction_id],[trx_type],[resource_id],[submitted_flag],[upload_flag],[payment_code],[amount_home],[reimbursment_flag],[approval_flag],[approved_by],[finalise_flag],[finalised_by])
END
GO
 