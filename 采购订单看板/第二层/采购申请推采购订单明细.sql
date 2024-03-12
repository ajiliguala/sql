WITH CG AS (SELECT e.FBILLNO      AS 采购订单单据编号,
                   e.FCREATEDATE  as 创建日期,
                   e.FAPPROVEDATE as 审核日期,
                   ml2.FNAME      AS 采购订单物料名称,
                   d.FSEQ         AS 采购订单分录序号,
                   c.FBILLNO      AS 采购申请单单据编号,
                   ml1.FNAME      AS 采购申请单物料名称,
                   b.FSEQ         AS 采购申请单分录序号,
                   ml1.FMATERIALID,
                   c.FDOCUMENTSTATUS
            FROM T_PUR_POORDERENTRY_LK a
                     LEFT JOIN T_PUR_REQENTRY b ON a.FSID = b.FENTRYID
                     LEFT JOIN T_PUR_REQUISITION c ON b.FID = c.FID
                     LEFT JOIN T_BD_MATERIAL_L ml1 ON b.FMATERIALID = ml1.FMATERIALID AND ml1.FLOCALEID = 2052
                     LEFT JOIN T_PUR_POORDERENTRY d ON a.FENTRYID = d.FENTRYID
                     LEFT JOIN T_PUR_POORDER e ON d.FID = e.FID
                     LEFT JOIN T_BD_MATERIAL_L ml2 ON d.FMATERIALID = ml2.FMATERIALID AND ml2.FLOCALEID = 2052
            WHERE a.FSTABLENAME = 'T_PUR_ReqEntry'
              AND c.FDOCUMENTSTATUS = 'C'),
     MainQuery AS (SELECT A.FBILLNO             AS 订单编号,
                          B.FNAME               AS 单据类型,
                          C.FNAME                  申请组织,
                          AA.F_PIKU_SYR            使用人,
                          D.FNUMBER             AS 物料编码,
                          E.FNAME                  物料名称,
                          E.FSPECIFICATION         物料规格,
                          t5l.FNAME             AS 单位,
                          aa.FREQQTY            AS 数量,
                          a.FAPPROVEDATE        AS 采购申请审核日期,
                          d.F_CGY                  执行采购,
                          aa.F_KFCG                开发采购,
                          YEAR(a.FAPPROVEDATE)  AS ApprovalYear,
                          MONTH(a.FAPPROVEDATE) AS ApprovalMonth

                   FROM T_PUR_Requisition a
                            LEFT JOIN T_BAS_BILLTYPE_L B ON A.FBILLTYPEID = B.FBILLTYPEID AND B.FLOCALEID = 2052
                            LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FORGID = A.FAPPLICATIONORGID AND C.FLOCALEID = 2052
                            inner JOIN T_PUR_ReqEntry AA ON AA.FID = A.FID
                            LEFT JOIN T_BD_MATERIAL D ON AA.FMATERIALID = D.FMATERIALID
                            LEFT JOIN T_BD_MATERIAL_L E ON AA.FMATERIALID = E.FMATERIALID
                            LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = aa.FUNITID AND T5L.FLOCALEID = 2052
                            LEFT JOIN CG ON CG.采购申请单单据编号 = A.FBILLNO and CG.FMATERIALID = AA.FMATERIALID and
                                            aa.fseq = CG.采购申请单分录序号
                   WHERE A.FDOCUMENTSTATUS = 'C'
                     AND A.FAPPLICATIONORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
                     AND 采购订单单据编号 is NULL)

 SELECT

        执行采购,
        ApprovalYear,
        ApprovalMonth,
        COUNT(*) AS 总数
        --COUNT(采购订单创建日期_7天内) AS 七天内
       -- COUNT(采购订单创建日期_大于7天) AS 大于七天

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
        order by 执行采购,ApprovalYear,ApprovalMonth


