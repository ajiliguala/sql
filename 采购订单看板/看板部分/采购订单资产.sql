WITH
 CG AS (
    SELECT
        e.FBILLNO AS 采购订单单据编号,
        e.FCREATEDATE as 创建日期,
        e.FAPPROVEDATE as 审核日期,
        ml2.FNAME AS 采购订单物料名称,
        d.FSEQ AS 采购订单分录序号,
        c.FBILLNO AS 采购申请单单据编号,
        ml1.FNAME AS 采购申请单物料名称,
        b.FSEQ AS 采购申请单分录序号,
        ml1.FMATERIALID,
        c.FDOCUMENTSTATUS,
        BE.FNAME
    FROM
        T_PUR_POORDERENTRY_LK a
        LEFT JOIN T_PUR_REQENTRY b ON a.FSID = b.FENTRYID
        LEFT JOIN T_PUR_REQUISITION c ON b.FID = c.FID
        LEFT JOIN T_BD_MATERIAL_L ml1 ON b.FMATERIALID = ml1.FMATERIALID AND ml1.FLOCALEID = 2052
        LEFT JOIN T_PUR_POORDERENTRY d ON a.FENTRYID = d.FENTRYID
        LEFT JOIN T_PUR_POORDER e ON d.FID = e.FID
        LEFT JOIN T_BAS_BILLTYPE_L BE ON E.FBILLTYPEID=BE.FBILLTYPEID AND BE.FLOCALEID=2052
        LEFT JOIN T_BD_MATERIAL_L ml2 ON d.FMATERIALID = ml2.FMATERIALID AND ml2.FLOCALEID = 2052
    WHERE
        a.FSTABLENAME = 'T_PUR_ReqEntry'
        AND (BE.FNAME='资产采购订单' or BE.FNAME= '费用采购订单')
),
 CG1 AS (
    SELECT
        e.FBILLNO AS 采购订单单据编号,
        e.FCREATEDATE as 创建日期,
        e.FAPPROVEDATE as 审核日期,
        ml2.FNAME AS 采购订单物料名称,
        d.FSEQ AS 采购订单分录序号,
        c.FBILLNO AS 采购申请单单据编号,
        ml1.FNAME AS 采购申请单物料名称,
        b.FSEQ AS 采购申请单分录序号,
        ml1.FMATERIALID,
        c.FDOCUMENTSTATUS,
        BE.FNAME
    FROM
        T_PUR_POORDERENTRY_LK a
        LEFT JOIN T_PUR_REQENTRY b ON a.FSID = b.FENTRYID
        LEFT JOIN T_PUR_REQUISITION c ON b.FID = c.FID
        LEFT JOIN T_BD_MATERIAL_L ml1 ON b.FMATERIALID = ml1.FMATERIALID AND ml1.FLOCALEID = 2052
        LEFT JOIN T_PUR_POORDERENTRY d ON a.FENTRYID = d.FENTRYID
        LEFT JOIN T_PUR_POORDER e ON d.FID = e.FID
        LEFT JOIN T_BAS_BILLTYPE_L BE ON E.FBILLTYPEID=BE.FBILLTYPEID AND BE.FLOCALEID=2052
        LEFT JOIN T_BD_MATERIAL_L ml2 ON d.FMATERIALID = ml2.FMATERIALID AND ml2.FLOCALEID = 2052
    WHERE
        a.FSTABLENAME = 'T_PUR_ReqEntry'
        AND (BE.FNAME='标准采购订单' or BE.FNAME= '标准委外订单')
),
MainQuery AS (
    SELECT

        -- CASE
        --     WHEN DATEDIFF(DAY, A.FAPPROVEDATE, CG.创建日期) BETWEEN 3 AND 6 THEN 1
        --     ELSE 0
        -- END AS 采购订单材料创建日期_3_6_标志,
        -- CASE
        --     WHEN DATEDIFF(DAY, A.FAPPROVEDATE, CG.创建日期) >= 7 THEN 1
        --     ELSE 0
        -- END AS 采购订单材料创建日期_大于7天_标志,
         CASE
            WHEN DATEDIFF(DAY, A.FAPPROVEDATE, CG1.审核日期) BETWEEN 0 AND 6 THEN 1
            ELSE 0
        END AS 采购订单资产创建日期_3_6_标志,
        CASE
            WHEN DATEDIFF(DAY, A.FAPPROVEDATE, CG1.审核日期) >= 7 THEN 1
            ELSE 0
        END AS 采购订单资产创建日期_大于7天_标志
    FROM T_PUR_Requisition A
    LEFT JOIN T_BAS_BILLTYPE_L B ON A.FBILLTYPEID = B.FBILLTYPEID AND B.FLOCALEID = 2052
    INNER JOIN T_PUR_ReqEntry AA ON AA.FID = A.FID
    LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = AA.FUNITID AND T5L.FLOCALEID = 2052
	--LEFT JOIN CG ON CG.采购申请单单据编号 = A.FBILLNO AND CG.FMATERIALID = AA.FMATERIALID AND AA.FSEQ = CG.采购申请单分录序号
	LEFT JOIN CG CG1 ON CG1.采购申请单单据编号 = A.FBILLNO AND CG1.FMATERIALID = AA.FMATERIALID AND AA.FSEQ = CG1.采购申请单分录序号

    WHERE
        A.FDOCUMENTSTATUS = 'C'
				--AND
-- --     -- 只包括当前月份的数据
--      (CG.创建日期 >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) and CG.创建日期 < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0))
-- AND
--     -- 只包括当前月份的数据
    --(CG1.审核日期 >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) and CG1.审核日期 < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0))
   AND A.FAPPLICATIONORGID IN('1', '100329', '100330', '100331', '100332', '3798064', '4355331'))

-- 外部查询用于计算结果
SELECT
    -- SUM(采购订单材料创建日期_3_6_标志) AS 采购订单材料创建日期_7天内_数量,
    -- SUM(采购订单材料创建日期_大于7天_标志) AS 采购订单材料创建日期_大于7天_数量,
     COALESCE(SUM(采购订单资产创建日期_3_6_标志), 0) AS 采购订单资产创建日期_7天内_数量,
   COALESCE(SUM(采购订单资产创建日期_大于7天_标志), 0) AS采购订单资产创建日期_大于7天_数量
FROM MainQuery;