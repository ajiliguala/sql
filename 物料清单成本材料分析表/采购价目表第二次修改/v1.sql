WITH WLSX AS
         (
select FVALUE,
(select FNAME from T_META_FORMENUM_L where FID = T_META_FORMENUMITEM.FID and FLOCALEID =  2052) as MJLXMC
,(select FCAPTION from T_META_FORMENUMITEM_L where FENUMID = T_META_FORMENUMITEM.FENUMID  and FLOCALEID = 2052) as MC
from T_META_FORMENUMITEM
WHERE (select FNAME from T_META_FORMENUM_L where FID = T_META_FORMENUMITEM.FID and FLOCALEID =  2052)='BD_物料属性'
         )
	SELECT DISTINCT TOP 100 PERCENT
	A.FXMC AS 父项名称,
	A.FXBM AS 父项编码,
	A.FPERUNITSTANDHOUR AS 标准工时,
	A.BBH AS 版本号,
	A.ZXMC AS 子项名称,
	A.ZXBM AS 子项编码,
	A.mc AS 物料属性,
	A.ZXGG AS 子项规格,
	A.用量,
	A.备料比例,
	A.未税单价本位币 AS 入库未税单价本位币,
	A.材料总价,
	A.币别 AS 销售币别,
	A.销售单价,
	SUM(CASE WHEN A.FMATERIALTYPE = 1 THEN A.材料总价 ELSE 0 END) OVER (PARTITION BY A.FXBM) AS 材料成本,
	CCC.供应商,
	CCC.FDATAVALUE AS 采购价格类型,
	CCC.FPRICE AS 采购未税单价,
    CCC.币别 AS 采购币别,
	CCC."替代前未税(本位币)单价",
    CCC.替代前物料代码,
    CCC.替代前物料名称,
    CCC.替代前规格型号,
	CCC.替代前供应商,
    CCC.使用组织

FROM
	(
	SELECT DISTINCT
		A.BBH,
		A.FXMC,
		A.ZXBMID,
		A.FXBM,
		A.FPERUNITSTANDHOUR,
		A.ZXMC,
		A.ZXBM,
		A.ZXGG,
		A.FNUMERATOR/ A.FDENOMINATOR AS 用量,
		1+A.FSCRAPRATE/100 AS 备料比例,
		D.未税单价本位币,
		D.未税单价本位币 * ( A.FNUMERATOR/ A.FDENOMINATOR ) * ( 1+A.FSCRAPRATE/100 ) AS 材料总价,
		C.销售单价,
		c.币别,
		A.FMATERIALTYPE,
		A.ZZ,
		A.MC
	FROM
		(
--抓取父项子项信息
		SELECT DISTINCT
		AAA.FMATERIALID,
		AAA.FNAME AS FXMC,
		A.FNUMBER AS BBH,
		AAA.FXBM AS FXBM,
		AAA.FORGID AS ZZ,
		AAA.FPERUNITSTANDHOUR,
		TEMP.FNAME AS ZXMC,
		TEMP.FNUMBER AS ZXBM,
		TEMP.FSPECIFICATION AS ZXGG,
		TEMP.FENTRYID,
		TEMP.FMATERIALTYPE,
		TEMP.FSCRAPRATE,
		TEMP.FNUMERATOR,
		TEMP.FDENOMINATOR,
		TEMP.FMATERIALID AS ZXBMID,
		TEMP.MC
	FROM
		T_ENG_BOM A
		LEFT JOIN(
			SELECT DISTINCT
				AA.FNUMBER,
				AA.FMATERIALID,
				AA.FMODIFYDATE,
				AA.rnk,
				AA.FXBM,
				AA.FNAME,
				AA.FMASTERID,
				AA.FORGID,
				AA.FID,
				AA.FPERUNITSTANDHOUR
				FROM
				(SELECT
				A.FMASTERID,
				B.FMATERIALID,
				A.FNUMBER,
				C.FNAME,
				B.FNUMBER AS FXBM,
				A.FMODIFYDATE,
				D.FORGID,
				A.FID,
				E.FPERUNITSTANDHOUR,
				ROW_NUMBER ( ) OVER (PARTITION BY B.FNUMBER ORDER BY A.FMODIFYDATE DESC ) AS rnk
				FROM T_ENG_BOM A
				LEFT JOIN T_BD_MATERIAL B ON A.FMATERIALID= B.FMATERIALID
				LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FUSEORGID= D.FORGID
				LEFT JOIN T_BD_MATERIAL_L C ON A.FMATERIALID= C.FMATERIALID
				LEFT JOIN t_BD_MaterialProduce E ON E.FMATERIALID=B.FMATERIALID
				WHERE A.FUSEORGID='1915285'
				--AND B.FMATERIALID='3669015'
				)AA
				WHERE
				AA.rnk=1
		)AAA ON AAA.FMASTERID=A.FMASTERID
		LEFT JOIN (
		SELECT DISTINCT
			B.FNUMBER,
			A.FENTRYID,
			A.FID,
			C.FNAME,
			C.FSPECIFICATION,
			A.FMATERIALTYPE,
			A.FSCRAPRATE,
			A.FNUMERATOR,
			A.FDENOMINATOR,
			A.FMATERIALID,
			E.MC
		FROM
			T_ENG_BOMCHILD A
			LEFT JOIN T_BD_MATERIAL B ON B.FMATERIALID= A.FMATERIALID
			LEFT JOIN T_BD_MATERIAL_L C ON B.FMATERIALID= C.FMATERIALID
		    LEFT JOIN t_BD_MaterialBase D ON C.FMATERIALID=D.FMATERIALID
		    full JOIN WLSX E ON E.FVALUE=D.FERPCLSID
			--WHERE A.FID='4322717'
		) TEMP ON TEMP.FID= AAA.FID
	WHERE
		 A.FFORBIDSTATUS= 'A'
		 AND A.FUSEORGID= '1915285'
		--AND AAA.FXBM='03.02.2001.00288'

	) A
		LEFT JOIN (
--选最新销售订单单价
	SELECT
		TEMP.FNUMBER,
		TEMP.FDATE,
		TEMP.FPRICE AS 销售单价,
		TEMP.币别
FROM
	(
--销售订单单价排序
	SELECT
		D.FNUMBER,
		A.FDATE,
		C.FPRICE,
		G.FNAME AS 币别,
		ROW_NUMBER ( ) OVER ( PARTITION BY B.FMATERIALID ORDER BY A.FDATE DESC ) AS rnk
	FROM
		T_SAL_ORDER A
		LEFT JOIN T_SAL_ORDERENTRY B ON B.FID=A.FID
		LEFT JOIN T_SAL_ORDERENTRY_F C ON C.FENTRYID=B.FENTRYID
		LEFT JOIN T_BD_MATERIAL D ON D.FMATERIALID=B.FMATERIALID
		LEFT JOIN T_ORG_ORGANIZATIONS_L E ON D.FUSEORGID=E.FORGID
		LEFT JOIN T_SAL_ORDERFIN F ON F.FID=A.FID
		LEFT JOIN T_BD_CURRENCY_l G ON F.FSETTLECURRID=G.FPKID
 	WHERE
	 E.FORGID='1915285'
	)TEMP
	WHERE TEMP.RNK=1
	) C ON A.FXBM= C.FNUMBER
		LEFT JOIN (
--抓取最新入库单单价
SELECT
		TEMP.FNUMBER,
		TEMP.F_BWBPRICE AS 未税单价本位币,
		TEMP.FDATE,
		TEMP.XUHAO
	FROM
		(
--单价排序
		SELECT
			A.FNUMBER,
			C.F_BWBPRICE,
			C.XUHAO,
			C.FDATE
		FROM
			(
			SELECT
				ROW_NUMBER ( ) OVER ( PARTITION BY D.FNUMBER ORDER BY A.FDATE DESC ) AS XUHAO,
				A.FDATE,
				B.F_BWBPRICE,
				B.FMATERIALID
			FROM
				t_STK_InStock A
				INNER JOIN T_STK_INSTOCKENTRY B ON A.FID= B.FID
				LEFT JOIN T_BD_MATERIAL D ON D.FMATERIALID= B.FMATERIALID
				LEFT JOIN T_ORG_ORGANIZATIONS_L E ON D.FUSEORGID=E.FORGID
	WHERE
	E.FORGID='1915285'
			) C
			LEFT JOIN T_BD_MATERIAL A ON A.FMATERIALID=C.FMATERIALID
		) TEMP
	WHERE
		TEMP.XUHAO= 1
	) D ON A.ZXBM= D.FNUMBER
	)A
    left JOIN (SELECT
    BBB.使用组织,
    BBB.币别,
    BBB.FDATAVALUE,
    BBB.供应商,
    BBB.FAPPROVEDATE,
    BBB.XUHAO,
    BBB.F_KING_TDQWSDJ AS '替代前未税(本位币)单价',
    BBB.F_KING_TDQWLDM AS '替代前物料代码',
    BBB.F_KING_TDQWLMC AS '替代前物料名称',
    BBB.F_KING_TDQGZXH AS '替代前规格型号',
	BBB.F_KING_TDQGYS AS '替代前供应商',
	BBB.FNUMBER,
	BBB.FPRICE
FROM
(
	SELECT
	    G.FNUMBER,
	    B.FNAME as 使用组织,
	    C.FNAME as 币别,
	    E.FDATAVALUE,
	    F.FNAME AS 供应商,
	    A.FAPPROVEDATE ,
	    D.F_KING_TDQWSDJ,
	    D.F_KING_TDQWLDM,
	    D.F_KING_TDQWLMC,
	    D.F_KING_TDQGZXH,
	    D.F_KING_TDQGYS,
	    d.FPRICE,
	    ROW_NUMBER ( ) OVER ( PARTITION BY D.FMATERIALID ORDER BY A.FAPPROVEDATE DESC ) AS XUHAO
	FROM t_PUR_PriceList A
	LEFT JOIN T_ORG_ORGANIZATIONS_L B ON A.FUSEORGID=B.FORGID
    LEFT JOIN T_BD_CURRENCY_l C ON A.FCURRENCYID=C.FPKID
	LEFT JOIN T_PUR_PRICELISTENTRY D ON D.FID=A.FID
	LEFT JOIN (
select a.FNUMBER, a.FID,b.FMASTERID,b.FENTRYID,c.FDATAVALUE from T_BAS_ASSISTANTDATA a
inner join T_BAS_ASSISTANTDATAENTRY b on a.FID=b.FID
inner join T_BAS_ASSISTANTDATAENTRY_L c on (b.FENTRYID = c.FENTRYID and c.FLocaleId = 2052)
where b.FDOCUMENTSTATUS ='C'
and a.FNUMBER like '%CGJGLX%'
) E ON E.FMASTERID=D.FDEFASSISTANTO
	LEFT JOIN t_BD_Supplier_l F ON F.FSUPPLIERID=A.FSUPPLIERID
	LEFT JOIN T_BD_MATERIAL G ON G.FMATERIALID=D.FMATERIALID
	WHERE B.FNAME='芜湖长信新型显示器件有限公司')BBB
	WHERE BBB.XUHAO=1) CCC ON CCC.FNUMBER=A.ZXBM
	WHERE
		a.ZXBM IS NOT NULL
-- 		--根据组织筛选数据
		AND A.ZZ=_CurrentOrgUnitId_
-- 		--添加父项多选功能，不选择时返回全部数据
 		AND (A.FXBM IN (#FXBM#) OR (SELECT #FXBM# FOR XML path(''))='' )
	ORDER BY A.FXBM




