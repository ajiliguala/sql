-- 采购类别 -- 使用组织
WITH MATERIAL AS (
	SELECT DISTINCT
		a.FMATERIALID,
		a.FNUMBER AS FNUMBER1,
		a.FUSEORGID,
		c.FNAME,
		b.FNAME AS 'MATERIALNAME',
		c.FNAME AS 'ORGNAME',
		d.FDATAVALUE AS 'F_CPLB'
	FROM
		T_BD_MATERIAL a
		LEFT JOIN T_BD_MATERIAL_L b ON a.FMATERIALID= b.FMATERIALID
		LEFT JOIN T_ORG_ORGANIZATIONS_L c ON a.FUSEORGID = c.FORGID
		LEFT JOIN T_BAS_ASSISTANTDATAENTRY_L d ON a.F_CPLB = d.FENTRYID
	where c.FNAME IN ( '车载事业部', '(原)第五事业部' )
	--WHERE FNUMBER='01.05.0099.02363'
	),
	SAL AS (
	SELECT
		c.FNUMBER1 AS 'FNUMBER1',
		c.F_CPLB,
		c.MATERIALNAME,
		c.FNAME as 部门,
		I.FNUMBER,
		e.FNAME AS 'SALEORGNAME',
		f.FNAME AS 'CUSTOMER',
		a.FMATERIALID,
		c.FMATERIALID as abc,
		G.F_STYZ_QTY,
		g.F_STYZ_Qty1,
		g.F_STYZ_Qty2,
		g.F_STYZ_Qty3,
		g.F_STYZ_Qty4,
		g.F_STYZ_Qty5,
		g.F_STYZ_Qty6,
		g.F_STYZ_Qty7,
		g.F_STYZ_Qty8,
		g.F_STYZ_Qty9,
		g.F_STYZ_Qty10,
		g.F_STYZ_Qty11,
		c.FNAME,
		g.F_STYZ_Qty12,
		g.F_STYZ_Qty13,
		g.F_STYZ_Qty14,
		g.F_STYZ_Qty15,
		g.F_STYZ_Qty16,
		g.F_STYZ_Qty17,
		g.F_STYZ_Qty18,
		g.F_STYZ_Qty19,
		g.F_STYZ_Qty20,
		g.F_STYZ_Qty21,
		g.F_STYZ_Qty22,
		g.F_STYZ_Qty23,
		g.F_STYZ_Qty24,
		g.F_STYZ_Qty25,
		g.F_STYZ_Qty26,
		g.F_STYZ_Qty27,
		g.F_STYZ_Qty28,
		g.F_STYZ_Qty29,
		g.F_STYZ_Qty30,
		G.F_STYZ_YUE
	FROM
	STYZ_t_Cust_Entry100125 G
	    left join T_bd_MATERIAL a on a.FMATERIALID=g.FMATERIALID
		left JOIN MATERIAL c ON c.FNUMBER1= a.FNUMBER
		LEFT JOIN T_BD_CUSTOMER_L f ON g.F_STYZ_KH = f.FCUSTID
	    left JOIN STYZ_t_Cust100104 I ON I.FID=G.FID
		LEFT JOIN T_ORG_ORGANIZATIONS_L e ON i.FUSEORGID = e.FORGID and e.FNAME=c.FNAME
	GROUP BY
		c.FNUMBER1,
		c.F_CPLB,
		c.MATERIALNAME,
		e.FNAME,f.FNAME,
		a.FMATERIALID,
		I.FNUMBER,
		c.FNAME,
		G.F_STYZ_QTY,
		g.F_STYZ_Qty1,
		g.F_STYZ_Qty2,
		g.F_STYZ_Qty3,
		g.F_STYZ_Qty4,
		c.FMATERIALID ,
		g.F_STYZ_Qty5,
		g.F_STYZ_Qty6,
		g.F_STYZ_Qty7,
		g.F_STYZ_Qty8,
		g.F_STYZ_Qty9,
		g.F_STYZ_Qty10,
		g.F_STYZ_Qty11,
		g.F_STYZ_Qty12,
		g.F_STYZ_Qty13,
		g.F_STYZ_Qty14,
		g.F_STYZ_Qty15,
		g.F_STYZ_Qty16,
		g.F_STYZ_Qty17,
		g.F_STYZ_Qty18,
		g.F_STYZ_Qty19,
		g.F_STYZ_Qty20,
		g.F_STYZ_Qty21,
		g.F_STYZ_Qty22,
		g.F_STYZ_Qty23,
		g.F_STYZ_Qty24,
		g.F_STYZ_Qty25,
		g.F_STYZ_Qty26,
		g.F_STYZ_Qty27,
		g.F_STYZ_Qty28,
		g.F_STYZ_Qty29,
		g.F_STYZ_Qty30,
		G.F_STYZ_YUE,
		g.F_STYZ_KH
	)

SELECT
	CONVERT ( CHAR ( 10 ), GETDATE( ) + 1, 120 )AS '计划交货日期',
	Z.CUSTOMER AS '客户',
	Z.SALEORGNAME AS '销售组织',
	Z.FNUMBER1 AS '物料编码',
	Z.MATERIALNAME AS '物料名称',
	Z.F_CPLB AS '产品类别',
CASE

		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 1 THEN
		F_STYZ_Qty
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 2 THEN
		F_STYZ_Qty1
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 3 THEN
		F_STYZ_Qty2
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 4 THEN
		F_STYZ_Qty3
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 5 THEN
		F_STYZ_Qty4
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 6 THEN
		F_STYZ_Qty5
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 7 THEN
		F_STYZ_Qty6
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 8 THEN
		F_STYZ_Qty7
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 9 THEN
		F_STYZ_Qty8
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 10 THEN
		F_STYZ_Qty9
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 11 THEN
		F_STYZ_Qty10
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 12 THEN
		F_STYZ_Qty11
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 13 THEN
		F_STYZ_Qty12
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 14 THEN
		F_STYZ_Qty13
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 15 THEN
		F_STYZ_Qty14
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 16 THEN
		F_STYZ_Qty15
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 17 THEN
		F_STYZ_Qty16
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 18 THEN
		F_STYZ_Qty17
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 19 THEN
		F_STYZ_Qty18
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 20 THEN
		F_STYZ_Qty19
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 21 THEN
		F_STYZ_Qty20
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 22 THEN
		F_STYZ_Qty21
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 23 THEN
		F_STYZ_Qty22
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 24 THEN
		F_STYZ_Qty23
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 25 THEN
		F_STYZ_Qty24
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 26 THEN
		F_STYZ_Qty25
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 27 THEN
		F_STYZ_Qty26
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 28 THEN
		F_STYZ_Qty27
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 29 THEN
		F_STYZ_Qty28
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 30 THEN
		F_STYZ_Qty29
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 31 THEN
		F_STYZ_Qty30
	END as 数量,
    MONTH(F_STYZ_YUE),
    YEAR(F_STYZ_YUE)

FROM
	SAL Z
WHERE
    MONTH(CONVERT ( CHAR ( 10 ), GETDATE( ) + 1, 120 ))=MONTH(F_STYZ_YUE)
    AND YEAR(CONVERT ( CHAR ( 10 ), GETDATE( ) + 1, 120 ))=YEAR(F_STYZ_YUE)
	AND Z.SALEORGNAME IN ( '车载事业部', '(原)第五事业部' )
and (CASE

		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 1 THEN
		F_STYZ_Qty
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 2 THEN
		F_STYZ_Qty1
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 3 THEN
		F_STYZ_Qty2
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 4 THEN
		F_STYZ_Qty3
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 5 THEN
		F_STYZ_Qty4
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 6 THEN
		F_STYZ_Qty5
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 7 THEN
		F_STYZ_Qty6
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 8 THEN
		F_STYZ_Qty7
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 9 THEN
		F_STYZ_Qty8
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 10 THEN
		F_STYZ_Qty9
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 11 THEN
		F_STYZ_Qty10
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 12 THEN
		F_STYZ_Qty11
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 13 THEN
		F_STYZ_Qty12
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 14 THEN
		F_STYZ_Qty13
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 15 THEN
		F_STYZ_Qty14
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 16 THEN
		F_STYZ_Qty15
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 17 THEN
		F_STYZ_Qty16
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 18 THEN
		F_STYZ_Qty17
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 19 THEN
		F_STYZ_Qty18
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 20 THEN
		F_STYZ_Qty19
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 21 THEN
		F_STYZ_Qty20
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 22 THEN
		F_STYZ_Qty21
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 23 THEN
		F_STYZ_Qty22
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 24 THEN
		F_STYZ_Qty23
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 25 THEN
		F_STYZ_Qty24
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 26 THEN
		F_STYZ_Qty25
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 27 THEN
		F_STYZ_Qty26
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 28 THEN
		F_STYZ_Qty27
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 29 THEN
		F_STYZ_Qty28
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 30 THEN
		F_STYZ_Qty29
		WHEN day(CONVERT(char(10),GETDATE() + 1,120)) = 31 THEN
		F_STYZ_Qty30
	END<>0)
ORDER BY
    z.CUSTOMER
