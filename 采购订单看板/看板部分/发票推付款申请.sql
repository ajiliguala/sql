WITH TEMP AS (SELECT A.FBILLNO           AS 单据号,
                     D.FSRCBILLNO,
                     FBUYIVQTY           AS 采购发票数量,
                     A.FWRITTENOFFSTATUS AS 付款核销状态,
                     A.FSETACCOUNTTYPE   AS 立账类型,
                     A.FBYVERIFY         AS 生成方式,
                     A.FWRITTENOFFSTATUS AS 表头开票核销状态,
                     A.FENDDATE          AS 到期日,
                     E.FBILLNO,
                     D.FAPPLYAMOUNTFOR,
                     D.FPAYAMOUNTFOR     AS YFD
              FROM T_AP_PAYABLE A
                       LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                       LEFT JOIN T_AP_PAYABLEPLAN C ON A.FID = C.FID
                       LEFT JOIN T_CN_PAYAPPLYENTRY D ON D.FSRCBILLNO = A.FBILLNO
                       LEFT JOIN T_CN_PAYAPPLY E ON E.FID = D.FID
              WHERE A.FDOCUMENTSTATUS = 'C'
                AND A.FWRITTENOFFSTATUS <> 'C'
                AND A.FSETACCOUNTTYPE = '3'--财务应付
                AND A.F_KING_DESPDEPT <> '1499956'--职责部门不为基建办
                AND (E.FPAYAMOUNTFOR_H > E.FAPPLYAMOUNTFOR_H OR E.FPAYAMOUNTFOR_H IS NULL OR
                     E.FAPPLYAMOUNTFOR_H IS NULL)
                AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
                AND A.FENDDATE < GETDATE()
                --AND A.FBILLNO ='AP020300007448'
                AND ((C.FPAYAMOUNTFOR = 0)
                  OR
                     (
                         (C.FPAYAMOUNTFOR > 0 AND
                          (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) > 0)
                             OR
                         (C.FPAYAMOUNTFOR < 0 AND
                          (C.FPAYAMOUNTFOR - c.FAPPLYAMOUNT - a.FRELATEHADPAYAMOUNT + C.FPAYREAPPLYAMT) < 0)
                         )))

SELECT COUNT(*) AS 数量
FROM TEMP

