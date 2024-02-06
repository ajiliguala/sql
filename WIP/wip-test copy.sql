SELECT
AA.生产组织,
AA.生产车间,
AA.生产订单编码,
AA.工单状态,
CASE  
        WHEN AA.生产订单数量 = FLOOR(AA.生产订单数量) THEN CAST(AA.生产订单数量 AS INT)  
        ELSE AA.生产订单数量  -- 在SQL Server中，ROUND的第三个参数是不必要的（也不会被接受），这里只是为了示意  
    END AS 生产订单数量,  
AA.生产订单物料编码,
AA.生产订单物料名称,
AA.生产订单物料规格型号,
AA.生产订单子项物料号,
AA.生产订单子项物料名称,
AA.生产订单子项物料规格型号,
 -- BOM用量格式化  
    CASE  
        WHEN AA.BOM用量 = FLOOR(AA.BOM用量) THEN CAST(AA.BOM用量 AS INT)  
        ELSE AA.BOM用量 
    END AS BOM用量,  
  
    -- 应领数量格式化  
    CASE  
        WHEN AA.应领数量 = FLOOR(AA.应领数量) THEN CAST(AA.应领数量 AS INT)  
        ELSE AA.应领数量 
    END AS 应领数量,  
  
    -- 生产订单领料数量格式化  
    CASE  
        WHEN AA.生产订单领料数量 = FLOOR(AA.生产订单领料数量) THEN CAST(AA.生产订单领料数量 AS INT)  
        ELSE AA.生产订单领料数量  
    END AS 生产订单领料数量,  
  
    -- 生产补料数量格式化  
    CASE  
        WHEN AA.生产补料数量 = FLOOR(AA.生产补料数量) THEN CAST(AA.生产补料数量 AS INT)  
        ELSE AA.生产补料数量  
    END AS 生产补料数量,  
  
    -- 生产退料数量格式化  
    CASE  
        WHEN AA.生产退料数量 = FLOOR(AA.生产退料数量) THEN CAST(AA.生产退料数量 AS INT)  
        ELSE AA.生产退料数量  
    END AS 生产退料数量,  
  
    -- 生产入库数量格式化  
    CASE  
        WHEN AA.生产入库数量 = FLOOR(AA.生产入库数量) THEN CAST(AA.生产入库数量 AS INT)  
        ELSE AA.生产入库数量 
    END AS 生产入库数量,  
  
    -- 生产耗用数量格式化  
    CASE  
        WHEN AA.生产耗用数量 = FLOOR(AA.生产耗用数量) THEN CAST(AA.生产耗用数量 AS INT)  
        ELSE AA.生产耗用数量  
    END AS 生产耗用数量,  
  
    -- 生产退库数量格式化  
    CASE  
        WHEN AA.生产退库数量 = FLOOR(AA.生产退库数量) THEN CAST(AA.生产退库数量 AS INT)  
        ELSE AA.生产退库数量  
    END AS 生产退库数量,  
  
    -- 冲销生产耗用数量格式化  
    CASE  
        WHEN AA.冲销生产耗用数量 = FLOOR(AA.冲销生产耗用数量) THEN CAST(AA.冲销生产耗用数量 AS INT)  
        ELSE AA.冲销生产耗用数量 
    END AS 冲销生产耗用数量,  
  
    -- WIP数量格式化  
    CASE  
        WHEN AA.WIP数量 = FLOOR(AA.WIP数量) THEN CAST(AA.WIP数量 AS INT)  
        ELSE AA.WIP数量  
    END AS WIP数量  
FROM
(SELECT TOP 100 PERCENT
  hL.FNAME AS 生产组织,
	dl.fname AS 生产车间,
	h.FBILLNO AS 生产订单编码,
CASE
		
		WHEN e.FSTATUS= '1' THEN
		'计划' 
		WHEN e.FSTATUS= '2' THEN
		'计划确认' 
		WHEN e.FSTATUS= '3' THEN
		'下达' 
		WHEN e.FSTATUS= '4' THEN
		'开工' 
		WHEN e.FSTATUS= '5' THEN
		'完工' 
		ELSE e.FSTATUS 
	END AS 工单状态,
	f.FQTY AS 生产订单数量,
	m1.Fnumber AS 生产订单物料编码,
	m1l.FNAME AS 生产订单物料名称,
	m1l.FSPECIFICATION AS 生产订单物料规格型号,
	m2.Fnumber AS 生产订单子项物料号,
	m2l.FNAME AS 生产订单子项物料名称,
	m2l.FSPECIFICATION AS 生产订单子项物料规格型号,
	a.FMUSTQTY/ ( 1+FSCRAPRATE / 100 ) / f.FQTY AS BOM用量,
	a.FMUSTQTY AS 应领数量,
	b.FPICKEDQTY AS 生产订单领料数量,
	temp.FSCBLQTY AS 生产补料数量,
	TEMP2.fqty AS 生产退料数量,
	temp3.FREALQTY AS 生产入库数量,
	( a.FMUSTQTY/ ( 1+FSCRAPRATE / 100 ) / f.FQTY ) * temp3.FREALQTY AS 生产耗用数量,
	temp4.FREALQTY AS 生产退库数量,
	temp4.FREALQTY* ( a.FMUSTQTY/ ( 1+FSCRAPRATE / 100 ) / f.FQTY ) AS 冲销生产耗用数量,
	(  
    ISNULL(b.FPICKEDQTY, 0) + -- 生产订单领料数量  
    ISNULL(temp.FSCBLQTY, 0) - -- 生产补料数量  
    ISNULL(TEMP2.fqty, 0) - -- 生产退料数量  
    (a.FMUSTQTY / (1 + ISNULL(FSCRAPRATE, 0) / 100) / ISNULL(f.FQTY, 1)) * ISNULL(temp3.FREALQTY, 0) + -- 生产耗用数量  
    ISNULL(temp4.FREALQTY, 0) * (a.FMUSTQTY / (1 + ISNULL(FSCRAPRATE, 0) / 100) / ISNULL(f.FQTY, 1)) -- 冲销生产耗用数量  
  ) AS WIP数量
FROM
	T_PRD_PPBOMENTRY a
	INNER JOIN T_PRD_PPBOMENTRY_Q b ON a.FENTRYID= b.FENTRYID
	INNER JOIN T_PRD_PPBOMENTRY_C c ON a.FENTRYID= c.FENTRYID
	INNER JOIN T_PRD_PPBOM d ON a.FID= d.FID
	INNER JOIN T_PRD_MOENTRY_A e ON d.FMOENTRYID= e.FENTRYID
	INNER JOIN T_PRD_MOENTRY f ON f.FENTRYID= e.FENTRYID
	INNER JOIN T_PRD_MOENTRY_Q g ON g.FENTRYID= e.FENTRYID
	INNER JOIN T_PRD_MO h ON h.FID= e.FID
	LEFT JOIN T_ORG_ORGANIZATIONS_L HL ON HL.FORGID=h.FPRDORGID
	INNER JOIN T_BD_DEPARTMENT_L dl ON ( d.FWORKSHOPID= dl.FDEPTID AND dl.FLOCALEID= 2052 )
	LEFT JOIN T_BD_MATERIAL m1 ON f.FMATERIALID= m1.FMATERIALID
	LEFT JOIN T_BD_MATERIAL_L m1L ON ( f.FMATERIALID= m1L.FMATERIALID AND m1L.FLOCALEID= 2052 )
	LEFT JOIN T_BD_MATERIAL m2 ON a.FMATERIALID= m2.FMATERIALID
	LEFT JOIN T_BD_MATERIAL_L m2L ON ( a.FMATERIALID= m2L.FMATERIALID AND m2L.FLOCALEID= 2052 )
	LEFT JOIN T_PRD_FEEDMTRLDATA BL ON ( h.FBILLNO= BL.FMOBILLNO AND A.FMATERIALID= BL.FMATERIALID ) --补料
	LEFT JOIN (
	SELECT
		a.FMOBILLNO,
		a.FMATERIALID,
		FACTUALQTY AS FSCBLQTY 
	FROM
		T_PRD_FEEDMTRLDATA a
		INNER JOIN T_PRD_FEEDMTRL ah ON a.FID= ah.FID
		INNER JOIN T_PRD_FEEDMTRLDATA_Q q ON a.FENTRYID= q.FENTRYID 
	WHERE
		ah.FDOCUMENTSTATUS= 'C' 
	) temp ON ( temp.FMOBILLNO= h.FBILLNO AND temp.FMATERIALID= m2.FMATERIALID ) --退料
	LEFT JOIN (
	SELECT SUM
		( a.fqty ) AS fqty,
		a.FMATERIALID,
		a.FMOBILLNO 
	FROM
		T_PRD_RETURNMTRLENTRY a
		LEFT JOIN T_PRD_RETURNMTRL b ON a.fid= b.fid 
	WHERE
		b.FDOCUMENTSTATUS= 'C' 
	GROUP BY
		a.FMATERIALID,
		a.FMOBILLNO 
	) TEMP2 ON ( temp2.FMOBILLNO= h.FBILLNO AND temp2.FMATERIALID= m2.FMATERIALID ) --生产入库
	LEFT JOIN ( SELECT SUM ( FREALQTY ) AS FREALQTY, FMOBILLNO, FMATERIALID FROM T_PRD_INSTOCKENTRY GROUP BY FMOBILLNO, FMATERIALID ) temp3 ON ( temp3.FMOBILLNO= h.FBILLNO AND temp3.FMATERIALID= m1.FMATERIALID )
	LEFT JOIN ( SELECT SUM ( FREALQTY ) AS FREALQTY, FMOBILLNO, FMATERIALID FROM T_PRD_RESTOCKENTRY GROUP BY FMOBILLNO, FMATERIALID ) temp4 ON ( temp4.FMOBILLNO= h.FBILLNO AND temp4.FMATERIALID= m1.FMATERIALID ) 
WHERE
	d.FDOCUMENTSTATUS= 'C'
	AND e.FSTATUS<> '6' 
	AND e.FSTATUS<> '7'
-- 	AND h.FPRDORGID=_CurrentOrgUnitId_
-- 	AND (h.FBILLNO IN (#FBILLNO#) OR (SELECT #FBILLNO# FOR XML path(''))='' )
-- 	AND	(m1.Fnumber IN (#Fnumber#) OR (SELECT #Fnumber# FOR XML path(''))='' )
-- 	AND	(dl.fname IN (#fname#) OR (SELECT #fname# FOR XML path(''))='' )
GROUP BY
h.FPRDORGID,
	dl.fname,
	m1.Fnumber,
	m1l.FNAME,
	a.FMUSTQTY,
	b.FPICKEDQTY,
	a.FMATERIALID,
	a.FSCRAPRATE,
	h.FBILLNO,
	e.FSTATUS,
	f.FQTY,
	m2.Fnumber,
	m2l.FNAME,
	m1l.FSPECIFICATION,
	m2l.FSPECIFICATION,
	temp.FSCBLQTY,
	TEMP2.fqty,
	temp3.FREALQTY,
	temp4.FREALQTY,
	hL.FNAME
	ORDER BY
	h.FBILLNO,m1.Fnumber
	)AA