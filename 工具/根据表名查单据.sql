select

FID

,(select FNAME from T_META_OBJECTTYPE_L where FID = T_META_OBJECTTYPE_Temp.FID and FLOCALEID = 2052) FNAME

,FKERNELXML

,Item

from

(select FKERNELXML.query('//TableName') 'Item', * from T_META_OBJECTTYPE) T_META_OBJECTTYPE_Temp

where convert(varchar(max),Item) like '%ora_t_Cust100040%' --数据库表名(依情况替换此处't_ER_ExpenseReimb')