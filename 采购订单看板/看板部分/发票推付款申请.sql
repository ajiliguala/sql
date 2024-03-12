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
                    A.FOPENSTATUS       AS 表头开票核销状态,
                    E.FNAME             AS 采购员,
                    YEAR(A.FDATE)       AS ApprovalYear,
                    MONTH(A.FDATE)      AS ApprovalMonth
             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                      LEFT JOIN T_AP_PAYABLEPLAN C ON A.FID = C.FID
                      LEFT JOIN V_BD_BUYER_L E ON E.FID = A.FPURCHASERID
             WHERE A.FWRITTENOFFSTATUS <> 'C'
               AND A.FDOCUMENTSTATUS = 'C'
               AND A.FSETACCOUNTTYPE = '3'--财务应付
               AND A.F_KING_DESPDEPT <> '002'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
               AND ((C.FPAYAMOUNTFOR = 0)
                 OR
                    (
                        (C.FPAYAMOUNTFOR > 0 AND
                         (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) > 0)
                            OR
                        (C.FPAYAMOUNTFOR < 0 AND
                         (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) < 0)
                        )
                 )),


     FKSQ AS
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
                    A.FWRITTENOFFSTATUS AS 表头开票核销状态
             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                      LEFT JOIN T_AP_PAYABLEPLAN C ON A.FID = C.FID
             WHERE A.FDOCUMENTSTATUS = 'C'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FSETACCOUNTTYPE = '3'--财务应付
               AND A.F_KING_DESPDEPT <> '002'
               AND A.FWRITTENOFFSTATUS <> 'C'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
               AND ((C.FPAYAMOUNTFOR = 0)
                 OR
                    (
                        (C.FPAYAMOUNTFOR > 0 AND
                         (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) > 0)
                            OR
                        (C.FPAYAMOUNTFOR < 0 AND
                         (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) < 0)
                        ))
               AND c.FAPPLYAMOUNT <> 0)

SELECT COUNT(*)  AS 数量
                   FROM ZG
                            LEFT JOIN FKSQ ON ZG.单据号 = FKSQ.单据号
                   WHERE FKSQ.单据号 IS NULL
