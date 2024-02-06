
	SELECT DISTINCT TOP 100 PERCENT
	A.FXMC AS 父项名称,
	A.FXBM AS 父项编码,
	A.FPERUNITSTANDHOUR AS 标准工时,
	A.BBH AS 版本号,
	A.ZXMC AS 子项名称,
	A.ZXBM AS 子项编码,
	A.FMATERIALTYPE AS 材料类型,
	A.ZXGG AS 子项规格,
	A.用量,
	A.备料比例,
	A.单价,
	A.材料总价,
	A.币别,
	A.销售单价,
--计算成本材料
	SUM(CASE WHEN A.FMATERIALTYPE = 1 THEN A.材料总价 ELSE 0 END) OVER (PARTITION BY A.FXBM) AS 材料成本 	
FROM
	(
	SELECT DISTINCT
		A.BBH,
		A.FXMC,
		A.FXBM,
		A.FPERUNITSTANDHOUR,
		A.ZXMC,
		A.ZXBM,
		A.ZXGG,
		A.FNUMERATOR/ A.FDENOMINATOR AS 用量,
		1+A.FSCRAPRATE/100 AS 备料比例,
		D.单价,
		D.单价 * ( A.FNUMERATOR/ A.FDENOMINATOR ) * ( 1+A.FSCRAPRATE/100 ) AS 材料总价,
		C.销售单价,
		c.币别,
		A.FMATERIALTYPE,
		A.ZZ
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
		TEMP.FDENOMINATOR
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
			A.FDENOMINATOR
		FROM
			T_ENG_BOMCHILD A
			LEFT JOIN T_BD_MATERIAL B ON B.FMATERIALID= A.FMATERIALID
			LEFT JOIN T_BD_MATERIAL_L C ON B.FMATERIALID= C.FMATERIALID
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
		D.FUSEORGID,
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
		TEMP.F_BWBPRICE AS 单价,
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
	WHERE
		a.ZXBM IS NOT NULL
		and a.fxbm='01.05.0001.00203'
		--AND A.FPERUNITSTANDHOUR<>'0'
		--根据组织筛选数据
		--AND A.ZZ=_CurrentOrgUnitId_
		--添加父项多选功能，不选择时返回全部数据
		--AND (A.FXBM IN (#FXBM#) OR (SELECT #FXBM# FOR XML path(''))='' )
	ORDER BY A.FXBM
