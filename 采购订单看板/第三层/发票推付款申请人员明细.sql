--暂估
WITH ZG AS
         (
-- 单据状态等于已审核
-- 立账类型等于财务应付
-- 单据头-表头基本-付款核销状态不等于完全
-- 职责部门编码<>002
-- 所选分录行（正）应付金额- 付款申请金额-付（退）款关联金额+已申请付款金额>0  或者 所选分录行（负）应付金额- 付款申请金额-付（退）款关联金额+已申请付款金额<0
             SELECT A.FBILLNO           AS 单据号,
                    FBUYIVQTY           AS 采购发票数量,
                    A.FWRITTENOFFSTATUS AS 付款核销状态,
                    A.FSETACCOUNTTYPE   AS 立账类型,
                    A.FBYVERIFY         AS 生成方式,
                    B.FOPENSTATUS       AS 表体开票核销状态,
                    C.FNAME             AS 单据类型,
                    A.FDATE             AS 业务日期,
                    D.FNAME             AS 供应商,
                    E.FNAME             AS 采购员,
                    G.FNAME             AS 物料名称,
                    F.FNUMBER           AS 物料编码,
                    G.FSPECIFICATION    AS 物料规格,
                    B.FPRICE            AS 单价,
                    T5L.FNAME           AS 单位,
                    B.FPRICEQTY         AS 数量,
                    YEAR(A.FDATE)       AS ApprovalYear,
                    MONTH(A.FDATE)      AS ApprovalMonth
             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                      LEFT JOIN T_BAS_BILLTYPE_L C ON A.FBILLTYPEID = C.FBILLTYPEID AND C.FLOCALEID = 2052
                      LEFT JOIN T_BD_SUPPLIER_L D on D.FSUPPLIERID = A.FSUPPLIERID
                      LEFT JOIN V_BD_BUYER_L E ON E.FID = A.FPURCHASERID
                      LEFT JOIN T_BD_MATERIAL F ON B.FMATERIALID = F.FMATERIALID
                      LEFT JOIN T_BD_MATERIAL_L G ON B.FMATERIALID = G.FMATERIALID
                      LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = B.FPRICEUNITID AND T5L.FLOCALEID = 2052
                      LEFT JOIN T_AP_PAYABLEPLAN H ON A.FID = H.FID
             WHERE A.FWRITTENOFFSTATUS <> 'C'
               AND A.FSETACCOUNTTYPE = '3'--财务应付
               AND A.F_KING_DESPDEPT <> '002'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
               AND ((H.FPAYAMOUNTFOR = 0)
                 OR
                    (
                        (H.FPAYAMOUNTFOR > 0 AND
                         (H.FPAYAMOUNTFOR - H.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + H.FPAYREAPPLYAMT) > 0)
                            OR
                        (H.FPAYAMOUNTFOR < 0 AND
                         (H.FPAYAMOUNTFOR - H.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + H.FPAYREAPPLYAMT) < 0)
                        ))),
     FKSQ AS
         (
-- 单据状态等于已审核
-- 立账类型等于财务应付
-- 单据头-表头基本-付款核销状态不等于完全
-- 职责部门编码<>002
-- 所选分录行（正）应付金额- 付款申请金额-付（退）款关联金额+已申请付款金额>0  或者 所选分录行（负）应付金额- 付款申请金额-付（退）款关联金额+已申请付款金额<0

             SELECT A.FBILLNO           AS 单据号1,
                    FBUYIVQTY           AS 采购发票数量1,
                    A.FWRITTENOFFSTATUS AS 付款核销状态1,
                    A.FSETACCOUNTTYPE   AS 立账类型1,
                    A.FBYVERIFY         AS 生成方式1,
                    A.FWRITTENOFFSTATUS AS 表头开票核销状态1--T_AP_PAYABLEENTRY
             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                      LEFT JOIN T_AP_PAYABLEPLAN H ON A.FID = H.FID
             WHERE A.FDOCUMENTSTATUS = 'C'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FSETACCOUNTTYPE = '3'--财务应付
               AND A.F_KING_DESPDEPT <> '002'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
               AND ((H.FPAYAMOUNTFOR = 0)
                 OR
                    (
                        (H.FPAYAMOUNTFOR > 0 AND
                         (H.FPAYAMOUNTFOR - H.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + H.FPAYREAPPLYAMT) > 0)
                            OR
                        (H.FPAYAMOUNTFOR < 0 AND
                         (H.FPAYAMOUNTFOR - H.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + H.FPAYREAPPLYAMT) < 0)
                        ))
               AND H.FAPPLYAMOUNT <> 0)
SELECT ZG.单据号,
       ZG.单据类型,
       ZG.业务日期,
       ZG.供应商,
       ZG.采购员,
       ZG.物料名称,
       ZG.物料编码,
       ZG.物料规格,
       ZG.单价,
       单位,
       ZG.数量,
       ApprovalYear,
       ApprovalMonth
FROM ZG
         LEFT JOIN FKSQ ON ZG.单据号 = FKSQ.单据号1
WHERE FKSQ.单据号1 IS NULL
  AND ZG.采购员 = '${采购员}'
  AND (
    -- 只包括当前月份的数据
    (ZG.业务日期 >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) and
     ZG.业务日期 < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0))
    )

