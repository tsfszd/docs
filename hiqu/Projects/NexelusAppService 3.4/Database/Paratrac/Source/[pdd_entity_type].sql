insert into pdd_entity_type( entity_type_id, entity_type_desc) values ('1','TransactionHeader')
insert into pdd_entity_type( entity_type_id, entity_type_desc) values ('2','ExpenseTransaction')

go
begin transaction

alter table pdd_entity_type add [priority] int
go
delete pdd_entity_type
;with cte as (
select 'Level2' d union 
select 'Level2Customer' union 
select 'Level3' union 
select 'TransactionHeader' union 
select 'ExpenseTransaction' union 
select 'TransactionExpense' union 
select 'Transaction'  )

 insert into pdd_entity_type
select  row_number() over (partition by 1 order by (select 1) ), d, row_number() over (partition by 1 order by (select 1) ) r from cte
 
commit
go
