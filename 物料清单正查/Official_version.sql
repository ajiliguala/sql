with cte as
(
select 0 as BOM层次,t1.fid as 最顶级BOM内码,t1.FNUMBER as BOM版本,fxwl.FNUMBER as 父项物料代码,fxwl_L.FNAME as 父项物料名称,t3.FSEQ as 分录行号
	,t3.FREPLACEGROUP as 项次,CAST(10000+t3.FREPLACEGROUP AS nvarchar) as 项次组合,cast(CAST(t1.fid AS nvarchar)+'-'+CAST(1000000+t3.FREPLACEGROUP AS nvarchar) as nvarchar(max)) as BOM内码和项次组合
	,t3.FMATERIALID as 子项物料内码,zxwl.FNUMBER as 子项物料代码,zxwl_L.FNAME as 子项物料名称,case when FMATERIALTYPE = 1 then '标准件' when FMATERIALTYPE = 2 then '返还件' when FMATERIALTYPE = 3 then '替代件'  else '未知类型' end as 子项类型
	,t3.FNUMERATOR as 分子,t3.FDENOMINATOR as 分母,t3.FFIXSCRAPQTY as 固定损耗,t3.FSCRAPRATE as 变动损耗,t3.FBOMID,t1.FUSEORGID,CAST((t3.FNUMERATOR/t3.FDENOMINATOR) AS decimal(20,10)) 标准用量
	,CAST(((t3.FNUMERATOR/t3.FDENOMINATOR)+((t3.FNUMERATOR/t3.FDENOMINATOR)*CASE WHEN t3.FSCRAPRATE>0 THEN t3.FSCRAPRATE/100 ELSE 0 END)) AS decimal(20,10)) 实际用量,fxwl.FMATERIALID
	,CAST(t3.FNUMERATOR/t3.FDENOMINATOR AS decimal(20,10)) 用量,G.FPERUNITSTANDHOUR AS 标准工时,zxwl_L.FSPECIFICATION,t3.FMATERIALTYPE,t1.FCREATEDATE
from T_ENG_BOM t1
	join T_BD_MATERIAL fxwl	on fxwl.FMATERIALID = t1.FMATERIALID and t1.FFORBIDSTATUS = 'A'	--只取未禁用状态的BOM
	join T_BD_MATERIAL_L fxwl_L	on fxwl.FMATERIALID = fxwl_l.FMATERIALID and fxwl_L.FLOCALEID =2052
	join T_BD_MATERIALPRODUCE fxwl_P on fxwl_P.FMATERIALID = fxwl.FMATERIALID
	join T_ENG_BOMCHILD t3 on t1.fid = t3.FID		
	join T_BD_MATERIAL zxwl	on zxwl.FMATERIALID = t3.FMATERIALID
	join T_BD_MATERIAL_L zxwl_L	on zxwl.FMATERIALID = zxwl_L.FMATERIALID and zxwl_L.FLOCALEID =2052
	JOIN t_BD_MaterialProduce G on G.FMATERIALID = fxwl.FMATERIALID
where 1=1 and fxwl_P.FISMAINPRD = 1	and fxwl.FNUMBER='01.05.0001.01901'
union all
select p.BOM层次+1 as BOM层次,P.最顶级BOM内码 as 最顶级BOM内码,t1.FNUMBER as BOM版本,fxwl.FNUMBER as 父项物料代码,fxwl_L.FNAME as 父项物料名称,t3.FSEQ as 分录行号,
t3.FREPLACEGROUP as 项次,cast(p.项次组合+'.'+CAST(10000+t3.FREPLACEGROUP AS nvarchar) as nvarchar) as 项次组合,cast(p.BOM内码和项次组合 +'.'+ ( CAST(t1.FID AS nvarchar) + '-' +CAST(10000+t3.FREPLACEGROUP AS nvarchar) ) as nvarchar(max))  as BOM内码组合
,t3.FMATERIALID as 子项物料内码,zxwl.FNUMBER as 子项物料代码,zxwl_L.FNAME as 子项物料名称,case when T3.FMATERIALTYPE = 1 then '标准件' when T3.FMATERIALTYPE = 2 then '返还件' when T3.FMATERIALTYPE = 3 then '替代件' else '未知类型' end as 子项类型
,t3.FNUMERATOR as 分子,t3.FDENOMINATOR as 分母,t3.FFIXSCRAPQTY as 固定损耗,t3.FSCRAPRATE as 变动损耗,t3.FBOMID,t1.FUSEORGID,CAST((t3.FNUMERATOR/t3.FDENOMINATOR)*p.标准用量 AS decimal(20,10)) 标准用量,
CAST(((t3.FNUMERATOR/t3.FDENOMINATOR)+((t3.FNUMERATOR/t3.FDENOMINATOR)*CASE WHEN t3.FSCRAPRATE>0 THEN t3.FSCRAPRATE/100 ELSE 0 END))*p.实际用量 AS decimal(20,10)) 实际用量,fxwl.FMATERIALID,
CAST(t3.FNUMERATOR/t3.FDENOMINATOR AS decimal(20,10)) 用量,G.FPERUNITSTANDHOUR AS 标准工时,zxwl_L.FSPECIFICATION,t3.FMATERIALTYPE,t1.FCREATEDATE
from cte P		--调用递归CTE本身
join T_ENG_BOM t1 on t1.FMATERIALID = p.子项物料内码
join T_BD_MATERIAL fxwl	on fxwl.FMATERIALID = t1.FMATERIALID and t1.FFORBIDSTATUS = 'A'
join T_BD_MATERIAL_L fxwl_L	on fxwl.FMATERIALID = fxwl_l.FMATERIALID and fxwl_L.FLOCALEID =2052
join T_ENG_BOMCHILD t3 on t1.fid = t3.FID		
join T_BD_MATERIAL zxwl	on zxwl.FMATERIALID = t3.FMATERIALID
join T_BD_MATERIAL_L zxwl_L	on zxwl.FMATERIALID = zxwl_L.FMATERIALID and zxwl_L.FLOCALEID =2052
 JOIN t_BD_MaterialProduce G on G.FMATERIALID = fxwl.FMATERIALID
WHERE T1.FDocumentStatus='C'
),
cte2_ZuiXinZiXiangBom as
(
select t1.BOM层次 as BOM层级,t1.标准工时,t1.最顶级BOM内码,t1.BOM版本,t1.父项物料代码 as 父项物料代码,t1.父项物料名称 as 物料名称,0 as 分录行号,0 as 项次,t1.项次组合 as 项次组合,BOM内码和项次组合,
0 as 子项物料内码,'' as 子项物料代码,'' as 子项物料名称,'最顶层父项' as 子项类型,0 as 分子,0 as 分母,0 as 固定损耗,0 as 变动损耗,0 as BOM内码,t1.FUSEORGID,'1' as 标准用量,'1' as 实际用量
,t1.用量,dense_rank() over(partition by t1.最顶级BOM内码,t1.父项物料代码 order by t1.BOM版本 desc) as BOM版本号分区,t1.FSPECIFICATION,t1.FMATERIALID,t1.FMATERIALTYPE,t1.FCREATEDATE
from cte t1 where 1=1 and t1.BOM层次 = 0 and t1.项次组合 = '10001'
union 
select t1.BOM层次+1 as BOM层级,t1.标准工时,t1.最顶级BOM内码,t1.BOM版本,t1.子项物料代码 as 物料代码,t1.子项物料名称 as 物料名称,t1.分录行号 as 分录行号,t1.项次 as 项次,t1.项次组合 as 项次组合,BOM内码和项次组合,
0 as 子项物料内码,t1.子项物料代码 as 子项物料代码,'' as 子项物料名称,t1.子项类型 as 子项类型,t1.分子 as 分子,t1.分母 as 分母,t1.固定损耗 as 固定损耗,t1.变动损耗 as 变动损耗,t1.FBOMID as BOM内码,t1.FUSEORGID,t1.标准用量,t1.实际用量
,t1.用量,dense_rank() over(partition by t1.最顶级BOM内码,t1.父项物料代码 order by t1.BOM层次+1,t1.BOM版本 desc) as BOM版本号分区,t1.FSPECIFICATION,t1.FMATERIALID,t1.FMATERIALTYPE,t1.FCREATEDATE
from cte t1 
),

cte3_unit_cost as 
(
SELECT TEMP.FNUMBER,TEMP.F_BWBPRICE AS 单价,TEMP.FDATE,TEMP.XUHAO,TEMP.FMATERIALID
	FROM(
SELECT A.FNUMBER,C.F_BWBPRICE,C.XUHAO,C.FDATE,A.FMATERIALID
	FROM(
		SELECT ROW_NUMBER ( ) OVER ( PARTITION BY D.FNUMBER ORDER BY A.FDATE DESC ) AS XUHAO,A.FDATE,B.F_BWBPRICE,B.FMATERIALID FROM t_STK_InStock A
		INNER JOIN T_STK_INSTOCKENTRY B ON A.FID= B.FID
		LEFT JOIN T_BD_MATERIAL D ON D.FMATERIALID= B.FMATERIALID 
		LEFT JOIN T_ORG_ORGANIZATIONS_L E ON D.FUSEORGID=E.FORGID
			) C 
			LEFT JOIN T_BD_MATERIAL A ON A.FMATERIALID=C.FMATERIALID
		) TEMP 
	WHERE
		TEMP.XUHAO= 1 
),

cte4_order_number as 
(
	--选最新销售订单单价
	SELECT TEMP.FNUMBER,TEMP.FDATE,TEMP.FPRICE AS 销售单价,TEMP.币别,temp.FEXCHANGERATE as 汇率,temp.FMATERIALID
FROM
	(
--销售订单单价排序
	SELECT D.FNUMBER,A.FDATE,C.FPRICE,D.FUSEORGID,G.FNAME AS 币别,ROW_NUMBER ( ) OVER ( PARTITION BY B.FMATERIALID ORDER BY A.FDATE DESC ) AS rnk ,f.FEXCHANGERATE,d.FMATERIALID
	FROM
		T_SAL_ORDER A
		LEFT JOIN T_SAL_ORDERENTRY B ON B.FID=A.FID
		LEFT JOIN T_SAL_ORDERENTRY_F C ON C.FENTRYID=B.FENTRYID
		LEFT JOIN T_BD_MATERIAL D ON D.FMATERIALID=B.FMATERIALID
		LEFT JOIN T_ORG_ORGANIZATIONS_L E ON D.FUSEORGID=E.FORGID
		LEFT JOIN T_SAL_ORDERFIN F ON F.FID=A.FID
		LEFT JOIN T_BD_CURRENCY_l G ON F.FSETTLECURRID=G.FPKID
	)TEMP
	WHERE TEMP.RNK=1
),

cte4_time AS
(
SELECT
	temp3.FMATERIALID,temp3.rnk 
FROM
	(
	SELECT
		temp2.FMATERIALID,temp2.rnk 
	FROM
		(
		SELECT
			ROW_NUMBER ( ) OVER ( partition BY temp.FMATERIALID ORDER BY temp.日期 DESC ) AS rnk,TEMP.FMATERIALID 
		FROM
			( SELECT CONVERT ( CHAR ( 10 ), T1.FCREATEDATE, 120 ) AS 日期, t1.FMATERIALID FROM T_ENG_BOM T1 ) TEMP 
		) temp2 
	) temp3 
WHERE
	temp3.rnk=1

)


select DISTINCT t2.BOM层级 as BOM层级,t2.子项类型 as 子项类型,t2.标准工时
,t2.父项物料代码 as 子项物料代码,t2.物料名称 as 物料名称,t2.FSPECIFICATION as 子项规格,t2.分录行号 as 分录行号,t2.项次 as 项次,t2.分子 as 分子,t2.分母 as 分母
,t2.固定损耗 as 固定损耗,t2.变动损耗 as 变动损耗,1+t2.变动损耗/100 as 备料比例
,t2.项次组合 as 项次组合,t2.BOM内码和项次组合,t2.BOM内码 as 子项BOM版本内码,t2.BOM版本 as 所属BOM,t2.最顶级BOM内码,t2.标准用量,t2.实际用量,t2.用量,
LEFT(t2.BOM版本, CASE WHEN CHARINDEX('_', t2.BOM版本) > 0 THEN CHARINDEX('_', t2.BOM版本) - 1 ELSE LEN(t2.BOM版本) END) 父物料,T3.单价,t3.单价*t2.用量*t2.变动损耗 as 材料总价,
t4.销售单价,t4.币别,t4.汇率,t4.销售单价*t4.汇率 as '单价(本位币)',
SUM(CASE WHEN T2.FMATERIALTYPE = 1 THEN t3.单价*t2.用量*t2.变动损耗 ELSE 0 END) OVER (PARTITION BY t2.FMATERIALID) AS 材料成本

from cte2_ZuiXinZiXiangBom t2
LEFT JOIN cte3_unit_cost t3 on t2.子项物料代码 = t3.FNUMBER
LEFT JOIN cte4_order_number t4 on t2.FMATERIALID=t4.FMATERIALID
left join cte4_time t5 on t2.FMATERIALID=t5.FMATERIALID

where 1=1
and t2.BOM版本号分区 = 1 --通过“BOM版本号分区”标识最新版本的BOM，按照父项物料分区之后，把BOM版本降序排列，BOM版本高的值就是1
and ( (t2.BOM层级 = 0 and t2.项次组合 = '10001' ) or (t2.BOM层级 > 0) ) --这个是为了查询出最终的结果.
and t2.FUSEORGID in (1915285)-- 使用组织内码
--and t2.BOM层级=2
--and t2.BOM层级=t2.项次
order by t2.BOM内码和项次组合