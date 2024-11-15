use nex_pdm;
select 
concat(pdd_resources.name_first,' ',pdd_resources.name_last) employee,
level2_key,
level3_key,
(select top 1 level3_description 
from pdd_level3 
   where pdd_level3.level2_key = pld_transactions.level2_key and 
   PATINDEX (concat(rtrim(pld_transactions.level3_key),'%'),pdd_level3.level3_key)>0 ) Level3_description,
task_code,
sum(units)
 from pld_transactions
 inner join pdd_resources on pdd_resources.resource_id=pld_transactions.resource_id


      where applied_date >= '10/01/2024' 
  and applied_date < '11/01/2024'

group by pdd_resources.name_first,pdd_resources.name_last,level2_key,level3_key,task_code

