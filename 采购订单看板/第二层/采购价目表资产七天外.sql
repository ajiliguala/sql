
--资产
WITH CGJM AS (
	SELECT
		FPRICE,
		FMATERIALID,
		FCREATEDATE as 价目表创建日期,
		FAPPROVEDATE as 价目表审核日期,
        AA.物料编码
	FROM
		(
		SELECT
			A.FPRICE,
			A.FMATERIALID,
			B.FCREATEDATE,
            C.FNUMBER AS 物料编码,
			b.FAPPROVEDATE,b.FDOCUMENTSTATUS,
			ROW_NUMBER ( ) OVER ( PARTITION BY A.FMATERIALID ORDER BY B.FCREATEDATE DESC ) AS rn
		FROM
			t_PUR_PriceListEntry A
			LEFT JOIN t_PUR_PriceList B ON A.FID = B.FID
            LEFT JOIN T_BD_MATERIAL C ON A.FMATERIALID = C.FMATERIALID
		) AA
	WHERE
		rn = 1
        and FDOCUMENTSTATUS='c'
        AND (LEFT(AA.物料编码, 2) = '11' AND SUBSTRING(AA.物料编码, 3, 1) = '.'
        OR LEFT(AA.物料编码, 2) = '13' AND SUBSTRING(AA.物料编码, 3, 1) = '.')

		--AND FMATERIALID='234775'

),
MainQuery AS (
   SELECT
A.FBILLNO AS 订单编号,
B.FNAME AS 单据类型,
C.FNAME 申请组织,
AA.F_PIKU_SYR 使用人,
D.FNUMBER AS 物料编码,
E.FNAME 物料名称,
E.FSPECIFICATION 物料规格,
t5l.FNAME AS 单位,
aa.FREQQTY AS 数量,
a.FAPPROVEDATE AS 采购申请审核日期,
d.F_CGY 执行采购,
aa.F_KFCG 开发采购,
YEAR(价目表审核日期) AS ApprovalYear,
MONTH(价目表审核日期) AS ApprovalMonth,
    CASE
        WHEN DATEDIFF(DAY, a.FAPPROVEDATE,价目表审核日期) BETWEEN 3 AND 7 THEN 价目表审核日期
        ELSE NULL
    END AS 采购订单创建日期_7天内,
	 CASE
        WHEN DATEDIFF(DAY,a.FAPPROVEDATE,价目表审核日期) > 7 THEN 价目表审核日期
        ELSE NULL
    END AS 采购订单创建日期_大于7天

FROM  T_PUR_Requisition a
LEFT JOIN T_BAS_BILLTYPE_L B ON A.FBILLTYPEID=B.FBILLTYPEID AND B.FLOCALEID=2052
LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FORGID =A.FAPPLICATIONORGID  AND C.FLOCALEID=2052
inner JOIN T_PUR_ReqEntry AA ON AA.FID=A.FID
LEFT JOIN T_BD_MATERIAL D ON AA.FMATERIALID=D.FMATERIALID
LEFT JOIN T_BD_MATERIAL_L E ON AA.FMATERIALID=E.FMATERIALID
LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = aa.FUNITID AND T5L.FLOCALEID = 2052
LEFT JOIN CGJM ON AA.FMATERIALID=CGJM.FMATERIALID
WHERE
A.FDOCUMENTSTATUS='C'
AND ( (LEFT(D.FNUMBER, 2) = '11' AND SUBSTRING(D.FNUMBER, 3, 1) = '.'
        OR LEFT(D.FNUMBER, 2) = '13' AND SUBSTRING(D.FNUMBER, 3, 1) = '.'))
AND C.FORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
)


    SELECT

        执行采购,
        ApprovalYear,
        ApprovalMonth,
        COUNT(*) AS 总数,
        --COUNT(采购订单创建日期_7天内) AS 七天内审核
       COUNT(采购订单创建日期_大于7天) AS 大于七天

    FROM MainQuery
    WHERE
    Approvalyear>='2023'
    --and 执行采购='李卓文'
    GROUP BY
        执行采购,
        ApprovalYear,
        ApprovalMonth
    HAVING   -- 排除当前月份
        (ApprovalYear * 100 + ApprovalMonth) < (YEAR(GETDATE()) * 100 + MONTH(GETDATE()))
        order by 执行采购,ApprovalYear,
        ApprovalMonth