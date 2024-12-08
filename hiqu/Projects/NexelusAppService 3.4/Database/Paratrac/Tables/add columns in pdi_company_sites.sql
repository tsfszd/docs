
IF NOT EXISTS (select * from sys.columns where name ='source_field' and OBJECT_NAME(object_id)='pdi_company_sites')
BEGIN
alter table pdi_company_sites add source_field varchar(64)
END
GO


IF NOT EXISTS (select * from sys.columns where name ='mapped_field' and OBJECT_NAME(object_id)='pdi_company_sites')
BEGIN
alter table pdi_company_sites add mapped_field varchar(64)
END
GO

